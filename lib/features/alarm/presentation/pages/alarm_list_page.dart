import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ttt_alarm/core/di/injection.dart';
import 'package:ttt_alarm/core/services/notification_service.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_event.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_state.dart';

class AlarmListPage extends StatefulWidget {
  const AlarmListPage({super.key});

  @override
  State<AlarmListPage> createState() => _AlarmListPageState();
}

class _AlarmListPageState extends State<AlarmListPage> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    await getIt<NotificationService>().requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<AlarmBloc>()..add(LoadAlarms()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Awake?'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => context.push('/settings'),
              tooltip: 'Settings',
            ),
          ],
        ),
        body: BlocBuilder<AlarmBloc, AlarmState>(
          builder: (context, state) {
            if (state.status == AlarmStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.alarms.isEmpty) {
              return const Center(child: Text('No alarms. Add one!'));
            }
            return ListView.builder(
              itemCount: state.alarms.length,
              itemBuilder: (context, index) {
                final alarm = state.alarms[index];
                return ListTile(
                  title: Text(
                    DateFormat('HH:mm').format(alarm.time),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${alarm.label} • ${alarm.difficulty.name}'),
                      if (alarm.isEnabled)
                        Text(
                          _getTimeRemaining(alarm.time),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  trailing: Switch(
                    value: alarm.isEnabled,
                    onChanged: (val) {
                      context.read<AlarmBloc>().add(ToggleAlarm(alarm.id, val));
                    },
                  ),
                  onLongPress: () {
                    final alarmBloc = context.read<AlarmBloc>();
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Alarm'),
                        content: const Text(
                          'Are you sure you want to delete this alarm?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              alarmBloc.add(DeleteAlarm(alarm.id));
                              Navigator.pop(context);
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push('/add_alarm'),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  String _getTimeRemaining(DateTime alarmTime) {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarmTime.hour,
      alarmTime.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final diff = scheduledTime.difference(now);
    final hours = diff.inHours;
    final minutes = diff.inMinutes % 60;

    if (hours > 0) {
      return 'Alarm in $hours hr $minutes min';
    } else {
      return 'Alarm in $minutes min';
    }
  }
}
