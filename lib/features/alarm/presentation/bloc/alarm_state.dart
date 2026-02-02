import 'package:equatable/equatable.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';

enum AlarmStatus { initial, loading, loaded, error }

class AlarmState extends Equatable {
  final List<AlarmEntity> alarms;
  final AlarmStatus status;

  const AlarmState({this.alarms = const [], this.status = AlarmStatus.initial});

  AlarmState copyWith({List<AlarmEntity>? alarms, AlarmStatus? status}) {
    return AlarmState(
      alarms: alarms ?? this.alarms,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [alarms, status];
}
