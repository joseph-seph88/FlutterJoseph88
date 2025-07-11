import 'package:ai_hair_official/core/api_client.dart';
import 'package:ai_hair_official/features/hair/services/hair_service.dart';
import 'package:ai_hair_official/features/hair/presentation/cubits/hair_cubit.dart';
import 'package:get_it/get_it.dart';

void setupHairDi(GetIt getIt) {
  getIt.registerLazySingleton<HairService>(
    () => HairService(getIt<ApiClient>()),
  );

  getIt.registerLazySingleton<HairCubit>(
    () => HairCubit(getIt<HairService>()),
  );
}
