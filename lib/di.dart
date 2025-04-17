import 'package:get_it/get_it.dart';
import '../services/cat_api_service.dart';
import '../data/repositories/cat_repository.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<CatApiService>(CatApiService());
  getIt.registerSingleton<CatRepository>(CatRepository(getIt<CatApiService>()));
}
