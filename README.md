# RayManage
Raynet Management Client uninstall
From Felxera with thanks
Script needs product code

Run regedit.exe
Navigate to the HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall registry key. 
For 64 bit systems this would be: HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
Select the Edit > Find... menu option, and search for the string "ManageSoft for managed devices" (without the quotes).
This string should be found under a registry key with a path like 
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\ {30A2BB4B-D82F-4BC0-B074-4455731DAFC2}. 
The value surrounded by curly braces ("{" and "}") at the end of this path is the product code.

Product code to be inserted:
msiexec /x{ProductCode} /q /l*v c:\Temp\UninstallManageSoft.log
