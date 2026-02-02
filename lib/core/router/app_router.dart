import 'package:go_router/go_router.dart';
import 'package:ttt_alarm/features/alarm/presentation/pages/alarm_editor_page.dart';
import 'package:ttt_alarm/features/alarm/presentation/pages/alarm_list_page.dart';
import 'package:ttt_alarm/features/alarm/presentation/pages/alarm_ring_page.dart';
import 'package:ttt_alarm/features/settings/presentation/pages/settings_page.dart';
import 'package:ttt_alarm/features/insights/presentation/pages/insights_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AlarmListPage()),
    GoRoute(
      path: '/add_alarm',
      builder: (context, state) => const AlarmEditorPage(),
    ),
    GoRoute(
      path: '/ring',
      builder: (context, state) {
        final alarmId = state.uri.queryParameters['alarmId'];
        // difficulty param is deprecated in favor of alarmId lookup, but keeping for fallback/compat
        final diffIndexString = state.uri.queryParameters['difficulty'];
        final diffIndex = diffIndexString != null
            ? int.tryParse(diffIndexString)
            : null;
        return AlarmRingPage(alarmId: alarmId, difficultyIndex: diffIndex);
      },
    ),
    GoRoute(
      path: '/game',
      builder: (context, state) {
        final diffIndexString = state.uri.queryParameters['difficulty'];
        final diffIndex = diffIndexString != null
            ? int.tryParse(diffIndexString)
            : null;
        return AlarmRingPage(isGameMode: true, difficultyIndex: diffIndex);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/insights',
      builder: (context, state) => const InsightsPage(),
    ),
  ],
);
