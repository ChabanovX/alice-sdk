part of 'profile_bloc.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

class LoadProfileUserEvent extends ProfileEvent {
  const LoadProfileUserEvent();
}
