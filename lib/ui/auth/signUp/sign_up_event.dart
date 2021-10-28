part of 'sign_up_bloc.dart';

abstract class SignUpEvent {}

class RetrieveLostDataEvent extends SignUpEvent {}

class ChooseImageFromGalleryEvent extends SignUpEvent {
  ChooseImageFromGalleryEvent();
}

class CaptureImageByCameraEvent extends SignUpEvent {
  CaptureImageByCameraEvent();
}

class ValidateFieldsEvent extends SignUpEvent {
  GlobalKey<FormState> key;
  bool acceptEula;

  ValidateFieldsEvent(this.key, {required this.acceptEula});
}

class ToggleEulaCheckboxEvent extends SignUpEvent {
  bool eulaAccepted;

  ToggleEulaCheckboxEvent({required this.eulaAccepted});
}
