[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Split-Path -Parent $PSScriptRoot)
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
    '2.0.0-draft.1',
    'define',
    'compile',
    'audit',
    'ROLE_SPEC',
    'RUNTIME_PROFILE',
    'PRESERVATION_MAP',
    'PORTABLE_ROLE_PROMPT',
    'FINAL_ROLE_PROMPT',
    'TRIAGE_RESULT',
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

if (Test-Path -LiteralPath (Resolve-RepoPath 'LICENSE')) {
    Write-Host 'License file present.' -ForegroundColor Green
}
else {
    Add-Warning 'LICENSE is not present. Public release remains blocked until the owner selects one.'
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

Write-Host 'Release validation passed.' -ForegroundColor Green
exit 0
