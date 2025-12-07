import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_web_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/notification_item.dart';

@LazySingleton(as: DashboardRemoteDataSource)
class DashboardMockDataSource implements DashboardRemoteDataSource {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New student registration: Emily Chen',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
      type: NotificationType.enrollment,
    ),
    NotificationItem(
      id: '2',
      title: 'Class cancellation: Swimming 101',
      description: 'Pool maintenance scheduled',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      type: NotificationType.classCancellation,
    ),
    NotificationItem(
      id: '3',
      title: 'Payment received from Michael Torres',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
      type: NotificationType.payment,
    ),
    NotificationItem(
      id: '4',
      title: 'Coach David requested time off',
      description: 'December 20-22, 2025',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
      type: NotificationType.timeOff,
    ),
    NotificationItem(
      id: '5',
      title: 'Equipment delivery scheduled for tomorrow',
      description: 'New basketball hoops arriving at 10 AM',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      isRead: true,
      type: NotificationType.delivery,
    ),
  ];

  @override
  Future<DashboardStats> getDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return DashboardStats(
      totalStudents: 247,
      activeCoaches: 18,
      classesThisWeek: 42,
      attendanceRate: 87.5,
      recentActivities: [
        RecentActivity(
          id: '1',
          title: 'John Doe enrolled in Tennis Basics',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          icon: Icons.person_add,
        ),
        RecentActivity(
          id: '2',
          title: 'Coach Sarah updated Soccer Advanced schedule',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          icon: Icons.calendar_today,
        ),
        RecentActivity(
          id: '3',
          title: 'Basketball Court A maintenance completed',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          icon: Icons.check_circle,
        ),
        RecentActivity(
          id: '4',
          title: 'New payment received from Emily Chen',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          icon: Icons.payment,
        ),
        RecentActivity(
          id: '5',
          title: 'Swimming pool inspection scheduled',
          timestamp: DateTime.now().subtract(const Duration(hours: 8)),
          icon: Icons.event,
        ),
      ],
    );
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_notifications);
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }
}
