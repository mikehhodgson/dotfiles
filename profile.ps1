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

Function Set-Location-Dotfiles() { Set-Location $env:appdata\dotfiles }

Function Open-Explorer-Here() {
  start .
}

Function Get-Weather() {
  # maybe worth caching the data
  (Invoke-WebRequest http://www.bom.gov.au/wa/observations/perth.shtml).AllElements `
  | ? { $_.tagname -eq 'td' -and $_.headers -eq "tPERTH-tmp tPERTH-station-perth" } `
  | select-object innerText `
  | ft -hidetableheaders

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
    clear
    invoke-expression $command

    # Just to let the user know what is happening
    "Waiting for $interval seconds. Press Ctrl-C to stop execution..."
    sleep $interval
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
    sleep 1
    $this_time = (get-item $file).LastWriteTime
  }
}

Function WaitFor-File($command, $file) {
  $this_time = (get-item $file).LastWriteTime
  $last_time = $this_time
  while ($last_time -eq $this_time) {
    sleep 1
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

Function Run-Gitk() {
  & gitk --all @args
}

Function Open-History() {
  Invoke-Item (Get-PSReadLineOption).HistorySavePath
}

# https://stackoverflow.com/a/31776247/10258089
Function Get-LocalBranches() {
  git branch --format "%(refname:short) %(upstream)" | awk '{if (!$2) print $1;}'
}

New-Alias -Force -Name edp -Value Edit-Profile
New-Alias -Force -Name which -Value Get-CommandDefinition
New-Alias -Force -Name weather -Value Get-Weather
New-Alias -Force -Name w -Value Get-Weather
New-Alias -Force -Name watch -Value Watch-Command
New-Alias -Force -Name uptime -Value Get-SystemUptime
New-Alias -Force -Name boottime -Value Get-SystemBootTime
New-Alias -Force -Name icanhazmusic -Value Get-MusicForProgramming
New-Alias -Force -Name dotfiles -Value Set-Location-Dotfiles
New-Alias -Force -Name here -Value Open-Explorer-Here
New-Alias -Force -Name gk -Value Run-Gitk
New-Alias -Force -Name yeet -Value Remove-Item
New-Alias -Force -Name hist -Value Open-History
New-Alias -Force -Name local -Value Get-LocalBranches

# http://stackoverflow.com/questions/2770526/where-are-the-default-aliases-defined-in-powershell
# As a training exercise, and to test my scripts for compatibility, I sometimes remove the non-ReadOnly aliases:
#Get-Alias | ? { ! ($_.Options -match "ReadOnly") } | % { Remove-Item alias:$_ }


if ($host.Name -eq 'ConsoleHost') {
  Import-Module PSReadline
  Set-PSReadlineOption -EditMode emacs
  Set-PSReadlineOption -HistoryNoDuplicates:$True
  Set-PSReadLineOption -WordDelimiters ";:,.[]{}()/\|^&*-=+'`"@"
  Set-PSReadlineKeyHandler -Key Ctrl+v -Function Paste

  Set-PSReadLineOption -Colors  @{
    "Operator"  = [ConsoleColor]::White
    "Parameter" = [ConsoleColor]::White
  }
  #https://github.com/lzybkr/PSReadLine/blob/master/PSReadLine/SamplePSReadlineProfile.ps1

  # https://docs.microsoft.com/en-us/windows/terminal/tutorials/powerline-setup

  # https://ohmyposh.dev/docs/installation/windows
  # https://ohmyposh.dev/docs/installation/prompt
  # winget install JanDeDobbeleer.OhMyPosh --source winget
  # now requires "Nerd Fonts", not "Powerline" fonts: www.nerdfonts.com/font-downloads
  # Initialize Oh-My-Posh with a theme
  oh-my-posh init pwsh --config 'powerline' | Invoke-Expression
}