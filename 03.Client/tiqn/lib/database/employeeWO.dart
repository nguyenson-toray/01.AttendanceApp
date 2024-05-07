import 'package:tiqn/database/employee.dart';

class EmployeeWO extends Employee {
  double totalW = 0;
  double totalOt = 0;
  get getTotalW => this.totalW;

  set setTotalW(totalW) => this.totalW = totalW;

  get getTotalOt => this.totalOt;

  set setTotalOt(totalOt) => this.totalOt = totalOt;
}
