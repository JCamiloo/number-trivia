import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia/commons/error/exceptions.dart';
import 'package:trivia/commons/error/failures.dart';
import 'package:trivia/commons/network/network_info.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef Future<NumberTrivia> _ConcreteOrRandomChooser();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteSource remoteSource;
  final NumberTriviaLocalSource localSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {@required this.remoteSource,
      @required this.localSource,
      @required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
      int number) async {
    return await _getTrivia(() {
      return remoteSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChooser getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localSource.cacheNumberTrivia(remoteTrivia);
        return Right(remoteTrivia);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    try {
      return Right(await localSource.getLastNumberTrivia());
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}
