import 'package:flutter_web_app/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/notification_item.dart';

abstract class DashboardRepository {
  Future<DashboardStats> getDashboardStats();
  Future<List<NotificationItem>> getNotifications();
  Future<void> markNotificationAsRead(String id);
}
