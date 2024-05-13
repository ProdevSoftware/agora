part of 'video_bloc.dart';

@freezed
class VideoState with _$VideoState {
  const factory VideoState({
    required bool muted,
    required bool muteVideo,
    required bool backCamera,
    required bool isSomeOneJoinedCall,
    required bool isInitialize,
    required Color networkQualityBarColor,
    required List<int> users,
    required RtcEngine? rtcEngine,
    required RtcEngineEventHandler? rtcEngineEventHandler,
    required VideoViewControllerBase? controllerBase,
  }) = _VideoState;

  factory VideoState.initial() => const VideoState(
        muted: false,
        muteVideo: false,
        backCamera: false,
        isSomeOneJoinedCall: false,
        isInitialize: false,
        networkQualityBarColor: Colors.green,
        users: [],
        rtcEngine: null,
        controllerBase: null,
        rtcEngineEventHandler: null,
      );
}
