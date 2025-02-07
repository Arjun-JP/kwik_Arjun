import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_event.dart';
import 'package:kwik/bloc/navbar_bloc/navbar_state.dart';

class NavbarBloc extends Bloc<NavbarEvent, NavbarState> {
  NavbarBloc() : super(const NavbarInitial()) {
    on<UpdateNavBarIndex>((event, emit) {
      emit(NavbarUpdated(event.index, state.isBottomNavBarVisible));
    });

    on<UpdateNavBarVisibility>((event, emit) {
      emit(NavbarUpdated(state.selectedIndex, event.isVisible));
    });

    on<SelectNavBarItem>((event, emit) {
      emit(NavbarUpdated(event.index, event.isBottomNavBarVisible));
    });
  }
}
