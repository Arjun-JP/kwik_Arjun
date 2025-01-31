// States
import 'package:equatable/equatable.dart';

abstract class NavbarState extends Equatable {
  final int selectedIndex;
  final bool isBottomNavBarVisible;
  const NavbarState(this.selectedIndex, this.isBottomNavBarVisible);

  @override
  List<Object> get props => [selectedIndex, isBottomNavBarVisible];
}

class NavbarInitial extends NavbarState {
  const NavbarInitial() : super(0, true);
}

class NavbarUpdated extends NavbarState {
  const NavbarUpdated(int selectedIndex, bool isBottomNavBarVisible)
      : super(selectedIndex, isBottomNavBarVisible);
}
