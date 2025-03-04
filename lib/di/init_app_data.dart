import 'package:get_it/get_it.dart';

import '../google_manager/google_sheets_service.dart';
import '../module/home/data/data_source/home_remote_data_source.dart';
import '../module/home/data/repository/home_repository_impl.dart';
import '../module/home/domain/repository/home_repository.dart';
import '../module/home/domain/usecase/home_usecase.dart';
import '../module/home/ui/viewmodel/home_cubit.dart';

final GetIt getIt = GetIt.instance;

Future<void> initDependency() async {
  final googleSheetsService = await GoogleSheetsService.createInstance();
  getIt.registerLazySingleton<GoogleSheetsService>(() => googleSheetsService);

  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiManager: getIt<GoogleSheetsService>()),
  );

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: getIt<HomeRemoteDataSource>()),
  );

  getIt.registerLazySingleton<HomeUseCase>(
    () => HomeUseCaseImpl(homeRepository: getIt<HomeRepository>()),
  );

  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt<HomeUseCase>()));
}
