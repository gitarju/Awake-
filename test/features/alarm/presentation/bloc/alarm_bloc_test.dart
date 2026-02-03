import 'package:flutter_test/flutter_test.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:ttt_alarm/features/alarm/domain/repositories/alarm_repository.dart';
import 'package:ttt_alarm/features/alarm/data/services/alarm_scheduler_service.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_event.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_state.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

// Mocks
class MockAlarmRepository implements AlarmRepository {
  List<AlarmEntity> alarms = [];

  @override
  Future<List<AlarmEntity>> getAlarms() async => List.from(alarms);

  @override
  Future<void> saveAlarm(AlarmEntity alarm) async {
    final index = alarms.indexWhere((element) => element.id == alarm.id);
    if (index != -1) {
      alarms[index] = alarm;
    } else {
      alarms.add(alarm);
    }
  }

  @override
  Future<void> deleteAlarm(String id) async {
    alarms.removeWhere((element) => element.id == id);
  }

  @override
  Future<void> toggleAlarm(String id, bool isEnabled) async {
    final index = alarms.indexWhere((element) => element.id == id);
    if (index != -1) {
      alarms[index] = alarms[index].copyWith(isEnabled: isEnabled);
    }
  }
}

class MockAlarmSchedulerService extends AlarmSchedulerService {
  AlarmEntity? lastScheduledAlarm;
  AlarmEntity? lastCancelledAlarm;

  @override
  Future<void> scheduleAlarm(AlarmEntity alarm) async {
    lastScheduledAlarm = alarm;
  }

  @override
  Future<void> cancelAlarm(AlarmEntity alarm) async {
    lastCancelledAlarm = alarm;
  }
}

void main() {
  late MockAlarmRepository mockRepository;
  late MockAlarmSchedulerService mockScheduler;
  late AlarmBloc bloc;

  setUp(() {
    mockRepository = MockAlarmRepository();
    mockScheduler = MockAlarmSchedulerService();
    bloc = AlarmBloc(mockRepository, mockScheduler);
  });

  group('AlarmBloc', () {
    test('ToggleAlarm recalculates time for past alarms and schedules future time', () async {
      // Setup
      final now = DateTime.now();
      // Past time: Yesterday
      final pastTime = now.subtract(const Duration(days: 1));

      final alarm = AlarmEntity(
        id: '1',
        time: pastTime,
        label: 'Past Alarm',
        isEnabled: false,
        difficulty: Difficulty.medium,
      );

      // Seed repo
      await mockRepository.saveAlarm(alarm);

      // Act: Load first to populate state (important for Toggle logic which reads from state)
      bloc.add(LoadAlarms());
      await bloc.stream.firstWhere((state) => state.status == AlarmStatus.loaded);

      // Trigger toggle
      bloc.add(ToggleAlarm('1', true));

      // Wait for the next loaded state (triggered by Toggle -> LoadAlarms)
      await bloc.stream.firstWhere((state) => state.status == AlarmStatus.loaded);

      // Assert
      expect(mockScheduler.lastScheduledAlarm, isNotNull);
      final scheduledTime = mockScheduler.lastScheduledAlarm!.time;

      print('Now: $now');
      print('Original Past Time: $pastTime');
      print('Scheduled Time: $scheduledTime');

      // Verify scheduled time is in the future
      expect(scheduledTime.isAfter(now), isTrue, reason: 'Scheduled time should be in the future');

      // Also verify repo was updated with the new time
      final savedAlarm = mockRepository.alarms.firstWhere((a) => a.id == '1');
      expect(savedAlarm.time.isAfter(now), isTrue, reason: 'Repository should be updated with new time');
    });
  });
}
