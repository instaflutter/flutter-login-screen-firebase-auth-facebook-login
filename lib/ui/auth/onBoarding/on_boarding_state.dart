part of 'on_boarding_cubit.dart';

abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  int currentPageCount;

  OnBoardingInitial(this.currentPageCount);
}
