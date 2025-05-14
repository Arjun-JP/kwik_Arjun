import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/models/coupon_model.dart';
import 'package:kwik/repositories/coupon_repo.dart';
import 'coupon_event.dart';
import 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final CouponRepository repository;

  CouponBloc({required this.repository}) : super(CouponInitial()) {
    on<FetchAllCoupons>(_onFetchAllCoupons);
    on<ApplyCoupon>(_onApplyCoupon);
    on<ResetCoupons>(_onResetCoupon);
  }

  Future<void> _onFetchAllCoupons(
      FetchAllCoupons event, Emitter<CouponState> emit) async {
    emit(CouponLoading());
    try {
      final coupons = await repository.getAllCoupons();
      print(coupons);
      emit(CouponListLoaded(coupons: coupons));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  Future<void> _onApplyCoupon(
    ApplyCoupon event,
    Emitter<CouponState> emit,
  ) async {
    List<CouponModel> coupons = [];

    // Preserve the current list of coupons from previous state
    if (state is CouponListLoaded) {
      final currentState = state as CouponListLoaded;
      coupons = currentState.coupons;
    } else if (state is CouponApplied) {
      final currentState = state as CouponApplied;
      coupons = currentState.coupons;
    } else if (state is ApplyCouponLoading) {
      final currentState = state as ApplyCouponLoading;
      coupons = currentState.coupons;
    }

    // Emit loading state with current coupons
    emit(ApplyCouponLoading(
      couponcode: event.couponCode,
      coupons: coupons,
    ));

    try {
      final applied = await repository.applycoupon(
        couponcode: event.couponCode,
      );

      // Debug: Print applied coupon and coupon list
      print("Applied: $applied");
      print("Discount: ${applied["data"]["discount_price"]}");
      print("Coupons retained: ${coupons.length}");

      emit(CouponApplied(
        coupon: applied,
        coupons: coupons,
        couponCode: event.couponCode,
        disAmount: double.tryParse(
              applied["data"]["discount_price"].toString(),
            ) ??
            0.0,
      ));
    } catch (e) {
      emit(CouponError(message: e.toString()));
    }
  }

  FutureOr<void> _onResetCoupon(ResetCoupons event, Emitter<CouponState> emit) {
    emit(CouponInitial());
  }
}
