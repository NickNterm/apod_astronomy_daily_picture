import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/entities/astronomy_fact.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/repositories/astronomy_fact_repository.dart';
import 'package:astronomy_picture_of_the_day/features/astronomy_picture/domain/usecases/get_astronomy_fact.dart';
import 'package:dartz/dartz.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAstronomyFactRepository extends Mock implements AstronomyFactRepository {}

void main() {
  MockAstronomyFactRepository mockAstronomyFactRepository = MockAstronomyFactRepository();
  GetAstronomyFact usecase = GetAstronomyFact(mockAstronomyFactRepository);

  final tDate = DateTime(2021, 1, 1);
  final tAstronomyFact = AstronomyFact(
    title: 'title',
    explanation: 'explanation',
    date: tDate,
    imageUrl: 'imageUrl',
    copyRight: 'copyRight',
  );

  test('should get AstronomyFact for the date from the repository', () async {
    // arrange
    when(() => mockAstronomyFactRepository.getAstronomyFact(any())).thenAnswer((_) async => Right(tAstronomyFact));
    // act
    final result = await usecase(date: tDate);
    // assert
    expect(result, Right(tAstronomyFact));
    verify(() => mockAstronomyFactRepository.getAstronomyFact(tDate));
    verifyNoMoreInteractions(mockAstronomyFactRepository);
  });
}
