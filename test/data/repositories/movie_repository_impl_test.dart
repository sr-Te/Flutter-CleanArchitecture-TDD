import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/network_info.dart';
import 'package:my_movie_list/data/datasources/movies_local_data_source.dart';
import 'package:my_movie_list/data/datasources/movies_remote_data_source.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/data/repositories/movies_repository_impl.dart';

class MockRemoteDataSource extends Mock implements MoviesRemoteDataSource {}

class MockLocalDataSource extends Mock implements MoviesLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MoviesRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MoviesRepositoryImpl(
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

  group('getMoviesNowPlaying', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    final tLanguage = 'en-US';
    final tMovieList = MovieListModel();

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMoviesNowPlaying(tLanguage);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesNowPlaying(any))
              .thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.getMoviesNowPlaying(tLanguage);
          // assert
          verify(mockRemoteDataSource.getMoviesNowPlaying(tLanguage));
          expect(result, equals(Right(tMovieList)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMoviesNowPlaying(any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getMoviesNowPlaying(tLanguage);
          // assert
          verify(mockRemoteDataSource.getMoviesNowPlaying(tLanguage));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMoviesNowPlaying())
              .thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.getMoviesNowPlaying(tLanguage);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMoviesNowPlaying());
          expect(result, equals(Right(tMovieList)));
        },
      );

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastMoviesNowPlaying())
            .thenThrow(CacheException());
        // act
        final result = await repository.getMoviesNowPlaying(tLanguage);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastMoviesNowPlaying());
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
