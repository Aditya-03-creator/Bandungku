import 'package:flutter/material.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/profile/profile_page.dart';
import '../features/home/home_page.dart';
import '../features/list/list_page.dart';
import '../features/detail/detail_page.dart';
import '../data/models/item.dart';

class RouteNames {
  static const dashboard = '/';
  static const home = '/home';
  static const list = '/list';
  static const detail = '/detail';
  static const profile = '/profile';
}

class AppRoutes {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteNames.list:
        final int? categoryId = settings.arguments as int?;
        return MaterialPageRoute(builder: (_) => ListPage(categoryId: categoryId));
      case RouteNames.detail:
        final item = settings.arguments as Item;
        return MaterialPageRoute(builder: (_) => DetailPage(item: item));
      case RouteNames.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      default:
        return MaterialPageRoute(builder: (_) => const DashboardPage());
    }
  }
}
