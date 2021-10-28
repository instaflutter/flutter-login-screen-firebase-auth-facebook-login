part of 'welcome_bloc.dart';

enum WelcomePressTarget { login, signup }


class WelcomeInitial {
  WelcomePressTarget? pressTarget;

  WelcomeInitial({this.pressTarget});
}
