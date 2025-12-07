import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_web_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_event.dart';
import 'package:flutter_web_app/features/dashboard/presentation/bloc/dashboard/dashboard_state.dart';

@injectable
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRepository _dashboardRepository;

  DashboardBloc(this._dashboardRepository) : super(const DashboardInitial()) {
    on<DashboardDataRequested>(_onDataRequested);
    on<DashboardRefreshRequested>(_onRefreshRequested);
  }

  Future<void> _onDataRequested(
    DashboardDataRequested event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    try {
      final stats = await _dashboardRepository.getDashboardStats();
      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    DashboardRefreshRequested event,
    Emitter<DashboardState> emit,
  ) async {
    try {
      final stats = await _dashboardRepository.getDashboardStats();
      emit(DashboardLoaded(stats));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
