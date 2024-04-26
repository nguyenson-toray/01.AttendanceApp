import 'package:mongo_dart/mongo_dart.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:bson/bson.dart';

class MongoDb {
  String ipServer =
      // '192.168.1.11';
      'localhost';
  late var colEmployee, colAttLog, colShift, colShiftRegister, colOtRegister;
  late Db db;
  initDB() async {
    var db = Db("mongodb://$ipServer:27017/tiqn");
    await db.open();
    // colEmployee = db.collection('Employee');
    colEmployee = db.collection('Employee');
    colAttLog = db.collection('AttLog');
    colShift = db.collection('Shift');
    colShiftRegister = db.collection('ShiftRegister');
    colOtRegister = db.collection('OtRegister');
  }

  Future<List<Shift>> getShifts() async {
    List<Shift> result = [];
    await colShift
        .find(where.sortBy('shift', descending: false))
        .forEach((shift) => {result.add(Shift.fromMap(shift))});

    return result;
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> result = [];
    await colEmployee
        .find(where.sortBy('empId', descending: true))
        .forEach((emp) => {result.add(Employee.fromMap(emp))});
    // print('getAllEmployee => ${result.length} records');
    return result;
  }

  Future<void> removeEmployee(String empId) async {
    await colEmployee.deleteOne({"empId": empId});
  }

  Future<void> insertManyEmployees(List<Employee> inputEmps) async {
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
  }

  Future<List<AttLog>> getAttLogs(DateTime timneBegin, DateTime timeEnd) async {
    List<AttLog> result = [];
    await colAttLog
        .find(where
                .gt('timestamp', timneBegin)
                .and(where.lt('timestamp', timeEnd))
            // .sortBy('timestamp', descending: true)
            )
        .forEach((log) => {result.add(AttLog.fromMap(log))});
    // print(
    //     'getAttLogs ${timneBegin}  to ${timeEnd} => ${result.length} records');
    return result;
  }

  Future<void> deleteOneAttLog(String objectIdString) async {
    if (objectIdString.isEmpty) return;
    print('deleteOneAttLog :$objectIdString');
    var myObjectId = ObjectId.parse(objectIdString);
    await colAttLog.deleteOne({"_id": myObjectId});
  }

  Future<void> insertAttLogs(List<AttLog> logs) async {
    List<Map<String, dynamic>> maps = [];
    for (var element in logs) {
      maps.add(element.toMap());
    }
    await colAttLog.insertMany(maps);
  }

  Future<List<ShiftRegister>> getShiftRegister() async {
    List<ShiftRegister> result = [];
    await colShiftRegister
        // .find(where.sortBy('toDate', descending: true))
        .find()
        .forEach((e) => {result.add(ShiftRegister.fromMap(e))});
    return result;
  }

  Future<void> deleteOneShiftRegister(String objectIdString) async {
    if (objectIdString.isEmpty) return;
    print('deleteOneShiftRegister :$objectIdString');
    var myObjectId = ObjectId.parse(objectIdString);
    await colShiftRegister.deleteOne({"_id": myObjectId});
  }

  Future<void> addOneShiftRegister(ShiftRegister shiftRegister) async {
    await colShiftRegister.insertOne(shiftRegister.toMap());
  }

  Future<void> addOneShiftRegisterFromMap(Map shiftRegister) async {
    await colShiftRegister.insertOne(shiftRegister);
  }

  Future<void> updateOneShiftRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    var myObjectId = ObjectId.parse(objectIdString);
    await colShiftRegister.updateOne(
        where.eq('_id', myObjectId), modify.set('$key', value));
  }

  Future<void> insertShiftRegisters(List<ShiftRegister> shiftRegisters) async {
    List<Map<String, dynamic>> maps = [];
    for (var element in shiftRegisters) {
      maps.add(element.toMap());
    }
    await colShiftRegister.insertMany(maps);
  }

  Future<List<OtRegister>> getOTRegisterByRangeDate(
      DateTime timneBegin, DateTime timeEnd) async {
    // print('getOTRegister : form $timneBegin   to $timeEnd');
    List<OtRegister> result = [], temp = [];
    DateTime date = timneBegin;
    if (timneBegin.day != timeEnd.day) {
      await colOtRegister
          .find(where.lt('fromDate', timneBegin).or(where.gt('toDate', timeEnd))
              // .sortBy('timestamp', descending: true)
              )
          .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
    } else {
      await colOtRegister
          .find(
              where.lt('fromDate', timneBegin).and(where.gt('toDate', timeEnd))
              // .sortBy('timestamp', descending: true)
              )
          .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
    }

    return result;
  }

  Future<List<OtRegister>> getOTRegisterAll() async {
    print('getOTRegister');
    List<OtRegister> result = [], temp = [];

    await colOtRegister
        .find(
            // .sortBy('timestamp', descending: true)
            )
        .forEach((ot) => {result.add(OtRegister.fromMap(ot))});
    return result;
  }

  Future<void> deleteOneOtRegister(String objectIdString) async {
    if (objectIdString.isEmpty) return;
    print('deleteOneOtRegister :$objectIdString');
    var myObjectId = ObjectId.parse(objectIdString);
    await colOtRegister.deleteOne({"_id": myObjectId});
  }

  Future<void> addOneOtRegister(OtRegister otRegister) async {
    await colOtRegister.insertOne(otRegister.toMap());
  }

  Future<void> addOneOtRegisterFromMap(Map otRegister) async {
    await colOtRegister.insertOne(otRegister);
  }

  Future<void> updateOneOtRegisterByObjectId(
      String objectIdString, String key, dynamic value) async {
    var myObjectId = ObjectId.parse(objectIdString);
    await colOtRegister.updateOne(
        where.eq('_id', myObjectId), modify.set('$key', value));
  }

  Future<void> insertOtRegisters(List<OtRegister> otRegisters) async {
    List<Map<String, dynamic>> maps = [];
    for (var element in otRegisters) {
      maps.add(element.toMap());
    }
    await colOtRegister.insertMany(maps);
  }
}
