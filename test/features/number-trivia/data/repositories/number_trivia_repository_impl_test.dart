import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trivia/commons/platform/network_info.dart';
import 'package:trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_remote_source.dart';

class MockRemoteDataSource extends Mock implements NumberTriviaRemoteSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteSource: mockRemoteDataSource,
      localSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });
}