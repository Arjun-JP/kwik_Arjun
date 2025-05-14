import 'package:equatable/equatable.dart';

abstract class CouponEvent extends Equatable {
  const CouponEvent();

  @override
  List<Object> get props => [];
}

class FetchAllCoupons extends CouponEvent {}

class ApplyCoupon extends CouponEvent {
  final String couponCode;

  const ApplyCoupon({required this.couponCode});

  @override
  List<Object> get props => [couponCode];
}

class ResetCoupons extends CouponEvent {}
