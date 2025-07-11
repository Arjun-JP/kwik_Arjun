import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/widgets/shimmer/shimmer1.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../bloc/banner_bloc/banner_bloc.dart';
import '../../../bloc/banner_bloc/banner_event.dart';
import '../../../bloc/banner_bloc/banner_state.dart';
import '../../../repositories/banner_repository.dart';

class BannerModel1 extends StatefulWidget {
  final String bgColor;
  final String titlecolor;
  final double height;
  final int bannerId;
  final double verticalpadding;
  final double horizontalpadding;
  final double viewportFraction;
  final double borderradious;
  final bool showbanner;

  const BannerModel1({
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
  State<BannerModel1> createState() => _BannerModel1State();
}

class _BannerModel1State extends State<BannerModel1> {
  final CarouselSliderController _carouselController =
      CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return widget.showbanner
        ? BlocProvider(
            create: (context) => BannerBloc(bannerepository: BannerRepository())
              ..add(FetchBanners()),
            child: Builder(
              builder: (context) {
                return BlocBuilder<BannerBloc, BannerState>(
                  builder: (context, state) {
                    if (state is BannerLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is BannerLoaded) {
                      final filteredBanners = state.banners
                          .where((banner) => banner.bannerId == widget.bannerId)
                          .toList();

                      if (filteredBanners.isEmpty) {
                        return const SizedBox();
                      }

                      return Container(
                        color: parseColor(widget.bgColor),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: widget.horizontalpadding,
                              vertical: widget.verticalpadding),
                          child: Stack(
                            children: [
                              CarouselSlider.builder(
                                carouselController:
                                    _carouselController, // Sync Controller
                                itemCount: filteredBanners.length,
                                options: CarouselOptions(
                                  height: widget.height,
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
                                  final banner = filteredBanners[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        widget.borderradious),
                                    child: InkWell(
                                      onTap: () {
                                        context.push(
                                          '/subcategory-products?subcategoryid=${filteredBanners[index].subCategoryRef}&subcatname=Dry%20Fruits',
                                        );
                                      },
                                      child: SizedBox(
                                          width: double.infinity,
                                          child: CachedNetworkImage(
                                            imageUrl: banner.bannerImage,
                                            width: double.infinity,
                                            height:
                                                200, // optional: set your desired height
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                const Shimmer(
                                                    width: double.infinity,
                                                    height: 200),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                bottom: 10,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: AnimatedSmoothIndicator(
                                    activeIndex:
                                        currentIndex, // Update active index
                                    count: filteredBanners.length,
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
                    } else if (state is BannerError) {
                      return Center(child: Text("Error: ${state.message}"));
                    }
                    return const Center(child: Text("No data available"));
                  },
                );
              },
            ),
          )
        : const SizedBox();
  }
}
