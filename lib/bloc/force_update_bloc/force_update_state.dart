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

class NoUpdateRequired extends UpdateState {}
