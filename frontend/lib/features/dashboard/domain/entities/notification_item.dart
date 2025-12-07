import 'package:equatable/equatable.dart';

enum NotificationType {
  enrollment,
  classCancellation,
  payment,
  timeOff,
  delivery,
  general,
}

class NotificationItem extends Equatable {
  final String id;
  final String title;
  final String? description;
  final DateTime timestamp;
  final bool isRead;
  final NotificationType type;

  const NotificationItem({
    required this.id,
    required this.title,
    this.description,
    required this.timestamp,
    required this.isRead,
    required this.type,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? timestamp,
    bool? isRead,
    NotificationType? type,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [id, title, description, timestamp, isRead, type];
}
