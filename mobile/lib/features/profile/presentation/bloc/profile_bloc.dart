import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../domain/entities/profile_user.dart';
import '../../domain/repository/profile_repository.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(super.initialState) {
    on<LoadProfileUserEvent>(_onProfileUserEvent);
  }

  Future<void> _onProfileUserEvent(
    LoadProfileUserEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final user = await ProfileRepository().getUser();
    emit(ProfileUserState(user: user));
  }
}
