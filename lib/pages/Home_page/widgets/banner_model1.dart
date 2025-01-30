import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/banner_bloc/banner_bloc.dart';
import '../../../bloc/banner_bloc/banner_event.dart';
import '../../../bloc/banner_bloc/banner_state.dart';
import '../../../repositories/banner_repository.dart';

class BannerModel1 extends StatelessWidget {
  final String bgColor;
  final String titlecolor;
  final double height;
  final int bannerId;

  const BannerModel1({
    super.key,
    required this.bgColor,
    required this.titlecolor,
    required this.height,
    required this.bannerId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannerBloc(bannerepository: BannerRepository())
        ..add(FetchBanners()), // Dispatch the event to fetch banners
      child: Builder(
        builder: (context) {
          return BlocBuilder<BannerBloc, BannerState>(
            builder: (context, state) {
              if (state is BannerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is BannerLoaded) {
                // Filter banners to only include those with banner_id == 1
                final filteredBanners = state.banners
                    .where((banner) => banner.bannerId == bannerId)
                    .toList();

                if (filteredBanners.isEmpty) {
                  return const SizedBox();
                }
                return Container(
                  color: parseColor(
                      bgColor), // Optional: Apply background color to container
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Carousel Section
                        SizedBox(
                          height: height, // Height of the carousel
                          child: PageView.builder(
                            itemCount: filteredBanners.length,
                            itemBuilder: (context, index) {
                              final banner = filteredBanners[index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    // color: parseColor(bgColor), // Optional background color
                                    image: DecorationImage(
                                      image: NetworkImage(banner.bannerImage),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              );
                            },
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
    );
  }
}

// Function to parse hex color correctly (optional)
Color parseColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return const Color(0xFFADD8E6); // Default pastel blue
  }

  hexColor = hexColor.replaceAll("#", ""); // Remove # if present

  // If the input is 6 characters long (RGB), add "FF" for full opacity
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor";
  }
  // If the input is not 8 characters (AARRGGBB), return default pastel color
  else if (hexColor.length != 8) {
    return const Color(0xFFADD8E6);
  }

  try {
    return Color(int.parse("0x$hexColor")); // Ensure correct 0xAARRGGBB format
  } catch (e) {
    return const Color(0xFFADD8E6); // Default pastel blue on error
  }
}
