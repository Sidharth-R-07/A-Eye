import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_ai/constant/asset_images.dart';
import 'package:open_ai/constant/colors.dart';
import 'package:open_ai/models/message_model.dart';
import 'package:open_ai/providers/auth_provider.dart';
import 'package:open_ai/providers/chat_provider.dart';
import 'package:open_ai/providers/db_provider.dart';
import 'package:open_ai/providers/models_provider.dart';
import 'package:open_ai/widgets/loader.dart';
import 'package:open_ai/widgets/message_card.dart';
import 'package:open_ai/widgets/outline_button.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animate_do/animate_do.dart';

import 'mobile_welcome_screen.dart';

class MobileChatScreen extends StatefulWidget {
  const MobileChatScreen({super.key});

  @override
  State<MobileChatScreen> createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  bool _isLoading = false;

  final TextEditingController inputController = TextEditingController();
  late ScrollController _listScrollController;
  late FocusNode _focusNode;
  String inputText = '';

  String voiceText = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  SpeechToText speechToText = SpeechToText();

  void initSpeech() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      voiceText = result.recognizedWords;
    });

    log('PRINTING VOICE:$voiceText');
  }

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _listScrollController = ScrollController();
    initSpeech();
  }

  @override
  void dispose() {
    super.dispose();
    _listScrollController.dispose();
    inputController.dispose();
    speechToText.stop();

    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final modelProvider = Provider.of<ModelsProvider>(context);
    final chatProvider = Provider.of<ChatProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dbProvider = Provider.of<DbProvider>(context);
    dbProvider.getAllHistory();
    final size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: MobilechatScreenAppBar(context),
        drawer: openDrawer(
            authProvider: authProvider,
            chatProvider: chatProvider,
            dbProvider: dbProvider,
            size: size,
            modelProvider: modelProvider),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: chatProvider.chatList.isEmpty
                      ? FadeInLeft(
                          delay: const Duration(milliseconds: 100),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: MessageCard(
                                message:
                                    'Hello ${authProvider.getCurrentUser!.displayName!.toUpperCase()} ! How can i help you today?',
                                isBot: true),
                          ),
                        )
                      : ListView.builder(
                          controller: _listScrollController,
                          itemCount: chatProvider.getChatList.length,
                          itemBuilder: (context, index) {
                            final msg = chatProvider.getChatList[index];

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              child: MessageCard(
                                message: msg.message,
                                isBot: msg.chatIndex == 1 ? true : false,
                              ),
                            );
                          },
                        ),
                ),
              ),

              //if _isLoading true show Loader
              // if (_isLoading) const Loader(),

              FadeInUpBig(
                duration: const Duration(milliseconds: 1500),
                delay: const Duration(milliseconds: 500),
                child: Container(
                  decoration: const BoxDecoration(color: bgPrimary),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: inputController,
                          focusNode: _focusNode,
                          onChanged: (value) {
                            setState(() {
                              inputText = value;
                            });
                          },
                          onFieldSubmitted: (_) => _sendMessage(
                              chatProvider: chatProvider,
                              modelsProvider: modelProvider,
                              dbProvider: dbProvider),
                          style: const TextStyle(color: whiteColor),
                          decoration: const InputDecoration(
                              hintText: ' Hey..How can i help you?',
                              hintStyle: TextStyle(color: bgIconColor),
                              border: InputBorder.none),
                        ),
                      ),
                      _isLoading
                          ? const SizedBox.shrink()
                          : IconButton(
                              onPressed: () async {
                                if (await speechToText.hasPermission ||
                                    speechToText.isNotListening) {
                                  await startListening();
                                } else if (speechToText.isListening) {
                                  await stopListening();
                                } else {
                                  initSpeech();
                                }
                              },
                              icon: Icon(
                                speechToText.isListening
                                    ? Icons.pause
                                    : Icons.mic,
                                color: bgIconColor,
                              ),
                            ),
                      _isLoading
                          ? const Loader(
                              color: whiteColor,
                            )
                          : IconButton(
                              onPressed: () => _sendMessage(
                                chatProvider: chatProvider,
                                modelsProvider: modelProvider,
                                dbProvider: dbProvider,
                              ),
                              icon: const Icon(
                                Icons.send,
                                color: bgIconColor,
                              ),
                            ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Container openDrawer({
    required DbProvider dbProvider,
    required ChatProvider chatProvider,
    required ModelsProvider modelProvider,
    required AuthProvider authProvider,
    required Size size,
  }) {
    bool _loading = false;
    final currentUser = authProvider.getCurrentUser;

    return Container(
      width: size.width * 0.70,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: linearContainerBg,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DrawerHeader(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BounceInDown(
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: bgSecondary,
                          backgroundImage: NetworkImage(currentUser!.photoURL!),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: FadeInLeft(
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: bgIconColor,
                              size: 35,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  FadeInLeft(
                    child: Text(
                      currentUser.displayName!.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: whiteColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FadeInLeft(
                    child: FittedBox(
                      child: Text(
                        currentUser.email!,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: whiteColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              child: dbProvider.historyList.isEmpty
                  ? const Center(
                      child: Text(
                        'There is no history yet!',
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      addSemanticIndexes: true,
                      itemCount: dbProvider.historyList.length,
                      // reverse: true,
                      // shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final history = dbProvider.historyList[index];
                        return FadeInLeft(
                          delay: Duration(milliseconds: 600 * index),
                          child: ListTile(
                            title: Text(
                              history.message,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                  color: whiteColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: IconButton(
                                icon: const Icon(
                                  Icons.arrow_right_outlined,
                                  color: whiteColor,
                                ),
                                onPressed: () {
                                  _sendMessage(
                                      modelsProvider: modelProvider,
                                      chatProvider: chatProvider,
                                      dbProvider: dbProvider,
                                      fromHistory: true,
                                      historyMsg: history.message);

                                  Navigator.of(context).pop();
                                }),
                          ),
                        );
                      },
                    )),
          // const Spacer(),
          // if (dbProvider.historyList.isNotEmpty)

          dbProvider.historyList.isNotEmpty
              ? MyOutlineButton(
                  onTap: () {
                    dbProvider.clearAllHistory();
                  },
                  title: 'clear history')
              : const SizedBox.shrink(),
          ListTile(
            onTap: () async {
              setState(() {
                _loading = true;
              });
              try {
                await authProvider
                    .signOutUser()
                    .then((value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MobileWelcomeScreen(),
                        ),
                        (route) => false));
              } catch (err) {
                FToast().showToast(
                    child: Text(err.toString()), gravity: ToastGravity.BOTTOM);
              } finally {
                setState(() {
                  _loading = false;
                });
              }
            },
            title: const Text(
              'Sign Out',
              style: TextStyle(color: whiteColor),
            ),
            trailing: _loading == true
                ? const Loader()
                : const Icon(
                    Icons.logout_outlined,
                    color: bgIconColor,
                  ),
          )
        ],
      ),
    );
  }

  AppBar MobilechatScreenAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      centerTitle: false,
      title: Row(
        children: [
          SvgPicture.asset(
            aiSvgImage,
            height: 45,
            placeholderBuilder: (context) => const Loader(color: whiteColor),
          ),
          const SizedBox(
            width: 6,
          ),
          const Text(
            'A-Eye',
            style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                letterSpacing: .5),
          ),
        ],
      ),
    );
  }

  void listScrollToEnd() {
    _listScrollController.animateTo(
        _listScrollController.position.maxScrollExtent,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut);
  }

  Future<void> _sendMessage(
      {required ModelsProvider modelsProvider,
      required ChatProvider chatProvider,
      required DbProvider dbProvider,
      bool fromHistory = false,
      String historyMsg = ''}) async {
    //Send Message to APi
    String msg = inputController.text.trim();

    if (fromHistory || historyMsg.isNotEmpty) {
      msg = historyMsg;
    }

    if (msg.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;

      chatProvider.addUserMessage(message: msg);
      inputController.clear();
    });

    await chatProvider.sendMessageToApi(
        msg: msg, chatModeld: modelsProvider.getCurrentModel);

    _focusNode.unfocus();
    inputController.clear();

    listScrollToEnd();
    setState(() {
      _isLoading = false;
    });

    if (fromHistory == false) {
      try {
        await dbProvider.addToHistory(MessageModel(
            message: msg,
            chatIndex: 0,
            createAt: DateTime.now().toIso8601String()));
      } catch (err) {
        print('ERROR----------$err');
      }
    }

    msg = '';
  }
}
