import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_bloc.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_state.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/common/dashboard_card.dart';
import 'package:flutter_web_app/features/dashboard/presentation/widgets/common/stat_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class OverviewPage extends StatelessWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is DashboardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error loading dashboard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context
                        .read<DashboardBloc>()
                        .add(const DashboardRefreshRequested());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is DashboardLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dashboard Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: isMobile ? 2.5 : 2.0,
                children: [
                  StatCard(
                    title: 'Total Students',
                    value: '${state.stats.totalStudents}',
                    icon: Icons.people,
                    trend: 12.5,
                  ),
                  StatCard(
                    title: 'Active Coaches',
                    value: '${state.stats.activeCoaches}',
                    icon: Icons.group,
                    trend: 5.2,
                  ),
                  StatCard(
                    title: 'Classes This Week',
                    value: '${state.stats.classesThisWeek}',
                    icon: Icons.class_,
                    trend: -2.3,
                  ),
                  StatCard(
                    title: 'Attendance Rate',
                    value: '${state.stats.attendanceRate}%',
                    icon: Icons.check_circle,
                    trend: 3.1,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              DashboardCard(
                title: 'Recent Activity',
                action: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context
                        .read<DashboardBloc>()
                        .add(const DashboardRefreshRequested());
                  },
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.stats.recentActivities.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final activity = state.stats.recentActivities[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          activity.icon,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      title: Text(activity.title),
                      subtitle: Text(timeago.format(activity.timestamp)),
                    );
                  },
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
