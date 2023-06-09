import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:open_ai/constant/colors.dart';

class MessageCard extends StatefulWidget {
  final String message;
  final bool isBot;
  const MessageCard({super.key, required this.message, required this.isBot});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  bool isPlaying = false;
  FlutterTts ftts = FlutterTts();

  void textToSpeak(String text) async {
    await ftts.setLanguage("en-US");
    await ftts.setSpeechRate(0.5); //speed of speech
    await ftts.setVolume(1.0); //volume of speech
    await ftts.setPitch(1); //pitc of sound

    //play text to sp
    var result = await ftts.speak(text);
    if (result == 1) {
      setState(() {
        isPlaying = true;
      });
      //speaking
    } else {
      setState(() {
        isPlaying = false;
      });
      //not speaking
    }
  }

  void stopSpeaking() async {
    await ftts.stop();
    setState(() {
      isPlaying = false;
    });
  }

  @override
  void dispose() {
    super.dispose();

    ftts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                widget.isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: widget.isBot ? bgPrimary : bgContainerUserColor,
                  borderRadius: BorderRadius.only(
                    topLeft:
                        widget.isBot ? Radius.zero : const Radius.circular(25),
                    bottomLeft: const Radius.circular(25),
                    bottomRight:
                        widget.isBot ? const Radius.circular(25) : Radius.zero,
                    topRight: const Radius.circular(25),
                  ),
                ),
                width: widget.message.length <= 25 ? null : size.width * 0.80,
                child: Stack(
                  children: [
                    SizedBox(
                      width: widget.message.length <= 25
                          ? null
                          : size.width * 0.70,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          displayFullTextOnTap: true,
                          repeatForever: false,
                          totalRepeatCount: 1,
                          animatedTexts: [
                            TyperAnimatedText(
                              widget.message,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (widget.isBot)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          onPressed: () {
                            if (!isPlaying) {
                              textToSpeak(widget.message);
                            } else {
                              stopSpeaking();
                            }
                          },
                          icon: isPlaying
                              ? const Icon(Icons.volume_up_outlined)
                              : const Icon(Icons.volume_off_outlined),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
