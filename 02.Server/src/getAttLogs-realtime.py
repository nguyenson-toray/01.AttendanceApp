# -*- coding: utf-8 -*-
import os
import sys
from multiprocessing import Process
from zk import ZK
import pymongo
CWD = os.path.dirname(os.path.realpath(__file__))
ROOT_DIR = os.path.dirname(CWD)
sys.path.append(ROOT_DIR)

client = pymongo.MongoClient("mongodb://192.168.1.11:27017/")
db = client["tiqn"]  # Replace "mydatabase" with your database name
collectionEmployee = db["Employee"]
collectionAttLog = db["AttLog"]
def live_capture_attendance(zkMachine: ZK )-> None:
    print('live_capture : ', zkMachine)
    conn = None
    try:
        print(zkMachine)
        conn = zkMachine.connect()
        for attendance in conn.live_capture():
            if attendance is None:
                pass
            else:
                print (attendance)

                for emp in collectionEmployee.find():
                    if (int(emp['attFingerId']) == int(attendance.user_id)):
                        mydict = {"machineNo": zkMachine.get_network_params()['ip'].last, "uid": attendance.uid, "attFingerId": int(attendance.user_id),
                                  "empId": emp['empId'], "name": emp['name'],
                                  "timestamp": attendance.timestamp}
                        collectionAttLog.insert_one(mydict)
                        break
    except Exception as e:
        print ("Process terminate : {}".format(e))
    finally:
        if conn:
            conn.disconnect()
if __name__ == "__main__":  # confirms that the code is under main function
    machine1 = ZK('192.168.1.31', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
    machine2 = ZK('192.168.1.32', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
    machine3 = ZK('192.168.1.33', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
    machine4 = ZK('192.168.1.34', port=4370, timeout=5, password=0, force_udp=False, ommit_ping=False)
    attMachines = [machine1, machine2, machine3, machine4]
    # Create a new process
    # for machine in attMachines:

    process_machine1 = Process(target=live_capture_attendance, args=(machine1,))
    process_machine2 = Process(target=live_capture_attendance, args=(machine2,))
    process_machine3 = Process(target=live_capture_attendance, args=(machine3,))
    process_machine4 = Process(target=live_capture_attendance, args=(machine4,))
    process_machine1.start()
    process_machine2.start()
    process_machine3.start()
    process_machine4.start()