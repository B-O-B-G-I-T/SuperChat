part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {

}

final class SettingLoaded extends SettingState {
  final UserModel user;
  const SettingLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

final class SettingUpdate extends SettingState {
  final String displayName;
  final String bio;
  const SettingUpdate({required this.displayName, required this.bio});

  @override
  List<Object> get props => [displayName, bio];
}

final class SettingDelete extends SettingState {

}
