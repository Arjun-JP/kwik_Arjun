import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import 'package:kwik/constants/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionBottomSheet extends StatefulWidget {
  const LocationPermissionBottomSheet({super.key});

  @override
  State<LocationPermissionBottomSheet> createState() =>
      _LocationPermissionBottomSheetState();
}

TextEditingController lessoncontroller = TextEditingController();

class _LocationPermissionBottomSheetState
    extends State<LocationPermissionBottomSheet> {
  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  Future<void> getCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    // If permission is granted, get the current position
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Use the coordinates to get the city name
      List<Placemark> placemarks = await GeocodingPlatform.instance!
          .placemarkFromCoordinates(position.latitude, position.longitude);
      context.pop();
      // Extract city name
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      // height: MediaQuery.of(context).size.height * .26,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.buttonColorOrange, // Choose your color
              width: 2.0, // Thickness of the border
            ),
          ),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          spacing: 3,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
                height: 170,
                width: MediaQuery.of(context).size.width * .9,
                "assets/images/IMG_1593.jpg"),
            Text("Enable your location for better delivery experience!",
                // Your doorstep shopping buddy will be right here—just a tap away. Come back soon!
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textColorblack,
                    fontSize: 18,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => getCurrentLocation(),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(MediaQuery.of(context).size.width, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: AppColors.buttonColorOrange,
                backgroundColor: AppColors.buttonColorOrange,
              ),
              child: Text(
                "Continue",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: AppColors.kwhiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
