import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/core/constants/dashboard_routes.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_web_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_cubit.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_state.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/navigation/collapsible_menu_section.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/navigation/navigation_menu_item.dart';

class DesktopSidebar extends StatelessWidget {
  const DesktopSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        final isCollapsed = state.isSidebarCollapsed;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isCollapsed ? 80 : 280,
          child: GlassmorphicCard(
            borderRadius: 0,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                _buildToggleButton(context, isCollapsed),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        children: [
                          NavigationMenuItem(
                            icon: Icons.dashboard,
                            label: 'Overview',
                            route: DashboardRoutes.overview,
                            isCollapsed: isCollapsed,
                          ),
                          CollapsibleMenuSection(
                            icon: Icons.people,
                            label: 'Students',
                            route: DashboardRoutes.students,
                            isCollapsed: isCollapsed,
                            children: [
                              NavigationMenuItem(
                                icon: Icons.check_circle,
                                label: 'Active',
                                route: '${DashboardRoutes.students}/active',
                                isCollapsed: isCollapsed,
                                isNested: true,
                              ),
                              NavigationMenuItem(
                                icon: Icons.cancel,
                                label: 'Inactive',
                                route: '${DashboardRoutes.students}/inactive',
                                isCollapsed: isCollapsed,
                                isNested: true,
                              ),
                            ],
                          ),
                          NavigationMenuItem(
                            icon: Icons.group,
                            label: 'Coaches',
                            route: DashboardRoutes.coaches,
                            isCollapsed: isCollapsed,
                          ),
                          NavigationMenuItem(
                            icon: Icons.class_,
                            label: 'Classes',
                            route: DashboardRoutes.classes,
                            isCollapsed: isCollapsed,
                          ),
                          NavigationMenuItem(
                            icon: Icons.calendar_today,
                            label: 'Schedule',
                            route: DashboardRoutes.schedule,
                            isCollapsed: isCollapsed,
                          ),
                          NavigationMenuItem(
                            icon: Icons.settings,
                            label: 'Settings',
                            route: DashboardRoutes.settings,
                            isCollapsed: isCollapsed,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildLogoutButton(context, isCollapsed),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToggleButton(BuildContext context, bool isCollapsed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IconButton(
        icon: Icon(
          isCollapsed ? Icons.menu : Icons.menu_open,
          color: AppTheme.primaryPurple,
        ),
        onPressed: () {
          context.read<NavigationCubit>().toggleSidebar();
        },
        tooltip: isCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, bool isCollapsed) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: NavigationMenuItem(
        icon: Icons.logout,
        label: 'Logout',
        route: '/logout',
        isCollapsed: isCollapsed,
        onTap: () {
          context.read<AuthBloc>().add(const AuthLogoutRequested());
        },
      ),
    );
  }
}
