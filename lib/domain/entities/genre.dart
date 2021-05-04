import 'package:equatable/equatable.dart';

class Genre extends Equatable {
  final int id;
  final String name;

  Genre({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [this.id, this.name];
}
