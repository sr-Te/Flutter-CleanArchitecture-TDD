import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:my_movie_list/core/errors/exception.dart';
import 'package:my_movie_list/core/errors/failure.dart';
import 'package:my_movie_list/core/network/network_info.dart';
import 'package:my_movie_list/data/datasources/movie_remote_data_source.dart';
import 'package:my_movie_list/data/models/movie_model.dart';
import 'package:my_movie_list/data/repositories/movie_repository_impl.dart';

class MockRemoteDataSource extends Mock implements MovieRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  MovieRepositoryImpl repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getMoviesNowPlaying', () {
    // DATA FOR THE MOCKS AND ASSERTIONS
    final tLanguage = 'en-US';
    final tMovieList = [MovieModel(title: 'test')];

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

    group('device is online', () {
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
  });
}
