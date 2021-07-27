import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/core/network/network_info.dart';
import 'package:my_movie_list/data/datasources/genres/genres_local_data_source.dart';
import 'package:my_movie_list/data/datasources/genres/genres_remote_data_source.dart';
import 'package:my_movie_list/data/repositories/genres_repository_impl.dart';
import 'package:my_movie_list/domain/entities/genre.dart';

class MockRemoteDataSource extends Mock implements GenresRemoteDataSource {}

class MockLocalDataSource extends Mock implements GenresLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  GenresRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = GenresRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getGenres', () {
    final tLanguage = MoviesApi.en;
    final tGenresList = [Genre(id: 1, name: 'test')];

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getGenres(tLanguage);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getGenres(any))
              .thenAnswer((_) async => tGenresList);
          // act
          final result = await repository.getGenres(tLanguage);
          // assert
          verify(mockRemoteDataSource.getGenres(tLanguage));
          expect(result, equals(Right(tGenresList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getGenres(any))
              .thenAnswer((_) async => tGenresList);
          // act
          await repository.getGenres(tLanguage);
          // assert
          verify(mockRemoteDataSource.getGenres(tLanguage));
          verify(mockLocalDataSource.cacheGenres(tGenresList));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getGenres(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getGenres(tLanguage);
          // assert
          verify(mockRemoteDataSource.getGenres(tLanguage));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastGenres())
              .thenAnswer((_) async => tGenresList);
          // act
          final result = await repository.getGenres(tLanguage);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastGenres());
          expect(result, equals(Right(tGenresList)));
        },
      );

      test(
        'shoul return CacheFailure when there is no cached data present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastGenres()).thenThrow(CacheException());
          // act
          final result = await repository.getGenres(tLanguage);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastGenres());
          expect(result, equals(Left(CacheFailure())));
        },
      );
    });
  });
}
