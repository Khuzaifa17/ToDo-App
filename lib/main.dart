import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Custom/BottomNavigation.dart';
import 'package:flutter_application_1/Models/darkMode.dart';
import 'package:flutter_application_1/Splash_Screen.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DarkMode(),
          builder: (context, child) {
            final provider = Provider.of<DarkMode>(context);
            return MaterialApp(
              theme: provider.isValue ? ThemeData.dark() : ThemeData.light(),
              home: SafeArea(child: checkuser()),
            );
          },
        )
      ],
    );
  }
}

Widget checkuser() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return const BottomNaviScreen();
  } else {
    return const SpalshScreen();
  }
}
