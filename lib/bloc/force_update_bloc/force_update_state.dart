abstract class UpdateState {}

class UpdateInitial extends UpdateState {}

class UpdateAvailable extends UpdateState {
  final String title;
  final String description;
  final String updateType;
  final String downloadUrl;

  UpdateAvailable({
    required this.title,
    required this.description,
    required this.updateType,
    required this.downloadUrl,
  });
}

class UserPoolCount extends UpdateState {
  final int trialLimit;
  final int freeLimit;
  final int premiumLimit;
  final int ultraPremiumLimit;
  final String userPool;
  final int storiesCreatedToday;
  final DateTime lastStoryCreatedDate;

  UserPoolCount({
    required this.trialLimit,
    required this.freeLimit,
    required this.premiumLimit,
    required this.ultraPremiumLimit,
    required this.userPool,
    required this.storiesCreatedToday,
    required this.lastStoryCreatedDate,
  });

  UserPoolCount copyWith({
    int? trialLimit,
    int? freeLimit,
    int? premiumLimit,
    int? ultraPremiumLimit,
    String? userPool,
    int? storiesCreatedToday,
    DateTime? lastStoryCreatedDate,
  }) {
    return UserPoolCount(
      trialLimit: trialLimit ?? this.trialLimit,
      freeLimit: freeLimit ?? this.freeLimit,
      premiumLimit: premiumLimit ?? this.premiumLimit,
      ultraPremiumLimit: ultraPremiumLimit ?? this.ultraPremiumLimit,
      userPool: userPool ?? this.userPool,
      storiesCreatedToday: storiesCreatedToday ?? this.storiesCreatedToday,
      lastStoryCreatedDate: lastStoryCreatedDate ?? this.lastStoryCreatedDate,
    );
  }
}

class NoUpdateRequired extends UpdateState {}
