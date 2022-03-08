@echo off
SETLOCAL

:: Use double slash \\ for .reg compatibility

set "thisdir=%~dp0"
set "thisdir=%thisdir:\=\\%"

set "scriptpath=%thisdir%script.cmd"
set "icopath=%thisdir%ico.ico"
set "noshellpath=%thisdir%noshell.vbs"

:: Remove previous context menu entries
call "%~dp0ContextMenuRemove.cmd"


:: Create noshell.vbs in order to run github.bat silently (to avoid cmd window popup)
echo 'from http://superuser.com/questions/140047                                                   >"%noshellpath%"
echo If WScript.Arguments.Count ^>= 1 Then                                                        >>"%noshellpath%"
echo     ReDim arr(WScript.Arguments.Count-1)                                                     >>"%noshellpath%"
echo     For i = 0 To WScript.Arguments.Count-1                                                   >>"%noshellpath%"
echo         Arg = WScript.Arguments(i)                                                           >>"%noshellpath%"
echo         If InStr(Arg, " ") ^> 0 or InStr(Arg, "&") ^> 0 Then Arg = chr(34) ^& Arg ^& chr(34) >>"%noshellpath%"
echo       arr(i) = Arg                                                                           >>"%noshellpath%"
echo     Next                                                                                     >>"%noshellpath%"
echo     RunCmd = Join(arr)                                                                       >>"%noshellpath%"
echo     CreateObject("Wscript.Shell").Run RunCmd, 0 , True                                       >>"%noshellpath%"
echo End If                                                                                       >>"%noshellpath%"



:: Add context menu
set "rtmp=%temp%\context-menu--activate.reg"

echo Windows Registry Editor Version 5.00                                                        >"%rtmp%"
echo:                                                                                           >>"%rtmp%"
echo ; Right click on explorer TREE                                                             >>"%rtmp%"
echo [HKEY_CURRENT_USER\Software\Classes\Directory\shell\PyCharmOpenGitBase]                    >>"%rtmp%"
echo @="PyCharm Open Git Base"                                                                  >>"%rtmp%"
echo "Icon"="%icopath%,0"                                                                       >>"%rtmp%"
echo:                                                                                           >>"%rtmp%"
echo [HKEY_CURRENT_USER\Software\Classes\Directory\shell\PyCharmOpenGitBase\command]            >>"%rtmp%"
echo @="WScript \"%noshellpath%\" \"%scriptpath%\" \"%%1\""                                     >>"%rtmp%"
echo:                                                                                           >>"%rtmp%"
echo ; Right click on explorer main area                                                        >>"%rtmp%"
echo [HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\PyCharmOpenGitBase]         >>"%rtmp%"
echo @="PyCharm Open Git Base"                                                                  >>"%rtmp%"
echo "Icon"="%icopath%,0"                                                                       >>"%rtmp%"
echo:                                                                                           >>"%rtmp%"
echo [HKEY_CURRENT_USER\Software\Classes\Directory\Background\shell\PyCharmOpenGitBase\command] >>"%rtmp%"
echo @="WScript \"%noshellpath%\" \"%scriptpath%\" \"%%V\""                                     >>"%rtmp%"

reg import "%rtmp%" > nul 2>&1
del "%rtmp%"

echo PyCharm Open Git Base has been added
echo:

:: Pause if double clicked
if /i "%comspec% /c %~0 " equ "%cmdcmdline:"=%" pause