# Modules
Install-Module -Name PowerShellGet -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module -Name "F7History"

# Cli
choco install fd -y
choco install fzf -y
choco install bat -y
choco install ripgrep -y
choco install jq -y
choco install far -y
choco install micro -y
choco install lazygit -y
choco install oh-my-posh -y
choco install doublecmd -y
choco install ntop.portable -y

# dotnet tools
dotnet tool install -g csharprepl