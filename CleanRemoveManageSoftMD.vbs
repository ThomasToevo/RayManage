removeProduct
removeManageSoftEventLog


Sub removeManageSoftEventLog
	const MgsELKey = "HKLM\System\CurrentControlSet\Services\EventLog\ManageSoft\"
	const MgsELFileLocationKey = "HKLM\System\CurrentControlSet\Services\EventLog\ManageSoft\File"
	const RunonceFullValue = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\RemoveMGSEventLog"
	const HKEY_LOCAL_MACHINE = &H80000002

	on error resume next

	Set WshShell = WScript.CreateObject("WScript.Shell")

	' Remove registy keys for the event log
	WshShell.RegDelete("HKLM\System\CurrentControlSet\Services\EventLog\ManageSoft\")
	
	' Add a registry key that will remove the evt file on reboot
	dim sysRoot
	sysRoot = WshShell.ExpandEnvironmentStrings("%systemroot%")
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\RemoveMGSEventLog1",_
		"command.com /C del " & sysRoot & "\system32\config\ManageSo.evt"
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\RemoveMGSEventLog2",_
		"command.com /C del " & sysRoot & "\system32\config\Manage~1.evt"
	WshShell.RegWrite "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\RemoveMGSEventLog3",_
		"command.com /C del " & sysRoot & "\system32\config\ManageSoft.evt"
end Sub

sub removeProduct

	Set WshShell = WScript.CreateObject("WScript.Shell")
	
	On Error Resume Next
	
	' Run ndlaunch
	executeCommand """C:\Program Files\ManageSoft\Launcher\ndlaunch"" -o InstallProfile=Public -d ""Managed Device Default Configuration"" -o UILevel=Quiet"
	
	' run the uninstaller, TKL:insert product key oof your installation here below
	executeCommand "msiexec /x{21822924-9872-4DE0-85B7-D9C766D563F1} /q"
	
	' Remove directories
	dim filesys
	Set filesys = CreateObject("Scripting.FileSystemObject")

	If filesys.FolderExists("C:\Program Files\ManageSoft") Then 
		filesys.DeleteFolder "C:\Program Files\ManageSoft",True
	End If 

	'get environment variable
	dim oShell, oEnv, oWDir, strPath
	set oShell = CreateObject ("WScript.Shell")
	Set oEnv = oShell.Environment("Process")
	strPath = oEnv("windir") & "\Temp\ManageSoft"

	If filesys.FolderExists(strPath) Then 
		filesys.DeleteFolder strPath,True
	End If 

	If filesys.FolderExists("C:\Documents and Settings\All Users\Application Data\ManageSoft Corp") Then 
		filesys.DeleteFolder "C:\Documents and Settings\All Users\Application Data\ManageSoft Corp",True
	End If 
		
	' Remove registry keys
	executeCommand "REG DELETE ""HKLM\Software\ManageSoft Corp\ManageSoft"" /F"


end sub

sub executeCommand(myCommand)
	dim Result
	Set WshShell = WScript.CreateObject("WScript.Shell")
	
	On Error Resume Next
	Err.clear
	Result = WshShell.Run(myCommand,RunMinimizeWindow, True)
	If Result <> 0 Or Err.Number <> 0 Then
		wscript.Echo("Error running command:")
		wscript.Echo(myCommand)
		wscript.Echo(Err.description &"  Error number:"& Err.number)
	End If
end sub
