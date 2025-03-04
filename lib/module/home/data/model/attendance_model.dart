import 'package:json_annotation/json_annotation.dart';

part 'attendance_model.g.dart';

@JsonSerializable()
class Attendance {
  String employeeId;
  String name;
  int date;
  int checkIn;
  int checkOut;
  int overtimeHours;
  String status; // Present or Absent

  Attendance({
    required this.employeeId,
    required this.name,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.overtimeHours,
    required this.status,
  });

  // JSON Serialization
  factory Attendance.fromJson(Map<String, dynamic> json) =>
      _$AttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceToJson(this);
}
