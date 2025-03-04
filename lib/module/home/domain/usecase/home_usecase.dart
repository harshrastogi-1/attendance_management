import '../../data/model/attendance_model.dart';
import '../repository/home_repository.dart';

abstract class HomeUseCase {
  Future<List<Attendance>> getAttendanceData(String range);
  Future<void> updateAttendance(String range, List<String> values, int index);
  Future<void> removeEmployee(int rowIndex);
  Future<void> addEmployee(Attendance employee);
}

class HomeUseCaseImpl implements HomeUseCase {
  final HomeRepository _homeRepository;
  HomeUseCaseImpl({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;

  @override
  Future<List<Attendance>> getAttendanceData(String range) {
    return _homeRepository.getAttendanceData(range);
  }

  @override
  Future<void> updateAttendance(String range, List<String> values, int index) {
    return _homeRepository.updateAttendance(range, values, index);
  }

  @override
  Future<void> addEmployee(Attendance employee) {
    return _homeRepository.addEmployee(employee);
  }

  @override
  Future<void> removeEmployee(int rowIndex) {
    return _homeRepository.removeEmployee(rowIndex);
  }
}
