import 'package:equatable/equatable.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';

abstract class AlarmEvent extends Equatable {
  const AlarmEvent();
  @override
  List<Object> get props => [];
}

class LoadAlarms extends AlarmEvent {}

class AddAlarm extends AlarmEvent {
  final AlarmEntity alarm;
  const AddAlarm(this.alarm);
}

class ToggleAlarm extends AlarmEvent {
  final String id;
  final bool isEnabled;
  const ToggleAlarm(this.id, this.isEnabled);
}

class DeleteAlarm extends AlarmEvent {
  final String id;
  const DeleteAlarm(this.id);
}
