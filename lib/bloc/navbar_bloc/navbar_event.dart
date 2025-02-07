import 'package:equatable/equatable.dart';

abstract class NavbarEvent extends Equatable {
  const NavbarEvent();

  @override
  List<Object> get props => [];
}

// Update only index
class UpdateNavBarIndex extends NavbarEvent {
  final int index;
  const UpdateNavBarIndex(this.index);

  @override
  List<Object> get props => [index];
}

// Update only visibility
class UpdateNavBarVisibility extends NavbarEvent {
  final bool isVisible;
  const UpdateNavBarVisibility(this.isVisible);

  @override
  List<Object> get props => [isVisible];
}

// Update both index and visibility
class SelectNavBarItem extends NavbarEvent {
  final int index;
  final bool isBottomNavBarVisible;
  const SelectNavBarItem(this.index, this.isBottomNavBarVisible);

  @override
  List<Object> get props => [index, isBottomNavBarVisible];
}
