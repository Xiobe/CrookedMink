@echo off\
rem Create temporary directory to gather information
mkdir %TEMP%\discovery

rem Gather the Windows OS version
ver > %TEMP%\discovery\T1082_version.txt

rem Print all the environment variables
set > %TEMP%\discovery\T1082_environment.txt

rem Get current user information, SID, domain, groups the user belongs to and
rem and the security privileges of the user
whoami /all > %TEMP%\discovery\T1033_userinfo.txt
whoami /user /fo list >> %TEMP%\discovery\T1033_userinfo.txt

rem Get computer name, user name, OS version, domain information, DNS and the
rem logon domain
net config workstation > %TEMP%\discovery\T1082_computerinfo.txt
net config server >> %TEMP%\discovery\T1082_computerinfo.txt

rem Get information about the domain, network adapters, DNS/WSUS server
ipconfig /all > %TEMP%\discovery\T1016_network.txt

rem Get information about the configuration of the computer, the configuration
rem of the operating system, including security informatiom, product ID and
rem hardware properties, such as RAM, disk space and network cards
systeminfo /fo list > %TEMP%\discovery\T1082_systeminfo.txt

rem Check the registry value for terminal services, when it is 0, then terminal
rem services are enabled, when it is 1, they are disabled.
reg query "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections > T1012_terminalservices.txt

rem Display the ARP table
arp -a > %TEMP%\discovery\T1016_arp.txt

rem Display the route table
route print > %TEMP%\discovery\T1016_routetable.txt

rem Display the current TCP/IP network connections
if %ERRORLEVEL EQU 0 (
   netstat -bano > %TEMP%\discovery\T1049_netstat.txt
) else (
  netstat -ano > %TEMP%\discovery\T1049_netstat.txt
)

rem Display the processes and their loaded modules
tasklist /M /fo list > %TEMP%\discovery\T1057_tasklist_modules.txt

rem Display the verbose process information
tasklist /V /fo list > %TEMP%\discovery\T1057_tasklist_verbose.txt

rem Display the services
tasklist /svc /fo list > %TEMP%\discovery\T1057_tasklist_services.txt

rem Display the apps
tasklist /apps /fo list > %TEMP%\discovery\T1057_tasklist_app.txt

rem Display the started network services
net start > %TEMP%\discovery\T1057_net_start.txt

rem Display all visible processes
qprocess * > %TEMP%\discovery\T1057_qprocess.txt

rem Display the list of local administrator accounts on the local system
net localgroup "Administrators" > %TEMP%\discovery\T1069_local_admins.txt

rem Display local administrator information
net user Administrator > %TEMP%\discovery\T1087_local_admin_detail.txt

rem Display local user
net user %username% > %TEMP%\discovery\T1087_local_%username%_detail.txt

rem Display the shares of the local system presented to the network
rem C$ is the default share
rem IPC$ is the remote IPC share
rem ADMIN$ is the remote Admin share
net share > %TEMP%\discovery\T1135_local_shares.txt

rem Display active SMB sessions on local system so you can see which users have
rem connections.
if %ERRORLEVEL EQU 0 (
   net session | find "\\" > %TEMP%\discovery\T1049_SMB_sessions.txt
) else (
   echo "Executed with no administrative privileges" > %TEMP%\discovery\T1049_SMB_sessions.txt
)
