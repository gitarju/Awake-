// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../features/alarm/data/datasources/alarm_local_data_source.dart'
    as _i137;
import '../../features/alarm/data/repositories/alarm_repository_impl.dart'
    as _i153;
import '../../features/alarm/data/services/alarm_scheduler_service.dart'
    as _i562;
import '../../features/alarm/domain/repositories/alarm_repository.dart'
    as _i1014;
import '../../features/alarm/presentation/bloc/alarm_bloc.dart' as _i620;
import '../../features/game/presentation/bloc/game_bloc.dart' as _i541;
import '../../features/settings/presentation/bloc/theme_bloc.dart' as _i930;
import '../services/notification_service.dart' as _i941;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i541.GameBloc>(() => _i541.GameBloc());
    gh.factory<_i930.ThemeBloc>(() => _i930.ThemeBloc());
    gh.lazySingleton<_i941.NotificationService>(
      () => _i941.NotificationService(),
    );
    gh.lazySingleton<_i562.AlarmSchedulerService>(
      () => _i562.AlarmSchedulerService(),
    );
    gh.lazySingleton<_i137.AlarmLocalDataSource>(
      () => _i137.AlarmLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i1014.AlarmRepository>(
      () => _i153.AlarmRepositoryImpl(gh<_i137.AlarmLocalDataSource>()),
    );
    gh.lazySingleton<_i620.AlarmBloc>(
      () => _i620.AlarmBloc(
        gh<_i1014.AlarmRepository>(),
        gh<_i562.AlarmSchedulerService>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i137.RegisterModule {}
