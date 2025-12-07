import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_web_app/core/constants/dashboard_routes.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/navigation/navigation_state.dart';

@injectable
class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit()
      : super(const NavigationState(
          isSidebarCollapsed: false,
          currentRoute: DashboardRoutes.overview,
        ));

  void toggleSidebar() {
    emit(state.copyWith(isSidebarCollapsed: !state.isSidebarCollapsed));
  }

  void navigateTo(String route) {
    emit(state.copyWith(currentRoute: route));
  }

  bool isActive(String route) => state.currentRoute == route;
}
