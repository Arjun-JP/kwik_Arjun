import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_event.dart';
import 'package:kwik/bloc/force_update_bloc/force_update_state.dart';
import 'package:kwik/pages/Force%20Update%20page/force_update.dart';
import 'package:kwik/repositories/get_app_data_repo.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final GetAppDataRepo repository;

  UpdateBloc(this.repository) : super(UpdateInitial()) {
    on<CheckForUpdate>(_onCheckForUpdate);
  }

  Future<void> _onCheckForUpdate(
      CheckForUpdate event, Emitter<UpdateState> emit) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = 0;

      Map<String, dynamic> appdata = await repository.getappdata();

      final title = appdata['new_update_title_ios'];
      final description = appdata['new_update_des_ios'];

      final forceUpdateVersion = Platform.isAndroid
          ? appdata['force_update_android']
          : appdata['force_update_ios'];

      final downloadUrl = "https://pramctraining.in/";
      print(title);
      print(description);
      print(forceUpdateVersion);
      print("object");
      // Compare versions safely
      if (forceUpdateVersion > currentVersion) {
        Navigator.push(
          event.context,
          MaterialPageRoute(
            builder: (context) => ForceUpdatePage(
              title: title,
              description: description,
              imageUrl: "https://via.placeholder.com/300", // Dummy image
              downloadUrl: downloadUrl,
            ),
          ),
        );

        emit(UpdateAvailable(
          title: title,
          description: description,
          updateType: "force",
          downloadUrl: downloadUrl,
        ));
      } else {
        emit(NoUpdateRequired());
      }
    } catch (e) {
      emit(NoUpdateRequired());
    }
  }

  /// Compares two semantic version strings (e.g., "1.2.3" > "1.0.0")
//   bool _isVersionGreater(String serverVersion, int currentVersion) {
//     List<int> serverParts =
//         serverVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
//     List<int> currentParts =
//         currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();

//     for (int i = 0; i < serverParts.length; i++) {
//       if (i >= currentParts.length || serverParts[i] > currentParts[i]) {
//         return true;
//       } else if (serverParts[i] < currentParts[i]) {
//         return false;
//       }
//     }

//     return false;
//   }
}
