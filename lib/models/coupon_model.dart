class CouponModel {
  final String id;
  final String couponName;
  final String couponDes;
  final DateTime startDate;
  final DateTime endDate;
  final double minOrderValue;
  final double discountMaxPrice;
  final double discountPercentage;
  final String couponImage;
  final String couponType;
  final List<String> userList;
  final String couponCode;
  final DateTime createdTime;

  CouponModel({
    required this.id,
    required this.couponName,
    required this.couponDes,
    required this.startDate,
    required this.endDate,
    required this.minOrderValue,
    required this.discountMaxPrice,
    required this.discountPercentage,
    required this.couponImage,
    required this.couponType,
    required this.userList,
    required this.couponCode,
    required this.createdTime,
  });

  factory CouponModel.fromJson(Map<String, dynamic> json) {
    return CouponModel(
      id: json['_id'] ?? '',
      couponName: json['coupon_name'] ?? '',
      couponDes: json['coupon_des'] ?? '',
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      minOrderValue: (json['min_order_value'] ?? 0).toDouble(),
      discountMaxPrice: (json['discount_max_price'] ?? 0).toDouble(),
      discountPercentage: (json['discount_percentage'] ?? 0).toDouble(),
      couponImage: json['coupon_image'] ?? '',
      couponType: json['coupon_type'] ?? '',
      userList: List<String>.from(json['user_list'] ?? []),
      couponCode: json['coupon_code'] ?? '',
      createdTime: DateTime.parse(json['created_time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_name': couponName,
      'coupon_des': couponDes,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'min_order_value': minOrderValue,
      'discount_max_price': discountMaxPrice,
      'discount_percentage': discountPercentage,
      'coupon_image': couponImage,
      'coupon_type': couponType,
      'user_list': userList,
      'coupon_code': couponCode,
      'created_time': createdTime.toIso8601String(),
    };
  }
}
