import 'package:flutter/material.dart';
import 'package:flutter_web_app/core/di/injection.dart';
import 'package:flutter_web_app/core/router/app_router.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SaaS Platform',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
