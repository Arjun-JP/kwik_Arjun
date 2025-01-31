import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

abstract class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

class SelectNavBarItem extends NavbarEvent {
  final int index;
  final bool isBottomNavBarVisible;
  const SelectNavBarItem(this.index, this.isBottomNavBarVisible);

  @override
  List<Object> get props => [index, isBottomNavBarVisible];
}
