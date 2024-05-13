// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class OtRegister {
  int objectId;
  String requestNo;
  DateTime requestDate;
  DateTime otDate;
  String otTimeBegin;
  String otTimeEnd;
  String empId;
  String name;
  OtRegister({
    required this.objectId,
    required this.requestNo,
    required this.requestDate,
    required this.otDate,
    required this.otTimeBegin,
    required this.otTimeEnd,
    required this.empId,
    required this.name,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'requestNo': requestNo,
      'requestDate': requestDate,
      'otDate': otDate,
      'otTimeBegin': otTimeBegin,
      'otTimeEnd': otTimeEnd,
      'empId': empId,
      'name': name,
    };
  }

  factory OtRegister.fromMap(Map<String, dynamic> map) {
    return OtRegister(
      objectId: map['_id'] as int,
      requestNo: map['requestNo'] as String,
      requestDate: map['requestDate'],
      otDate: map['otDate'],
      otTimeBegin: map['otTimeBegin'] as String,
      otTimeEnd: map['otTimeEnd'] as String,
      empId: map['empId'] as String,
      name: map['name'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OtRegister.fromJson(String source) =>
      OtRegister.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OtRegister(objectId: $objectId, requestNo: $requestNo, requestDate: $requestDate, otDate: $otDate, fromTime: $otTimeBegin, toTime: $otTimeEnd, empId: $empId, name: $name)';
  }

  @override
  bool operator ==(covariant OtRegister other) {
    if (identical(this, other)) return true;

    return other.objectId == objectId &&
        other.requestNo == requestNo &&
        other.requestDate == requestDate &&
        other.otDate == otDate &&
        other.otTimeBegin == otTimeBegin &&
        other.otTimeEnd == otTimeEnd &&
        other.empId == empId &&
        other.name == name;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        requestNo.hashCode ^
        requestDate.hashCode ^
        otDate.hashCode ^
        otTimeBegin.hashCode ^
        otTimeEnd.hashCode ^
        empId.hashCode ^
        name.hashCode;
  }
}
