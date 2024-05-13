// import 'package:realm/realm.dart';
import 'package:intl/intl.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheet.dart';
import 'package:tiqn/gValue.dart';

class MyFuntion {
  // static void calculateLastId(RealmResults<Employee> employees) {
  //   for (var element in employees) {
  //     final finger = element.attFingerId!;
  //     final id = int.tryParse(element.empId.toString().split('TIQN-')[1])!;
  //     if (finger > gValue.lastFingerId) {
  //       gValue.lastFingerId = finger;
  //     }
  //     if (id > gValue.lastEmpId) {
  //       gValue.lastEmpId = id;
  //     }
  //   }
  // }

  // static List<Employee> convertRealmEmployeeToList(
  //     RealmResults<Employee> realmResults) {
  //   List<Employee> result = [];
  //   for (var element in realmResults) {
  //     result.add(element);
  //   }
  //   return result;
  // }
/*
  static AttReport createAttGeneralReport(
      DateTime dateInput, List<AttLog> attLogs) {
    late DateTime date;
    late AttReportDetail direct;
    late AttReportDetail inDirect;
    late AttReportDetail management;
    late AttReportDetail total;
    AttReport report;
    List<String> listEmpIdpresent = [];
    for (var log in attLogs) {
      listEmpIdpresent.add(log.empId!);
    }
    listEmpIdpresent = listEmpIdpresent.toSet().toList();
    print(
        'createAttGeneralReport -dateInput: $dateInput    Total att record : ${attLogs.length}');
    print('present : ${listEmpIdpresent.length}');
    //--
    late int newlyJoinedD = 0,
        newlyJoinedI = 0,
        newlyJoinedM = 0,
        newlyJoinedT = 0;
    late int maternityComebackD = 0,
        maternityComebackI = 0,
        maternityComebackM = 0,
        maternityComebackT = 0;
    late int resignedD = 0, resignedI = 0, resignedM = 0, resignedT = 0;
    late int maternityLeaveD = 0,
        maternityLeaveI = 0,
        maternityLeaveM = 0,
        maternityLeaveT = 0;
    late int workingD = 0, workingI = 0, workingM = 0, workingT = 0;
    late int enrolledTotalD = 0,
        enrolledTotalI = 0,
        enrolledTotalM = 0,
        enrolledTotalT = 0;
    late int actualWorkingD = 0,
        actualWorkingI = 0,
        actualWorkingM = 0,
        actualWorkingT = 0;
    late int absentD = 0, absentI = 0, absentM = 0, absentT = 0;
    late double absentPercentD = 0,
        absentPercentI = 0,
        absentPercentM = 0,
        absentPercentT = 0;

    date = dateInput;

    for (var emp in gValue.employees) {
      switch (emp.directIndirect) {
        case 'Direct':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedD++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackD++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedD++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveD++;
          if (emp.workStatus == 'Working') workingD++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingD++;
          break;
        case 'Indirect':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedI++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackI++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedI++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveI++;
          if (emp.workStatus == 'Working') workingI++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingI++;
          break;
        case 'Management':
          if (date.difference(emp.joiningDate!).inDays == 0) newlyJoinedM++;
          if (emp.maternityComebackDate != null) if (date
                  .difference(emp.maternityComebackDate!)
                  .inDays ==
              0) {
            maternityComebackM++;
          }
          if (emp.resignDate !=
              null) if (date.difference(emp.resignDate!).inDays == 0) {
            resignedM++;
          }
          if (emp.workStatus == 'Maternity') maternityLeaveM++;
          if (emp.workStatus == 'Working') workingM++;
          if (listEmpIdpresent.contains(emp.empId)) actualWorkingM++;
          break;
        default:
      }
    }
    enrolledTotalD = maternityLeaveD + workingD;
    absentD = workingD - actualWorkingD;
    absentPercentD =
        listEmpIdpresent.isEmpty ? 0 : absentD / (workingD - maternityLeaveD);

    direct = AttReportDetail(
        newlyJoinedD,
        maternityComebackD,
        resignedD,
        maternityLeaveD,
        workingD,
        enrolledTotalD,
        actualWorkingD,
        absentD,
        absentPercentD);
    //-----------
    enrolledTotalI = maternityLeaveI + workingI;
    absentI = workingI - actualWorkingI;
    absentPercentI =
        listEmpIdpresent.isEmpty ? 0 : absentI / (workingI - maternityLeaveI);
    inDirect = AttReportDetail(
        newlyJoinedI,
        maternityComebackI,
        resignedI,
        maternityLeaveI,
        workingI,
        enrolledTotalI,
        actualWorkingI,
        absentI,
        absentPercentI);
    //-----------
    enrolledTotalM = maternityLeaveM + workingM;
    absentM = workingM - actualWorkingM;
    absentPercentM =
        listEmpIdpresent.isEmpty ? 0 : absentM / (workingM - maternityLeaveM);
    management = AttReportDetail(
        newlyJoinedM,
        maternityComebackM,
        resignedM,
        maternityLeaveM,
        workingM,
        enrolledTotalM,
        actualWorkingM,
        absentM,
        absentPercentM);
    //-----------

    newlyJoinedT = newlyJoinedD + newlyJoinedI + newlyJoinedM;
    maternityComebackT =
        maternityComebackD + maternityComebackI + maternityComebackM;
    resignedT = resignedD + resignedI + resignedM;
    maternityLeaveT = maternityLeaveD + maternityLeaveI + maternityLeaveM;
    workingT = workingD + workingI + workingM;
    enrolledTotalT = enrolledTotalD + enrolledTotalI + enrolledTotalM;
    actualWorkingT = actualWorkingD + actualWorkingI + actualWorkingM;
    enrolledTotalT = gValue.employees
        .where((element) => element.workStatus != 'Resigned')
        .length;
    absentT = absentD + absentI + absentM;
    absentPercentT =
        listEmpIdpresent.isEmpty ? 0 : absentT / (workingT - maternityLeaveT);
    total = AttReportDetail(
        newlyJoinedT,
        maternityComebackT,
        resignedT,
        maternityLeaveT,
        workingT,
        enrolledTotalT,
        actualWorkingT,
        absentT,
        absentPercentT);
    //-------------------------
    report = AttReport(
      // ObjectId(),
        date: date,
        direct: direct,
        inDirect: inDirect,
        management: management,
        total: total);

    return report;
  }
*/
  static void calculateAttendanceStatus() {
    gValue.employeeIdPresents.clear();
    gValue.employeeIdAbsents.clear();
    var temp = gValue.attLogs.map((e) => e.empId).toList();
    gValue.employeeIdPresents = temp.toSet().toList();
    gValue.employeeIdPresents.removeWhere((element) => element == 'No Emp Id');
    gValue.employeeIdAbsents = gValue.employeeIdWorkings
        .toSet()
        .difference(gValue.employeeIdPresents.toSet())
        .toList();

    print(
        'calculateAttendanceStatus :employeeIdPresents.length: ${gValue.employeeIdPresents.length}     \nemployeeIdAbsents.length: ${gValue.employeeIdAbsents.length}');
  }

  static void calculateEmployeeStatus() {
    gValue.enrolled = 0;
    gValue.employeeIdNames.clear();
    gValue.employeeIdMaternityLeaves.clear();
    gValue.employeeIdPregnantYoungchilds.clear();
    gValue.employeeIdWorkings.clear();
    for (var element in gValue.employees) {
      if (element.workStatus != 'Resigned') {
        gValue.enrolled++;

        gValue.employeeIdNames.add('${element.empId!}   ${element.name!}');
        if (element.workStatus == 'Maternity leave') {
          gValue.employeeIdMaternityLeaves.add(element.empId!);
        } else {
          gValue.employeeIdWorkings.add(element.empId!);
          if (element.workStatus.toString().contains('pregnant') ||
              element.workStatus.toString().contains('young')) {
            gValue.employeeIdPregnantYoungchilds.add(element.empId!);
          }
        }
      }
    }
    print(
        'calculateEmployeeStatus : employeeIdNames.length: ${gValue.employeeIdNames.length}     employeeIdWorkings.length: ${gValue.employeeIdWorkings.length} employeeIdMaternityLeaves.length: ${gValue.employeeIdMaternityLeaves.length}  employeeIdPregnantYoungchilds.length: ${gValue.employeeIdPregnantYoungchilds.length}');
  }

  static List<TimeSheet> createTimeSheets(
      List<Employee> employees,
      List<Shift> shifts,
      List<ShiftRegister> shiftRegisters,
      List<OtRegister> otRegisters,
      List<AttLog> attLogs,
      DateTime timeBegin,
      DateTime timeEnd) {
    List<TimeSheet> result = [];
    DateTime dateTemp = timeBegin;
    List<DateTime> dates = [];
    if (employees.isEmpty || attLogs.isEmpty) {
      return result;
    }
    while (dateTemp.isBefore(timeEnd)) {
      dates.add(dateTemp);
      dateTemp = dateTemp.add(const Duration(days: 1));
    }
    List<OtRegister> otRegistersOnDate = [];
    for (var date in dates) {
      List<AttLog> dayLogs =
          attLogs.where((log) => (log.timestamp.day == date.day)).toList();
      if (dayLogs.isEmpty) continue;
      List<String> empIdShift1 = [],
          empIdShift2 = [],
          // empIdCanteen = [],
          empIdOT = [];
      for (var element in shiftRegisters) {
        if (element.fromDate.isBefore(date) && element.toDate.isAfter(date)) {
          if (element.shift == 'Shift 1') {
            empIdShift1.add(element.empId);
          } else if (element.shift == 'Shift 2') {
            empIdShift2.add(element.empId);
          }
        }
      }
      for (var element in otRegisters) {
        if (element.otDate.isAtSameMomentAs(date)) {
          otRegistersOnDate.add(element);
        }
      }

      empIdOT = otRegisters.map((e) => e.empId).toList();
      for (var emp in employees.where((element) =>
          (!element.workStatus.toString().contains('Resigned') ||
              (element.workStatus.toString().contains('Resigned') &&
                  date.isBefore(element.resignOn!))))) {
        List<DateTime>? logsTime;
        List<AttLog> logs =
            dayLogs.where((log) => (log.empId == emp.empId)).toList();
        logsTime = logs.map((e) => e.timestamp).cast<DateTime>().toList();
        double normalHours = 8, ot = 0;
        String shift = 'Day';
        int restHour = 1;
        DateTime shiftTimeBegin =
            DateTime.utc(date.year, date.month, date.day, 8);
        DateTime shiftTimeEnd =
            DateTime.utc(date.year, date.month, date.day, 17);

        if (emp.section == 'Canteen') {
          shift = 'Canteen';
        } else if (empIdShift1.contains(emp.empId)) {
          shift = 'Shift 1';
        } else if (empIdShift2.contains(emp.empId)) {
          shift = 'Shift 2';
        }
        restHour =
            shifts.firstWhere((element) => element.shift == shift).restHour;
        final hourBegin = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .begin
            .split(':')[0]);
        final minuteBegin = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .begin
            .split(':')[1]);
        final hourEnd = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .end
            .split(':')[0]);
        final minuteEnd = int.parse(shifts
            .firstWhere((element) => element.shift == shift)
            .end
            .split(':')[1]);

        shiftTimeBegin = DateTime.utc(
            date.year, date.month, date.day, hourBegin, minuteBegin);
        shiftTimeEnd =
            DateTime.utc(date.year, date.month, date.day, hourEnd, minuteEnd);
        DateTime firstIn = DateTime.utc(2000);
        DateTime lastOut = DateTime.utc(2000);
        DateTime restBegin = shiftTimeBegin.add(const Duration(hours: 4));
        DateTime restEnd = restBegin.add(Duration(hours: restHour));
        if (logs.isEmpty) {
          {
            normalHours = 0;
            ot = 0;
          }
        } else if (logs.length == 1) {
          firstIn = logs.first.timestamp;
          normalHours = 0;
          ot = 0;
        } else {
          firstIn = logsTime.reduce((a, b) => a.isBefore(b) ? a : b);
          lastOut = logsTime.reduce((a, b) => a.isAfter(b) ? a : b);
          if (emp.workStatus.toString().contains('pregnant') ||
              emp.workStatus.toString().contains('child')) {
            shiftTimeEnd = shiftTimeEnd.subtract(const Duration(hours: 1));
          }
          if ((firstIn.isBefore(shiftTimeBegin) &&
                  lastOut.isBefore(shiftTimeBegin)) ||
              (firstIn.isAfter(shiftTimeEnd) &&
                  lastOut.isAfter(shiftTimeEnd))) {
            normalHours = 0;
            ot = 0;
          } else if (firstIn.isAtSameMomentAs(lastOut)) {
            normalHours = 0;
            ot = 0;
          } else {
            normalHours = 8;
            // NORMAL
            if (firstIn.isAfter(shiftTimeBegin) &&
                lastOut.isAfter(shiftTimeEnd)) {
              // vao tre, ra dung gio
              if (firstIn.isBefore(restBegin)) {
                // truoc 12h
                normalHours -=
                    firstIn.difference(shiftTimeBegin).inMinutes / 60;
              } else if (firstIn.isBefore(restEnd)) {
                // 12h .. 13h
                normalHours = 4;
              } else {
                //sau 13h
                normalHours = shiftTimeEnd.difference(firstIn).inMinutes / 60;
              }
            } else if (firstIn.isBefore(shiftTimeBegin) &&
                lastOut.isBefore(shiftTimeEnd)) {
              // vao dung gio, ra som
              if (lastOut.isBefore(restBegin)) {
                //ra truoc 12h :
                normalHours = lastOut.difference(restBegin).inMinutes / 60;
              } else if (lastOut.isBefore(restEnd)) {
                // ra sau 12h & truoc 13h
                normalHours = 4;
              } else {
                // ra sau 13h : 8- so gio ra som
                normalHours -= shiftTimeEnd.difference(lastOut).inMinutes / 60;
              }
            }
            // DateTime otBeginAllow = shiftTimeEnd;
            DateTime otEndAllow =
                shiftTimeEnd.add(const Duration(hours: 2)); // default 2 hours
            if (gValue.allowAllOt) {
              // gia dinh cho phep toan bo ot
              if (!gValue.defaultOt2H) {
                otEndAllow = shiftTimeEnd.add(const Duration(hours: 6));
              }
              if (lastOut.isBefore(otEndAllow)) {
                // OT ra som
                ot = lastOut.difference(shiftTimeEnd).inMinutes / 60;
              } else {
                // OT ra dung gio
                ot = 2;
              }
              ot = ot < gValue.minHourOt ? 0 : ot;
            } else if (empIdOT.contains(emp.empId)) {
              // neu trong danh sach OT
              OtRegister otRegisterEmp = otRegistersOnDate
                  .firstWhere((otRecord) => otRecord.empId == emp.empId);

              final beginH = otRegisterEmp.otTimeBegin.split(':')[0];
              final beginM = otRegisterEmp.otTimeBegin.split(':')[1];
              final endH = otRegisterEmp.otTimeEnd.split(':')[0];
              final endM = otRegisterEmp.otTimeEnd.split(':')[1];

              DateTime beginTime = DateFormat("dd-MM-yyyy hh:mm:ss")
                  .parse('01-01-2000 $beginH:$beginM:00');
              DateTime endTime = DateFormat("dd-MM-yyyy hh:mm:ss")
                  .parse('01-01-2000 $endH:$endM:00');
              DateTime otEndAllow = shiftTimeEnd
                  .add(Duration(hours: endTime.difference(beginTime).inHours));
              if (lastOut.isBefore(otEndAllow)) {
                // OT ra som
                ot = lastOut.difference(shiftTimeEnd).inMinutes / 60;
              } else {
                // OT ra dung gio
                ot = otEndAllow.difference(shiftTimeEnd).inMinutes / 60;
              }
              ot = ot < gValue.minHourOt ? 0 : ot;
            }
          }
        }
        result.add(TimeSheet(
            date: date,
            empId: emp.empId!,
            attFingerId: emp.attFingerId!,
            name: emp.name!,
            department: emp.department!,
            section: emp.section!,
            group: emp.group ?? '',
            lineTeam: emp.lineTeam ?? "",
            shift: shift,
            firstIn: firstIn.year == 2000 ? null : firstIn,
            lastOut: lastOut.year == 2000 ? null : lastOut,
            normalHours: normalHours,
            otHours: ot));
      }
    }
    return result;
  }
}
