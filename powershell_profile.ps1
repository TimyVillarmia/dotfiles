# --- 1. THEME (Oh-My-Posh) ---
# Pointing to the specific dotfile location you're now using
$themePath = "$HOME\.takuya.omp.json"

if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config $themePath | Invoke-Expression
    oh-my-posh disable notice
}

# --- 2. MODULES ---
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# --- 3. REPO TOOLS & ALIASES ---
Set-Alias -Name c -Value clear
Set-Alias -Name v -Value code
Set-Alias -Name grep -Value Select-String

function reload { . $PROFILE }
function edpro  { code $PROFILE }

# --- 4. NAVIGATION & SHORTCUTS ---
# Added zoxide (z) support to match your Fedora workflow
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    zoxide init powershell | Invoke-Expression
}

function cdc  { Set-Location "C:\Users\timyv" }
function desk { Set-Location "C:\Users\timyv\Desktop" }
function wsl  { Set-Location "\\wsl.localhost\Ubuntu\home\timy" } 
function win  { explorer.exe . }

# --- 5. PSREADLINE (Zsh-style Experience) ---
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Matches the "Up-Arrow search" behavior from your .zshrc
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

Set-PSReadLineOption -Colors @{ InlinePrediction = '#717171' }