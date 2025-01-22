import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kwik/constants/colors.dart';


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
      "title": "Welcome to XYZ App",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
    
    },
    {
      "title": "Groceries",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
     
    },
    {
      "title": "Groceries",
      "description":
          "Effortlessly buy items with just a few taps, making transactions quick and simple",
     // "image": "assets/images/3.png"
    },
  ];

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
            flex: 2,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardData.length,
                    (index) => buildDot(index),
                  ),
                ),
                SizedBox(
                  height: deviceheight * 0.029, // 20
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () => context.push('/CreateAccount'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColorOrange,
                        minimumSize: Size(devicewidth, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text("Get started",
                        style: theme.textTheme.titleMedium!.copyWith(
                            color: AppColors.textColorWhite,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceheight * 0.029,
                      vertical: deviceheight * 0.029),
                  child: ElevatedButton(
                    onPressed: () => context.push('/Loginpage'),
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: AppColors.kwhiteColor,
                        minimumSize: Size(devicewidth, deviceheight * 0.0737),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    child: Text("Already have an account",
                        style: theme.textTheme.titleMedium!.copyWith(
                            color: AppColors.textColorblue,
                            fontSize: 20,
                            fontWeight: FontWeight.w400)),
                  ),
                ),
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
  final String? image;

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
      children: [
        SizedBox(
          width: devicewidth,
          height: deviceheight * 0.46,
          child: Image.asset(
            image!,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: deviceheight * 0.0589,
            right: deviceheight * 0.0589,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  title,
                  style: theme.textTheme.displaySmall!.copyWith(
                      color: AppColors.textColorblue,
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
          padding: EdgeInsets.only(
            left: deviceheight * 0.029,
            right: deviceheight * 0.029,
          ),
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
