# --- 1. THEME (Oh-My-Posh) ---
# Takuya/Craftzdog theme initialization
$themePath = "$HOME\.config\powershell\takuya.omp.json"
if (!(Test-Path $themePath)) {
    $null = New-Item -ItemType Directory -Force -Path (Split-Path $themePath)
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craftzdog/dotfiles-public/master/.config/powershell/takuya.omp.json" -OutFile $themePath
}
oh-my-posh init pwsh --config $themePath | Invoke-Expression
oh-my-posh disable notice

# --- 2. MODULES ---
# Terminal-Icons adds the folder/file icons to 'ls'
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# --- 3. REPO TOOLS & ALIASES ---
# One-letter shortcuts
Set-Alias -Name c -Value clear
Set-Alias -Name v -Value code
Set-Alias -Name grep -Value Select-String

# Unified Workflow (Matches your WSL setup)
function reload { . $PROFILE }
function edpro  { code $PROFILE }

# --- 4. NAVIGATION & SHORTCUTS ---
function cdc  { Set-Location "C:\Users\timyv" }
function desk { Set-Location "C:\Users\timyv\Desktop" }
function wsl  { Set-Location "\\wsl.localhost\Ubuntu\home\timy" } 
function win  { explorer.exe . }

# --- 5. PSREADLINE (Smart Zsh-style History) ---
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Up/Down Arrow search (Type 'git' then Up Arrow to see only git history)
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# Colors
Set-PSReadLineOption -Colors @{ InlinePrediction = '#717171' }