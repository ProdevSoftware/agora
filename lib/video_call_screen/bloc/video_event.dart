part of 'video_bloc.dart';

@freezed
class VideoEvent with _$VideoEvent {
  const factory VideoEvent.onInitRtc(
      ClientRoleType roleType, String channelName) = _OnInitRtc;

  const factory VideoEvent.onUserJoined() = _OnUserJoined;

  const factory VideoEvent.onUserOffline() = _OnUserOffline;

  const factory VideoEvent.onError() = _OnError;

  const factory VideoEvent.onLeaveChannel() = _OnLeaveChannel;

  const factory VideoEvent.onSwitchCamera() = _OnSwitchCamera;

  const factory VideoEvent.onToggleMuteVideo() = _OnToggleMuteVideo;

  const factory VideoEvent.onToggleMuteAudio() = _OnToggleMuteAudio;

  const factory VideoEvent.onCallEnd() = _OnCallEnd;

  const factory VideoEvent.onDestroy() = _OnDestroy;

  const factory VideoEvent.onAddUser(List<int> dat) = _OnAddUser;
}
