import 'package:agora/Helpers/text_styles.dart';
import 'package:agora/video_call_screen/view/video_call_page.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class JoinRoomDialog extends StatelessWidget {
  final TextEditingController roomTxtController = TextEditingController();

  JoinRoomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: const Text("Join Room"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/room_join_vector.png',
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: roomTxtController,
            decoration: const InputDecoration(
                hintText: "Enter room id to join",
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF1A1E78), width: 2)),
                enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color(0xFF1A1E78), width: 2))),
            style: regularTxtStyle.copyWith(
                color: const Color(0xFF1A1E78), fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A1E78),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () async {
              if (roomTxtController.text.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VideoCallScreen(
                      channelName: ClientRoleType.clientRoleAudience,
                    ),
                  ),
                );
              } else {}
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_forward, color: Colors.white),
                const SizedBox(
                  width: 4,
                ),
                Text(
                  "Join Room",
                  style: regularTxtStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
