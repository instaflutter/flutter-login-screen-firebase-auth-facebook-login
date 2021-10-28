part of 'welcome_bloc.dart';

@immutable
abstract class WelcomeEvent {}

class LoginPressed extends WelcomeEvent {}

class SignupPressed extends WelcomeEvent {}
