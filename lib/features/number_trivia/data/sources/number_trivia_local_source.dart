import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the time
  /// the user had and internet connection.
  /// 
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}