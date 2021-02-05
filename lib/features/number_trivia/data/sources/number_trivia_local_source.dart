import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/commons/error/exceptions.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalSource {
  /// Gets the cached [NumberTriviaModel] which was gotten the time
  /// the user had and internet connection.
  ///
  /// Throws [CacheException] if no cached data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalSourceImpl implements NumberTriviaLocalSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalSourceImpl({@required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);

    if (jsonString != null) {
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }

    throw CacheException();
  }

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson())
    );
  }
}
