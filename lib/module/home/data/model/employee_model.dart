import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class Employee {
  final String id;
  final String name;
  final String role; // e.g., "Developer", "Manager"
  final bool isActive; // Determines if employee is active

  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.isActive,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
