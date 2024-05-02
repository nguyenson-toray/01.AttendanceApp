import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import 'package:tiqn/database/attLog.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheet.dart';
import 'package:tiqn/gValue.dart';

class MyFile {
  static Future<File> getFile() async {
    File file = File('path');
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }
    return file;
  }

  static Future<Directory> getDir() async {
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    return appDocumentsDir;
  }

  // static Future<List<Employee>> readExcelEmployee() async {
  //   print('readExcelEmployee'); //sheet Name
  //   gValue.logs.clear();
  //   List<Employee> emps = [];
  //   try {
  //     File file = await getFile();
  //     var bytes = file.readAsBytesSync();
  //     var excel = Excel.decodeBytes(bytes);
  //     gValue.logs.add('File : ${file.path}');
  //     for (var table in excel.tables.keys) {
  //       print('Sheet Name: $table'); //sheet Name
  //       print('maxColumns: ${excel.tables[table]?.maxColumns}');
  //       print('maxRows: ${excel.tables[table]?.maxRows}');
  //       gValue.logs.add(
  //           'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
  //       for (int rowIndex = 1;
  //           rowIndex < excel.tables[table]!.maxRows;
  //           rowIndex++) {
  //         var row = excel.tables[table]!.rows[rowIndex];
  //         if (row[2] == null || row[3] == null || row[4] == null) {
  //           gValue.logs.add(
  //               'ERROR : Row $rowIndex: Finger ID or Employee ID is empty\n');
  //           continue;
  //         }

  //         Employee emp = Employee(
  //           empId: row[1]?.value.toString(),
  //           attFingerId: int.tryParse(row[2]!.value.toString()),
  //           name: row[3]?.value.toString(),
  //           department: row[4]?.value.toString(),
  //           section: row[5]?.value.toString(),
  //           group: row[6]?.value.toString() ?? "",
  //           lineTeam: row[7]?.value.toString(),
  //           gender: row[8]?.value.toString(),
  //           positionE: row[9]?.value.toString(),
  //           level: row[10]?.value.toString(),
  //           directIndirect: row[11]?.value.toString(),
  //           sewingNonSewing: row[12]?.value.toString(),
  //           supporting: row[13]?.value.toString() ?? "",
  //           dob: DateTime.tryParse(row[14]!.value.toString()),
  //           joiningDate: DateTime.tryParse(row[15]!.value.toString()),
  //           workStatus: row[16]?.value.toString(),
  //           maternityBegin: row[17]?.value != null
  //               ? DateTime.tryParse(row[17]!.value.toString())
  //               : null,
  //           maternityEnd: row[18]?.value != null
  //               ? DateTime.tryParse(row[18]!.value.toString())
  //               : null,
  //         );
  //         emps.add(emp);
  //         gValue.logs.add('OK : Row $rowIndex: ${emp.empId}  ${emp.name}\n');
  //       }
  //     }
  //   } catch (e) {}

  //   return emps;
  // }

  static Future<void> createExcelEmployee(
      List<Employee> emps, bool isMini, String fileName) async {
//Create an Excel document.
//Creating a workbook.
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Employees';
    Range range = sheet.getRangeByName('A2:S2');
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Employee ID');
    sheet.getRangeByName('C1').setText('Finger ID');
    sheet.getRangeByName('D1').setText('Full name');
    sheet.getRangeByName('E1').setText('Department');
    sheet.getRangeByName('F1').setText('Section');
    sheet.getRangeByName('G1').setText('Group');
    sheet.getRangeByName('H1').setText('Line Team');
    if (!isMini) {
      sheet.getRangeByName('I1').setText('Gender');
      sheet.getRangeByName('J1').setText('Position E');
      sheet.getRangeByName('K1').setText('Level');
      sheet.getRangeByName('L1').setText('Direct Indirect');
      sheet.getRangeByName('M1').setText('Sewing NonSewing');
      sheet.getRangeByName('N1').setText('Supporting');
      sheet.getRangeByName('O1').setText('DOB');
      sheet.getRangeByName('P1').setText('Joining date');
      sheet.getRangeByName('Q1').setText('Work status');
      sheet.getRangeByName('R1').setText('Resign date');
      sheet.getRangeByName('A1:R1').cellStyle = styleHeader;
    } else {
      sheet.getRangeByName('A1:H1').cellStyle = styleHeader;
    }

    int row = 1;
    for (var emp in emps) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1).toDouble());
      sheet.getRangeByName('B$row').setText('${emp.empId}');
      sheet.getRangeByName('C$row').setNumber(emp.attFingerId?.toDouble());
      sheet.getRangeByName('D$row').setText('${emp.name}');
      sheet.getRangeByName('E$row').setText('${emp.department}');
      sheet.getRangeByName('F$row').setText('${emp.section}');
      sheet.getRangeByName('G$row').setText('${emp.group}');
      sheet.getRangeByName('H$row').setText('${emp.lineTeam}');
      if (!isMini) {
        sheet.getRangeByName('I$row').setText('${emp.gender}');
        sheet.getRangeByName('J$row').setText('${emp.positionE}');
        sheet.getRangeByName('K$row').setText('${emp.level}');
        sheet.getRangeByName('L$row').setText('${emp.directIndirect}');
        sheet.getRangeByName('M$row').setText('${emp.sewingNonSewing}');
        sheet.getRangeByName('N$row').setText('${emp.supporting}');
        sheet
            .getRangeByName('O$row')
            .setDateTime(emp.dob?.year == 1900 ? null : emp.dob);
        sheet.getRangeByName('P$row').setDateTime(
            emp.joiningDate?.year == 1900 ? null : emp.joiningDate);
        sheet.getRangeByName('Q$row').setText('${emp.workStatus}');
        sheet
            .getRangeByName('R$row')
            .setDateTime(emp.resignOn?.year == 2099 ? null : emp.resignOn);
        range = sheet.getRangeByName('A2:R2');
      } else {
        range = sheet.getRangeByName('A2:H2');
      }
    }
    // Assigning text to cells

// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(4);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(Platform.isWindows
        ? '$path\\$fileName ${DateFormat('dd-MMM-yyyy hhmmss').format(DateTime.now())}.xlsx'
        : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  //---------------
  static Future<void> createExcelAttLog(
      List<AttLog> logsInput, String fileName) async {
//Create an Excel document.
//Creating a workbook.
    Iterable<AttLog> logs = logsInput.reversed;
    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Attendance Log';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 160, 168, 174);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('Finger ID');
    sheet.getRangeByName('C1').setText('Employee ID');
    sheet.getRangeByName('D1').setText('Name');
    sheet.getRangeByName('E1').setText('Time');
    sheet.getRangeByName('F1').setText('Machine');
    sheet.getRangeByName('A1:F1').cellStyle = styleHeader;
    int row = 1;
    for (var log in logs) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').setNumber(log.attFingerId!.toDouble());
      sheet.getRangeByName('C$row').setText('${log.empId!}');
      sheet.getRangeByName('D$row').setText('${log.name}');
      sheet.getRangeByName('E$row').numberFormat = 'dd-MMM-yyyy hh:mm';
      sheet.getRangeByName('E$row').setDateTime(log.timestamp);
      // sheet.getRangeByName('F$row').numberFormat = '0';
      sheet.getRangeByName('F$row').setNumber(log.machineNo!.toDouble());
    }
    // Assigning text to cells
    final Range range = sheet.getRangeByName('A2:F2');

// Auto-Fit column the range
    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(4);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

/*
  static Future<void> createExcelAttReport(
      List<AttReport> attReportsInput) async {
    print('createExcelAttReport');
    Iterable<AttReport> attReports = attReportsInput.reversed;
    String fileName =
        'Attendance report ${DateFormat('MMM-yyyy hhmmss').format(DateTime.now())}';
    //Create an Excel document.
//Creating a workbook.
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name =
        'Attendance report ${DateFormat('MMM-yyyy').format(DateTime.now())}';

// Set the  value.
    sheet.getRangeByName('A1').setText('Date');
    sheet.getRangeByName('A1:A3').merge();
    sheet.getRangeByName('B1').setText('Direct');
    sheet.getRangeByName('B1:J1').merge();
    sheet.getRangeByName('K1').setText('Indirect');
    sheet.getRangeByName('K1:S1').merge();
    sheet.getRangeByName('T1').setText('Management');
    sheet.getRangeByName('T1:AB1').merge();
    sheet.getRangeByName('AC1').setText('Total');
    sheet.getRangeByName('AC1:AK1').merge();
    //-------------
    sheet
        .getRangeByName('B2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('B3').setText('N');
    sheet.getRangeByName('C2').setText('Resigned');
    sheet.getRangeByName('C3').setText('R');
    sheet.getRangeByName('D2').setText('Maternity leave');
    sheet.getRangeByName('D3').setText('M');
    sheet.getRangeByName('E2').setText('Working');
    sheet.getRangeByName('E3').setText('W');
    sheet.getRangeByName('F2').setText('Enrolled Total');
    sheet.getRangeByName('F3').setText('E');
    sheet.getRangeByName('G2').setText('Actual working');
    sheet.getRangeByName('G3').setText('W');
    sheet.getRangeByName('H2').setText('Absent');
    sheet.getRangeByName('H3').setText('A');
    sheet.getRangeByName('I2').setText('Total working');
    sheet.getRangeByName('I3').setText('T');
    sheet.getRangeByName('J2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('J3').setText('P');
    //-------------
    sheet
        .getRangeByName('K2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('K3').setText('N');
    sheet.getRangeByName('L2').setText('Resigned');
    sheet.getRangeByName('L3').setText('R');
    sheet.getRangeByName('M2').setText('Maternity leave');
    sheet.getRangeByName('M3').setText('M');
    sheet.getRangeByName('N2').setText('Working');
    sheet.getRangeByName('N3').setText('W');
    sheet.getRangeByName('O2').setText('Enrolled Total');
    sheet.getRangeByName('O3').setText('E');
    sheet.getRangeByName('P2').setText('Actual working');
    sheet.getRangeByName('P3').setText('W');
    sheet.getRangeByName('Q2').setText('Absent');
    sheet.getRangeByName('Q3').setText('A');
    sheet.getRangeByName('R2').setText('Total working');
    sheet.getRangeByName('R3').setText('T');
    sheet.getRangeByName('S2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('S3').setText('P');
    //-------------
    sheet
        .getRangeByName('T2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('T3').setText('N');
    sheet.getRangeByName('U2').setText('Resigned');
    sheet.getRangeByName('U3').setText('R');
    sheet.getRangeByName('V2').setText('Maternity leave');
    sheet.getRangeByName('V3').setText('M');
    sheet.getRangeByName('W2').setText('Working');
    sheet.getRangeByName('W3').setText('W');
    sheet.getRangeByName('X2').setText('Enrolled Total');
    sheet.getRangeByName('X3').setText('E');
    sheet.getRangeByName('Y2').setText('Actual working');
    sheet.getRangeByName('Y3').setText('W');
    sheet.getRangeByName('Z2').setText('Absent');
    sheet.getRangeByName('Z3').setText('A');
    sheet.getRangeByName('AA2').setText('Total working');
    sheet.getRangeByName('AA3').setText('T');
    sheet.getRangeByName('AB2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('AB3').setText('P');
    //-------------
    sheet
        .getRangeByName('AC2')
        .setText('Newly joined\nMaternity return to work');
    sheet.getRangeByName('AC3').setText('N');
    sheet.getRangeByName('AD2').setText('Resigned');
    sheet.getRangeByName('AD3').setText('R');
    sheet.getRangeByName('AE2').setText('Maternity leave');
    sheet.getRangeByName('AE3').setText('M');
    sheet.getRangeByName('AF2').setText('Working');
    sheet.getRangeByName('AF3').setText('W');
    sheet.getRangeByName('AG2').setText('Enrolled Total');
    sheet.getRangeByName('AG3').setText('E');
    sheet.getRangeByName('AH2').setText('Actual working');
    sheet.getRangeByName('AH3').setText('W');
    sheet.getRangeByName('AI2').setText('Absent');
    sheet.getRangeByName('AI3').setText('A');
    sheet.getRangeByName('AJ2').setText('Total working');
    sheet.getRangeByName('AJ3').setText('T');
    sheet.getRangeByName('AK2').setText('Absent percent\n(No Maternity)');
    sheet.getRangeByName('AK3').setText('P');

    int row = 3;
    for (var report in attReports) {
      row++;
      sheet.getRangeByName('A$row').setDateTime(report.date?.toLocal());
      //---
      sheet.getRangeByName('B$row').setNumber(
          (report.direct!.newlyJoined + report.direct!.maternityComeback)
              .toDouble());
      sheet
          .getRangeByName('C$row')
          .setNumber(report.direct!.resigned.toDouble());
      sheet
          .getRangeByName('D$row')
          .setNumber(report.direct!.maternityLeave.toDouble());
      sheet
          .getRangeByName('E$row')
          .setNumber(report.direct!.working.toDouble());
      sheet
          .getRangeByName('F$row')
          .setNumber(report.direct!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('G$row')
          .setNumber(report.direct!.actualWorking.toDouble());
      sheet.getRangeByName('H$row').setNumber(report.direct!.absent.toDouble());
      sheet
          .getRangeByName('I$row')
          .setNumber(report.direct!.working.toDouble());
      sheet
          .getRangeByName('J$row')
          .setNumber(report.direct!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('K$row').setNumber(
          (report.inDirect!.newlyJoined + report.direct!.maternityComeback)
              .toDouble());
      sheet
          .getRangeByName('L$row')
          .setNumber(report.inDirect!.resigned.toDouble());
      sheet
          .getRangeByName('M$row')
          .setNumber(report.inDirect!.maternityLeave.toDouble());
      sheet
          .getRangeByName('N$row')
          .setNumber(report.inDirect!.working.toDouble());
      sheet
          .getRangeByName('O$row')
          .setNumber(report.inDirect!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('P$row')
          .setNumber(report.inDirect!.actualWorking.toDouble());
      sheet
          .getRangeByName('Q$row')
          .setNumber(report.inDirect!.absent.toDouble());
      sheet
          .getRangeByName('R$row')
          .setNumber(report.inDirect!.working.toDouble());
      sheet
          .getRangeByName('S$row')
          .setNumber(report.inDirect!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('T$row').setNumber((report.management!.newlyJoined +
              report.management!.maternityComeback)
          .toDouble());
      sheet
          .getRangeByName('U$row')
          .setNumber(report.management!.resigned.toDouble());
      sheet
          .getRangeByName('V$row')
          .setNumber(report.management!.maternityLeave.toDouble());
      sheet
          .getRangeByName('W$row')
          .setNumber(report.management!.working.toDouble());
      sheet
          .getRangeByName('X$row')
          .setNumber(report.management!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('Y$row')
          .setNumber(report.management!.actualWorking.toDouble());
      sheet
          .getRangeByName('Z$row')
          .setNumber(report.management!.absent.toDouble());
      sheet
          .getRangeByName('AA$row')
          .setNumber(report.management!.working.toDouble());
      sheet
          .getRangeByName('AB$row')
          .setNumber(report.management!.absentPercent.toDouble());
      //-------------
      sheet.getRangeByName('AC$row').setNumber((report.management!.newlyJoined +
              report.management!.maternityComeback)
          .toDouble());
      sheet
          .getRangeByName('AD$row')
          .setNumber(report.total!.maternityLeave.toDouble());
      sheet
          .getRangeByName('AE$row')
          .setNumber(report.total!.maternityLeave.toDouble());
      sheet
          .getRangeByName('AF$row')
          .setNumber(report.total!.working.toDouble());
      sheet
          .getRangeByName('AG$row')
          .setNumber(report.total!.enrolledTotal.toDouble());
      sheet
          .getRangeByName('AH$row')
          .setNumber(report.total!.actualWorking.toDouble());
      sheet.getRangeByName('AI$row').setNumber(report.total!.absent.toDouble());
      sheet
          .getRangeByName('AJ$row')
          .setNumber(report.total!.working.toDouble());
      sheet
          .getRangeByName('AK$row')
          .setNumber(report.total!.absentPercent.toDouble());
    }

//Creating a new style with all properties.
    final Style styleDate = workbook.styles.add('styleDate');
    final Style styleDateRow = workbook.styles.add('styleDateRow');
    final Style styleHeader1 = workbook.styles.add('styleHeader1');
    final Style styleHeader2 = workbook.styles.add('styleHeader2');
    final Style styleHeader3 = workbook.styles.add('styleHeader3');
    final Style styleDirect = workbook.styles.add('styleDirect');
    final Style styleIndrect = workbook.styles.add('styleIndrect');
    final Style styleManagement = workbook.styles.add('styleManagement');
    final Style styleTotal = workbook.styles.add('styleTotal');
    styleHeader1.bold = true;
    styleDate.bold = true;
    styleDate.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleDateRow.bold = true;
    styleDateRow.bold = true;
    styleDateRow.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader1.vAlign = VAlignType.center;
    styleHeader1.hAlign = HAlignType.center;
    styleHeader1.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader2.vAlign = VAlignType.top;
    styleHeader2.hAlign = HAlignType.center;
    styleHeader2.wrapText = true;
    styleHeader2.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleHeader3.vAlign = VAlignType.center;
    styleHeader3.hAlign = HAlignType.center;
    styleHeader3.bold = true;
    styleHeader3.backColorRgb = const Color.fromARGB(255, 200, 223, 242);
    styleDirect.backColorRgb = const Color.fromARGB(255, 187, 188, 187);
    styleIndrect.backColorRgb = const Color.fromARGB(255, 224, 226, 224);
    styleManagement.backColorRgb = const Color.fromARGB(255, 172, 203, 173);
    styleTotal.backColorRgb = const Color.fromARGB(255, 135, 158, 135);
    sheet.getRangeByName('A1:A3').cellStyle = styleDate;
    sheet.getRangeByName('B1:AK1').cellStyle = styleHeader1;
    sheet.getRangeByName('B2:AK2').columnWidth = 7;
    sheet.getRangeByName('B2:AK2').rowHeight = 72;
    sheet.getRangeByName('B2:AK2').cellStyle = styleHeader2;
    sheet.getRangeByName('A3:AK3').rowHeight = 16;
    sheet.getRangeByName('B3:AK3').cellStyle = styleHeader3;
    sheet.getRangeByName('B4:J$row').cellStyle = styleDirect;
    sheet.getRangeByName('K4:S$row').cellStyle = styleIndrect;
    sheet.getRangeByName('T4:AB$row').cellStyle = styleManagement;
    sheet.getRangeByName('AC4:AK$row').cellStyle = styleTotal;
    sheet.showGridlines = true;
// Auto-Fit column the range
    // range.autoFitColumns();
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }
*/
  static Future<List<AttLog>> readExcelAttLog() async {
    List<AttLog> logs = [];
    print('readExcelAttLog'); //sheet Name
    gValue.logs.clear();
    List<Employee> emps = [];
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        for (int rowIndex = 1;
            rowIndex < excel.tables[table]!.maxRows;
            rowIndex++) {
          var row = excel.tables[table]!.rows[rowIndex];
          if (row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null) {
            gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
            continue;
          }
          AttLog log = AttLog(
              objectId: '',
              attFingerId: int.parse(row[1]!.value.toString()),
              empId: row[2]!.value.toString(),
              name: row[3]!.value.toString(),
              timestamp: DateTime.parse(row[4]!.value.toString()),
              machineNo: int.parse(row[5]!.value.toString()));

          logs.add(log);
          gValue.logs.add(
              'OK : Row $rowIndex: ${log.empId}  ${log.name}  ${log.timestamp}\n');
        }
      }
    } catch (e) {}
    return logs;
  }

  static Future<void> createExcelTimeSheet(
      List<TimeSheet> timeSheets, String fileName) async {
    final Workbook workbook = Workbook();
    workbook.worksheets[0];
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Timesheets';
    Range range = sheet.getRangeByName('A2:N2');
    //Creating a new style for header.
    final Style styleHeader = workbook.styles.add('styleHeader');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 174, 210, 239);
    // final Style styleZeroHour = workbook.styles.add('styleZeroHour');
    // styleHeader.backColorRgb = Colors.redAccent;
    // final Style styleOT = workbook.styles.add('styleOT');
    // styleHeader.backColorRgb = Colors.orange;
    // Set the text value FOR HEADER.
    sheet.getRangeByName('A1:N1').merge();
    sheet.getRangeByName('A1:N2').cellStyle = styleHeader;
    sheet.getRangeByName('A1').setText(fileName);
    sheet.getRangeByName('A2').setText('No');
    sheet.getRangeByName('B2').setText('Date');
    sheet.getRangeByName('C2').setText('Employee ID');
    sheet.getRangeByName('D2').setText('Finger ID');
    sheet.getRangeByName('E2').setText('Full name');
    sheet.getRangeByName('F2').setText('Department');
    sheet.getRangeByName('G2').setText('Section');
    sheet.getRangeByName('H2').setText('Group');
    sheet.getRangeByName('I2').setText('Line/Team');
    sheet.getRangeByName('J2').setText('Shift');
    sheet.getRangeByName('K2').setText('Fist In');
    sheet.getRangeByName('L2').setText('Last Out');
    sheet.getRangeByName('M2').setText('Working hours');
    sheet.getRangeByName('N2').setText('OT hours');

    int row = 2;
    for (var timeSheet in timeSheets) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('B$row').setDateTime(timeSheet.date);
      sheet.getRangeByName('C$row').setText('${timeSheet.empId}');
      sheet.getRangeByName('D$row').setNumber(timeSheet.attFingerId.toDouble());
      sheet.getRangeByName('E$row').setText('${timeSheet.name}');
      sheet.getRangeByName('F$row').setText('${timeSheet.department}');
      sheet.getRangeByName('G$row').setText('${timeSheet.section}');
      sheet.getRangeByName('H$row').setText('${timeSheet.group}');
      sheet.getRangeByName('I$row').setText(
          '${timeSheet.lineTeam.toString() != 'null' ? timeSheet.lineTeam : ''}');
      sheet.getRangeByName('J$row').setText('${timeSheet.shift}');
      sheet.getRangeByName('K$row').numberFormat = 'hh:mm';
      sheet.getRangeByName('K$row').setDateTime(
          timeSheet.firstIn?.year == 2000 ? null : timeSheet.firstIn);
      sheet.getRangeByName('L$row').numberFormat = 'hh:mm';
      sheet.getRangeByName('L$row').setDateTime(
          timeSheet.lastOut?.year == 2000 ? null : timeSheet.lastOut);
      sheet.getRangeByName('M$row').numberFormat = '0.0';
      // if (timeSheet.normalHours == 0)
      // sheet.getRangeByName('M$row:M$row').cellStyle = styleZeroHour;
      sheet.getRangeByName('M$row').setNumber(timeSheet.normalHours);
      sheet.getRangeByName('M$row').numberFormat = '0.0';
      // if (timeSheet.otHours > 0)
      // sheet.getRangeByName('M$row:M$row').cellStyle = styleOT;

      sheet
          .getRangeByName('N$row')
          .setNumber(roundDouble(timeSheet.otHours, 1));
    }

    // Auto-Fit column the range

    range.autoFitColumns();
    sheet.autoFitColumn(1);
    sheet.autoFitColumn(2);
    sheet.autoFitColumn(5);
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook
        .dispose(); //Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<void> createExcelShiftRegisters(
      List<ShiftRegister> shiftRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.

    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Attendance Log';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 160, 168, 174);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('From');
    sheet.getRangeByName('C1').setText('To');
    sheet.getRangeByName('D1').setText('Employee ID');
    sheet.getRangeByName('E1').setText('Name');
    sheet.getRangeByName('F1').setText('Shift');
    sheet.getRangeByName('A1:F1').cellStyle = styleHeader;
    int row = 1;
    for (var shiftRegister in shiftRegisters) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('B$row').setDateTime(shiftRegister.fromDate);
      sheet.getRangeByName('C$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('C$row').setDateTime(shiftRegister.toDate);
      sheet.getRangeByName('D$row').setText('${shiftRegister.empId}');
      sheet.getRangeByName('E$row').setText('${shiftRegister.name}');
      sheet.getRangeByName('F$row').setText('${shiftRegister.shift}');
    }

    final Range range = sheet.getRangeByName('A2:F2');

// Auto-Fit column the range
    range.autoFitColumns();
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<List<ShiftRegister>> readExcelShiftRegister() async {
    List<ShiftRegister> shiftRegisters = [];
    print('readExcelAttLog'); //sheet Name
    gValue.logs.clear();
    List<Employee> emps = [];
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        for (int rowIndex = 1;
            rowIndex < excel.tables[table]!.maxRows;
            rowIndex++) {
          var row = [];
          row = excel.tables[table]!.rows[rowIndex];
          if (row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null) {
            gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
            continue;
          }
          ShiftRegister shiftRegister = ShiftRegister(
              objectId: '',
              fromDate: DateTime.parse(row[1].value.toString()),
              toDate: DateTime.parse(row[2].value.toString()),
              empId: row[3].value.toString(),
              name: row[4].value.toString(),
              shift: row[5].value.toString());

          shiftRegisters.add(shiftRegister);
          gValue.logs.add(
              'OK : Row $rowIndex: ${shiftRegister.fromDate} to ${shiftRegister.toDate}  ${shiftRegister.empId}  ${shiftRegister.name}  ${shiftRegister.shift}\n');
        }
      }
    } catch (e) {}
    return shiftRegisters;
  }

  static Future<void> createExcelOtRegisters(
      List<OtRegister> otRegisters, String fileName) async {
//Create an Excel document.
//Creating a workbook.

    final Workbook workbook = Workbook();
//Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'OT Registers';
//Creating a new style with all properties.
    final Style styleHeader = workbook.styles.add('Style1');
    styleHeader.bold = true;
    styleHeader.backColorRgb = const Color.fromARGB(255, 160, 168, 174);
// Set the text value.
    sheet.getRangeByName('A1').setText('No');
    sheet.getRangeByName('B1').setText('From');
    sheet.getRangeByName('C1').setText('To');
    sheet.getRangeByName('D1').setText('Employee ID');
    sheet.getRangeByName('E1').setText('Name');
    sheet.getRangeByName('F1').setText('Time begin');
    sheet.getRangeByName('G1').setText('Time end');
    sheet.getRangeByName('A1:G1').cellStyle = styleHeader;
    int row = 1;
    for (var otRegister in otRegisters) {
      row++;
      sheet.getRangeByName('A$row').setNumber((row - 1));
      sheet.getRangeByName('B$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('B$row').setDateTime(otRegister.fromDate);
      sheet.getRangeByName('C$row').numberFormat = 'dd-MMM-yyyy';
      sheet.getRangeByName('C$row').setDateTime(otRegister.toDate);
      sheet.getRangeByName('D$row').setText('${otRegister.empId}');
      sheet.getRangeByName('E$row').setText('${otRegister.name}');
      sheet.getRangeByName('F$row').setText('${otRegister.fromTime}');
      sheet.getRangeByName('G$row').setText('${otRegister.toTime}');
    }

    final Range range = sheet.getRangeByName('A2:G2');

// Auto-Fit column the range
    range.autoFitColumns();
//Save and launch the excel.
    final List<int> bytes = workbook.saveSync();
//Dispose the document.
    workbook.dispose();

//Get the storage folder location using path_provider package.
    final Directory directory = await getDir();
    final String path = directory.path;
    final File file = File(
        Platform.isWindows ? '$path\\$fileName.xlsx' : '$path/$fileName.xlsx');

    await file.writeAsBytes(bytes, flush: true, mode: FileMode.write);
    if (Platform.isWindows) {
      await Process.run('cmd', ['/c', 'start', '', (file.path)]);
      // await Process.run('start', <String>['${file.path}'], runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>[(file.path)], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>[(file.path)], runInShell: true);
    }
  }

  static Future<List<OtRegister>> readExcelOtRegister() async {
    List<OtRegister> otRegisters = [];
    print('readExcelOtRegister'); //sheet Name
    gValue.logs.clear();
    try {
      File file = await getFile();
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      gValue.logs.add('File : ${file.path}');
      for (var table in excel.tables.keys) {
        print('Sheet Name: $table'); //sheet Name
        print('maxColumns: ${excel.tables[table]?.maxColumns}');
        print('maxRows: ${excel.tables[table]?.maxRows}');
        gValue.logs.add(
            'Sheet Name: $table   Columns: ${excel.tables[table]?.maxColumns}   Rows: ${excel.tables[table]?.maxRows}\n');
        for (int rowIndex = 1;
            rowIndex < excel.tables[table]!.maxRows;
            rowIndex++) {
          var row = [];
          row = excel.tables[table]!.rows[rowIndex];
          if (row[1] == null ||
              row[2] == null ||
              row[3] == null ||
              row[4] == null ||
              row[5] == null) {
            gValue.logs.add('ERROR : Row $rowIndex: is not enought infor\n');
            continue;
          }
          OtRegister otRegister = OtRegister(
            objectId: '',
            fromDate: DateTime.parse(row[1].value.toString()),
            toDate: DateTime.parse(row[2].value.toString())
                .add(Duration(hours: 23, minutes: 59, seconds: 59)),
            empId: row[3].value.toString(),
            name: row[4].value.toString(),
            fromTime: row[5].value.toString(),
            toTime: row[6].value.toString(),
          );

          otRegisters.add(otRegister);
          gValue.logs.add(
              'OK : Row $rowIndex: ${DateFormat('dd-MMM-yyyy').format(otRegister.fromDate)} to ${DateFormat('dd-MMM-yyyy').format(otRegister.toDate)}  ${otRegister.empId}  ${otRegister.name}  ${otRegister.fromTime} to ${otRegister.toTime}\n');
        }
      }
    } catch (e) {}
    return otRegisters;
  }
}

double roundDouble(double value, int places) {
  num mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
