import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_bloc.dart';
import 'package:kwik/bloc/Cart_bloc/cart_event.dart' as cart;
import 'package:kwik/bloc/Coupon_bloc/Coupon_bloc.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_event.dart';
import 'package:kwik/bloc/Coupon_bloc/coupon_state.dart';
import 'package:kwik/constants/doted_devider.dart';
import 'package:kwik/models/coupon_model.dart';
import 'package:kwik/widgets/shimmer/coupon_list_shimmer.dart';

class CouponsPage extends StatefulWidget {
  const CouponsPage({super.key});

  @override
  State<CouponsPage> createState() => _CouponsPageState();
}

class _CouponsPageState extends State<CouponsPage> {
  @override
  void initState() {
    context.read<CouponBloc>().add(FetchAllCoupons());
    super.initState();
  }

  double couponamount = 0.0;
  String couponcode = "";

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocListener<CouponBloc, CouponState>(listener: (context, state) {
      if (state is CouponInitial) {
        context.read<CouponBloc>().add(FetchAllCoupons());
      }
      if (state is CouponApplied) {
        context.read<CartBloc>().add(cart.ApplyCoupon(
            amount: state.disAmount, couponcode: state.couponCode));
      }
    }, child: BlocBuilder<CouponBloc, CouponState>(builder: (context, state) {
      if (state is ApplyCouponLoading) {
        return const CircularProgressIndicator();
      } else if (state is CouponInitial) {
        context.read<CouponBloc>().add(FetchAllCoupons());
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
              onTap: () {
                print(state.toString());
              },
              child: Text(
                "Coupons",
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: List.generate(
              5,
              (index) => const CouponWidgetshimmer(),
            ),
          )),
        );
      } else if (state is CouponLoading) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Coupons",
              style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
            ),
          ),
          body: SingleChildScrollView(
              child: Column(
            children: List.generate(
              5,
              (index) => const CouponWidgetshimmer(),
            ),
          )),
        );
      } else if (state is CouponListLoaded) {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            appBar: AppBar(
              title: InkWell(
                onTap: () {
                  print(state.toString());
                },
                child: Text(
                  "Coupons",
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        state.coupons.length,
                        (index) => couponWidget(
                            theme: theme,
                            coupon: state.coupons[index],
                            appliedcouponcode: ""),
                      ),
                    ),
                  ),
                )
              ],
            ));
      } else if (state is CouponApplied) {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            appBar: AppBar(
              title: InkWell(
                onTap: () {
                  print(state.toString());
                },
                child: Text(
                  "Coupons",
                  style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(
                        state.coupons.length,
                        (index) => couponWidget(
                            theme: theme,
                            coupon: state.coupons[index],
                            appliedcouponcode: state.couponCode),
                      ),
                    ),
                  ),
                )
              ],
            ));
      } else {
        return Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            appBar: AppBar(
              title: Text(
                "Coupons",
                style: theme.textTheme.bodyMedium!.copyWith(fontSize: 18),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SizedBox(child: Text(state.toString())),
                ),
                Expanded(
                  child: SizedBox(child: Text(state.toString())),
                )
              ],
            ));
      }
    }));
  }

  Widget couponWidget(
      {required ThemeData theme,
      required CouponModel coupon,
      required String appliedcouponcode}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15,
        ),
        color: Colors.white,
      ),
      width: double.infinity,
      child: Column(
        spacing: 5,
        children: [
          ListTile(
            leading: Image.network(coupon.couponImage ??
                "https://firebasestorage.googleapis.com/v0/b/kwikgroceries-8a11e.firebasestorage.app/o/sample%2Fdiscount%201.png?alt=media&token=95699213-a3e6-4335-8013-8f46d90f913a"),
            title: Text(
              coupon.couponName,
              style: theme.textTheme.bodyLarge,
            ),
            subtitle: Text(
              coupon.couponCode,
              style: theme.textTheme.bodyMedium!.copyWith(color: Colors.grey),
            ),
            trailing: ElevatedButton.icon(
              onPressed: () {
                context.read<CouponBloc>().add(ResetCoupons());
                // context.read<CouponBloc>().add(FetchAllCoupons());
                context
                    .read<CouponBloc>()
                    .add(ApplyCoupon(couponCode: coupon.couponCode));
              },
              label: Text(
                appliedcouponcode == "" ||
                        coupon.couponCode != appliedcouponcode
                    ? "Apply"
                    : "Applied",
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: appliedcouponcode == "" ||
                        coupon.couponCode != appliedcouponcode
                    ? const Color(0xFF318616)
                    : const Color(0xffFF592E),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 18.0, left: 12),
            child: DottedDivider(),
          ),
          Row(
            children: [
              const Expanded(flex: 1, child: Icon(Icons.arrow_right_rounded)),
              Expanded(
                flex: 5,
                child: Text(
                  "This coupon requires a minimum order of ${coupon.minOrderValue}",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Expanded(flex: 1, child: Icon(Icons.arrow_right_rounded)),
              Expanded(
                flex: 5,
                child: Text(
                  "Maximum discount available is ${coupon.discountMaxPrice}",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Expanded(flex: 1, child: Icon(Icons.arrow_right_rounded)),
              Expanded(
                flex: 5,
                child: Text(
                  "If you update your cart, you’ll need to apply the coupon again.",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Expanded(flex: 1, child: Icon(Icons.arrow_right_rounded)),
              Expanded(
                flex: 5,
                child: Text(
                  "This coupon is valid until ${formatIso8601Date(coupon.endDate.toIso8601String())}. Don’t miss out!",
                  style: theme.textTheme.bodyMedium!
                      .copyWith(color: Colors.grey, fontSize: 14),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

String formatIso8601Date(String isoDateString) {
  try {
    DateTime dateTime = DateTime.parse(isoDateString)
        .toLocal(); // Parse and convert to local time

    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1]; // Month is 1-based index
    final year = dateTime.year;

    return '${day}th ${month} ${year} ';
  } catch (e) {
    print('Error formatting date: $e');
    return 'Not Updated';
  }
}
