// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OtRegister {
  String objectId;
  DateTime fromDate;
  DateTime toDate;
  String empId;
  String name;
  String fromTime;
  String toTime;
  OtRegister({
    required this.objectId,
    required this.fromDate,
    required this.toDate,
    required this.empId,
    required this.name,
    required this.fromTime,
    required this.toTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'fromDate': fromDate,
      'toDate': toDate,
      'empId': empId,
      'name': name,
      'fromTime': fromTime,
      'toTime': toTime,
    };
  }

  @override
  bool operator ==(covariant OtRegister other) {
    if (identical(this, other)) return true;

    return other.objectId == objectId &&
        other.fromDate == fromDate &&
        other.toDate == toDate &&
        other.empId == empId &&
        other.name == name &&
        other.fromTime == fromTime &&
        other.toTime == toTime;
  }

  factory OtRegister.fromMap(Map<String, dynamic> map) {
    return OtRegister(
      objectId: map['_id'].toString(),
      fromDate: map['fromDate'],
      toDate: map['toDate'],
      empId: map['empId'] as String,
      name: map['name'] as String,
      fromTime: map['fromTime'] as String,
      toTime: map['toTime'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtRegister.fromJson(String source) =>
      OtRegister.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OtRegister(objectId: $objectId fromDate: $fromDate, toDate: $toDate, empId: $empId, name: $name, fromTime: $fromTime, toTime: $toTime)';
  }
}
