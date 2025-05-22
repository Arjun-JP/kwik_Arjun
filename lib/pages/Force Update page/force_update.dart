import 'package:flutter/material.dart';
import 'package:kwik/constants/colors.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class ForceUpdatePage extends StatelessWidget {
  final String title;
  final String description;

  final String downloadUrl;

  const ForceUpdatePage({
    Key? key,
    required this.title,
    required this.description,
    required this.downloadUrl,
  }) : super(key: key);

  void _launchUpdateUrl(BuildContext context) async {
    final Uri url = Uri.parse(downloadUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open update link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Lottie.asset(
                    'assets/images/force_update.json',
                    height: 300,
                    repeat: false,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    title,
                    style: theme.textTheme.titleLarge!.copyWith(fontSize: 19),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium!.copyWith(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  SafeArea(
                    child: ElevatedButton(
                      onPressed: () => _launchUpdateUrl(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonColorOrange,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 8),
                      ),
                      child: Text(
                        "Update Now",
                        style: theme.textTheme.bodyLarge!
                            .copyWith(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
