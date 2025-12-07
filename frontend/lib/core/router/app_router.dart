import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/core/di/injection.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/register_page.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:flutter_web_app/features/auth/presentation/pages/reset_password_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/dashboard_scaffold.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/overview_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/students_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/coaches_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/classes_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/schedule_page.dart';
import 'package:flutter_web_app/features/dashboard/presentation/pages/settings_page.dart';

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
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        pageBuilder: (context, state) => MaterialPage(
          key: state.pageKey,
          child: const ForgotPasswordPage(),
        ),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'] ?? '';
          return MaterialPage(
            key: state.pageKey,
            child: ResetPasswordPage(token: token),
          );
        },
      ),
      GoRoute(
        path: '/dashboard',
        redirect: (context, state) {
          final authState = getIt<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return '/login';
          }
          if (state.matchedLocation == '/dashboard') {
            return '/dashboard/overview';
          }
          return null;
        },
        routes: [
          ShellRoute(
            builder: (context, state, child) {
              return DashboardScaffold(child: child);
            },
            routes: [
              GoRoute(
                path: 'overview',
                name: 'dashboard-overview',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const OverviewPage(),
                ),
              ),
              GoRoute(
                path: 'students',
                name: 'dashboard-students',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const StudentsPage(),
                ),
              ),
              GoRoute(
                path: 'coaches',
                name: 'dashboard-coaches',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const CoachesPage(),
                ),
              ),
              GoRoute(
                path: 'classes',
                name: 'dashboard-classes',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const ClassesPage(),
                ),
              ),
              GoRoute(
                path: 'schedule',
                name: 'dashboard-schedule',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const SchedulePage(),
                ),
              ),
              GoRoute(
                path: 'settings',
                name: 'dashboard-settings',
                pageBuilder: (context, state) => MaterialPage(
                  key: state.pageKey,
                  child: const SettingsPage(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
}
