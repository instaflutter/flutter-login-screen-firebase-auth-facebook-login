import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    ImagePicker imagePicker = ImagePicker();

    on<RetrieveLostDataEvent>((event, emit) async {
      final LostDataResponse response = await imagePicker.retrieveLostData();
      if (response.file != null) {
        emit(PictureSelectedState(
            imageData: await response.file!.readAsBytes()));
      }
    });

    on<ChooseImageFromGalleryEvent>((event, emit) async {
      if (!kIsWeb &&
          (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
        FilePickerResult? result = await FilePicker.platform.pickFiles();
        if (result != null) {
          emit(PictureSelectedState(
              imageData: await File(result.files.single.path!).readAsBytes()));
        }
      } else {
        XFile? xImage =
            await imagePicker.pickImage(source: ImageSource.gallery);
        if (xImage != null) {
          emit(PictureSelectedState(imageData: await xImage.readAsBytes()));
        }
      }
    });

    on<CaptureImageByCameraEvent>((event, emit) async {
      XFile? xImage = await imagePicker.pickImage(source: ImageSource.camera);
      if (xImage != null) {
        emit(PictureSelectedState(imageData: await xImage.readAsBytes()));
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
