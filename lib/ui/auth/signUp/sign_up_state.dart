part of 'sign_up_bloc.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class PictureSelectedState extends SignUpState {
  Uint8List? imageData;

  PictureSelectedState({required this.imageData});
}

class SignUpFailureState extends SignUpState {
  String errorMessage;

  SignUpFailureState({required this.errorMessage});
}

class ValidFields extends SignUpState {}

class EulaToggleState extends SignUpState {
  bool eulaAccepted;

  EulaToggleState(this.eulaAccepted);
}
