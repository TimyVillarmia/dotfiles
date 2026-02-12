# --- 1. THEME (Oh-My-Posh) ---
$themePath = "$HOME\.config\powershell\takuya.omp.json"
if (!(Test-Path $themePath)) {
    $null = New-Item -ItemType Directory -Force -Path (Split-Path $themePath)
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/craftzdog/dotfiles-public/master/.config/powershell/takuya.omp.json" -OutFile $themePath
}
oh-my-posh init pwsh --config $themePath | Invoke-Expression
oh-my-posh disable notice

# --- 2. MODULES ---
Import-Module Terminal-Icons -ErrorAction SilentlyContinue

# --- 3. ZSH-LIKE ALIASES & REPO TOOLS ---
Set-Alias -Name c -Value clear
Set-Alias -Name v -Value code
Set-Alias -Name grep -Value Select-String
# New Aliases to match your WSL workflow
Set-Alias -Name reload -Value { . $PROFILE }
Set-Alias -Name edpro -Value { code $PROFILE }

# --- 4. NAVIGATION & UTILITIES ---
function cdc { Set-Location "C:\Users\timyv" }
function desk { Set-Location "C:\Users\timyv\Desktop" }
function wsl { Set-Location "\\wsl.localhost\Ubuntu\home\timy" } 
function win { explorer.exe . } # Opens Windows Explorer in current folder

# --- 5. PSREADLINE (The "Zsh" Feel) ---
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Use Arrow Keys to search history like in Zsh
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -Colors @{ InlinePrediction = '#717171' }