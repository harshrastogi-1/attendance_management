import 'package:attendance_manager/module/home/data/data_source/home_remote_data_source.dart';
import 'package:attendance_manager/module/home/data/mappers/home_mapper.dart';
import 'package:attendance_manager/module/home/domain/repository/home_repository.dart';

import '../model/attendance_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl({
    required HomeRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final HomeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Attendance>> getAttendanceData(String range) async {
    return HomeMapper.mapAttendanceData(
        await _remoteDataSource.getAttendanceData(range));
  }

  @override
  Future<void> updateAttendance(
      String range, List<String> values, int index) async {
    await _remoteDataSource.updateAttendance(range, values, index);
  }

  @override
  Future<void> addEmployee(Attendance employee) {
    return _remoteDataSource.addEmployee(employee);
  }

  @override
  Future<void> removeEmployee(int rowIndex) {
    return _remoteDataSource.removeEmployee(rowIndex);
  }
}
