part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object> get props => [];
}

final class SettingInitialEvent extends SettingEvent {}

final class SettingLoadedEvent extends SettingEvent {}

final class SettingUpdateEvent extends SettingEvent {
  final String displayName;
  final String bio;

  const SettingUpdateEvent({required this.displayName, required this.bio});

  @override
  List<Object> get props => [displayName, bio];
}

final class SettingDeleteEvent extends SettingEvent {

}
