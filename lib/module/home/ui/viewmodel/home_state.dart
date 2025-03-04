part of 'home_cubit.dart';

class HomeState extends Equatable {
  final List<Attendance>? attendanceList;
  final List<Attendance>? allAttendanceList;
  final Status status;
  final String? message;
  final bool isUpdating;
  final String? selectedDate; // For filtering attendance by date
  final DateTime? selectDate;

  const HomeState(
      {this.attendanceList,
      this.allAttendanceList,
      this.status = Status.loading,
      this.message,
      this.isUpdating = false,
      this.selectedDate,
      this.selectDate});

  HomeState copyWith({
    List<Attendance>? attendanceList,
    List<Attendance>? allAttendanceList,
    Status? status,
    String? message,
    bool? isUpdating,
    String? selectedDate,
    DateTime? selectDate,
  }) {
    return HomeState(
        attendanceList: attendanceList ?? this.attendanceList,
        status: status ?? this.status,
        message: message ?? this.message,
        isUpdating: isUpdating ?? this.isUpdating,
        selectedDate: selectedDate ?? this.selectedDate,
        allAttendanceList: allAttendanceList ?? this.allAttendanceList,
        selectDate: selectDate ?? this.selectDate);
  }

  @override
  List<Object?> get props => [
        attendanceList,
        allAttendanceList,
        status,
        message,
        isUpdating,
        selectedDate,
        selectDate
      ];
}

enum Status {
  initialLoading, // Shimmer effect for initial loading
  loading, // Loading for search or pagination
  success, // Data loaded successfully
  empty, // No results found
  error, // Error state
  noInternet, // No internet state
  loadingMore, // Pagination loader
}
