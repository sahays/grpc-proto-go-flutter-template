import 'package:equatable/equatable.dart';
import 'package:flutter_web_app/features/dashboard/domain/entities/notification_item.dart';

class NotificationsState extends Equatable {
  final List<NotificationItem> items;
  final int unreadCount;
  final bool isOpen;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    required this.items,
    required this.unreadCount,
    required this.isOpen,
    this.isLoading = false,
    this.error,
  });

  factory NotificationsState.initial() {
    return const NotificationsState(
      items: [],
      unreadCount: 0,
      isOpen: false,
      isLoading: false,
    );
  }

  NotificationsState copyWith({
    List<NotificationItem>? items,
    int? unreadCount,
    bool? isOpen,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      isOpen: isOpen ?? this.isOpen,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [items, unreadCount, isOpen, isLoading, error];
}
