abstract class UpdateEvent {}

class CheckForUpdate extends UpdateEvent {}

class UserClickedUpdateNow extends UpdateEvent {}

class UserClickedUpdateLater extends UpdateEvent {}

//for user pool

class FetchPoolCountEvent extends UpdateEvent {}

class IncrementStoryCountEvent extends UpdateEvent {}

class ResetStoryCountIfNewDayEvent extends UpdateEvent {}
