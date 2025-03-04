import '../../data/model/attendance_model.dart';

abstract class HomeRepository {
  Future<List<Attendance>> getAttendanceData(String range);
  Future<void> updateAttendance(String range, List<String> values, int index);
  Future<void> removeEmployee(int rowIndex);
  Future<void> addEmployee(Attendance employee);
}
