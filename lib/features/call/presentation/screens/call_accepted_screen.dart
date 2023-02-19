import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/core/utilis/agora_config.dart';
import 'package:whatsapp_clone/features/call/data/model/call_model.dart';

class CallAcceptedScreen extends StatefulWidget {
  const CallAcceptedScreen(
      {super.key,
      required this.channelId,
      required this.isGroupChat,
      required this.callModel});
  final String channelId;
  final bool isGroupChat;
  final CallModel callModel;

  @override
  State<CallAcceptedScreen> createState() => _CallAcceptedScreenState();
}

class _CallAcceptedScreenState extends State<CallAcceptedScreen> {
  AgoraClient? agoraClient;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    agoraClient = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
            appId: AgoraConfig.appId, channelName: widget.channelId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
