import 'dart:async';

import 'package:agora/Helpers/utils.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_event.dart';

part 'video_state.dart';

part 'video_bloc.freezed.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  VideoBloc() : super(VideoState.initial()) {
    on<_OnInitRtc>(_onInitRtc);
    on<_OnSwitchCamera>(_onSwitchCamera);
    on<_OnToggleMuteVideo>(_onToggleMuteVideo);
    on<_OnToggleMuteAudio>(_onToggleMuteAudio);
    on<_OnCallEnd>(_onCallEnd);
    on<_OnDestroy>(_onDestroy);
    on<_OnAddUser>(_onAddUser);
  }

  Future<void> _onInitRtc(_OnInitRtc event, Emitter<VideoState> emit) async {
    final rtcEngine = createAgoraRtcEngine();
    emit(state.copyWith(rtcEngine: rtcEngine));

    await rtcEngine.initialize(const RtcEngineContext(
      appId: '95d70b0c3e2b4a9ab3098bc2143bc278',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    rtcEngine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint(
              "local user: ${connection.localUid} onJoinChannel: ${connection.channelId}");
        },
        onUserJoined:
            (RtcConnection connection, int remoteUid, int elapsed) async {
          debugPrint("remote user $remoteUid joined");
          var users = state.users.toList();
          users.add(remoteUid);
          add(VideoEvent.onAddUser(users));
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) async {
          debugPrint("userOffline :: $remoteUid ");
          List<int> users = List.from(state.users); // Create a copy of the list
          users.remove(remoteUid); // Modify the copy
          add(VideoEvent.onAddUser(users));
        },
        // Other event handlers...
      ),
    );

    await rtcEngine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await rtcEngine.enableVideo();
    await rtcEngine.startPreview();
    await rtcEngine.joinChannel(
      token:
          '007eJxTYGgsnuUxZ9YZpXNyV3suHL8v/un+8+VcbEf+7jeZ6tP9abKuAoOlaYq5QZJBsnGqUZJJomVikrGBpUVSspGhiTGQNLdInu6Y1hDIyDD9DR8DIxSC+AIMBUX5Kallien5RYllyYk5OQwMAM81JqA=',
      channelId: 'prodevagoravcall',
      uid: 0,
      options: const ChannelMediaOptions(),
    );
    final newState = state.copyWith(rtcEngine: rtcEngine);
    emit(newState);
  }

  Future<FutureOr<void>> _onSwitchCamera(
      _OnSwitchCamera event, Emitter<VideoState> emit) async {
    await state.rtcEngine!.switchCamera();
    emit(state.copyWith(
      rtcEngine: state.rtcEngine,
    ));
  }

  Future<FutureOr<void>> _onToggleMuteVideo(
      _OnToggleMuteVideo event, Emitter<VideoState> emit) async {
    await state.rtcEngine!.muteLocalVideoStream(!state.muteVideo);
    emit(state.copyWith(
      muteVideo: state.muteVideo ? false : true,
      rtcEngine: state.rtcEngine,
    ));
  }

  Future<FutureOr<void>> _onToggleMuteAudio(
      _OnToggleMuteAudio event, Emitter<VideoState> emit) async {
    await state.rtcEngine!.muteLocalAudioStream(!state.muted);
    emit(state.copyWith(
      muted: state.muted ? false : true,
      rtcEngine: state.rtcEngine,
    ));
  }

  Future<void> _onCallEnd(_OnCallEnd event, Emitter<VideoState> emit) async {
    RtcEngine? data = state.rtcEngine;
    data!.leaveChannel();
    data.release();
    emit(state.copyWith(rtcEngine: data, users: []));
  }

  Future<void> _onDestroy(_OnDestroy event, Emitter<VideoState> emit) async {
    RtcEngine? data = state.rtcEngine;
    data!.leaveChannel();
    data.release();
    emit(state.copyWith(rtcEngine: data, users: []));
  }

  @override
  Future<void> close() {
    // dispose
    add(const VideoEvent.onDestroy());
    return super.close();
  }

  int getNetworkQuality(int txQuality) {
    switch (txQuality) {
      case 0:
        return 2;

      case 1:
        return 4;

      case 2:
        return 3;

      case 3:
        return 2;

      case 4:
        return 1;

      default:
        return 0;
    }
  }

  Color getNetworkQualityBarColor(int txQuality) {
    switch (txQuality) {
      case 0:
        return Colors.green;

      case 1:
        return Colors.green;

      case 2:
        return Colors.yellow;

      case 3:
        return Colors.redAccent;

      case 4:
        return Colors.red;

      default:
        return Colors.red;
    }
  }

  Future<void> _onAddUser(_OnAddUser event, Emitter<VideoState> emit) async {
    emit(state.copyWith(users: event.dat));
  }
}
