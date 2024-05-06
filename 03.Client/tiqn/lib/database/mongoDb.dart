import 'package:mongo_dart/mongo_dart.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/gValue.dart';

class MongoDb {
  String ipServer = '192.168.1.11';
  // 'localhost';
  late var colEmployee,
      colAttLog,
      colShift,
      colShiftRegister,
      colOtRegister,
      colConfig;
  late Db db;
  initDB() async {
    db = Db("mongodb://$ipServer:27017/tiqn");
    try {
      await db.open();

      colEmployee = db.collection('Employee');
      colAttLog = db.collection('AttLog');
      colShift = db.collection('Shift');
      colShiftRegister = db.collection('ShiftRegister');
      colOtRegister = db.collection('OtRegister');
      colConfig = db.collection('Config');
    } catch (e) {
      print(e);
    }
  }

  getConfig() async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> result = [];
      result = await colConfig.find().toList();
      gValue.allowAllOt = result.first['allowAllOt'];
      gValue.defaultOt2H = result.first['defaultOt2H'];
      gValue.showObjectId = bool.parse(result.first['showObjectId']);
    } catch (e) {
      print(e);
    }
  }

  Future<List<Shift>> getShifts() async {
    List<Shift> result = [];
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      await colShift
          .find(where.sortBy('shift', descending: false))
          .forEach((shift) => {result.add(Shift.fromMap(shift))});
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> result = [];
    try {
      if (!db.isConnected) {
        print('getEmployees - DB not connected, try connect again');
        await initDB();
      }
      await colEmployee
          .find(where.sortBy('empId', descending: true))
          .forEach((emp) => {result.add(Employee.fromMap(emp))});
      // print('getAllEmployee => ${result.length} records');
    } catch (e) {
      print(e);
    }

    return result;
  }

  Future<void> removeEmployee(String empId) async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      await colEmployee.deleteOne({"empId": empId});
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertManyEmployees(List<Employee> inputEmps) async {
    try {
      if (!db.isConnected) {
        print('insertManyEmployees - DB not connected, try connect again');
        await initDB();
      }
      List<Employee> allEmps = await getEmployees();
      List<Employee> empNews = [];
      List<Employee> empExits = [];
      var str = allEmps.toString();
      for (var element in inputEmps) {
        str.contains(element.empId.toString())
            ? empExits.add(element)
            : empNews.add(element);
      }
      List<Map<String, dynamic>> mapNews = [];
      for (var element in empNews) {
        mapNews.add(element.toMap());
      }
      if (mapNews.isNotEmpty) await colEmployee.insertMany(mapNews);
      if (empExits.isNotEmpty) {
        empExits.forEach((element) async {
          await colEmployee.deleteOne({"empId": element.empId});
          await colEmployee.insertOne(element.toMap());
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<List<AttLog>> getAttLogs(DateTime timneBegin, DateTime timeEnd) async {
    List<AttLog> result = [];
    try {
      if (!db.isConnected) {
        print('getAttLogs DB not connected, try connect again');
        await initDB();
      }
      await colAttLog
          .find(where
                  .gt('timestamp', timneBegin)
                  .and(where.lt('timestamp', timeEnd))
              // .sortBy('timestamp', descending: true)
              )
          .forEach((log) => {result.add(AttLog.fromMap(log))});
    } catch (e) {
      print(e);
    }
    // print(
    //     'getAttLogs ${timneBegin}  to ${timeEnd} => ${result.length} records');
    return result;
  }

  Future<void> deleteOneAttLog(String objectIdString) async {
    if (objectIdString.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('deleteOneAttLog DB not connected, try connect again');
          await initDB();
        }

        print('deleteOneAttLog :$objectIdString');
        var myObjectId = ObjectId.parse(objectIdString);
        await colAttLog.deleteOne({"_id": myObjectId});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> insertAttLogs(List<AttLog> logs) async {
    if (logs.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('insertAttLogs DB not connected, try connect again');
          await initDB();
        }
        List<Map<String, dynamic>> maps = [];
        for (var element in logs) {
          maps.add(element.toMap());
        }
        await colAttLog.insertMany(maps);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<List<ShiftRegister>> getShiftRegister() async {
    List<ShiftRegister> result = [];
    try {
      if (!db.isConnected) {
        print('getShiftRegister DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister
          // .find(where.sortBy('toDate', descending: true))
          .find()
          .forEach((e) => {result.add(ShiftRegister.fromMap(e))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> deleteOneShiftRegister(String objectIdString) async {
    if (objectIdString.isNotEmpty) {
      try {
        if (!db.isConnected) {
          print('deleteOneShiftRegister DB not connected, try connect again');
          await initDB();
        }
        print('deleteOneShiftRegister :$objectIdString');
        var myObjectId = ObjectId.parse(objectIdString);
        await colShiftRegister.deleteOne({"_id": myObjectId});
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> addOneShiftRegister(ShiftRegister shiftRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneShiftRegister DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister.insertOne(shiftRegister.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneShiftRegisterFromMap(Map shiftRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneShiftRegisterFromMap DB not connected, try connect again');
        await initDB();
      }
      await colShiftRegister.insertOne(shiftRegister);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOneShiftRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    try {
      if (!db.isConnected) {
        print(
            'updateOneShiftRegisterByObjectId DB not connected, try connect again');
        await initDB();
      }
      var myObjectId = ObjectId.parse(objectIdString);
      await colShiftRegister.updateOne(
          where.eq('_id', myObjectId), modify.set(key, value));
    } catch (e) {
      print(e);
    }
  }

  Future<void> insertShiftRegisters(List<ShiftRegister> shiftRegisters) async {
    try {
      if (!db.isConnected) {
        print('DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      for (var element in shiftRegisters) {
        maps.add(element.toMap());
      }
      await colShiftRegister.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }

  Future<List<OtRegister>> getOTRegisterByRangeDate(
      DateTime timneBegin, DateTime timeEnd) async {
    // print('getOTRegister : form $timneBegin   to $timeEnd');
    List<OtRegister> result = [], temp = [];
    DateTime date = timneBegin;
    try {
      if (!db.isConnected) {
        print('getOTRegisterByRangeDate DB not connected, try connect again');
        await initDB();
      }
      if (timneBegin.day != timeEnd.day) {
        await colOtRegister
            .find(
                where.lt('fromDate', timneBegin).or(where.gt('toDate', timeEnd))
                // .sortBy('timestamp', descending: true)
                )
            .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
      } else {
        await colOtRegister
            .find(where
                    .lt('fromDate', timneBegin)
                    .and(where.gt('toDate', timeEnd))
                // .sortBy('timestamp', descending: true)
                )
            .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
      }
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<OtRegister>> getOTRegisterAll() async {
    List<OtRegister> result = [];
    try {
      if (!db.isConnected) {
        print('getOTRegisterAll DB not connected, try connect again');
        await initDB();
      }
      await colOtRegister
          .find(
              // .sortBy('timestamp', descending: true)
              )
          .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
    } catch (e) {
      print(e);
    }
    return result;
  }

  Future<void> deleteOneOtRegister(String objectIdString) async {
    if (objectIdString.isEmpty) return;
    try {
      if (!db.isConnected) {
        print('deleteOneOtRegister DB not connected, try connect again');
        await initDB();
      }
      print('deleteOneOtRegister :$objectIdString');
      var myObjectId = ObjectId.parse(objectIdString);
      await colOtRegister.deleteOne({"_id": myObjectId});
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneOtRegister(OtRegister otRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneOtRegister DB not connected, try connect again');
        await initDB();
      }
      await colOtRegister.insertOne(otRegister.toMap());
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOneOtRegisterFromMap(Map otRegister) async {
    try {
      if (!db.isConnected) {
        print('addOneOtRegisterFromMap DB not connected, try connect again');
        await initDB();
      }
      await colOtRegister.insertOne(otRegister);
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateOneOtRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    if (!db.isConnected) {
      print('DB not connected, try connect again');
      initDB();
    }
    if (!db.isConnected) return;
    var myObjectId = ObjectId.parse(objectIdString);
    await colOtRegister.updateOne(
        where.eq('_id', myObjectId), modify.set(key, value));
  }

  Future<void> insertOtRegisters(List<OtRegister> otRegisters) async {
    try {
      if (!db.isConnected) {
        print('insertOtRegisters DB not connected, try connect again');
        await initDB();
      }
      List<Map<String, dynamic>> maps = [];
      for (var element in otRegisters) {
        maps.add(element.toMap());
      }
      await colOtRegister.insertMany(maps);
    } catch (e) {
      print(e);
    }
  }
}
