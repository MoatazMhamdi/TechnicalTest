import 'package:flutter/material.dart';
import './Screens/home_screen.dart';
import './Screens/details_screen.dart';

class AppRoute {
  static const String home = '/home';
  static const String detail = '/detail';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case detail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => DetailScreen(
            type: args['type'],
            id: args['id'],
          ),
        );
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
