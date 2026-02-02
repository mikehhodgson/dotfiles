# To be located  %UserProfile%\My Documents\WindowsPowerShell\profile.ps1
# https://technet.microsoft.com/en-us/library/bb613488(v=vs.85).aspx

# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables?view=powershell-7#maximumhistorycount
$MaximumHistoryCount = 32767

# Approved verbs:
# https://technet.microsoft.com/en-us/library/ms714428%28v=VS.85%29.aspx


# https://technet.microsoft.com/en-us/magazine/hh360993.aspx

Function Get-CommandDefinition([string]$name) {
  <#
    .SYNOPSIS
    Replicate *NIX "which" command.
    .DESCRIPTION
    Returns the path to the executable matched in the exectution path, or function definition.
    .EXAMPLE
    Get-CommandDefinition cmd
    C:\Windows\system32\cmd.exe
    Get-ChildItem
    .PARAMETER name
    The name of the command to find.
    #>
  process { (Get-Command $name).Definition }
}

Function Edit-Profile([switch]$ise) {
  <#
    .SYNOPSIS
    Open powershell profile in default editor.
    .DESCRIPTION
    Open CurrentUserAllHosts powershell profile in default powershell script editor.
    .PARAMETER ise
    Use PowerShell ISE instead of default.
    #>
  if ($ise) {
    ise $profile.CurrentUserAllHosts
  }
  else {
    Invoke-Item $profile.CurrentUserAllHosts
  }
}

New-Alias -Force -Name s -Value Start-Process

function d() { Set-Location $env:USERPROFILE\Desktop }
function dl() { Set-Location $env:USERPROFILE\Downloads }
function dotfiles() { Set-Location $env:USERPROFILE\git\dotfiles }
function e() { Start-Process . }


Function Get-Weather() {
  # maybe worth caching the data
  (Invoke-WebRequest http://www.bom.gov.au/wa/observations/perth.shtml).AllElements `
  | ForEach-Object { $_.tagname -eq 'td' -and $_.headers -eq "tPERTH-tmp tPERTH-station-perth" } `
  | select-object innerText `
  | Format-Table -hidetableheaders

}

##############################################################################
# Purpose: More-or-less mimic the popular unix "watch" command
# http://blog.ashdar-partners.com/2008/06/simplistic-implementation-of-watch.html
Function Watch-Command {
  param (
    [string] $command,
    [int] $interval = 2
  )

  do {
    Clear-Host
    invoke-expression $command

    # Just to let the user know what is happening
    "Waiting for $interval seconds. Press Ctrl-C to stop execution..."
    Start-Sleep $interval
  }
  # loop FOREVER
  while (1 -eq 1)
}

# https://stackoverflow.com/questions/29066742/watch-file-for-changes-and-run-command-with-powershell
# exec external with code block
# e.g. watch-file -command {.\runPHP.bat} -file your-script.php
Function Watch-File($command, $file) {
  $this_time = (get-item $file).LastWriteTime
  $last_time = $this_time
  while ($true) {
    if ($last_time -ne $this_time) {
      $last_time = $this_time
      invoke-command $command
    }
    Start-Sleep 1
    $this_time = (get-item $file).LastWriteTime
  }
}

function wait($command, $file) {
  $this_time = (get-item $file).LastWriteTime
  $last_time = $this_time
  while ($last_time -eq $this_time) {
    Start-Sleep 1
    $this_time = (get-item $file).LastWriteTime
  }
  invoke-command $command
}

# http://blogs.technet.com/b/heyscriptingguy/archive/2013/08/03/weekend-scripter-use-powershell-to-get-folder-sizes.aspx
#
#If I do not run the function with Admin rights, I will not have
# access to all folders, and errors arise. In fact, even if I do run
# the function with Admin rights, it is likely I will run into
# errors. So I use the ErrorAction parameter (EA) and set it to
# SilentlyContinue (0). I then sort by size. The command is shown
# here:
#
# Get-ChildItem -Directory -Recurse -EA 0 | Get-FolderSize | sort size -Descending
Function Get-FolderSize {
  BEGIN { $fso = New-Object -comobject Scripting.FileSystemObject }
  PROCESS {
    $path = $input.fullname
    $folder = $fso.GetFolder($path)
    $size = $folder.size
    [PSCustomObject]@{'Name' = $path; 'Size' = ($size / 1gb) }
  }
}

Function Get-SystemUptime {
  (Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
}

Function Get-SystemBootTime {
  (Get-CimInstance Win32_OperatingSystem).LastBootUpTime
}

Function Get-MusicForProgramming {
  <#
    .SYNOPSIS
    Gets music.
    .DESCRIPTION
    Returns the mp3s in the rss feed of musicforprogramming.net to the current directory
    .EXAMPLE
    Get-MusicForProgramming
    #>
  Write-Progress -Activity "Getting File List" -Status "Waiting" `
    -PercentComplete 0

  $items = Invoke-RestMethod -Uri "http://musicforprogramming.net/rss.php" |
  sort-object title
  $i = 0

  $items | ForEach-Object {
    $file = $_.comments.Split('/')[-1]
    Write-Progress -Activity "Downloading files" -Status "Downloading $file" `
      -PercentComplete ($i++ / $items.count * 100)
    if (-not (Test-Path $file)) {
      Invoke-WebRequest -Uri $_.comments -OutFile $file
    }
  }

  Write-Progress -Activity "Downloading files" -Status "Download complete" `
    -PercentComplete 100
}

Function Get-MotherboardInfo() {
  wmic baseboard get product, Manufacturer, version, serialnumber
}

if ($IsMacOS) {
  Function Open-Emacs {
    bash -c "TERM=screen-256color emacs -nw $($Args)"
  }
  New-Alias -Force -Name emacs -Value Open-Emacs
}
else {
  New-Alias -Force -Name emacs -Value runemacs   # starts new process
}

Function Start-DockerBash {
  docker run -ti -v ${PWD}:/root ubuntu bash
}

# https://news.ycombinator.com/item?id=20813591
Function hstat($url) {
  Invoke-WebRequest $url | Select-Object StatusCode
}

Function Invoke-Gitk() {
  & gitk --all @args
}

Function Open-History() {
  #Invoke-Item (Get-PSReadLineOption).HistorySavePath
  Get-Content (Get-PSReadLineOption).HistorySavePath
}

# https://stackoverflow.com/a/31776247/10258089
Function Get-LocalBranches() {
  git branch --format "%(refname:short) %(upstream)" | awk '{if (!$2) print $1;}'
}
function python {
  # winget install uv
  uv run python @args
}

New-Alias -Force -Name edp -Value Edit-Profile
New-Alias -Force -Name which -Value Get-CommandDefinition
New-Alias -Force -Name weather -Value Get-Weather
New-Alias -Force -Name w -Value Get-Weather
New-Alias -Force -Name watch -Value Watch-Command
New-Alias -Force -Name uptime -Value Get-SystemUptime
New-Alias -Force -Name boottime -Value Get-SystemBootTime
New-Alias -Force -Name icanhazmusic -Value Get-MusicForProgramming
New-Alias -Force -Name gk -Value Invoke-Gitk
New-Alias -Force -Name yeet -Value Remove-Item
New-Alias -Force -Name hist -Value Open-History
New-Alias -Force -Name local -Value Get-LocalBranches

New-Alias -Force -Name btop -Value btop4win
New-Alias -Force -Name htop -Value btop4win
New-Alias -Force -Name top -Value ntop
New-Alias -Force -Name lg -Value lazygit

# http://stackoverflow.com/questions/2770526/where-are-the-default-aliases-defined-in-powershell
# As a training exercise, and to test my scripts for compatibility, I sometimes remove the non-ReadOnly aliases:
#Get-Alias | ? { ! ($_.Options -match "ReadOnly") } | % { Remove-Item alias:$_ }


if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadline
  Set-PSReadlineOption -EditMode emacs
  Set-PSReadlineOption -HistoryNoDuplicates:$True
  Set-PSReadLineOption -WordDelimiters ";:,.[]{}()/\|^&*-=+'`"@"
  Set-PSReadlineKeyHandler -Key Ctrl+v -Function Paste
  #Set-PSReadLineOption -PredictionSource History

  Set-PSReadLineKeyHandler -Key 'Alt+n' -Function NextSuggestion
  Set-PSReadLineKeyHandler -Key 'Alt+p' -Function PreviousSuggestion

  # https://learn.microsoft.com/en-us/powershell/scripting/learn/shell/using-predictors?view=powershell-7.5#changing-keybindings
  Set-PSReadlineKeyHandler -Key 'Alt+f' `
    -Description "ForwardWord, or AcceptNextSuggestionWord if at end of line" `
    -ScriptBlock {
    $line = $null
    $cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -eq $line.Length) {
      $before = $line
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptNextSuggestionWord()
      [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

      if ($line -ne $before) { return }
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::ForwardWord()
  }

  Set-PSReadlineKeyHandler -Key 'Ctrl+e' `
    -Description "EndOfLine, or AcceptSuggestion if at end of line" `
    -ScriptBlock {
    $line = $null
    $cursor = $null

    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($cursor -eq $line.Length) {
      $before = $line
      [Microsoft.PowerShell.PSConsoleReadLine]::AcceptSuggestion()
      [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

      if ($line -ne $before) { return }
    }

    [Microsoft.PowerShell.PSConsoleReadLine]::EndOfLine()
  }

  Set-PSReadLineOption -Colors  @{
    # https://learn.microsoft.com/en-us/powershell/module/psreadline/set-psreadlineoption?view=powershell-7.5#example-4-set-multiple-color-options
    Command            = $PSStyle.Foreground.Yellow
    Comment            = $PSStyle.Foreground.Cyan
    Number             = $PSStyle.Foreground.White
    Member             = $PSStyle.Foreground.White
    Operator           = $PSStyle.Foreground.White
    Type               = $PSStyle.Foreground.White
    Variable           = $PSStyle.Foreground.Green
    Parameter          = $PSStyle.Foreground.White
    ContinuationPrompt = $PSStyle.Foreground.White
    Default            = $PSStyle.Foreground.White
    InlinePrediction   = $PSStyle.Foreground.Blue
  }

  #Set-PSReadLineKeyHandler -Chord "Ctrl+e" -Function AcceptSuggestion
  #Set-PSReadLineKeyHandler -Chord "Ctrl+f" -Function ForwardWord

  # https://github.com/PowerShell/PSReadLine/blob/master/PSReadLine/SamplePSReadLineProfile.ps1

  <#
  Set-PSReadLineKeyHandler -Chord '"', "'" `
    -BriefDescription SmartInsertQuote `
    -LongDescription "Insert paired quotes if not already on a quote" `
    -ScriptBlock {
    param($key, $arg)

    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    if ($line.Length -gt $cursor -and $line[$cursor] -eq $key.KeyChar) {
      # Just move the cursor
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor + 1)
    }
    else {
      # Insert matching quotes, move cursor to be in between the quotes
      [Microsoft.PowerShell.PSConsoleReadLine]::Insert("$($key.KeyChar)" * 2)
      [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
      [Microsoft.PowerShell.PSConsoleReadLine]::SetCursorPosition($cursor - 1)
    }
  }
#>

  # https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup

  # still want to import posh-git for git tab completion
  # Install-Module posh-git -Scope CurrentUser -Force
  #Import-Module posh-git

  # https://github.com/devblackops/Terminal-Icons
  # Install-Module -Name Terminal-Icons -Repository PSGallery
  #slow!
  #Import-Module -Name Terminal-Icons

  # handle slow imports
  Register-EngineEvent -SourceIdentifier 'PowerShell.OnIdle' -MaxTriggerCount 1 -Action {
    Import-Module -Name Terminal-Icons -Global
    Import-Module posh-git
  } | Out-Null

  # https://ohmyposh.dev/docs/installation/windows
  # https://ohmyposh.dev/docs/installation/prompt
  # winget install JanDeDobbeleer.OhMyPosh --source winget
  # now requires "Nerd Fonts", not "Powerline" fonts: www.nerdfonts.com/font-downloads
  # Initialize Oh-My-Posh with a theme
  # from https://github.com/JanDeDobbeleer/oh-my-posh/blob/main/themes/powerline.omp.json
  oh-my-posh init pwsh --config $PSScriptRoot\powerline.omp.json | Invoke-Expression
}

# For Windows Terminal Themes
# https://windowsterminalthemes.dev/
# https://learn.microsoft.com/en-us/windows/terminal/custom-terminal-gallery/theme-gallery
# https://terminalsplash.com/