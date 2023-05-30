import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:open_ai/constant/colors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:open_ai/providers/auth_provider.dart';
import 'package:open_ai/responsive/responsive_layout.dart';
import 'package:open_ai/screens/web_screen/web_chat_screen.dart';
import 'package:open_ai/widgets/auth_button.dart';
import 'package:open_ai/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../widgets/bg_animation.dart';
import 'mobile_chat_screen.dart';

class MobileWelcomeScreen extends StatefulWidget {
  const MobileWelcomeScreen({super.key});

  @override
  State<MobileWelcomeScreen> createState() => _MobileWelcomeScreenState();
}

class _MobileWelcomeScreenState extends State<MobileWelcomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoggedIn = false;
  bool visibleContainer = true;
  bool showStartButton = false;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: linearScaffoldBg,
          )),
          child: BgAnimation(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.bottomCenter,
                          colors: [
                        Colors.transparent.withOpacity(.10),
                        Colors.transparent.withOpacity(.90)
                      ])),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/ai-2.json',
                        height: size.height * 0.50),
                    SizedBox(
                      height: size.height * 0.08,
                    ),
                    isLoggedIn
                        ? welcomeUser(authProvider, context, size)
                        : welcomeNote(context, size, authProvider),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column welcomeUser(
      AuthProvider authProvider, BuildContext context, Size size) {
    bool loading = false;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 5),
          alignment: Alignment.topLeft,
          child: FadeInLeft(
            delay: const Duration(milliseconds: 1000),
            child: AnimatedTextKit(
                isRepeatingAnimation: false,
                onFinished: () {
                  setState(() {
                    showStartButton = true;
                  });
                },
                animatedTexts: [
                  TypewriterAnimatedText(
                    "Hello ${authProvider.getCurrentUser!.displayName!.toUpperCase()} , I'm A-Eye,Your\npersonal AI companion.\n\nYou can talk to me about\nanything you want.",
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ]),
          ),
        ),
        if (showStartButton) ...[
          SizedBox(
            height: size.height * 0.03,
          ),
          FadeInUp(
            child: KAuthButton(
                child: Text(
                  'Start',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: whiteColor, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                  await authProvider.setSignInStatus(true).then((_) {
                    setState(() {
                      loading = false;
                    });
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResponsiveLayout(
                            mobileScreen: MobileChatScreen(),
                            webScreen: WebChatScreen(),
                          ),
                        ),
                        (route) => false);
                  });
                }),
          ),
          SizedBox(
            height: size.height * 0.10,
          ),
        ]
      ],
    );
  }

  Visibility welcomeNote(
      BuildContext context, Size size, AuthProvider authProvider) {
    return Visibility(
      visible: visibleContainer,
      child: Expanded(
        child: Column(
          children: [
            FadeIn(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 1000),
              child: Text(
                'How may I help\n you today?',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .displaySmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            FadeIn(
              delay: const Duration(milliseconds: 1200),
              duration: const Duration(milliseconds: 1800),
              child: Text(
                'Using this software,you can ask your\nquestion and recieve articles using\nartificial intelligence assistant',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white, letterSpacing: 1),
              ),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            FadeIn(
              delay: const Duration(milliseconds: 2100),
              duration: const Duration(milliseconds: 2300),
              child: KAuthButton(
                child: isLoading
                    ? const Loader(
                        color: whiteColor,
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 25,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            'Sign in with google',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                    color: whiteColor,
                                    fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                onTap: () => _tryToSignIn(authProvider),
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  _tryToSignIn(AuthProvider authProvider) async {
    setState(() {
      isLoading = true;
    });
    await authProvider.signInWithGoogle().then((userCredential) {
      log(userCredential.toString());
    }).catchError((error) {
      log(error.toString());
    });

    setState(() {
      isLoading = false;

      visibleContainer = false;
    });
    Future.delayed(
      const Duration(
        milliseconds: 200,
      ),
      () {
        setState(() {
          isLoggedIn = true;
        });
      },
    );
  }
}
