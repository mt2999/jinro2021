REM :: notUSE^
/*
setlocal
cls
date /t&time /t
hostname
wmic logicaldisk get Name,Size,FreeSpace >%~dp0log\disk.log
ipconfig /all
netstat -r
typeperf -sc 10 -si 10 -o %~dp0log\cpu.log "\processor(_Total)\% Processor Time"
typeperf -sc 10 -si 10 -o %~dp0log\mem.log "\Memory\Available MBytes"
gpresult /z
gpresult /h %~dp0log\gp.html
w32tm /query /status
copy /y c:\Windows\System32\drivers\etc\hosts %~dp0log\.
systeminfo
wmic printer get name >%~dp0log\printer.log
set appcmd=c:\windows\system32\inetsrv\appcmd.exe
%appcmd% list site
%appcmd% list vdir
%appcmd% list app
%appcmd% list apppool
%appcmd% list config /section:staticcontent
tree f:\
copy /y %DBIO_ENV% %~dp0log\DBIO_ENV.txt
copy /y %DBIO_ENV_x64% %~dp0log\DBIO_ENV_x64.txt
pushd f:\
dir /a-d /oe /q /s
for /f %%i in ('dir /a-d /oe /q /s /b') do icacls %%i
popd
set
net start
net use
net share
net user hdk
if not "%ORACLE_HOME%" == "" (
 copy /y %ORACLE_HOME%\network\admin\sqlnet.ora %~dp0log\.
 copy /y %ORACLE_HOME%\network\admin\tnsnames.ora %~dp0log\.
 copy /y %ORACLE_HOME%\network\admin\listener.ora %~dp0log\.
 copy /y %ORACLE_HOME%\database\*pfile*.ora %~dp0log\.
)
tnsping localhost
lsnrctl status
expdp \"/ as sysdba\" full=y estimate_only=yes
copy /y d:\BACKUP\Export.bat %~dp0log\.
copy /y d:\Program Files(X86)\Netcobol\reboot.bat %~dp0log\.
call :SQL
date /t&time /t
endlocal
goto :EOF

:SQL
SET CONN=/ as sysdba
SET NLS_LANG=japanese_japan.ja16sjis
sqlplus -l %CONN% @"%~f0"
Exit /b
*/

show parameters
show parameter spfile

set linesize 80
select * from v$version;

col tablespace_name for a20
select * from dba_tablespace_usage_metrics;

col grantee for a30
col granted_role for a30
select * from dba_role_privs where grantee like '%HDK';

col product for a40
col version for a20
col status for a20
select product,version,status from product_component_version;

col instance_name for a20
col host_name for a20
col version for a20
col startup_time for a20
select instance_name,host_name,version,startup_time from v$instance;

col parameter for a20
col value for a20
select parameter,value from v$option;

exit
