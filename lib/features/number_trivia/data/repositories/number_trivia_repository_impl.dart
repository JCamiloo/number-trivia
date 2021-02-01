import 'package:meta/meta.dart';
import 'package:dartz/dartz.dart';
import 'package:trivia/commons/error/failures.dart';
import 'package:trivia/commons/platform/network_info.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_local_source.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_remote_source.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteSource remoteSource;
  final NumberTriviaLocalSource localSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({
    @required this.remoteSource, 
    @required this.localSource, 
    @required this.networkInfo
  });

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() {
    throw UnimplementedError();
  }
}
