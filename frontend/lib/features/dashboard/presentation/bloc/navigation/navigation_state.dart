import 'package:equatable/equatable.dart';

class NavigationState extends Equatable {
  final bool isSidebarCollapsed;
  final String currentRoute;

  const NavigationState({
    required this.isSidebarCollapsed,
    required this.currentRoute,
  });

  NavigationState copyWith({
    bool? isSidebarCollapsed,
    String? currentRoute,
  }) {
    return NavigationState(
      isSidebarCollapsed: isSidebarCollapsed ?? this.isSidebarCollapsed,
      currentRoute: currentRoute ?? this.currentRoute,
    );
  }

  @override
  List<Object?> get props => [isSidebarCollapsed, currentRoute];
}
