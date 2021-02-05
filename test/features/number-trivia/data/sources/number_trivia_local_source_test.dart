import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivia/commons/error/exceptions.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_local_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalSourceImpl source;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    source =
        NumberTriviaLocalSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn((fixture('trivia_cached.json')));

      // act
      final result = await source.getLastNumberTrivia();

      // assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(numberTriviaModel));
    });

    test('should throw a CacheException when there is not a cache value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = source.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final numberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');

    test('should call SharedPreferences to cache the data', () async {
      // act
      source.cacheNumberTrivia(numberTriviaModel);

      //assert
      final expectedJsonString = json.encode(numberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));
    });
  });
}
