import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

import '../constants/app_constants.dart';
import '../module/home/data/model/attendance_model.dart';
import '../utils/utils.dart';

class GoogleSheetsService {
  static auth.AutoRefreshingAuthClient? _authClient;
  static sheets.SheetsApi? _sheetsApi;
  static const String _spreadsheetId =
      "16HzouUabAz97XV1nErum_ham4f66-uFOkp-frjVgJpg";

  GoogleSheetsService._();

  static Future<GoogleSheetsService> createInstance() async {
    final instance = GoogleSheetsService._();
    await instance._initialize();
    return instance;
  }

  Future<void> _initialize() async {
    try {
      String? credentialsJson = dotenv.env['GOOGLE_CLOUD_CREDENTIALS'];

      final credentialsMap = jsonDecode(credentialsJson!);

      final credentials =
          auth.ServiceAccountCredentials.fromJson(credentialsMap);
      final client = await clientViaServiceAccount(
          credentials, ['https://www.googleapis.com/auth/spreadsheets']);

      _authClient = client;
      _sheetsApi = sheets.SheetsApi(client);

      print("✅ Google Sheets API Initialized Successfully!");
    } catch (e) {
      print("🚨 Error initializing Google Sheets API: $e");
      rethrow;
    }
  }

  Future<List<List<String>>> getSheetData(String range) async {
    try {
      final response =
          await _sheetsApi!.spreadsheets.values.get(_spreadsheetId, range);
      return response.values?.map((row) => List<String>.from(row)).toList() ??
          [];
    } catch (e) {
      print("🚨 Error fetching sheet data: $e");
      rethrow;
    }
  }

  Future<void> updateSheetData(
      String sheetName, int rowIndex, List<String> rowData) async {
    try {
      if (rowIndex < 1) {
        throw Exception("Invalid row index: $rowIndex");
      }

      int checkInEpoch = int.parse(rowData[3]);
      int checkOutEpoch = int.parse(rowData[4]);

      int overtimeHours = Utils.calculateOvertime(checkInEpoch, checkOutEpoch);
      rowData[5] = overtimeHours.toString();

      final valueRange = sheets.ValueRange(values: [rowData]);

      await _sheetsApi!.spreadsheets.values.update(
          valueRange, _spreadsheetId, sheetName,
          valueInputOption: "RAW");

      print("✅ Row $rowIndex Updated Successfully!");
    } catch (e) {
      print("🚨 Error updating sheet data: $e");
      rethrow;
    }
  }

  Future<void> addEmployee(Attendance employee) async {
    try {
      List<List<String>> values = [
        [
          employee.employeeId,
          employee.name,
          employee.date.toString(),
          employee.checkIn.toString(),
          employee.checkOut.toString(),
          employee.overtimeHours.toString(),
          employee.status,
        ]
      ];

      await _sheetsApi!.spreadsheets.values.append(
        sheets.ValueRange(values: values),
        _spreadsheetId,
        range,
        valueInputOption: "RAW",
      );

      print("✅ Employee Added: ${employee.name}");
    } catch (e) {
      print("🚨 Error adding employee: $e");
      rethrow;
    }
  }

  Future<void> removeEmployee(int rowIndex) async {
    try {
      final batchUpdateRequest = sheets.BatchUpdateSpreadsheetRequest(
        requests: [
          sheets.Request(
            deleteDimension: sheets.DeleteDimensionRequest(
              range: sheets.DimensionRange(
                sheetId: 0,
                dimension: "ROWS",
                startIndex: rowIndex,
                endIndex: rowIndex + 1,
              ),
            ),
          ),
        ],
      );

      // ✅ Send batch update request to delete the row
      await _sheetsApi!.spreadsheets
          .batchUpdate(batchUpdateRequest, _spreadsheetId);

      print("✅ Employee row deleted successfully!");
    } catch (e) {
      print("🚨 Error deleting employee row: $e");
      rethrow;
    }
  }
}
