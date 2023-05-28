import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
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
                            isPlaying = !isPlaying;
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

    /*  
    return Column(
      children: [
        Container(
          color: isBot ? bgSecondary : bgPrimary,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  isBot ? aiImage : personImage,
                  height: 25,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: AnimatedTextKit(
                        isRepeatingAnimation: false,
                        displayFullTextOnTap: true,
                        repeatForever: false,
                        totalRepeatCount: 1,
                        animatedTexts: [
                      TyperAnimatedText(
                        message,
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ])),
                isBot
                    ? Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.volume_off_rounded,
                              color: bgIconColor,
                            )),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ],
    );

    */
  }
}
