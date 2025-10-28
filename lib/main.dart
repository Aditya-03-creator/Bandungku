import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/app_theme.dart';

void main() => runApp(const UtsApp());

class UtsApp extends StatelessWidget {
  const UtsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wisata Bandung',
      theme: AppTheme.light,
      initialRoute: RouteNames.dashboard, // ✅ Dashboard sebagai halaman awal
      onGenerateRoute: AppRoutes.onGenerateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
