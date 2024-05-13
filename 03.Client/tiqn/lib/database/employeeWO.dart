import 'package:tiqn/database/employee.dart';

class EmployeeWO extends Employee {
  double totalW = 0;
  double totalOt = 0;
  get getTotalW => totalW;

  set setTotalW(totalW) => this.totalW = totalW;

  get getTotalOt => totalOt;

  set setTotalOt(totalOt) => this.totalOt = totalOt;
}
