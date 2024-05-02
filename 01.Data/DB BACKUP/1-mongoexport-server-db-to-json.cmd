REM @ECHO OFF
cls
setlocal enableextensions
set nameDir=%DATE:/=_%
mkdir %nameDir%
xcopy  .\2-mongoimport-json-to-local-db.cmd .\%nameDir% /K /D /H /Y
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttDevice  --out=%nameDir%/AttDevice.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttReport  --out=%nameDir%/AttReport.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttLog  --out=%nameDir%/AttLog.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=Config  --out=%nameDir%/Config.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=Employee  --out=%nameDir%/Employee.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=HistoryGetAttLogs  --out=%nameDir%/HistoryGetAttLogs.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=LastModifiedExcelData  --out=%nameDir%/LastModifiedExcelData.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=OtRegister  --out=%nameDir%/OtRegister.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=Shift  --out=%nameDir%/Shift.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=ShiftRegister  --out=%nameDir%/ShiftRegister.json