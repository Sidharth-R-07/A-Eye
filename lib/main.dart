import 'package:flutter/material.dart';
import 'package:open_ai/constant/colors.dart';
import 'package:open_ai/providers/auth_provider.dart';
import 'package:open_ai/providers/chat_provider.dart';
import 'package:open_ai/providers/models_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/db_provider.dart';
import 'screens/mobile_screen/mobile_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModelsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DbProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Open AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // colorScheme: ColorScheme.fromSeed(seedColor: bgSecondary),
          appBarTheme: const AppBarTheme(backgroundColor: bgPrimary),
          scaffoldBackgroundColor: bgSecondary,
          iconTheme: const IconThemeData(color: bgIconColor),
          fontFamily: 'Cera-pro',
          useMaterial3: true,
        ),
        home: const MobileSplashScreen(),
      ),
    );
  }
}
