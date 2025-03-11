import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:personal_select_chat/data/data_sources/auth_local_data_source.dart';
import 'package:personal_select_chat/data/repositories/auth_repository_impl.dart';
import 'package:personal_select_chat/domain/repositories/auth_repository.dart';
import 'package:personal_select_chat/domain/use_cases/auth_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../bloc/auth/auth_bloc.dart';
import '../../../data/data_sources/auth_remote_data_source.dart';
import '../router/router_bloc.dart';

class GetItSetup {
  final GetIt getIt = GetIt.instance;

  Future<void> setup() async {
    getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
    getIt.registerLazySingleton<GoogleSignIn>(() => GoogleSignIn());
    getIt.registerSingletonAsync<SharedPreferences>(
        () async => await SharedPreferences.getInstance());

    getIt.registerLazySingleton<RouterBloc>(() => RouterBloc());
    getIt.registerFactory<AuthLogicBloc>(
            () => AuthLogicBloc(getIt<AuthUseCase>(), getIt<RouterBloc>()));

    getIt.registerLazySingleton<AuthRemoteDataSource>(() =>
        AuthRemoteDataSourceImpl(getIt<FirebaseAuth>(), getIt<GoogleSignIn>()));
    getIt.registerLazySingleton<AuthLocalDataSource>(
        () => AuthLocalDataSourceImpl(getIt<SharedPreferences>()));

    getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(), getIt<AuthLocalDataSource>()));
    getIt.registerLazySingleton<AuthUseCase>(
        () => AuthUseCase(getIt<AuthRepository>()));
  }
}
