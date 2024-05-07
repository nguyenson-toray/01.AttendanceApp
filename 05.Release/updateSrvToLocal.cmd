cls
@echo off 
set  localDir="D:\04.Attendance App" 
set /p buildLocal=<"D:\04.Attendance App\version.txt"
set srvDir="T:\02.Public\05.IT\02.Software\04.Attendance App" 
set /p buildSrv=<"T:\02.Public\05.IT\02.Software\04.Attendance App\version.txt"

echo localDir:%localDir%
echo buildLocal:%buildLocal%
echo srvDir:%srvDir%
echo buildSrv:%buildSrv%

if exist "D:\04.Attendance App\" goto exits_func else goto not_exits_func
:exits_func (
	echo EXITS
	if  "%buildLocal%"=="%buildSrv%" (
	echo Local same srv	
	goto :runApp
	) else (
	echo Local diff srv	
	goto :updateApp
	)
)
:not_exits_func (
echo No Exits
mkdir %buildLocal%
Xcopy /E /H /C /I /Y %srvDir% %localDir% 
goto :updateApp
)
:updateApp
Xcopy /E /H /C /I /Y %srvDir% %localDir% 
:runApp 
echo runApp
@echo off

start  /MAX "" "D:\04.Attendance App\tiqn.exe" 
