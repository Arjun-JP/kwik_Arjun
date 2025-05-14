import 'package:equatable/equatable.dart';
import '../../models/coupon_model.dart';

abstract class CouponState extends Equatable {
  const CouponState();

  @override
  List<Object?> get props => [];
}

class CouponInitial extends CouponState {}

class CouponLoading extends CouponState {}

class ApplyCouponLoading extends CouponState {
  final String couponcode;
  final List<CouponModel> coupons;

  const ApplyCouponLoading({required this.couponcode, required this.coupons});

  @override
  List<Object?> get props => [couponcode];
}

class CouponListLoaded extends CouponState {
  final List<CouponModel> coupons;

  const CouponListLoaded({required this.coupons});

  @override
  List<Object?> get props => [coupons];
}

class CouponApplied extends CouponState {
  final Map<String, dynamic> coupon;
  final double disAmount;
  final String couponCode;
  final List<CouponModel> coupons;
  const CouponApplied(
      {required this.coupon,
      required this.disAmount,
      required this.couponCode,
      required this.coupons});

  @override
  List<Object?> get props => [coupon];
}

class CouponError extends CouponState {
  final String message;

  const CouponError({required this.message});

  @override
  List<Object?> get props => [message];
}
