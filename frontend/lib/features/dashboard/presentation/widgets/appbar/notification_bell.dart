import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_app/core/theme/app_theme.dart';
import 'package:flutter_web_app/core/widgets/gradient_background.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/notifications/notifications_cubit.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/notifications/notifications_state.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationBell extends StatelessWidget {
  const NotificationBell({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      builder: (context, state) {
        return PopupMenuButton(
          icon: Badge(
            label: state.unreadCount > 0
                ? Text('${state.unreadCount}')
                : null,
            isLabelVisible: state.unreadCount > 0,
            backgroundColor: AppTheme.accentPink,
            child: const Icon(Icons.notifications_outlined),
          ),
          offset: const Offset(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          itemBuilder: (context) {
            if (state.items.isEmpty) {
              return [
                PopupMenuItem(
                  enabled: false,
                  child: Center(
                    child: Text(
                      'No notifications',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ),
                ),
              ];
            }

            final recentNotifications = state.items.take(5).toList();

            return <PopupMenuEntry<dynamic>>[
              PopupMenuItem(
                enabled: false,
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF1E293B),
                  ),
                ),
              ),
              const PopupMenuDivider(),
              ...recentNotifications.map((notification) {
                return PopupMenuItem<dynamic>(
                  onTap: () {
                    if (!notification.isRead) {
                      context
                          .read<NotificationsCubit>()
                          .markAsRead(notification.id);
                    }
                  },
                  child: Container(
                    width: 300,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color: notification.isRead
                              ? Colors.transparent
                              : AppTheme.primaryPurple,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontWeight: notification.isRead
                                ? FontWeight.normal
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (notification.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            notification.description!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          timeago.format(notification.timestamp),
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: Center(
                  child: Text(
                    'View All',
                    style: TextStyle(
                      color: AppTheme.primaryPurple,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                onTap: () {
                  // TODO: Navigate to notifications page
                },
              ),
            ];
          },
        );
      },
    );
  }
}
