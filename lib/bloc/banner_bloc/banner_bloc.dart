import 'package:flutter_bloc/flutter_bloc.dart';

import '../../repositories/banner_repository.dart';
import 'banner_event.dart';
import 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository bannerepository;

  BannerBloc({required this.bannerepository}) : super(BannerInitial()) {
    on<FetchBanners>((event, emit) async {
      emit(BannerLoading());
      try {
        final banners = await bannerepository.fetchBanners();
        emit(BannerLoaded(banners));
      } catch (e) {
        emit(BannerError(e.toString()));
      }
    });
  }
}
