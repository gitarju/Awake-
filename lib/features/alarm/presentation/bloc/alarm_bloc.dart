import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ttt_alarm/features/alarm/data/services/alarm_scheduler_service.dart';
import 'package:ttt_alarm/features/alarm/domain/repositories/alarm_repository.dart';
import 'alarm_event.dart';
import 'alarm_state.dart';

@lazySingleton
class AlarmBloc extends Bloc<AlarmEvent, AlarmState> {
  final AlarmRepository _repository;
  final AlarmSchedulerService _scheduler;

  AlarmBloc(this._repository, this._scheduler) : super(const AlarmState()) {
    on<LoadAlarms>(_onLoadAlarms);
    on<AddAlarm>(_onAddAlarm);
    on<ToggleAlarm>(_onToggleAlarm);
    on<DeleteAlarm>(_onDeleteAlarm);
  }

  Future<void> _onLoadAlarms(LoadAlarms event, Emitter<AlarmState> emit) async {
    emit(state.copyWith(status: AlarmStatus.loading));
    try {
      final alarms = await _repository.getAlarms();
      emit(state.copyWith(status: AlarmStatus.loaded, alarms: alarms));
    } catch (_) {
      emit(state.copyWith(status: AlarmStatus.error));
    }
  }

  Future<void> _onAddAlarm(AddAlarm event, Emitter<AlarmState> emit) async {
    await _repository.saveAlarm(event.alarm);
    await _scheduler.scheduleAlarm(event.alarm);
    add(LoadAlarms());
  }

  Future<void> _onToggleAlarm(
    ToggleAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      final alarm = state.alarms.firstWhere((a) => a.id == event.id);

      if (event.isEnabled) {
        // Recalculate next occurrence
        final now = DateTime.now();
        var scheduledTime = DateTime(
          now.year,
          now.month,
          now.day,
          alarm.time.hour,
          alarm.time.minute,
        );

        if (scheduledTime.isBefore(now)) {
          scheduledTime = scheduledTime.add(const Duration(days: 1));
        }

        final updatedAlarm = alarm.copyWith(
          isEnabled: true,
          time: scheduledTime,
        );

        await _repository.saveAlarm(updatedAlarm);
        await _scheduler.scheduleAlarm(updatedAlarm);
      } else {
        await _repository.toggleAlarm(event.id, false);
        await _scheduler.cancelAlarm(alarm);
      }

      add(LoadAlarms());
    } catch (e) {
      debugPrint('Error toggling alarm: $e');
    }
  }

  Future<void> _onDeleteAlarm(
    DeleteAlarm event,
    Emitter<AlarmState> emit,
  ) async {
    try {
      try {
        final alarm = state.alarms.firstWhere((a) => a.id == event.id);
        await _scheduler.cancelAlarm(alarm);
      } catch (e) {
        debugPrint('Could not find alarm to cancel schedule: $e');
      }

      await _repository.deleteAlarm(event.id);
      add(LoadAlarms());
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
      // Optionally emit error state or show snackbar via listener
    }
  }
}
