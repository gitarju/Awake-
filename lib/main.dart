import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter/material.dart';
import 'package:ttt_alarm/core/di/injection.dart';
import 'package:ttt_alarm/core/services/notification_service.dart';
import 'package:ttt_alarm/core/theme/app_theme.dart';
import 'package:ttt_alarm/core/router/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_bloc.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_event.dart';
import 'package:ttt_alarm/features/settings/presentation/bloc/theme_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI
  configureDependencies();

  // Initialize Services
  await AndroidAlarmManager.initialize();
  await getIt<NotificationService>().init(); // Safe to call after DI definition

  runApp(const TTTAlarmApp());
}

class TTTAlarmApp extends StatelessWidget {
  const TTTAlarmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ThemeBloc>()..add(LoadTheme()),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Awake?',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
