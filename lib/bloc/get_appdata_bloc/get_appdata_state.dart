// bloc/policy_state.dart
abstract class GetAppdataState {}

class Getappdatainitial extends GetAppdataState {}

class GetappdataLoading extends GetAppdataState {}

class GetappdataLoaded extends GetAppdataState {
  final Map<String, dynamic> content;
  GetappdataLoaded(this.content);
}

class GetappdataError extends GetAppdataState {
  final String message;
  GetappdataError(this.message);
}
