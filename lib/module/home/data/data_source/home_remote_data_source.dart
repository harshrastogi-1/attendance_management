import '../../../../google_manager/google_sheets_service.dart';
import '../model/attendance_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<List<dynamic>>> getAttendanceData(String range);
  Future<void> updateAttendance(String range, List<String> values, int index);
  Future<void> removeEmployee(int rowIndex);
  Future<void> addEmployee(Attendance employee);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final GoogleSheetsService _apiManager;

  HomeRemoteDataSourceImpl({
    required GoogleSheetsService apiManager,
  }) : _apiManager = apiManager;

  @override
  Future<List<List<dynamic>>> getAttendanceData(String range) async {
    final response = await _apiManager.getSheetData(range);
    return response ?? [];
  }

  @override
  Future<void> updateAttendance(
      String range, List<String> values, int index) async {
    await _apiManager.updateSheetData(range, index, values);
  }

  @override
  Future<void> addEmployee(Attendance employee) async {
    await _apiManager.addEmployee(employee);
  }

  @override
  Future<void> removeEmployee(int rowIndex) async {
    await _apiManager.removeEmployee(rowIndex);
  }
}
