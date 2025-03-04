import '../../../../utils/utils.dart';
import '../model/attendance_model.dart';

class HomeMapper {
  HomeMapper._();
  static List<Attendance> mapAttendanceData(List<List<dynamic>> rawData) {
    return rawData.skip(1).map((row) {
      return Attendance(
        employeeId: row[0].toString(), // Convert to String
        name: row[1],
        date: row[2] == "" ? 0 : int.parse(row[2]),
        checkIn: row[3] == "" ? 0 : int.parse(row[3]),
        checkOut: row[4] == "" ? 0 : int.parse(row[4]),
        overtimeHours: row[3] == "" || row[4] == ""
            ? 0
            : Utils.calculateOvertime(
                int.parse(row[3]), int.parse(row[4])), // Handle null values
        status: row[6].toString(),
      );
    }).toList();
  }
}
