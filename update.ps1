$ErrorActionPreference = "Stop"

$RepoGit = "https://github.com/xEncerx/Academic-AI.git"
$RepoRaw = "https://raw.githubusercontent.com/xEncerx/Academic-AI/main"

$LocalVersion = if (Test-Path ".version") { Get-Content ".version" -Raw } else { "0.0.0" }
$RemoteVersion = (Invoke-WebRequest "$RepoRaw/.version").Content.Trim()

if ($LocalVersion.Trim() -eq $RemoteVersion) {
    Write-Host "✅ Уже актуальная версия: $LocalVersion"
    exit 0
}

Write-Host "🔄 Обновление с $($LocalVersion.Trim()) → $RemoteVersion"

$TmpDir = Join-Path $env:TEMP "academic-ai-update"
if (Test-Path $TmpDir) { Remove-Item $TmpDir -Recurse -Force }
git clone --depth=1 $RepoGit $TmpDir 2>$null

# Папки шаблона
$TemplateDirs = @("settings", ".agents")
foreach ($dir in $TemplateDirs) {
    if (Test-Path ".\$dir") { Remove-Item ".\$dir" -Recurse -Force }
    Copy-Item "$TmpDir\$dir" ".\$dir" -Recurse
}

# Файлы шаблона
$TemplateFiles = @("main.typ", "docs.md", "README.md", "AGENTS.md", ".version")
foreach ($file in $TemplateFiles) {
    Copy-Item "$TmpDir\$file" ".\$file" -Force
}

Remove-Item $TmpDir -Recurse -Force
Write-Host "✅ Шаблон обновлён до версии $RemoteVersion"