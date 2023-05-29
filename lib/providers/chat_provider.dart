import 'package:flutter/material.dart';
import 'package:open_ai/models/message_model.dart';

import '../services/api_services.dart';

class ChatProvider with ChangeNotifier {
  List<MessageModel> chatList = [];

  List<MessageModel> get getChatList => [...chatList];

  void addUserMessage({required String message}) {
    final msg = MessageModel(
        message: message,
        chatIndex: 0,
        createAt: DateTime.now().toIso8601String());
    chatList.add(msg);
    notifyListeners();
  }

  Future<void> sendMessageToApi(
      {required String msg,
      required String chatModeld,
      required BuildContext context}) async {
    chatList.addAll(
      await ApiServices.sendMessage(
          message: msg, modelId: chatModeld, ctx: context),
    );
    notifyListeners();
  }
}
