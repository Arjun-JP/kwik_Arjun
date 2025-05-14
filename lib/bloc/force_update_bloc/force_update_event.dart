import 'package:flutter/material.dart';

abstract class UpdateEvent {}

class CheckForUpdate extends UpdateEvent {
  final BuildContext context;
  CheckForUpdate(this.context);
}
