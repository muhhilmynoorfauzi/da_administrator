import 'package:da_administrator/pages/home_page.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => CounterProvider())], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DA Administrator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            if (user!.email == 'kikiamaliaaa725@gmail.com') {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else if (snapshot.hasError) {
            return const Text('Error');
          } else {
            // return const HomePage();
            // return const DetailClaimed();
            return const HomeUserPage();
            // return const LoginPage();
          }
        },
      ),
    );
  }
}
