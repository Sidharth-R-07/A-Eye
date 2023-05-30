import 'package:flutter/material.dart';
import 'package:open_ai/constant/asset_images.dart';
import 'package:open_ai/constant/colors.dart';
import 'package:open_ai/providers/db_provider.dart';
import 'package:open_ai/screens/mobile_screen/mobile_chat_screen.dart';
import 'package:open_ai/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/auth_provider.dart';
import 'mobile_welcome_screen.dart';

class MobileSplashScreen extends StatelessWidget {
  const MobileSplashScreen({super.key});

  checkLoginStatus(AuthProvider authProvider, BuildContext context) async {
    final status = await authProvider.getSignInStatus();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (status == null || status == false) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MobileWelcomeScreen(),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MobileChatScreen(),
        ));
      }
    });
  }

  initailizeDatabase(DbProvider dbProvider) async {
    dbProvider.openDb();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final dbProvider = Provider.of<DbProvider>(context, listen: false);

    final size = MediaQuery.of(context).size;
    initailizeDatabase(dbProvider);

    checkLoginStatus(authProvider, context);

    return SplashWidget(size: size);
  }
}

class SplashWidget extends StatelessWidget {
  const SplashWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSecondary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.50,
            child: Hero(
              tag: aiSvgImage,
              child: SvgPicture.asset(
                'assets/images/svg/ai-bot.svg',
                placeholderBuilder: (context) =>
                    const CircularProgressIndicator(
                  color: whiteColor,
                ),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const Loader(
            color: whiteColor,
          ),
        ],
      ),
    );
  }
}
