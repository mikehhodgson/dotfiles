!1::
FormatTime, CurrentDateTime,, yyyy-MM-dd
sendInput %CurrentDateTime%
return

!2::
FormatTime, CurrentDateTime,, yyyy-MM-dd'T'HH:mm:ss'Z
sendInput %CurrentDateTime%
return
