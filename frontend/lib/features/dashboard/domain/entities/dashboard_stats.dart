import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DashboardStats extends Equatable {
  final int totalStudents;
  final int activeCoaches;
  final int classesThisWeek;
  final double attendanceRate;
  final List<RecentActivity> recentActivities;

  const DashboardStats({
    required this.totalStudents,
    required this.activeCoaches,
    required this.classesThisWeek,
    required this.attendanceRate,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [
        totalStudents,
        activeCoaches,
        classesThisWeek,
        attendanceRate,
        recentActivities,
      ];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final DateTime timestamp;
  final IconData icon;

  const RecentActivity({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, title, timestamp, icon];
}
