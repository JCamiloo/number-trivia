import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia/commons/error/failures.dart';
import 'package:trivia/commons/use-cases/use_case.dart';
import 'package:trivia/commons/utils/input_converter.dart';
import 'package:trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/use-cases/get_concret_number_trivia.dart';
import 'package:trivia/features/number_trivia/domain/use-cases/get_random_number_trivia.dart';
import 'package:trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
        getRandomNumberTrivia: mockGetRandomNumberTrivia,
        inputConverter: mockInputConverter);
  });

  test('initialState should be empty', () {
    //assert
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final numberString = '1';
    final numberParserd = 1;
    final numberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Right(numberParserd));

    test(
        'should call the InputConverter to validate and convert the string to an unsigned integer',
        () async {
      // arrange
      setUpMockInputConverterSuccess();

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(numberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert
      final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      // assert
      verify(mockGetConcreteNumberTrivia(Params(number: numberParserd)));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));

      // assert later
      final expected = [Loading(), Loaded(trivia: numberTrivia)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
    });

    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      setUpMockInputConverterSuccess();

      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForConcreteNumber(numberString));
    });
  });

  group('GetTriviaForRandomNumber', () {
    final numberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('Should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(numberTrivia));

      // assert later
      final expected = [Loading(), Loaded(trivia: numberTrivia)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('Should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert later
      final expected = [Loading(), Error(message: SERVER_FAILURE_MESSAGE)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test(
        'Should emit [Loading, Error] with a proper message for the error when getting data fails',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert later
      final expected = [Loading(), Error(message: CACHE_FAILURE_MESSAGE)];

      expectLater(bloc.cast(), emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
