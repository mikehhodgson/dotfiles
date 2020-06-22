; alt + 1
!1::
FormatTime, CurrentDateTime,, yyyy-MM-dd
sendInput %CurrentDateTime%
return

; alt + shift + 1
!+1::
FormatTime, CurrentDateTime,, yyyyMMdd
sendInput %CurrentDateTime%
return

; alt + 2
!2::
FormatTime, CurrentDateTime,, yyyy-MM-dd'T'HH:mm:ss'Z
sendInput %CurrentDateTime%
return
