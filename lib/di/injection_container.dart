import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_training/core/network/network_info.dart';
import 'package:flutter_training/data/repositories/auth_repository_impl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_training/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_training/domain/repositories/auth_repository.dart';
import 'package:flutter_training/domain/usecases/login_usecase.dart';
import 'package:flutter_training/presentation/bloc/auth/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_training/core/network/api_client.dart';
import 'package:flutter_training/core/storage/local_storage.dart';
import 'package:flutter_training/core/security/encryption_service.dart';
import 'package:flutter_training/core/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => AuthBloc(loginUseCase: sl()));

  sl.registerLazySingleton(() => LoginUseCase(sl()));

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());

  sl.registerLazySingleton(() => ApiClient(sl()));
  sl.registerLazySingleton(() => LocalStorage(sl()));
  sl.registerLazySingleton(() => EncryptionService(sl()));
  sl.registerLazySingleton(() => AppTheme());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => FlutterSecureStorage());
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
}
