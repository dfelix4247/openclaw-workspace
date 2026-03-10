# C:\Users\danie\dev\openclaw-workspace\run.ps1
# Uses your shared venv at C:\Users\danie\dev\push-venv and runs repo CLIs via installed entrypoints.
#
# Usage:
#   .\run.ps1 buyer-scout bbb search --query "BBB private schools Downey CA"
#   .\run.ps1 lumen-scout search --query "real estate investing in Downey"
#
# Notes:
# - This does NOT install anything globally.
# - It assumes buyer-scout and lumen-scout entrypoints exist in push-venv\Scripts (your screenshot confirms).
# - It activates push-venv then runs the desired CLI.

param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet("buyer-scout", "lumen-scout", "lumen-core")]
  [string]$Repo,

  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$Args
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Force UTF-8 for PowerShell + native process output/redirection.
# This prevents `> out.jsonl` from being written as UTF-16 in Windows PowerShell.
[Console]::InputEncoding  = [System.Text.UTF8Encoding]::new($false)
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)
$OutputEncoding           = [System.Text.UTF8Encoding]::new($false)

function Fail([string]$Message) {
  Write-Host ""
  Write-Host "ERROR: $Message" -ForegroundColor Red
  exit 1
}

function Info([string]$Message) {
  Write-Host "• $Message" -ForegroundColor Cyan
}

# ---- CONFIG ----
$PushVenvRoot = "C:\Users\danie\dev\push-venv"
$ActivatePs1  = Join-Path $PushVenvRoot "Scripts\Activate.ps1"

# Map repo -> command name (as installed in push-venv\Scripts)
$CmdMap = @{
  "buyer-scout" = "buyer-scout"
  "lumen-scout" = "lumen-scout"
  # If lumen-core eventually exposes a CLI entrypoint, set it here.
  "lumen-core"  = "lumen-core"
}

if (-not (Test-Path -LiteralPath $ActivatePs1)) {
  Fail "push-venv activation script not found: $ActivatePs1"
}

# Activate shared venv
Info "Activating shared venv: $PushVenvRoot"
. $ActivatePs1

# Ensure the command exists (from the venv Scripts)
$cmdName = $CmdMap[$Repo]
$cmd = Get-Command $cmdName -ErrorAction SilentlyContinue

if (-not $cmd) {
  # Helpful diagnostics: list likely entrypoints
  $scripts = Join-Path $PushVenvRoot "Scripts"
  $hint = ""
  if (Test-Path $scripts) {
    $hint = "Available in Scripts: " + ((Get-ChildItem $scripts | Select-Object -ExpandProperty Name) -join ", ")
  }
  Fail "Command '$cmdName' not found after venv activation. $hint"
}

Info "Running: $cmdName $($Args -join ' ')"
& $cmdName @Args

exit $LASTEXITCODE