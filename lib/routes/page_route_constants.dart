import 'package:flutter/material.dart';

import '../module/home/ui/home_page.dart';

class AppRoutes {
  AppRoutes._();

  /// Named routes
  static const String homePage = '/homePage';
  static const String employeeDetailPage = "/employeeDetailPage";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case employeeDetailPage:
        return MaterialPageRoute(
          builder: (_) {
            return MyHomePage();
          },
        );

      default:
        return MaterialPageRoute(
          builder: (_) {
            return MyHomePage();
          },
        );
    }
  }
}
