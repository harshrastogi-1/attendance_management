import 'package:intl/intl.dart';

class Utils {
  Utils._();

  static String formatDateTime(int epochMillis,
      {String pattern = 'dd-MM-yyyy'}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    return DateFormat(pattern).format(dateTime);
  }

  static String formatEpoch(int epoch) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch);
    return "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }

  static int calculateOvertime(int checkInEpoch, int checkOutEpoch) {
    DateTime checkIn =
        DateTime.fromMillisecondsSinceEpoch(checkInEpoch, isUtc: true);
    DateTime checkOut =
        DateTime.fromMillisecondsSinceEpoch(checkOutEpoch, isUtc: true);

    // Calculate total work duration
    Duration workDuration = checkOut.difference(checkIn);
    int totalMinutes = workDuration.inMinutes;

    // 9 hours (540 minutes) is the official working time
    int overtimeMinutes = totalMinutes - 540;

    // Convert overtime minutes to hours
    return overtimeMinutes > 0 ? (overtimeMinutes ~/ 60) : 0;
  }
}
