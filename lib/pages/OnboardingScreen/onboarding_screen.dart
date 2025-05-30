import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/bloc/Address_bloc/Address_bloc.dart';
import 'package:kwik/bloc/Address_bloc/address_event.dart';
import 'package:kwik/constants/colors.dart';
import 'package:kwik/constants/network_check.dart';
import 'package:kwik/models/order_model.dart';
import 'package:kwik/widgets/kiwi_button.dart';
import 'package:kwik/widgets/waveclipper.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardData = [
    {
      "title": "Welcome to KWIK",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
      "image": "assets/images/image.jpeg"
    },
    {
      "title": "Groceries",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
      "image": "assets/images/image1.jpeg"
    },
    {
      "title": "Groceries",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
      "image": "assets/images/imag2.jpeg"
    },
  ];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NetworkUtils.checkConnection(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final devicewidth = MediaQuery.of(context).size.width;
    final deviceheight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.kwhiteColor,
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemCount: onboardData.length,
              itemBuilder: (context, index) {
                return OnboardContent(
                  title: onboardData[index]['title']!,
                  description: onboardData[index]['description']!,
                  image: onboardData[index]['image']!,
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardData.length,
                    (index) => buildDot(index),
                  ),
                ),
                SizedBox(height: deviceheight * 0.029),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: KiwiButton(
                      text: 'Next',
                      onPressed: () => context.go('/loginPage'),
                    )),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDot(int index) {
    return Container(
      height: 8,
      width: 8,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppColors.dotColorSelected
            : AppColors.dotColorUnSelected,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  final String title;
  final String description;
  final String image;

  const OnboardContent({
    super.key,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deviceheight = MediaQuery.of(context).size.height;
    final devicewidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const WaveclipperWidget(image: 'assets/images/image1.jpeg'),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceheight * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: theme.textTheme.displaySmall!.copyWith(
                      color: AppColors.textColorblack,
                      fontWeight: FontWeight.w700,
                      fontSize: 34),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: deviceheight * 0.01),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: deviceheight * 0.029),
          child: Text(
            description,
            style: theme.textTheme.bodyLarge!.copyWith(
                color: AppColors.textColorGrey,
                fontWeight: FontWeight.w400,
                height: devicewidth * 0.0035,
                fontSize: 20),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
