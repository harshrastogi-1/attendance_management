import 'package:attendance_manager/module/home/ui/viewmodel/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import '../../../utils/utils.dart';
import 'attendance_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final HomeCubit _homeCubit = GetIt.I<HomeCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Attendance Manager",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _selectDate(context, _homeCubit);
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        bloc: _homeCubit,
        builder: (context, state) {
          if (state.status == Status.initialLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == Status.success) {
            return ListView.builder(
              itemCount: state.attendanceList?.length ?? 0,
              itemBuilder: (context, index) {
                final attandence = state.attendanceList![index];
                return GestureDetector(
                  onLongPress: () => _showDeleteConfirmationDialog(
                      context, _homeCubit, state, index),
                  child: AttendanceCard(
                    key: ValueKey(attandence.employeeId.toString()),
                    checkInTime: attandence.checkIn,
                    checkOutTime: attandence.checkOut,
                    employeeName: attandence.name,
                    overtime: attandence.overtimeHours,
                    status: attandence.status,
                    date: Utils.formatDateTime(attandence.date),
                    onEditPressed: () {
                      _showEditBottomSheet(context, state, index);
                    },
                  ),
                );
              },
            );
          } else if (state.status == Status.error) {
            return Center(child: Text(state.message ?? ""));
          }
          return const Center(child: Text("No data available"));
        },
      ),
      floatingActionButton: BlocBuilder<HomeCubit, HomeState>(
        bloc: _homeCubit,
        builder: (context, state) => FloatingActionButton(
          onPressed: () {
            showAddEmployeeSheet(
              context,
              (id, name) {
                _homeCubit.addEmployee(id, name);
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context,
      HomeCubit homeCubit, HomeState state, int index) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Employee"),
        content: Text("Are you sure you want to delete this employee?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Close dialog
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _homeCubit.deleteEmployee(index);
              Navigator.of(context).pop(); // Close dialog without action
            },
            child: Text("Confirm", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void showAddEmployeeSheet(
      BuildContext context, Function(String, String) onAdd) {
    TextEditingController nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Employee",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Employee Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  String name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    String uniqueId =
                        "EMP${DateTime.now().millisecondsSinceEpoch}";
                    onAdd(uniqueId, name);
                    Navigator.pop(context); // Close bottom sheet
                  }
                },
                child: const Text("Add Employee"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    HomeCubit homeCubit,
  ) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _homeCubit.state.selectDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      homeCubit.updateDate(pickedDate);
      String formattedDate = _homeCubit.state.selectDate == null
          ? DateFormat('dd/MM/yyyy').format(DateTime.now()) // Default to today
          : DateFormat('dd/MM/yyyy').format(_homeCubit.state.selectDate!);
      _homeCubit.fetchAttendance(formattedDate);
    }
  }

  Future<int?> _selectTime(BuildContext context, int time) async {
    DateTime initialTime = DateTime.fromMillisecondsSinceEpoch(time);

    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.inputOnly,
      helpText: "",
      initialTime:
          TimeOfDay(hour: initialTime.hour, minute: initialTime.minute),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (pickedTime != null) {
      DateTime updatedDateTime = DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        pickedTime.hour,
        pickedTime.minute,
      );
      return updatedDateTime.millisecondsSinceEpoch;
    }
    return null;
  }

  void _showEditBottomSheet(BuildContext context, HomeState state, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Edit Attendance",
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              _buildTimeRow(
                "Check-In Time",
                state.attendanceList![index].checkIn,
                (time) {
                  state.attendanceList![index].checkIn = time;
                },
              ),
              const SizedBox(height: 16),
              _buildTimeRow(
                "Check-Out Time",
                state.attendanceList![index].checkOut,
                (time) {
                  state.attendanceList![index].checkOut = time;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  var result = await _homeCubit
                      .updateAttendance(state.attendanceList![index]);

                  if (mounted) {
                    if (!result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Check-out time cannot be before check-in time!"),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeRow(
      String label, int epochTime, Function(int) onTimeChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleMedium),
        TextButton(
          onPressed: () async {
            var selectedTime = await _selectTime(context, epochTime);
            if (selectedTime != null) {
              onTimeChanged(selectedTime); // Call the callback with new time
            }
          },
          child: Text(
            DateFormat('HH:mm')
                .format(DateTime.fromMillisecondsSinceEpoch(epochTime)),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
