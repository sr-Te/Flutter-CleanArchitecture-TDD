import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/api/movies_api.dart';
import 'package:my_movie_list/core/api/movies_endpoint.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/network_info.dart';
import 'package:my_movie_list/data/datasources/movies/movies_local_data_source.dart';
import 'package:my_movie_list/data/datasources/movies/movies_remote_data_source.dart';
import 'package:my_movie_list/data/repositories/movies_repository_impl.dart';
import 'package:my_movie_list/domain/entities/movie.dart';

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

  group('getMovies', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    final tLanguage = MoviesApi.en;
    final tEndpoint = MoviesEndpoint.withGenre;
    final genreId = -1;
    final List<Movie> tMovieModelList = [];

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMovies(tEndpoint, tLanguage, -1);
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
          when(
            mockRemoteDataSource.getMovies(any, any, any),
          ).thenAnswer((_) async => tMovieModelList);
          // act
          final result =
              await repository.getMovies(tEndpoint, tLanguage, genreId);
          // assert
          verify(mockRemoteDataSource.getMovies(any, any, any));
          expect(result, equals(Right(tMovieModelList)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(any, any, any))
              .thenAnswer((_) async => tMovieModelList);
          // act
          await repository.getMovies(tEndpoint, tLanguage, genreId);
          // assert
          verify(mockRemoteDataSource.getMovies(tEndpoint, tLanguage, genreId));

          verify(
            mockLocalDataSource.cacheMovies(
              tEndpoint + '$genreId',
              tMovieModelList,
            ),
          );
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovies(any, any, any))
              .thenThrow(ServerException());
          // act
          final result =
              await repository.getMovies(tEndpoint, tLanguage, genreId);
          // assert
          verify(mockRemoteDataSource.getMovies(tEndpoint, tLanguage, genreId));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return last locally cached data when the cached data is present',
        () async {
          // arrange
          when(mockLocalDataSource.getLastMovies(tEndpoint + '$genreId'))
              .thenAnswer((_) async => tMovieModelList);
          // act
          final result =
              await repository.getMovies(tEndpoint, tLanguage, genreId);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          verify(mockLocalDataSource.getLastMovies(tEndpoint + '$genreId'));
          expect(result, equals(Right(tMovieModelList)));
        },
      );

      test('should return CacheFailure when there is no cached data present',
          () async {
        // arrange
        when(mockLocalDataSource.getLastMovies(tEndpoint + '$genreId'))
            .thenThrow(CacheException());
        // act
        final result =
            await repository.getMovies(tEndpoint, tLanguage, genreId);
        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastMovies(tEndpoint + '$genreId'));
        expect(result, equals(Left(CacheFailure())));
      });
    });
  });

  group('searchMovies', () {
    final tLanguage = MoviesApi.en;
    final tQuery = 'k';
    final List<Movie> tMovieList = [];

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.searchMovies(tLanguage, tQuery);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.searchMovies(any, any),
          ).thenAnswer((_) async => tMovieList);
          // act
          final result = await repository.searchMovies(tLanguage, tQuery);
          // assert
          verify(mockRemoteDataSource.searchMovies(any, any));
          expect(result, equals(Right(tMovieList)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.searchMovies(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.searchMovies(tLanguage, tQuery);
          // assert
          verify(mockRemoteDataSource.searchMovies(tLanguage, tQuery));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return internet failure when there is no internet',
        () async {
          // act
          final result = await repository.searchMovies(tLanguage, tQuery);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(InternetFailure())));
        },
      );
    });
  });

  group('getMovieDetail', () {
    final tLanguage = MoviesApi.en;
    final tMovieId = 399566;
    final tMovieModel = Movie();

    test(
      'should check if the device is online',
      () {
        // arrange
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        // act
        repository.getMovieDetail(tLanguage, tMovieId);
        // assert
        verify(mockNetworkInfo.isConnected);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(
            mockRemoteDataSource.getMovieDetail(any, any),
          ).thenAnswer((_) async => tMovieModel);
          // act
          final result = await repository.getMovieDetail(tLanguage, tMovieId);
          // assert
          verify(mockRemoteDataSource.getMovieDetail(any, any));
          expect(result, equals(Right(tMovieModel)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getMovieDetail(any, any))
              .thenThrow(ServerException());
          // act
          final result = await repository.getMovieDetail(tLanguage, tMovieId);
          // assert
          verify(mockRemoteDataSource.getMovieDetail(tLanguage, tMovieId));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {
      test(
        'should return internet failure when there is no internet',
        () async {
          // act
          final result = await repository.getMovieDetail(tLanguage, tMovieId);
          // assert
          verifyZeroInteractions(mockRemoteDataSource);
          expect(result, equals(Left(InternetFailure())));
        },
      );
    });
  });
}
