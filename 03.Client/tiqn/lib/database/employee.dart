// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Employee {
  String? empId = 'TIQN-';
  int? attFingerId = 0;
  String? name = "Nguyễn Văn A";
  String? department = 'Production';
  String? section = 'Production';
  String? group = 'Sewing';
  String? lineTeam;
  String? gender = 'Female';
  String? positionE = 'Sewing Worker';
  String? level = 'Worker';
  String? directIndirect = 'Direct';
  String? sewingNonSewing = 'Sewing';
  String? supporting = '';
  DateTime? dob;
  DateTime? joiningDate;
  int? workStatus = 1;
  int? maternity = 0;
  Employee({
    this.empId,
    this.attFingerId,
    this.name,
    this.department,
    this.section,
    this.group,
    this.lineTeam,
    this.gender,
    this.positionE,
    this.level,
    this.directIndirect,
    this.sewingNonSewing,
    this.supporting,
    this.dob,
    this.joiningDate,
    this.workStatus,
    this.maternity,
  });

  Employee copyWith({
    String? empId,
    int? attFingerId,
    String? name,
    String? department,
    String? section,
    String? group,
    String? lineTeam,
    String? gender,
    String? positionE,
    String? level,
    String? directIndirect,
    String? sewingNonSewing,
    String? supporting,
    DateTime? dob,
    DateTime? joiningDate,
    int? workStatus,
    int? maternity,
  }) {
    return Employee(
      empId: empId ?? this.empId,
      attFingerId: attFingerId ?? this.attFingerId,
      name: name ?? this.name,
      department: department ?? this.department,
      section: section ?? this.section,
      group: group ?? this.group,
      lineTeam: lineTeam ?? this.lineTeam,
      gender: gender ?? this.gender,
      positionE: positionE ?? this.positionE,
      level: level ?? this.level,
      directIndirect: directIndirect ?? this.directIndirect,
      sewingNonSewing: sewingNonSewing ?? this.sewingNonSewing,
      supporting: supporting ?? this.supporting,
      dob: dob ?? this.dob,
      joiningDate: joiningDate ?? this.joiningDate,
      workStatus: workStatus ?? this.workStatus,
      maternity: maternity ?? this.maternity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'empId': empId,
      'attFingerId': attFingerId,
      'name': name,
      'department': department,
      'section': section,
      'group': group,
      'lineTeam': lineTeam,
      'gender': gender,
      'positionE': positionE,
      'level': level,
      'directIndirect': directIndirect,
      'sewingNonSewing': sewingNonSewing,
      'supporting': supporting,
      'dob': dob?.millisecondsSinceEpoch,
      'joiningDate': joiningDate?.millisecondsSinceEpoch,
      'workStatus': workStatus,
      'maternity': maternity,
    };
  }

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      empId: map['empId'] != null ? map['empId'] as String : null,
      attFingerId:
          map['attFingerId'] != null ? map['attFingerId'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      department:
          map['department'] != null ? map['department'] as String : null,
      section: map['section'] != null ? map['section'] as String : null,
      group: map['group'] != null ? map['group'] as String : null,
      lineTeam: map['lineTeam'] != null ? map['lineTeam'] as String : null,
      gender: map['gender'] != null ? map['gender'] as String : null,
      positionE: map['position'] != null ? map['position'] as String : null,
      level: map['level'] != null ? map['level'] as String : null,
      directIndirect: map['directIndirect'] != null
          ? map['directIndirect'] as String
          : null,
      sewingNonSewing: map['sewingNonSewing'] != null
          ? map['sewingNonSewing'] as String
          : null,
      supporting:
          map['supporting'] != null ? map['supporting'] as String : null,
      dob: map['dob'].runtimeType.toString().contains('DateTime')
          ? map['dob']
          : DateTime.utc(1900),
      // dob: DateTime.utc(1900),
      joiningDate:
          map['joiningDate'].runtimeType.toString().contains('DateTime')
              ? map['joiningDate']
              : DateTime.utc(1900),
      workStatus: map['workStatus'] != null ? map['workStatus'] as int : null,
      maternity: map['maternity'] != null ? map['maternity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Employee.fromJson(String source) =>
      Employee.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Employee(empId: $empId, attFingerId: $attFingerId, name: $name, department: $department, section: $section, group: $group, lineTeam: $lineTeam, gender: $gender, positionE: $positionE, level: $level, directIndirect: $directIndirect, sewingNonSewing: $sewingNonSewing, supporting: $supporting, dob: $dob, joiningDate: $joiningDate, workStatus: $workStatus, maternity: $maternity)';
  }

  @override
  bool operator ==(covariant Employee other) {
    if (identical(this, other)) return true;

    return other.empId == empId &&
        other.attFingerId == attFingerId &&
        other.name == name &&
        other.department == department &&
        other.section == section &&
        other.group == group &&
        other.lineTeam == lineTeam &&
        other.gender == gender &&
        other.positionE == positionE &&
        other.level == level &&
        other.directIndirect == directIndirect &&
        other.sewingNonSewing == sewingNonSewing &&
        other.supporting == supporting &&
        other.dob == dob &&
        other.joiningDate == joiningDate &&
        other.workStatus == workStatus &&
        other.maternity == maternity;
  }

  @override
  int get hashCode {
    return empId.hashCode ^
        attFingerId.hashCode ^
        name.hashCode ^
        department.hashCode ^
        section.hashCode ^
        group.hashCode ^
        lineTeam.hashCode ^
        gender.hashCode ^
        positionE.hashCode ^
        level.hashCode ^
        directIndirect.hashCode ^
        sewingNonSewing.hashCode ^
        supporting.hashCode ^
        dob.hashCode ^
        joiningDate.hashCode ^
        workStatus.hashCode ^
        maternity.hashCode;
  }
}
