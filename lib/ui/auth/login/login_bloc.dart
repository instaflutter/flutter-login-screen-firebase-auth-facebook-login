import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<ValidateLoginFieldsEvent>((event, emit) {
      if (event.key.currentState?.validate() ?? false) {
        event.key.currentState!.save();
        emit(ValidLoginFields());
      } else {
        emit(LoginFailureState(errorMessage: 'Please fill required fields.'));
      }
    });
  }
}
