import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BannerModel1Shimmer extends StatefulWidget {
  final String bgColor;
  final String titlecolor;
  final double height;
  final int bannerId;
  final double verticalpadding;
  final double horizontalpadding;
  final double viewportFraction;
  final double borderradious;
  final bool showbanner;

  const BannerModel1Shimmer({
    super.key,
    required this.bgColor,
    required this.titlecolor,
    required this.height,
    required this.bannerId,
    required this.showbanner,
    this.verticalpadding = 10,
    this.borderradious = 10,
    this.viewportFraction = 1.0,
    this.horizontalpadding = 10,
  });

  @override
  State<BannerModel1Shimmer> createState() => _BannerModel1ShimmerState();
}

class _BannerModel1ShimmerState extends State<BannerModel1Shimmer> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Container(
        color: parseColor(widget.bgColor),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: widget.horizontalpadding,
              vertical: widget.verticalpadding),
          child: Stack(
            children: [
              CarouselSlider.builder(
                carouselController: _carouselController, // Sync Controller
                itemCount: 3,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.width * widget.height,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  viewportFraction: widget.viewportFraction,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIndex) {
                  return Shimmer(width: double.infinity, height: widget.height);
                },
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: AnimatedSmoothIndicator(
                    activeIndex: currentIndex, // Update active index
                    count: 3,
                    effect: const ExpandingDotsEffect(
                      activeDotColor: Colors.white,
                      dotHeight: 6,
                      dotWidth: 6,
                    ),
                    onDotClicked: (index) {
                      _carouselController.animateToPage(index);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
