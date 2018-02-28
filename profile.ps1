# To be located  %UserProfile%\My Documents\WindowsPowerShell\profile.ps1
# https://technet.microsoft.com/en-us/library/bb613488(v=vs.85).aspx

if ($host.Name -eq 'ConsoleHost') {
    Import-Module PSReadline
    Set-PSReadlineOption -EditMode emacs
    Set-PSReadlineOption -HistoryNoDuplicates:$True
    Set-PSReadlineKeyHandler -Key Ctrl+v -Function Paste

    #https://github.com/lzybkr/PSReadLine/blob/master/PSReadLine/SamplePSReadlineProfile.ps1
}


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
    process{(Get-Command $name).Definition}
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

Function Get-Weather() {
    # maybe worth caching the data
    (Invoke-WebRequest http://www.bom.gov.au/wa/observations/perth.shtml).AllElements `
        | ? {$_.tagname -eq 'td' -and $_.headers -eq "tPERTH-tmp tPERTH-station-perth"} `
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
    BEGIN{$fso = New-Object -comobject Scripting.FileSystemObject}
    PROCESS{
        $path = $input.fullname
        $folder = $fso.GetFolder($path)
        $size = $folder.size
        [PSCustomObject]@{'Name' = $path;'Size' = ($size / 1gb)}
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
    $i=0

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


if ($IsOSX) {
    Function Open-Emacs {
        bash -c "TERM=screen-256color emacs -nw $($Args)"
    }
    New-Alias -Force -Name emacs -Value Open-Emacs
}
else {
    New-Alias -Force -Name emacs -Value runemacs   # starts new process
}

New-Alias -Force -Name edp -Value Edit-Profile
New-Alias -Force -Name which -Value Get-CommandDefinition
New-Alias -Force -Name weather -Value Get-Weather
New-Alias -Force -Name w -Value Get-Weather
New-Alias -Force -Name watch -Value Watch-Command
New-Alias -Force -Name uptime -Value Get-SystemUptime
New-Alias -Force -Name boottime -Value Get-SystemBootTime
New-Alias -Force -Name icanhazmusic -Value Get-MusicForProgramming


# http://stackoverflow.com/questions/2770526/where-are-the-default-aliases-defined-in-powershell
# As a training exercise, and to test my scripts for compatibility, I sometimes remove the non-ReadOnly aliases:
#Get-Alias | ? { ! ($_.Options -match "ReadOnly") } | % { Remove-Item alias:$_ }
