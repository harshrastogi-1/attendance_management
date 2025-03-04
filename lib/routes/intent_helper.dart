import 'package:attendance_manager/routes/page_route_constants.dart';
import 'package:flutter/cupertino.dart';

void navigateToHomeScreen({
  required BuildContext context,
}) {
  Navigator.pushNamed(
    context,
    AppRoutes.homePage,
    arguments: {},
  );
}

void navigateToEmployeeDetailScreen({
  required BuildContext context,
}) async {
  Navigator.pushNamed(
    context,
    AppRoutes.employeeDetailPage,
    arguments: {},
  );
}
