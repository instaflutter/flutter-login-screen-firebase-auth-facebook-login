import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    ImagePicker _imagePicker = ImagePicker();

    on<RetrieveLostDataEvent>((event, emit) async {
      final LostDataResponse? response = await _imagePicker.retrieveLostData();
      if (response != null && response.file != null) {
        emit(PictureSelectedState(imageFile: File(response.file!.path)));
      }
    });

    on<ChooseImageFromGalleryEvent>((event, emit) async {
      XFile? xImage = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (xImage != null) {
        emit(PictureSelectedState(imageFile: File(xImage.path)));
      }
    });

    on<CaptureImageByCameraEvent>((event, emit) async {
      XFile? xImage = await _imagePicker.pickImage(source: ImageSource.camera);
      if (xImage != null) {
        emit(PictureSelectedState(imageFile: File(xImage.path)));
      }
    });

    on<ValidateFieldsEvent>((event, emit) async {
      if (event.key.currentState?.validate() ?? false) {
        if (event.acceptEula) {
          event.key.currentState!.save();
          emit(ValidFields());
        } else {
          emit(SignUpFailureState(
              errorMessage: 'Please accept our terms of use.'));
        }
      } else {
        emit(SignUpFailureState(errorMessage: 'Please fill required fields.'));
      }
    });

    on<ToggleEulaCheckboxEvent>(
        (event, emit) => emit(EulaToggleState(event.eulaAccepted)));
  }
}
