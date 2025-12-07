import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/core/di/injection.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/notifications/notifications_cubit.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/appbar/dashboard_app_bar.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/navigation/desktop_sidebar.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/navigation/mobile_bottom_nav.dart';

class DashboardScaffold extends StatelessWidget {
  final Widget child;

  const DashboardScaffold({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: getIt<AuthBloc>(),
        ),
        BlocProvider(
          create: (_) => getIt<NavigationCubit>(),
        ),
        BlocProvider(
          create: (_) => getIt<DashboardBloc>()
            ..add(const DashboardDataRequested()),
        ),
        BlocProvider(
          create: (_) => getIt<NotificationsCubit>()..loadNotifications(),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        child: const _DashboardView(),
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    // Get the child widget from the parent DashboardScaffold
    final scaffold = context.findAncestorWidgetOfExactType<DashboardScaffold>();
    final child = scaffold?.child ?? const SizedBox.shrink();

    return Scaffold(
      body: GradientBackground(
        isDark: isDark,
        child: isMobile
            ? _buildMobileLayout(child)
            : _buildDesktopLayout(child),
      ),
    );
  }

  Widget _buildMobileLayout(Widget child) {
    return Column(
      children: [
        const DashboardAppBar(isMobile: true),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: child,
          ),
        ),
        const MobileBottomNav(),
      ],
    );
  }

  Widget _buildDesktopLayout(Widget child) {
    return Row(
      children: [
        const DesktopSidebar(),
        Expanded(
          child: Column(
            children: [
              const DashboardAppBar(isMobile: false),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
