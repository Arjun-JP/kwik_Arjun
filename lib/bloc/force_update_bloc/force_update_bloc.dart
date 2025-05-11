// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:kwik/bloc/force_update_bloc/force_update_event.dart';
// import 'package:kwik/bloc/force_update_bloc/force_update_state.dart';
// import 'package:package_info_plus/package_info_plus.dart';



// class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
//   UpdateBloc() : super(UpdateInitial()) {
//     on<CheckForUpdate>(_onCheckForUpdate);

//     on<FetchPoolCountEvent>(_onFetchPoolCountEvent);
//     on<IncrementStoryCountEvent>(_onIncrementStoryCount);
//     on<ResetStoryCountIfNewDayEvent>(_onResetStoryCountIfNewDay);

  

//   Future<void> _onCheckForUpdate(
//       CheckForUpdate event, Emitter<UpdateState> emit) async {
//     final info = await PackageInfo.fromPlatform();
//     final currentVersion = info.version;

//     // final doc = await FirebaseFirestore.instance
//     //     .collection('app_version')
//     //     .doc('appversion')
//     //     .get();

//     final latestVersion = Platform.isAndroid
//         ? doc['latestVersionAndroid']
//         : doc['latestVersionIos'];

//     final updateType = doc['updateType'];
//     final title = doc['title'];
//     final description = doc['description'];
//     final downloadUrl =
//         Platform.isAndroid ? doc['playstoreUrl'] : doc['appstoreUrl'];
//     print('gggg$downloadUrl $latestVersion');
//     if (_isNewerVersion(latestVersion, currentVersion) &&
//         updateType != 'patch') {
//       emit(UpdateAvailable(
//         title: title,
//         description: description,
//         updateType: updateType,
//         downloadUrl: downloadUrl,
//       ));
//     } else {
//       emit(NoUpdateRequired());
//     }
//   }

//   bool _isNewerVersion(String latest, String current) {
//     final latestParts = latest.split('.').map(int.parse).toList();
//     final currentParts = current.split('.').map(int.parse).toList();
//     for (int i = 0; i < latestParts.length; i++) {
//       if (i >= currentParts.length || latestParts[i] > currentParts[i])
//         return true;
//       if (latestParts[i] < currentParts[i]) return false;
//     }
//     return false;
//   }

//   Future<void> _onFetchPoolCountEvent(
//       FetchPoolCountEvent event, Emitter<UpdateState> emit) async {
//     final firestore = FirebaseFirestore.instance;

//     final appVersionDoc =
//         await firestore.collection('app_version').doc('appversion').get();

//     final data = appVersionDoc.data();
//     final trialLimit = data?['Trial'] ?? 9999;
//     final freeLimit = data?['Free'] ?? 3;
//     final premiumLimit = data?['Premium'] ?? 10;
//     final ultraPremiumLimit = data?['UltraPremium'] ?? 50;
//     print(
//         'all linmits $trialLimit  $freeLimit $premiumLimit $ultraPremiumLimit');
//     final user = FirebaseAuth.instance.currentUser;
//     String userPool = 'Trial';
//     if (user != null) {
//       final userDoc = await firestore.collection('users').doc(user.uid).get();
//       userPool = userDoc.data()?['user_pool'] ?? 'Trial';
//     }

//     final prefs = await SharedPreferences.getInstance();
//     final createdToday = prefs.getInt('storiesCreatedToday') ?? 0;

//     final lastDateStr = prefs.getString('lastStoryCreatedDate');
//     final lastDate =
//         lastDateStr != null ? DateTime.parse(lastDateStr) : DateTime.now();

//     emit(UserPoolCount(
//       trialLimit: trialLimit,
//       freeLimit: freeLimit,
//       premiumLimit: premiumLimit,
//       ultraPremiumLimit: ultraPremiumLimit,
//       userPool: userPool,
//       storiesCreatedToday: createdToday,
//       lastStoryCreatedDate: lastDate,
//     ));
//   }

//   Future<void> _onIncrementStoryCount(
//       IncrementStoryCountEvent event, Emitter<UpdateState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final updatedCount = (state as UserPoolCount).storiesCreatedToday + 1;
//     await prefs.setInt('storiesCreatedToday', updatedCount);
//     await prefs.setString(
//         'lastStoryCreatedDate', DateTime.now().toIso8601String());
//     print('the counts$updatedCount');
//     emit((state as UserPoolCount).copyWith(
//       storiesCreatedToday: updatedCount,
//       lastStoryCreatedDate: DateTime.now(),
//     ));
//   }

//   Future<void> _onResetStoryCountIfNewDay(
//       ResetStoryCountIfNewDayEvent event, Emitter<UpdateState> emit) async {
//     final prefs = await SharedPreferences.getInstance();
//     final lastDateStr = prefs.getString('lastStoryCreatedDate');
//     print('lastdate$lastDateStr');
//     if (lastDateStr != null) {
//       final lastDate = DateTime.parse(lastDateStr);
//       if (!_isSameDate(lastDate, DateTime.now())) {
//         await prefs.setInt('storiesCreatedToday', 0);

//         await prefs.setString(
//             'lastStoryCreatedDate', DateTime.now().toIso8601String());
//         emit((state as UserPoolCount).copyWith(
//           storiesCreatedToday: 0,
//           lastStoryCreatedDate: DateTime.now(),
//         ));
//       }
//     }
//   }

//   bool _isSameDate(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }
