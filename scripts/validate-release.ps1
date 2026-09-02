[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot),
    [ValidateSet('Draft', 'Release', 'Published')]
    [string]$Mode = 'Draft'
)

$ErrorActionPreference = 'Stop'

$root = [System.IO.Path]::GetFullPath($RepositoryRoot).TrimEnd(
    [System.IO.Path]::DirectorySeparatorChar,
    [System.IO.Path]::AltDirectorySeparatorChar
)
$rootPrefix = $root + [System.IO.Path]::DirectorySeparatorChar
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
    $isRoot = $path.Equals($root, [System.StringComparison]::OrdinalIgnoreCase)
    $isChild = $path.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)
    if (-not ($isRoot -or $isChild)) {
        throw "Path escapes repository root: $RelativePath"
    }
    return $path
}

function Get-RepoRelativePath {
    param([string]$FullPath)
    return [System.IO.Path]::GetRelativePath($root, $FullPath).Replace('\', '/')
}

$requiredFiles = @(
    'README.md',
    'README.en.md',
    'LICENSE',
    'LICENSE-SCOPE.md',
    'NOTICE.md',
    'PUBLICATION-REVIEW.md',
    'skills/README.md',
    'skills/role-prompt-authoring/README.md',
    'skills/role-prompt-authoring/role-prompt-authoring-skill.zh-CN.md',
    'skills/role-prompt-authoring/role-prompt-authoring-skill.en.md',
    'docs/README.md',
    'docs/zh-CN/architecture.md',
    'docs/zh-CN/output-contracts.md',
    'docs/zh-CN/runtime-profile.md',
    'docs/zh-CN/evaluation-and-triage.md',
    'docs/zh-CN/migration.md',
    'docs/en/architecture.md',
    'docs/en/output-contracts.md',
    'docs/en/runtime-profile.md',
    'docs/en/evaluation-and-triage.md',
    'docs/en/migration.md',
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

$gitMetadataPath = Join-Path $root '.git'
$trackedFiles = @()
if (Test-Path -LiteralPath $gitMetadataPath) {
    $trackedFiles = @(git -C $root ls-files)
    if ($LASTEXITCODE -ne 0) {
        Add-Failure 'Unable to read the Git tracked-file allowlist.'
    }
    else {
        $allowedTrackedFiles = @('.gitignore') + $requiredFiles
        foreach ($requiredTrackedFile in $allowedTrackedFiles) {
            if ($trackedFiles -notcontains $requiredTrackedFile) {
                Add-Failure "Required publication file is not Git-tracked: $requiredTrackedFile"
            }
        }
        foreach ($trackedFile in $trackedFiles) {
            if ($allowedTrackedFiles -notcontains $trackedFile) {
                Add-Failure "Git-tracked file is outside the publication allowlist: $trackedFile"
            }
        }

        if ($Mode -in @('Release', 'Published')) {
            $gitStatus = @(git -C $root status --porcelain=v1 --untracked-files=all)
            if ($LASTEXITCODE -ne 0) {
                Add-Failure 'Unable to verify that the publication worktree is clean.'
            }
            elseif ($gitStatus.Count -gt 0) {
                Add-Failure "$Mode validation requires a clean Git worktree and index. Commit or remove every staged, unstaged, and untracked change first."
            }
        }
    }
}
elseif ($Mode -in @('Release', 'Published')) {
    Add-Failure "$Mode validation requires a Git repository so the tracked-file allowlist can be checked."
}
else {
    Add-Warning 'Git metadata is unavailable; the tracked-file allowlist was not checked.'
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

$forbiddenPatterns = [ordered]@{
    'credential-like OpenAI key' = 'sk-[A-Za-z0-9_-]{16,}'
    'OpenSSL salted ciphertext' = 'U2FsdGVkX1[A-Za-z0-9+/=]{20,}'
    'Windows user profile path' = '(?i)[A-Z]:\\Users\\[^\\\s]+'
    'private development note name' = ('LLMRP_' + 'BENCHMARK_NOTES\.md')
    'private source directory name' = ('AstrBot' + '真实环境')
}

$files = @()
if ($trackedFiles.Count -gt 0) {
    foreach ($trackedFile in $trackedFiles) {
        $trackedPath = Resolve-RepoPath $trackedFile
        if (Test-Path -LiteralPath $trackedPath -PathType Leaf) {
            $files += Get-Item -LiteralPath $trackedPath
        }
    }
}
else {
    $files = @(Get-ChildItem -LiteralPath $root -Recurse -File | Where-Object {
        $_.FullName -notmatch '[\\/]\.git[\\/]'
    })
}

$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)

foreach ($file in $files) {
    $relativeFile = Get-RepoRelativePath $file.FullName
    if ($file.Length -gt 1MB) {
        Add-Failure "File exceeds 1 MiB allowlist limit: $relativeFile"
    }

    $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
    if ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Add-Failure "UTF-8 BOM found: $relativeFile"
    }
    if ($bytes -contains 0) {
        Add-Failure "NUL byte or binary content found in publication file: $relativeFile"
        continue
    }

    try {
        $content = $strictUtf8.GetString($bytes)
    }
    catch {
        Add-Failure "Publication file is not valid UTF-8: $relativeFile"
        continue
    }

    foreach ($pattern in $forbiddenPatterns.GetEnumerator()) {
        if ([regex]::IsMatch($content, $pattern.Value)) {
            Add-Failure "$($pattern.Key) found in $relativeFile"
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
        $isRoot = $resolved.Equals($root, [System.StringComparison]::OrdinalIgnoreCase)
        $isChild = $resolved.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase)
        if (-not ($isRoot -or $isChild)) {
            Add-Failure "Markdown link escapes repository: $(Get-RepoRelativePath $file.FullName) -> $target"
        }
        elseif (-not (Test-Path -LiteralPath $resolved)) {
            Add-Failure "Broken Markdown link: $(Get-RepoRelativePath $file.FullName) -> $target"
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

$bilingualDocumentPairs = @(
    @{ zh = 'README.md'; en = 'README.en.md'; label = 'root README' },
    @{ zh = 'docs/zh-CN/architecture.md'; en = 'docs/en/architecture.md'; label = 'architecture' },
    @{ zh = 'docs/zh-CN/output-contracts.md'; en = 'docs/en/output-contracts.md'; label = 'output contracts' },
    @{ zh = 'docs/zh-CN/runtime-profile.md'; en = 'docs/en/runtime-profile.md'; label = 'runtime profile' },
    @{ zh = 'docs/zh-CN/evaluation-and-triage.md'; en = 'docs/en/evaluation-and-triage.md'; label = 'evaluation and triage' },
    @{ zh = 'docs/zh-CN/migration.md'; en = 'docs/en/migration.md'; label = 'migration' }
)

foreach ($pair in $bilingualDocumentPairs) {
    $zhPath = Resolve-RepoPath $pair.zh
    $enPath = Resolve-RepoPath $pair.en
    if (-not (Test-Path -LiteralPath $zhPath) -or -not (Test-Path -LiteralPath $enPath)) {
        continue
    }
    $pairZhHeadings = @(Get-Content -LiteralPath $zhPath | Where-Object { $_ -match '^#{1,3}\s' })
    $pairEnHeadings = @(Get-Content -LiteralPath $enPath | Where-Object { $_ -match '^#{1,3}\s' })
    if ($pairZhHeadings.Count -ne $pairEnHeadings.Count) {
        Add-Failure "Bilingual document heading count mismatch for $($pair.label): zh=$($pairZhHeadings.Count), en=$($pairEnHeadings.Count)"
    }

    foreach ($path in @($zhPath, $enPath)) {
        $pairContent = Get-Content -Raw -LiteralPath $path
        if (-not $pairContent.Contains('2026-09-02.4')) {
            Add-Failure "Bilingual document is missing specification revision 2026-09-02.4: $($path.Substring($root.Length + 1))"
        }
    }
}

$readmeRequirements = @(
    @{
        path = 'README.md'
        tokens = @('模型层', 'Prompt 层', '宿主层', 'HDS Interlude', '展示性交付偏置', 'ROLE_SPEC', 'PORTABLE_ROLE_PROMPT', 'FINAL_ROLE_PROMPT', 'Persona Definition v1', 'astrbot-roleplay-persona-notes.md')
    },
    @{
        path = 'README.en.md'
        tokens = @('Model', 'Prompt', 'Host', 'HDS Interlude', 'Visible-Delivery Bias', 'ROLE_SPEC', 'PORTABLE_ROLE_PROMPT', 'FINAL_ROLE_PROMPT', 'Persona Definition v1', 'astrbot-roleplay-persona-notes.md')
    }
)

foreach ($requirement in $readmeRequirements) {
    $readmePath = Resolve-RepoPath $requirement.path
    $readmeContent = Get-Content -Raw -LiteralPath $readmePath
    foreach ($token in $requirement.tokens) {
        if (-not $readmeContent.Contains($token)) {
            Add-Failure "$($requirement.path) is missing required narrative token: $token"
        }
    }
    $mermaidBlocks = [regex]::Matches($readmeContent, '(?m)^```mermaid\s*$').Count
    if ($mermaidBlocks -ne 2) {
        Add-Failure "$($requirement.path) must contain exactly two Mermaid flowcharts; found $mermaidBlocks."
    }
}

$provenanceRequirements = @(
    @{
        path = 'archive/persona-definition-v1/README.md'
        tokens = @(
            'superseded-as-entry',
            '9ddf51215ec7bbcf86d3f43eaf682543a4ced6ce',
            'astrbot-roleplay-persona-notes.md',
            '7FE9D99281972A1C427E8119DCA93BDFB1F070662150B7E82EBFC3F2BE35A350',
            '167E18B6DE848BDD7A8F9485A8C8330D4B57C9719847A56917AD62263981CE41'
        )
    },
    @{
        path = 'docs/zh-CN/migration.md'
        tokens = @('Persona Definition v1', 'astrbot-roleplay-persona-notes.md', '不复制整篇文章')
    },
    @{
        path = 'docs/en/migration.md'
        tokens = @('Persona Definition v1', 'astrbot-roleplay-persona-notes.md', 'rather than copying the whole article')
    }
)

foreach ($requirement in $provenanceRequirements) {
    $path = Resolve-RepoPath $requirement.path
    if (-not (Test-Path -LiteralPath $path)) {
        Add-Failure "Missing provenance file: $($requirement.path)"
        continue
    }
    $content = Get-Content -Raw -LiteralPath $path
    foreach ($token in $requirement.tokens) {
        if (-not $content.Contains($token)) {
            Add-Failure "$($requirement.path) is missing provenance token: $token"
        }
    }
}

$licensePresent = Test-Path -LiteralPath (Resolve-RepoPath 'LICENSE')
$licenseScopePresent = Test-Path -LiteralPath (Resolve-RepoPath 'LICENSE-SCOPE.md')
$publicationReviewPath = Resolve-RepoPath 'PUBLICATION-REVIEW.md'
$publicationReviewPresent = Test-Path -LiteralPath $publicationReviewPath

if ($Mode -in @('Release', 'Published')) {
    if (-not $licensePresent) {
        Add-Failure "$Mode mode requires LICENSE."
    }
    else {
        $licenseText = Get-Content -Raw -LiteralPath (Resolve-RepoPath 'LICENSE')
        foreach ($phrase in @(
            'MIT License',
            'Copyright (c) 2026 Yuimi-chaya',
            'Permission is hereby granted, free of charge',
            'THE SOFTWARE IS PROVIDED "AS IS"'
        )) {
            if (-not $licenseText.Contains($phrase)) {
                Add-Failure "LICENSE is missing required MIT text: $phrase"
            }
        }
    }
    if (-not $licenseScopePresent) {
        Add-Failure "$Mode mode requires LICENSE-SCOPE.md covering documentation, Prompt files, scripts, and archive material."
    }
    else {
        $licenseScope = Get-Content -Raw -LiteralPath (Resolve-RepoPath 'LICENSE-SCOPE.md')
        foreach ($term in @('code', 'documentation', 'Prompt', 'archive', 'translation', 'third-party', 'HDS Interlude', 'Yuimi-chaya')) {
            if ($licenseScope -notmatch "(?i)$([regex]::Escape($term))") {
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
            'repository_url',
            'license',
            'reviewed_at',
            'published_at',
            'license_scope_reviewed',
            'third_party_reviewed',
            'privacy_reviewed',
            'archive_reviewed',
            'history_reviewed',
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

        if ($reviewValues.ContainsKey('repository_url') -and $reviewValues.repository_url -ne 'https://github.com/Yuimi-chaya/llm-rp-role-prompt-authoring') {
            Add-Failure 'PUBLICATION-REVIEW.md repository_url does not match the approved GitHub repository.'
        }

        if ($reviewValues.ContainsKey('license') -and $reviewValues.license -ne 'MIT') {
            Add-Failure 'PUBLICATION-REVIEW.md license must be MIT.'
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
                elseif ($validReviewedAt -and $publishedAt.Date -lt $reviewedAt.Date) {
                    Add-Failure 'PUBLICATION-REVIEW.md published_at cannot be earlier than reviewed_at.'
                }
            }
        }

        foreach ($fieldName in @('license_scope_reviewed', 'third_party_reviewed', 'privacy_reviewed', 'archive_reviewed', 'history_reviewed', 'owner_approval')) {
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
        Get-Content -Raw -LiteralPath (Resolve-RepoPath 'README.en.md')
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
        '(?i)does not yet have a selected license',
        '(?i)public release is blocked'
    )
    if ($Mode -eq 'Published') {
        $stalePatterns += @(
            '本地预发布',
            '尚未公开',
            '(?i)local pre-release',
            '(?i)pre-publication notice',
            '(?i)not yet published',
            '(?i)has not been published',
            'publication_status:\s*release-ready',
            '发布就绪草案',
            '(?i)release-ready draft',
            '当前机器可读状态为 `release-ready`',
            '(?i)current machine-readable state is `release-ready`'
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

Write-Host "Validated $($requiredFiles.Count) required paths and $($files.Count) publication files."

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
