import 'package:injectable/injectable.dart';
import 'package:flutter_web_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/dashboard_stats.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/notification_item.dart';
import 'package:flutter_web_app/features/dashboard/domain/repositories/dashboard_repository.dart';

@LazySingleton(as: DashboardRepository)
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<DashboardStats> getDashboardStats() async {
    return await _remoteDataSource.getDashboardStats();
  }

  @override
  Future<List<NotificationItem>> getNotifications() async {
    return await _remoteDataSource.getNotifications();
  }

  @override
  Future<void> markNotificationAsRead(String id) async {
    return await _remoteDataSource.markNotificationAsRead(id);
  }
}
