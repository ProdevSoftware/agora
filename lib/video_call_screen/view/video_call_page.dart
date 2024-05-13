import 'dart:async';
import 'package:agora/home/home_page.dart';
import 'package:agora/video_call_screen/bloc/video_bloc.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class VideoCallScreen extends StatefulWidget {
  final ClientRoleType channelName;

  VideoCallScreen({super.key, required this.channelName});

  @override
  VideoCallScreenState createState() => VideoCallScreenState();
}

class VideoCallScreenState extends State<VideoCallScreen> {
  // UserJoined Bool
  late VideoBloc bloc;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    print("\n============ ON DISPOSE ===============\n");
    super.dispose();
  }

  @override
  void initState() {
    debugPrint('widget.channelName   ${widget.channelName}');
    bloc = VideoBloc();
    bloc.add(VideoEvent.onInitRtc(widget.channelName, ''));
    super.initState();
  }

  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget buildJoinUserUI(VideoState state) {
    List<AgoraVideoView> views = [];
    views.add(AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: state.rtcEngine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    ));
    for (var uid in state.users) {
      views.add(AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: state.rtcEngine!,
          canvas: VideoCanvas(uid: uid),
          connection: const RtcConnection(channelId: 'prodevagoravcall'),
        ),
      ));
    }
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: <Widget>[
                      _expandedVideoRow([views[1]]),
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 8,
                            color: Colors.white38,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.fromLTRB(15, 40, 10, 15),
                        width: 110,
                        height: 140,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _expandedVideoRow([views[0]]),
                          ],
                        )))
              ],
            ));
      case 3:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        );
      default:
    }
    return Container();
  }

  void onCallEnd(BuildContext context) async {
    if (bloc.state.isSomeOneJoinedCall) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text("Note"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "No one has not joined this call yet,\nDo You want to close this room?"),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Yes"),
              onPressed: () {
                bloc.add(const VideoEvent.onCallEnd());
                Navigator.pop(context); // Close dialog
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ElevatedButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc,
      child: Scaffold(
        body: SafeArea(child: buildNormalVideoUI()),
        bottomNavigationBar:
            BlocBuilder<VideoBloc, VideoState>(builder: (context, state) {
          return ConvexAppBar(
            style: TabStyle.fixedCircle,
            backgroundColor: const Color(0xFF1A1E78),
            color: Colors.white,
            items: [
              TabItem(
                icon: state.muted ? Icons.mic_off_outlined : Icons.mic_outlined,
              ),
              const TabItem(
                icon: Icons.call_end_rounded,
              ),
              TabItem(
                icon: state.muteVideo
                    ? Icons.videocam_off_outlined
                    : Icons.videocam_outlined,
              ),
            ],
            initialActiveIndex: 2,
            //optional, default as 0
            onTap: (int i) {
              switch (i) {
                case 0:
                  bloc.add(const VideoEvent.onToggleMuteAudio());
                  break;
                case 1:
                  onCallEnd(context);
                  break;
                case 2:
                  bloc.add(const VideoEvent.onToggleMuteVideo());
                  break;
              }
            },
          );
        }),
      ),
    );
  }

  Widget buildNormalVideoUI() {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: <Widget>[
          BlocBuilder<VideoBloc, VideoState>(
            builder: (context, state) {
              if (state.rtcEngine != null) {
                return buildJoinUserUI(state);
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              margin: const EdgeInsets.only(left: 10, top: 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white38,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                    minimumSize: const Size(40, 50)),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 24.0,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: const EdgeInsets.only(right: 10, bottom: 4),
              child: RawMaterialButton(
                onPressed: () {
                  bloc.add(const VideoEvent.onSwitchCamera());
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                fillColor: Colors.white38,
                child: BlocBuilder<VideoBloc, VideoState>(
                    builder: (context, state) {
                  return Icon(
                    state.backCamera ? Icons.camera_rear : Icons.camera_front,
                    color: Colors.white,
                    size: 24.0,
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
