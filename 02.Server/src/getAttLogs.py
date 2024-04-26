
import pymongo
import sys
import os
from datetime import *
# from src.database.attLogMachine import AttLogMachine

sys.path.insert(1,os.path.abspath("./pyzk"))
from zk import ZK, const
conn = None
machine1 = ZK('192.168.1.31', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
machine2 = ZK('192.168.1.32', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
machine3 = ZK('192.168.1.33', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
machine4 = ZK('192.168.1.34', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)

from zk import ZK, const
client = pymongo.MongoClient("mongodb://192.168.1.11:27017/")
db = client["tiqn"]  # Replace "mydatabase" with your database name
collectionEmployee = db["Employee"]
collectionAttLogMachine = db["AttLogMachine"]
collectionAttLog = db["AttLog"]
collectionHistoryGetAttLogs = db["HistoryGetAttLogs"]
# Find all documents
allEmployee = collectionEmployee.find()
historyGetAttLogs = collectionHistoryGetAttLogs.find()
attMachines= [machine1, machine2, machine3, machine4]
machineNo=0
count=0
totalCount=0
try:
    # connect to device
    timeBeginGetLogs = datetime.now()
    for machine in attMachines:
        machineNo+=1
        count=0
        machineNoStr=f"machine{machineNo}"
        history={}
        for his in collectionHistoryGetAttLogs.find():
            if(int(his['machine'])==machineNo):
                history=his
        lastTime = history['lastTimeGetAttLogs']
        lastCount = history['lastCount']
        conn = machine.connect()
        print(f"Connecting machine : {machine.get_network_params()}")
        # disable device, this method ensures no activity on the device while the process is run
        conn.disable_device()
        # another commands will be here!
        # Get attendances (will return list of Attendance object)
        attendances = conn.get_attendance()
        for attendance in attendances:
            if (attendance.timestamp >lastTime):
                mydict = {"machineNo": machineNo, "uid": attendance.uid, "attFingerId": int(attendance.user_id),
                          "empId": 'TIQN-XXXX', "name": 'Not setting yet',
                          "timestamp": attendance.timestamp}
                for emp in collectionEmployee.find():
                    if(int(emp['attFingerId'])==int(attendance.user_id)):
                        mydict = {"machineNo": machineNo, "uid": attendance.uid, "attFingerId": int(attendance.user_id), "empId":emp['empId'], "name":emp['name'],
                                  "timestamp": attendance.timestamp}
                        break

                collectionAttLog.insert_one(mydict)
                count += 1

        myquery = {"machine": machineNo}
        newvalue = {"$set": {"lastTimeGetAttLogs": datetime.now(), "lastCount": count}}
        print(f"  => {count} records")
        collectionHistoryGetAttLogs.update_one(myquery, newvalue)
        totalCount+=count
        conn.enable_device()
except Exception as e:
    print ("Process terminate : {}".format(e))
finally:
    if conn:
        conn.disconnect()
    print(f"Total records : {totalCount}")
    timeEndGetLogs = datetime.now()
    print(f"Total time : {timeEndGetLogs - timeBeginGetLogs}")
