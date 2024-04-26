import 'package:package_info_plus/package_info_plus.dart';
import 'package:tiqn/database/attLog.dart';
import 'package:tiqn/database/employee.dart';
import 'package:tiqn/database/department.dart';
import 'package:tiqn/database/mongoDb.dart';
import 'package:tiqn/database/otRegister.dart';
import 'package:tiqn/database/shift.dart';
import 'package:tiqn/database/shiftRegister.dart';
import 'package:tiqn/database/timeSheet.dart';

class gValue {
  // static _Config config = _Config(mainFuntion: "mainFuntion");
  static List<String> mainFuntions = [];
  static String appName = '';
  static int enrolled = 0;
  static int workingNormal = 0;
  static int workingMaternity = 0;
  static int maternityLeave = 0;
  static int present = 0;
  static int absent = 0;
  static int inLate = 0;
  static int outEarly = 0;
  static MongoDb mongoDb = MongoDb();
  static List<AttLog> attLogs = <AttLog>[];
  static List<TimeSheet> timeSheets = <TimeSheet>[];
  static List<Shift> shifts = <Shift>[];
  static List<ShiftRegister> shiftRegisters = <ShiftRegister>[];
  static List<OtRegister> otRegisters = <OtRegister>[];
  static bool allowAllOt = false;
  static bool defaultOt2H = true;
  static bool miniInfoEmployee = true;
  // static List<AttReport> attReports = <AttReport>[];
  static List<Employee> employees = <Employee>[];
  static List<String> employeeIdNames = [];
  static List<Employee> employeeAbsents = <Employee>[];
  static String urlUpdateApp = '';
  static String latestVersion = '';
  static String updateBinaryUrl = '';
  static String updateChangeLog = '';
  static int lastEmpId = 0, lastFingerId = 0;
  static List<String> logs = [];
  static PackageInfo packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );
  static List<String> departments = [
    "Operation Management",
    "Production",
    "Purchase",
    "QA",
    "Warehouse",
    "Factory Manager"
  ];
  static Department department = Department();
  static String departmentJson = '''
{
  "Operation Management": [
    "Accounting",
    "Canteen",
    "HR/GA",
    "Operation Management",
    "Supply chain management"
  ],
  "Production": [
    "Production",
    "Development&Production Technology",
    "Preparation",
    "Pattern"
  ],
  "Purchase": [
    "Purchase"
  ],
  "QA": [
    "QA",
    "QC"
  ],
  "Warehouse": [
    "Warehouse"
  ],
  "Factory Manager": [
    "Factory Manager"
  ]
}
  ''';
}
