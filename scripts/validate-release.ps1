[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [ValidateSet('Draft', 'Release', 'Published')]
    [string]$Mode = 'Draft'
)

$ErrorActionPreference = 'Stop'

$root = [System.IO.Path]::GetFullPath($RepositoryRoot)
$failures = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Add-Failure {
    param([string]$Message)
    $failures.Add($Message)
}

function Add-Warning {
    param([string]$Message)
    $warnings.Add($Message)
}

function Resolve-RepoPath {
    param([string]$RelativePath)
    $path = [System.IO.Path]::GetFullPath((Join-Path $root $RelativePath))
    if (-not $path.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
        throw "Path escapes repository root: $RelativePath"
    }
    return $path
}

$requiredFiles = @(
    'README.md',
    'NOTICE.md',
    'PUBLICATION-REVIEW.md',
    'skills/README.md',
    'skills/role-prompt-authoring/README.md',
    'skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md',
    'skills/role-prompt-authoring/role-prompt-authoring-skill.en.md',
    'docs/architecture.md',
    'docs/output-contracts.md',
    'docs/runtime-profile.md',
    'docs/evaluation-and-triage.md',
    'docs/migration.md',
    'archive/README.md',
    'archive/persona-definition-v1/README.md',
    'archive/persona-definition-v1/immersive-role-prompt-engineering-skill.zh-CN.md',
    'archive/persona-definition-v1/immersive-role-prompt-engineering-skill.en.md',
    'archive/private-chat-compilation-v0/README.md',
    'archive/private-chat-compilation-v0/private-chat-role-prompt-compiler-skill.zh-CN.md',
    'archive/private-chat-compilation-v0/private-chat-role-prompt-compiler-skill.en.md',
    'tests/routing-cases.md',
    'scripts/validate-release.ps1'
)

foreach ($relativePath in $requiredFiles) {
    if (-not (Test-Path -LiteralPath (Resolve-RepoPath $relativePath) -PathType Leaf)) {
        Add-Failure "Missing required file: $relativePath"
    }
}

$skillFiles = @(
    'skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md',
    'skills/role-prompt-authoring/role-prompt-authoring-skill.en.md'
)

$requiredSkillTokens = @(
    '2.0.0-draft.4',
    '2026-09-02.4',
    'define',
    'compile',
    'audit',
    'ROLE_SPEC',
    'RUNTIME_PROFILE',
    'PRESERVATION_MAP',
    'PORTABLE_ROLE_PROMPT',
    'FINAL_ROLE_PROMPT',
    'TRIAGE_RESULT',
    'EVALUATION_PLAN',
    'BUILD_RECORD',
    'NON_INJECTABLE_MANIFEST',
    'definition_fault',
    'compilation_fault',
    'host_contract_fault',
    'model_limit',
    'sampling_variance',
    'preference_mismatch',
    'insufficient_evidence'
)

foreach ($skillFile in $skillFiles) {
    $path = Resolve-RepoPath $skillFile
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }
    $content = Get-Content -Raw -LiteralPath $path
    foreach ($token in $requiredSkillTokens) {
        if (-not $content.Contains($token)) {
            Add-Failure "$skillFile is missing required token: $token"
        }
    }
}

$archiveHashes = [ordered]@{
    'archive/persona-definition-v1/immersive-role-prompt-engineering-skill.zh-CN.md' = '7FE9D99281972A1C427E8119DCA93BDFB1F070662150B7E82EBFC3F2BE35A350'
    'archive/persona-definition-v1/immersive-role-prompt-engineering-skill.en.md' = '167E18B6DE848BDD7A8F9485A8C8330D4B57C9719847A56917AD62263981CE41'
    'archive/private-chat-compilation-v0/private-chat-role-prompt-compiler-skill.zh-CN.md' = 'CE4EADD0AA89C94504834B2C98930AFD4084D4AE896149AA5862E9A9203C1992'
    'archive/private-chat-compilation-v0/private-chat-role-prompt-compiler-skill.en.md' = '1CFE35A51C6C8E1F40611D28D4F27F26E10EAADE09118C914C57C387A1054F95'
}

foreach ($entry in $archiveHashes.GetEnumerator()) {
    $path = Resolve-RepoPath $entry.Key
    if (-not (Test-Path -LiteralPath $path)) {
        continue
    }
    $actual = (Get-FileHash -Algorithm SHA256 -LiteralPath $path).Hash
    if ($actual -ne $entry.Value) {
        Add-Failure "Archive hash mismatch: $($entry.Key)"
    }
}

$textExtensions = @('.md', '.ps1', '.txt', '.json', '.yaml', '.yml')
$forbiddenPatterns = [ordered]@{
    'credential-like OpenAI key' = 'sk-[A-Za-z0-9_-]{16,}'
    'OpenSSL salted ciphertext' = 'U2FsdGVkX1[A-Za-z0-9+/=]{20,}'
    'Windows user profile path' = '(?i)[A-Z]:\\Users\\[^\\\s]+'
    'private development note name' = ('LLMRP_' + 'BENCHMARK_NOTES\.md')
    'private source directory name' = ('AstrBot' + '真实环境')
}

$files = Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and $textExtensions -contains $_.Extension
}

foreach ($file in $files) {
    if ($file.Length -gt 1MB) {
        Add-Failure "File exceeds 1 MiB allowlist limit: $($file.FullName.Substring($root.Length + 1))"
    }

    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Add-Failure "UTF-8 BOM found: $($file.FullName.Substring($root.Length + 1))"
    }

    $content = [System.IO.File]::ReadAllText($file.FullName)
    foreach ($pattern in $forbiddenPatterns.GetEnumerator()) {
        if ([regex]::IsMatch($content, $pattern.Value)) {
            Add-Failure "$($pattern.Key) found in $($file.FullName.Substring($root.Length + 1))"
        }
    }
}

$markdownFiles = $files | Where-Object { $_.Extension -eq '.md' }
foreach ($file in $markdownFiles) {
    $content = [System.IO.File]::ReadAllText($file.FullName)
    $matches = [regex]::Matches($content, '\[[^\]]+\]\(([^)]+)\)')
    foreach ($match in $matches) {
        $target = $match.Groups[1].Value
        if ($target -match '^(https?://|mailto:|#)') {
            continue
        }
        $pathPart = ($target -split '#', 2)[0]
        if ([string]::IsNullOrWhiteSpace($pathPart)) {
            continue
        }
        $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $pathPart))
        if (-not $resolved.StartsWith($root, [System.StringComparison]::OrdinalIgnoreCase)) {
            Add-Failure "Markdown link escapes repository: $($file.FullName.Substring($root.Length + 1)) -> $target"
        }
        elseif (-not (Test-Path -LiteralPath $resolved)) {
            Add-Failure "Broken Markdown link: $($file.FullName.Substring($root.Length + 1)) -> $target"
        }
    }
}

$zhSkill = Get-Content -LiteralPath (Resolve-RepoPath $skillFiles[0])
$enSkill = Get-Content -LiteralPath (Resolve-RepoPath $skillFiles[1])
$zhHeadings = @($zhSkill | Where-Object { $_ -match '^#{1,3}\s' })
$enHeadings = @($enSkill | Where-Object { $_ -match '^#{1,3}\s' })
if ($zhHeadings.Count -ne $enHeadings.Count) {
    Add-Failure "Bilingual Skill heading count mismatch: zh=$($zhHeadings.Count), en=$($enHeadings.Count)"
}

$licensePresent = Test-Path -LiteralPath (Resolve-RepoPath 'LICENSE')
$licenseScopePresent = Test-Path -LiteralPath (Resolve-RepoPath 'LICENSE-SCOPE.md')
$publicationReviewPath = Resolve-RepoPath 'PUBLICATION-REVIEW.md'
$publicationReviewPresent = Test-Path -LiteralPath $publicationReviewPath

if ($Mode -in @('Release', 'Published')) {
    if (-not $licensePresent) {
        Add-Failure "$Mode mode requires LICENSE."
    }
    if (-not $licenseScopePresent) {
        Add-Failure "$Mode mode requires LICENSE-SCOPE.md covering documentation, Prompt files, scripts, and archive material."
    }
    else {
        $licenseScope = Get-Content -Raw -LiteralPath (Resolve-RepoPath 'LICENSE-SCOPE.md')
        foreach ($term in @('code', 'documentation', 'prompt', 'archive')) {
            if ($licenseScope -notmatch "(?i)\b$term\b") {
                Add-Failure "LICENSE-SCOPE.md must explicitly address: $term"
            }
        }
    }

    if (-not $publicationReviewPresent) {
        Add-Failure "$Mode mode requires PUBLICATION-REVIEW.md."
    }
    else {
        $review = Get-Content -Raw -LiteralPath $publicationReviewPath
        $expectedStatus = if ($Mode -eq 'Release') { 'release-ready' } else { 'published' }
        $reviewFieldNames = @(
            'publication_status',
            'reviewed_at',
            'published_at',
            'license_scope_reviewed',
            'third_party_reviewed',
            'privacy_reviewed',
            'archive_reviewed',
            'owner_approval'
        )
        $reviewValues = @{}

        foreach ($fieldName in $reviewFieldNames) {
            $fieldPattern = "(?m)^$([regex]::Escape($fieldName)):\s*(.*?)\s*$"
            $fieldMatches = [regex]::Matches($review, $fieldPattern)
            if ($fieldMatches.Count -ne 1) {
                Add-Failure "PUBLICATION-REVIEW.md must contain exactly one $fieldName field; found $($fieldMatches.Count)."
                continue
            }
            $reviewValues[$fieldName] = $fieldMatches[0].Groups[1].Value.Trim()
        }

        if ($reviewValues.ContainsKey('publication_status') -and $reviewValues.publication_status -ne $expectedStatus) {
            Add-Failure "PUBLICATION-REVIEW.md publication_status must be $expectedStatus in $Mode mode."
        }

        if ($reviewValues.ContainsKey('reviewed_at')) {
            $reviewedAt = [datetime]::MinValue
            $validReviewedAt = [datetime]::TryParseExact(
                $reviewValues.reviewed_at,
                'yyyy-MM-dd',
                [System.Globalization.CultureInfo]::InvariantCulture,
                [System.Globalization.DateTimeStyles]::None,
                [ref]$reviewedAt
            )
            if (-not $validReviewedAt -or $reviewedAt.Date -gt (Get-Date).Date) {
                Add-Failure 'PUBLICATION-REVIEW.md reviewed_at must be a valid, non-future YYYY-MM-DD date.'
            }
        }

        if ($reviewValues.ContainsKey('published_at')) {
            if ($Mode -eq 'Release') {
                if ($reviewValues.published_at -ne 'null') {
                    Add-Failure 'PUBLICATION-REVIEW.md published_at must remain null in Release mode.'
                }
            }
            else {
                $publishedAt = [datetime]::MinValue
                $validPublishedAt = [datetime]::TryParseExact(
                    $reviewValues.published_at,
                    'yyyy-MM-dd',
                    [System.Globalization.CultureInfo]::InvariantCulture,
                    [System.Globalization.DateTimeStyles]::None,
                    [ref]$publishedAt
                )
                if (-not $validPublishedAt -or $publishedAt.Date -gt (Get-Date).Date) {
                    Add-Failure 'PUBLICATION-REVIEW.md published_at must be a valid, non-future YYYY-MM-DD date in Published mode.'
                }
            }
        }

        foreach ($fieldName in @('license_scope_reviewed', 'third_party_reviewed', 'privacy_reviewed', 'archive_reviewed', 'owner_approval')) {
            if ($reviewValues.ContainsKey($fieldName) -and $reviewValues[$fieldName] -ne 'true') {
                Add-Failure "PUBLICATION-REVIEW.md $fieldName must be true in $Mode mode."
            }
        }
    }

    $reviewDecision = ''
    if ($publicationReviewPresent) {
        $reviewText = Get-Content -Raw -LiteralPath $publicationReviewPath
        $decisionMatch = [regex]::Match($reviewText, '(?ms)^## Current Decision\s*\r?\n(?<body>.*?)(?=^##\s|\z)')
        if ($decisionMatch.Success) {
            $reviewDecision = $decisionMatch.Groups['body'].Value
        }
        else {
            Add-Failure 'PUBLICATION-REVIEW.md must contain a Current Decision section.'
        }
    }

    $releaseStatusText = @(
        Get-Content -Raw -LiteralPath (Resolve-RepoPath 'README.md')
        Get-Content -Raw -LiteralPath (Resolve-RepoPath 'NOTICE.md')
        Get-Content -Raw -LiteralPath (Resolve-RepoPath 'skills/role-prompt-authoring/README.md')
        $reviewDecision
    ) -join "`n"
    $stalePatterns = @(
        '本地预发布草案',
        '尚未选择许可证',
        '当前没有 `?LICENSE`?',
        '(?i)local draft',
        '(?i)no license has been selected',
        '(?i)public release is blocked'
    )
    if ($Mode -eq 'Published') {
        $stalePatterns += @(
            '本地预发布',
            '尚未公开',
            '(?i)local pre-release',
            '(?i)pre-publication notice',
            '(?i)not yet published',
            '(?i)has not been published'
        )
    }
    foreach ($pattern in $stalePatterns) {
        if ($releaseStatusText -match $pattern) {
            Add-Failure "$Mode-facing README/NOTICE still contains stale state text matching: $pattern"
        }
    }
}
else {
    if (-not $licensePresent) {
        Add-Warning 'LICENSE is not present. Public release remains blocked until the owner selects one.'
    }
    if (-not $licenseScopePresent) {
        Add-Warning 'LICENSE-SCOPE.md is not present. Release scope remains unresolved.'
    }
}

Write-Host "Validated $($requiredFiles.Count) required paths and $($files.Count) text files."

foreach ($warning in $warnings) {
    Write-Warning $warning
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        [Console]::Error.WriteLine("ERROR: $failure")
    }
    exit 1
}

Write-Host "$Mode validation passed." -ForegroundColor Green
exit 0
