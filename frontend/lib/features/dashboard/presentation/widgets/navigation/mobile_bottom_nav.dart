import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_web_app/core/constants/dashboard_routes.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_state.dart';

class MobileBottomNav extends StatelessWidget {
  const MobileBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final currentRoute = state.currentRoute;
        int selectedIndex = _getSelectedIndex(currentRoute);

        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF1E293B).withOpacity(0.95)
                : Colors.white.withOpacity(0.95),
            border: Border(
              top: BorderSide(
                color: isDark
                    ? const Color(0xFF334155)
                    : Colors.grey.shade300,
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.dashboard,
                  label: 'Overview',
                  route: DashboardRoutes.overview,
                  isSelected: selectedIndex == 0,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.people,
                  label: 'Students',
                  route: DashboardRoutes.students,
                  isSelected: selectedIndex == 1,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.group,
                  label: 'Coaches',
                  route: DashboardRoutes.coaches,
                  isSelected: selectedIndex == 2,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.class_,
                  label: 'Classes',
                  route: DashboardRoutes.classes,
                  isSelected: selectedIndex == 3,
                  isDark: isDark,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.settings,
                  label: 'Settings',
                  route: DashboardRoutes.settings,
                  isSelected: selectedIndex == 4,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isSelected,
    required bool isDark,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.go(route);
            context.read<NavigationCubit>().navigateTo(route);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                transform: Matrix4.identity()
                  ..scale(isSelected ? 1.1 : 1.0),
                child: ShaderMask(
                  shaderCallback: (bounds) {
                    if (isSelected) {
                      return AppTheme.primaryGradient.createShader(bounds);
                    }
                    return LinearGradient(
                      colors: [
                        isDark ? Colors.white60 : Colors.grey.shade600,
                        isDark ? Colors.white60 : Colors.grey.shade600,
                      ],
                    ).createShader(bounds);
                  },
                  child: Icon(
                    icon,
                    size: 26,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppTheme.primaryPurple
                      : (isDark ? Colors.white60 : Colors.grey.shade600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(String currentRoute) {
    switch (currentRoute) {
      case DashboardRoutes.overview:
        return 0;
      case DashboardRoutes.students:
        return 1;
      case DashboardRoutes.coaches:
        return 2;
      case DashboardRoutes.classes:
        return 3;
      case DashboardRoutes.settings:
        return 4;
      default:
        return 0;
    }
  }
}
