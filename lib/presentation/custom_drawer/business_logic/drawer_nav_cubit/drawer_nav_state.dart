part of 'drawer_nav_cubit.dart';

abstract class DrawerNavState extends Equatable {
  @override
  List<Object> get props => [];
}

class DrawerNavInitial extends DrawerNavState {}

class DrawerNavGenre extends DrawerNavState {
  final Genre genre;
  DrawerNavGenre(this.genre);

  @override
  List<Object> get props => [genre];
}
