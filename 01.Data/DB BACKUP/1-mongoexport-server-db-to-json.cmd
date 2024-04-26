mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttDevice  --out=AttDevice.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttReport  --out=AttReport.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=AttLog  --out=AttLog.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=Employee  --out=Employee.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=HistoryGetAttLogs  --out=HistoryGetAttLogs.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=OtRegister  --out=OtRegister.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=Shift  --out=Shift.json
mongoexport --uri="mongodb://192.168.1.11:27017/tiqn"  --collection=ShiftRegister  --out=ShiftRegister.json