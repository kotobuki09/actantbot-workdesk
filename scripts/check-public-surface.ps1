$ErrorActionPreference = 'Stop'

$tracked = @(git ls-files --cached --others --exclude-standard)
if ($tracked.Count -eq 0) {
  throw 'Run this check from an initialized Git repository.'
}

$forbiddenNames = @('.env', '.env.local', '.env.production', 'id_rsa', 'id_ed25519')
$secretPatterns = @(
  'AKIA[0-9A-Z]{16}',
  'BEGIN (RSA|OPENSSH|EC|PGP) PRIVATE KEY',
  'ghp_[A-Za-z0-9]{20,}',
  'github_pat_[A-Za-z0-9_]{20,}',
  'sk-[A-Za-z0-9]{20,}'
)

$violations = [System.Collections.Generic.List[string]]::new()
foreach ($path in $tracked) {
  $name = [IO.Path]::GetFileName($path)
  if ($forbiddenNames -contains $name) {
    $violations.Add("forbidden tracked file: $path")
    continue
  }

  $content = Get-Content $path -Raw -ErrorAction Stop
  foreach ($pattern in $secretPatterns) {
    if ($content -match $pattern) {
      $violations.Add("secret pattern '$pattern' found in: $path")
    }
  }
}

if ($violations.Count -gt 0) {
  $violations | ForEach-Object { Write-Error $_ }
  exit 1
}

Write-Output "PUBLIC_SURFACE_OK files=$($tracked.Count)"
