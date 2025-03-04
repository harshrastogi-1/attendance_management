import 'package:flutter/material.dart';

import '../../../utils/utils.dart';

class AttendanceCard extends StatelessWidget {
  final String employeeName;
  final int checkInTime;
  final int checkOutTime;
  final int overtime;
  final String status;
  final String date;
  final VoidCallback onEditPressed;

  const AttendanceCard(
      {super.key,
      required this.employeeName,
      required this.checkInTime,
      required this.checkOutTime,
      required this.overtime,
      required this.status,
      required this.onEditPressed,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                employeeName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  onEditPressed();
                },
                child: const Icon(Icons.edit, size: 20, color: Colors.blueGrey),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoRow(Icons.access_time, "Check In:", checkInTime),
                  _buildInfoRow(Icons.exit_to_app, "Check Out:", checkOutTime),
                  status != 'Absent'
                      ? _buildInfoRowText(Icons.timer, "Overtime:", overtime)
                      : SizedBox.shrink(),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    checkInTime != 0 && checkOutTime != 0
                        ? "Present"
                        : "Absent",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: checkInTime != 0 && checkOutTime != 0
                              ? Colors.green
                              : Colors.red,
                        ),
                  ),
                  _buildInfoRowTime(
                      Icons.access_time_filled_outlined, "Date:", date),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            "$label ${value == 0 ? "__:__" : Utils.formatEpoch(value)}",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowText(IconData icon, String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey),
          const SizedBox(width: 6),
          Text(
            "$label $value",
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRowTime(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        "$label ${value}",
        style: const TextStyle(
            fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
      ),
    );
  }
}
