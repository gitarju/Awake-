import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ttt_alarm/core/di/injection.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_event.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          BlocBuilder<ThemeBloc, ThemeState>(
            builder: (context, state) {
              return ExpansionTile(
                leading: const Icon(Icons.palette),
                title: const Text('Theme'),
                subtitle: Text(_getThemeName(state.themeMode)),
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('System'),
                    value: ThemeMode.system,
                    groupValue: state.themeMode,
                    onChanged: (val) {
                      if (val != null)
                        context.read<ThemeBloc>().add(ChangeTheme(val));
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Light'),
                    value: ThemeMode.light,
                    groupValue: state.themeMode,
                    onChanged: (val) {
                      if (val != null)
                        context.read<ThemeBloc>().add(ChangeTheme(val));
                    },
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Dark'),
                    value: ThemeMode.dark,
                    groupValue: state.themeMode,
                    onChanged: (val) {
                      if (val != null)
                        context.read<ThemeBloc>().add(ChangeTheme(val));
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Sleep Insights'),
            subtitle: const Text('View your wake-up patterns'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              context.push('/insights');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.videogame_asset),
            title: const Text('Test Game'),
            subtitle: const Text('Practice Tic-Tac-Toe'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: const Text('Select Difficulty'),
                    children: [
                      SimpleDialogOption(
                        onPressed: () {
                          context.pop();
                          context.push('/game?difficulty=0'); // Easy
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Easy'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.pop();
                          context.push('/game?difficulty=1'); // Medium
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Medium'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.pop();
                          context.push('/game?difficulty=2'); // Hard
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Hard'),
                        ),
                      ),
                      SimpleDialogOption(
                        onPressed: () {
                          context.pop();
                          context.push('/game?difficulty=3'); // Invincible
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('Unbeatable'),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  String _getThemeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System Default';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }
}
