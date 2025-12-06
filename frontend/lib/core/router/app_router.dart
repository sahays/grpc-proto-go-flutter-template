import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/register_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const RegisterPage(),
        ),
      ),
      // GoRoute(
      //   path: '/dashboard',
      //   name: 'dashboard',
      //   pageBuilder: (context, state) => MaterialPage(
      //     key: state.pageKey,
      //     child: const DashboardPage(),
      //   ),
      // ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
