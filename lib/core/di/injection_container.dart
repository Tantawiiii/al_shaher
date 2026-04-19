import 'package:al_shaher/core/storage/auth_local_storage.dart';
import 'package:al_shaher/feature/user/auth/login/cubit/login_cubit.dart';
import 'package:al_shaher/feature/user/auth/register/data/register_remote_data_source.dart';
import 'package:al_shaher/feature/user/auth/register/cubit/register_cubit.dart';
import 'package:al_shaher/feature/user/auth/relation/cubit/branch_cubit.dart';
import 'package:al_shaher/feature/user/auth/relation/cubit/father_cubit.dart';
import 'package:al_shaher/feature/user/tree/data/tree_remote_data_source.dart';
import 'package:al_shaher/feature/user/events/data/events_remote_data_source.dart';
import 'package:al_shaher/feature/user/events/cubit/events_cubit.dart';
import 'package:al_shaher/feature/user/news/data/news_remote_data_source.dart';
import 'package:al_shaher/feature/user/news/cubit/news_cubit.dart';
import 'package:al_shaher/feature/user/members/data/members_remote_data_source.dart';
import 'package:al_shaher/feature/user/members/cubit/members_cubit.dart';
import 'package:al_shaher/feature/user/requests/data/requests_remote_data_source.dart';
import 'package:al_shaher/feature/user/requests/cubit/request_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/user/tree/cubit/tree_cubit.dart';
import '../network/dio_client.dart';
import '../network/network_service.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<AuthLocalStorage>(
    () => AuthLocalStorage(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NetworkService>(
    () => NetworkService(dio: sl<DioClient>().dio),
  );
  sl.registerLazySingleton<RegisterRemoteDataSource>(
    () => RegisterRemoteDataSource(sl<NetworkService>()),
  );

  sl.registerFactory<RegisterCubit>(
    () => RegisterCubit(sl<RegisterRemoteDataSource>()),
  );
  sl.registerFactory<BranchCubit>(
    () => BranchCubit(sl<RegisterRemoteDataSource>()),
  );
  sl.registerFactory<FatherCubit>(
    () => FatherCubit(sl<RegisterRemoteDataSource>()),
  );
  sl.registerFactory<LoginCubit>(
    () => LoginCubit(
      sl<RegisterRemoteDataSource>(),
      sl<AuthLocalStorage>(),
    ),
  );

  // Tree feature
  sl.registerLazySingleton<TreeRemoteDataSource>(
    () => TreeRemoteDataSource(sl<NetworkService>(), sl<AuthLocalStorage>()),
  );

  sl.registerFactory<TreeCubit>(
    () => TreeCubit(sl<TreeRemoteDataSource>()),
  );

  // Events feature
  sl.registerLazySingleton<EventsRemoteDataSource>(
    () => EventsRemoteDataSource(sl<NetworkService>(), sl<AuthLocalStorage>()),
  );
  sl.registerFactory<EventsCubit>(
    () => EventsCubit(sl<EventsRemoteDataSource>()),
  );

  // News feature
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(sl<NetworkService>(), sl<AuthLocalStorage>()),
  );
  sl.registerFactory<NewsCubit>(
    () => NewsCubit(sl<NewsRemoteDataSource>()),
  );

  // Members feature
  sl.registerLazySingleton<MembersRemoteDataSource>(
    () => MembersRemoteDataSource(sl<NetworkService>(), sl<AuthLocalStorage>()),
  );
  sl.registerFactory<MembersCubit>(
    () => MembersCubit(sl<MembersRemoteDataSource>()),
  );

  // Requests (public add-member, etc.)
  sl.registerLazySingleton<RequestsRemoteDataSource>(
    () => RequestsRemoteDataSource(sl<NetworkService>(), sl<AuthLocalStorage>()),
  );
  sl.registerFactory<RequestCubit>(
    () => RequestCubit(sl<RequestsRemoteDataSource>()),
  );
}

