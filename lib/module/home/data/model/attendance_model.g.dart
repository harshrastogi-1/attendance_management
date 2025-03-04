// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
      employeeId: json['employeeId'] as String,
      name: json['name'] as String,
      date: json['date'] as int,
      checkIn: json['checkIn'] as int,
      checkOut: json['checkOut'] as int,
      overtimeHours: (json['overtimeHours'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'name': instance.name,
      'date': instance.date,
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'overtimeHours': instance.overtimeHours,
      'status': instance.status,
    };
