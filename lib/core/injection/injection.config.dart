// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fittrack_pro/core/injection/register_module.dart' as _i203;
import 'package:fittrack_pro/features/dashboard/data/repositories/dashboard_repository_impl.dart'
    as _i145;
import 'package:fittrack_pro/features/dashboard/domain/repositories/dashboard_repository.dart'
    as _i870;
import 'package:fittrack_pro/features/dashboard/domain/usecases/dashboard_usecases.dart'
    as _i724;
import 'package:fittrack_pro/features/dashboard/presentation/cubit/dashboard_cubit.dart'
    as _i247;
import 'package:fittrack_pro/features/workout/data/datasources/workout_local_data_source.dart'
    as _i770;
import 'package:fittrack_pro/features/workout/data/repositories/workout_repository_impl.dart'
    as _i259;
import 'package:fittrack_pro/features/workout/domain/repositories/workout_repository.dart'
    as _i692;
import 'package:fittrack_pro/features/workout/domain/usecases/workout_usecases.dart'
    as _i606;
import 'package:fittrack_pro/features/workout/presentation/bloc/workout_bloc.dart'
    as _i743;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i870.DashboardRepository>(
        () => _i145.DashboardRepositoryImpl());
    gh.factory<_i724.GetWorkoutStats>(
        () => _i724.GetWorkoutStats(gh<_i870.DashboardRepository>()));
    gh.factory<_i724.GetWorkoutStatsStream>(
        () => _i724.GetWorkoutStatsStream(gh<_i870.DashboardRepository>()));
    gh.factory<_i724.GetUserProfile>(
        () => _i724.GetUserProfile(gh<_i870.DashboardRepository>()));
    gh.factory<_i724.UpdateUserProfile>(
        () => _i724.UpdateUserProfile(gh<_i870.DashboardRepository>()));
    gh.factory<_i724.GetWeeklyStats>(
        () => _i724.GetWeeklyStats(gh<_i870.DashboardRepository>()));
    gh.factory<_i724.GetMonthlyStats>(
        () => _i724.GetMonthlyStats(gh<_i870.DashboardRepository>()));
    gh.lazySingleton<_i770.WorkoutLocalDataSource>(() =>
        _i770.WorkoutLocalDataSourceImpl(
            sharedPreferences: gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i692.WorkoutRepository>(() => _i259.WorkoutRepositoryImpl(
        localDataSource: gh<_i770.WorkoutLocalDataSource>()));
    gh.factory<_i606.GetWorkouts>(
        () => _i606.GetWorkouts(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.StartWorkout>(
        () => _i606.StartWorkout(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.PauseWorkout>(
        () => _i606.PauseWorkout(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.ResumeWorkout>(
        () => _i606.ResumeWorkout(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.StopWorkout>(
        () => _i606.StopWorkout(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.GetCurrentWorkout>(
        () => _i606.GetCurrentWorkout(gh<_i692.WorkoutRepository>()));
    gh.factory<_i606.AddWorkoutPoint>(
        () => _i606.AddWorkoutPoint(gh<_i692.WorkoutRepository>()));
    gh.factory<_i743.WorkoutBloc>(() => _i743.WorkoutBloc(
          gh<_i606.StartWorkout>(),
          gh<_i606.PauseWorkout>(),
          gh<_i606.ResumeWorkout>(),
          gh<_i606.StopWorkout>(),
          gh<_i606.GetCurrentWorkout>(),
          gh<_i606.AddWorkoutPoint>(),
        ));
    gh.factory<_i247.DashboardCubit>(() => _i247.DashboardCubit(
          gh<_i724.GetWorkoutStats>(),
          gh<_i724.GetWorkoutStatsStream>(),
          gh<_i724.GetUserProfile>(),
          gh<_i724.UpdateUserProfile>(),
          gh<_i606.StartWorkout>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i203.RegisterModule {}
