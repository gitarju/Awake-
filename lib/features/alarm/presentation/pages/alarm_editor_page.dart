import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:ttt_alarm/core/di/injection.dart';
import 'package:ttt_alarm/features/alarm/domain/entities/alarm_entity.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_bloc.dart';
import 'package:ttt_alarm/features/alarm/presentation/bloc/alarm_event.dart';
import 'package:ttt_alarm/features/game/domain/game_enums.dart';

class AlarmEditorPage extends StatefulWidget {
  const AlarmEditorPage({super.key});

  @override
  State<AlarmEditorPage> createState() => _AlarmEditorPageState();
}

class _AlarmEditorPageState extends State<AlarmEditorPage> {
  TimeOfDay _time = TimeOfDay.now();
  String _label = 'Alarm';
  Difficulty _difficulty = Difficulty.medium;
  String? _audioPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Alarm')),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () async {
                      final newTime = await showTimePicker(
                        context: context,
                        initialTime: _time,
                      );
                      if (newTime != null) setState(() => _time = newTime);
                    },
                    child: Text(
                      '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Label'),
                    onChanged: (val) => _label = val,
                    controller: TextEditingController(text: _label),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<Difficulty>(
                    initialValue: _difficulty,
                    decoration: const InputDecoration(labelText: 'Difficulty'),
                    items: Difficulty.values
                        .map(
                          (d) =>
                              DropdownMenuItem(value: d, child: Text(d.name)),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _difficulty = val);
                        // Show warning for Invincible mode
                        if (val == Difficulty.invincible) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('⚠️ Warning: Invincible Mode'),
                              content: const Text(
                                'In this mode, you CANNOT lower the volume or exit the alarm screen.\n\n'
                                'You must defeat the AI to stop the alarm.\n'
                                'If you lose/draw 6 times, it will snooze for 5 minutes.\n'
                                'If you fail again after snooze, it will finally stop with a morning quote.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('I Understand'),
                                ),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _audioPath == null
                              ? 'Sound: Default'
                              : 'Sound: Custom File',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform
                              .pickFiles(type: FileType.audio);

                          if (result != null) {
                            setState(() {
                              _audioPath = result.files.single.path;
                            });
                          }
                        },
                        child: const Text('Select File'),
                      ),
                      if (_audioPath != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _audioPath = null),
                        ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final now = DateTime.now();
                      var dt = DateTime(
                        now.year,
                        now.month,
                        now.day,
                        _time.hour,
                        _time.minute,
                      );
                      if (dt.isBefore(now))
                        dt = dt.add(const Duration(days: 1));

                      final alarm = AlarmEntity(
                        id: const Uuid().v4(),
                        time: dt,
                        label: _label,
                        isEnabled: true,
                        difficulty: _difficulty,
                        audioPath: _audioPath,
                      );

                      getIt<AlarmBloc>().add(AddAlarm(alarm));
                      context.pop();
                    },
                    child: const Text('Save Alarm'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
