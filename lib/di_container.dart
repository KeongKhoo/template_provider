import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';
import 'package:template_provider/data/datasource/remote/dio/dio_client.dart';
import 'package:template_provider/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:template_provider/data/repository/language_repo.dart';
import 'package:template_provider/data/repository/onboarding_repo.dart';
import 'package:template_provider/provider/language_provider.dart';
import 'package:template_provider/provider/localization_provider.dart';
import 'package:template_provider/provider/onboarding_provider.dart';
import 'package:template_provider/provider/splash_provider.dart';
import 'package:template_provider/provider/theme_provider.dart';
import 'package:template_provider/util/app_constants.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton(() => DioClient(AppConstants.BANNER_URI, sl(),
      loggingInterceptor: sl(), sharedPreferences: sl()));

  // Repository
  sl.registerLazySingleton(() => LanguageRepo());
  sl.registerLazySingleton(() => OnBoardingRepo(dioClient: sl()));

  // Provider
  sl.registerFactory(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerFactory(() => OnBoardingProvider(onboardingRepo: sl()));
  sl.registerFactory(() => SplashProvider());
  sl.registerFactory(() => LanguageProvider(languageRepo: sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}
