import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_web_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/notifications/notifications_state.dart';

@injectable
class NotificationsCubit extends Cubit<NotificationsState> {
  final DashboardRepository _dashboardRepository;

  NotificationsCubit(this._dashboardRepository)
      : super(NotificationsState.initial());

  Future<void> loadNotifications() async {
    emit(state.copyWith(isLoading: true));
    try {
      final notifications = await _dashboardRepository.getNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;

      emit(state.copyWith(
        items: notifications,
        unreadCount: unreadCount,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _dashboardRepository.markNotificationAsRead(id);

      final updatedItems = state.items.map((item) {
        if (item.id == id) {
          return item.copyWith(isRead: true);
        }
        return item;
      }).toList();

      final unreadCount = updatedItems.where((n) => !n.isRead).length;

      emit(state.copyWith(
        items: updatedItems,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  void toggleDropdown() {
    emit(state.copyWith(isOpen: !state.isOpen));
  }
}
