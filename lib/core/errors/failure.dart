import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}

class FailureMessage {
  static String server = 'Server Failure';
  static String unexpected = 'Unexpected Error';
}
