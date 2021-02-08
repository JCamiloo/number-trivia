
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/commons/network/network_info.dart';
import 'package:trivia/commons/utils/input_converter.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:trivia/features/number_trivia/domain/use-cases/get_concret_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/use-cases/get_random_number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

Future<void> init() async {
  // Features
  // Bloc
  sl.registerFactory(() => NumberTriviaBloc(
    getConcreteNumberTrivia: sl(),
    getRandomNumberTrivia: sl(),
    inputConverter: sl()
  ));

  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  // Repository
  sl.registerLazySingleton<NumberTriviaRepository>(() => NumberTriviaRepositoryImpl(
    localSource: sl(),
    remoteSource: sl(),
    networkInfo: sl()
  ));

  // Data sources
  sl.registerLazySingleton<NumberTriviaRemoteSource>(() => NumberTriviaRemoteSourceImpl(
    client: sl()
  ));

  sl.registerLazySingleton<NumberTriviaLocalSource>(() => NumberTriviaLocalSourceImpl(
    sharedPreferences: sl()
  ));

  // Domain
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => DataConnectionChecker());
}