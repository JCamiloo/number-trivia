import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:trivia/commons/error/exceptions.dart';
import 'package:trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:trivia/features/number_trivia/data/sources/number_trivia_remote_source.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteSourceImpl source;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    source = NumberTriviaRemoteSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 404));
  }

  group('getConcreteNumberTrivia', () {
    final number = 1;
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perfom a get request on a URL with number 
      being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      source.getConcreteNumberTrivia(number);

      // assert
      verify(mockHttpClient.get('http://numbersapi.com/$number',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final result = await source.getConcreteNumberTrivia(number);

      // assert
      expect(result, equals(numberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure();

      // act
      final call = source.getConcreteNumberTrivia;

      // assert
      expect(() => call(number), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perfom a get request on a URL with number 
      being the endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      source.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess();

      // act
      final result = await source.getRandomNumberTrivia();

      // assert
      expect(result, equals(numberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      // arrange
      setUpMockHttpClientFailure();

      // act
      final call = source.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
