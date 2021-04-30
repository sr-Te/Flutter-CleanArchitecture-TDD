import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/network_info.dart';
import 'package:my_movie_list/data/datasources/movies_api.dart';
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
    final tLanguage = MoviesApi.en;
    final tEndpoint = MoviesEndpoint.nowPlaying;
    final tMovieList = MovieListModel();

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMovies(tEndpoint, tLanguage);
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
          when(mockRemoteDataSource.getMovies(any, any))
              .thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.getMovies(tEndpoint, tLanguage);
          // assert
          verify(mockRemoteDataSource.getMovies(tEndpoint, tLanguage));
          expect(result, equals(Right(tMovieList)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getMovies(tEndpoint, tLanguage);
          // assert
          verify(mockRemoteDataSource.getMovies(tEndpoint, tLanguage));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies(tEndpoint))
              .thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.getMovies(tEndpoint, tLanguage);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies(tEndpoint));
          expect(result, equals(Right(tMovieList)));
        },
      );

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastMovies(tEndpoint))
            .thenThrow(CacheException());
        // act
        final result = await repository.getMovies(tEndpoint, tLanguage);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastMovies(tEndpoint));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });
}
