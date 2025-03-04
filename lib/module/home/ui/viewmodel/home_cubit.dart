import 'package:attendance_manager/module/home/data/model/attendance_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_constants.dart';
import '../../domain/usecase/home_usecase.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeUseCase _homeUseCase;

  HomeCubit(this._homeUseCase)
      : super(HomeState(status: Status.initialLoading)) {
    fetchAttendance();
  }

  Future<void> fetchAttendance([String? selectedDate]) async {
    try {
      final attendanceData = await _homeUseCase.getAttendanceData(range);

      filterByDateAndId(attendanceData,
          selectedDate ?? DateFormat('dd/MM/yyyy').format(DateTime.now()));
    } catch (e) {
      emit(state.copyWith(
          status: Status.error, message: "Failed to fetch attendance: $e"));
    }
  }

  void filterByDateAndId(List<Attendance> allRecords, String selectedDate) {
    Set<String> uniqueEmployeeIds = {};
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(selectedDate);
    int selectedDateEpoch = parsedDate.millisecondsSinceEpoch;

    final filteredData = allRecords.where((record) {
      String formattedDate = DateFormat('dd/MM/yyyy')
          .format(DateTime.fromMillisecondsSinceEpoch(record.date));
      return formattedDate == selectedDate;
    }).toList();

    Map<String, Attendance> existingRecords = {
      for (var record in filteredData) record.employeeId: record
    };

    List<Attendance> uniqueAttendanceList = allRecords
        .where((employee) => uniqueEmployeeIds.add(employee.employeeId))
        .map((employee) {
      return existingRecords[employee.employeeId] ??
          Attendance(
            employeeId: employee.employeeId,
            name: employee.name,
            date: selectedDateEpoch,
            checkIn: 1740974400000, // Default 9:30 AM
            checkOut: 1741006800000, // Default 6:30 PM
            overtimeHours: 0,
            status: "Present",
          );
    }).toList();

    emit(HomeState(
        attendanceList: uniqueAttendanceList,
        allAttendanceList: allRecords,
        status: Status.success,
        selectedDate: selectedDate));
  }

  Future<bool> updateAttendance(Attendance updatedAttendance) async {
    if (updatedAttendance.checkOut < updatedAttendance.checkIn) {
      return false;
    }
    int originalIndex = state.allAttendanceList?.indexWhere(
          (element) =>
              element.employeeId == updatedAttendance.employeeId &&
              DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(element.date)) ==
                  DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                          updatedAttendance.date)),
        ) ??
        -1;

    if (originalIndex != -1) {
      List<String> values = [
        updatedAttendance.employeeId,
        updatedAttendance.name,
        updatedAttendance.date.toString(),
        updatedAttendance.checkIn.toString(),
        updatedAttendance.checkOut.toString(),
        updatedAttendance.overtimeHours.toString(),
        updatedAttendance.status
      ];
      try {
        int sheetRowIndex = originalIndex + 2;
        String rowRange = "Sheet1!A$sheetRowIndex:G$sheetRowIndex";

        await _homeUseCase.updateAttendance(
            rowRange, values, originalIndex + 2);

        fetchAttendance(state.selectedDate);
        return true;
      } catch (e) {
        emit(
          HomeState(
              message: "Failed to update attendance: $e", status: Status.error),
        );
        return false;
      }
    }
    return false;
  }

  Future<void> addEmployee(String id, String name) async {
    try {
      Attendance employee = Attendance(
          employeeId: id,
          name: name,
          date: DateTime.now().millisecondsSinceEpoch,
          checkIn: 0,
          checkOut: 0,
          overtimeHours: 0,
          status: "Present");
      await _homeUseCase.addEmployee(employee);
      fetchAttendance(); // Refresh after adding
      emit(HomeState(
          message: "Employee added successfully", status: Status.success));
    } catch (e) {
      emit(HomeState(
          message: "Failed to add employee: $e", status: Status.error));
    }
  }

  Future<void> deleteEmployee(int index) async {
    try {
      int sheetRowIndex = index + 1;
      await _homeUseCase.removeEmployee(sheetRowIndex);
      fetchAttendance();
    } catch (e) {
      emit(HomeState(
          message: "Failed to delete employee: $e", status: Status.error));
    }
  }

  void updateDate(DateTime? pickedDate) {
    if (pickedDate != null) {
      print("Updating selectedDate: $pickedDate");
      emit(state.copyWith(selectDate: pickedDate));
    }
  }
}
