import 'package:da_administrator/pages/example.dart';
import 'package:da_administrator/pages/home_page.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages_user/about_user_page.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/detail_tryout_user_page.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/pages_user/pay_coin_user_page.dart';
import 'package:da_administrator/pages_user/pay_done_user_page.dart';
import 'package:da_administrator/pages_user/pay_ewallet_user_page.dart';
import 'package:da_administrator/pages_user/pay_free_user_page.dart';
import 'package:da_administrator/pages_user/profile/nav_profile_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/quest_pg_user_page.dart';
import 'package:da_administrator/pages_user/question/result_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/waiting_user_page.dart';
import 'package:da_administrator/pages_user/tryout_saya_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User? currentUser;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((User? user) => setState(() => currentUser = user));
  }

  void _checkCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() => currentUser = user);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '${context.watch<CounterProvider>().getTitleUserPage}',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        Uri uri = Uri.parse(settings.name!);

        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'tryout') {
          String codeRoom = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
          if (codeRoom == '' || codeRoom == ' ') {
            return MaterialPageRoute(
              builder: (context) => const HomeUserPage(),
            );
          } else {
            return MaterialPageRoute(
              builder: (context) => DetailTryoutUserPage(docId: codeRoom),
            );
          }
        }

        return MaterialPageRoute(
          builder: (context) {
            if (currentUser != null) {
              if (currentUser!.email == 'kikiamaliaaa725@gmail.com') {
                return const HomePage();
              } else {
                return const HomeUserPage();
              }
            } else {
              // return const HomePage();
              // return const ResultQuestUserPage();
              // return const HomeUserPage();
              // return const NavProfileUserPage();
              // return const AboutUserPage();
              // return const NavQuestUserPage(minutes: 30);
              // return const WaitingUserPage(minutes: 1);
              // return const DetailMytryoutUserPage();
              // return const DetailTryoutUserPage();
              // return const TryoutUserPage(idPage: 0);
              // return const HomePage();
              // return const PayDoneUserPage();
              // return const PayFreeUserPage();
              // return const PayCoinUserPage();
              // return const PayEwalletUserPage();
              return const LoginPage();
              // return const AutoScrollListView();
            }
          },
        );

        /*return MaterialPageRoute(
          builder: (context) => StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final user = FirebaseAuth.instance.currentUser;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(body: Center(child: CircularProgressIndicator(color: primary)));
              } else if (snapshot.hasData) {
                if (user!.email == 'kikiamaliaaa725@gmail.com') {
                  page = const HomePage();
                } else {
                  page = const HomeUserPage();
                }
              } else if (snapshot.hasError) {
                page = Scaffold(body: Center(child: Text('Error', style: TextStyle(color: Colors.black, fontSize: h2))));
              } else {
                // page = const HomePage();
                // page = const ResultQuestUserPage();
                // page = const HomeUserPage();
                // page = const NavProfileUserPage();
                // page = const AboutUserPage();
                // page = const NavQuestUserPage(minutes: 30);
                // page = const WaitingUserPage(minutes: 1);
                // page = const DetailMytryoutUserPage();
                // page = const DetailTryoutUserPage();
                // page = const TryoutUserPage();
                // page = const PayDoneUserPage();
                // page = const PayFreeUserPage();
                // page = const PayCoinUserPage();
                // page = const PayEwalletUserPage();
                // page = const LoginPage();
                // page = const AutoScrollListView();
              }
              return page;
            },
          ),
        );*/
      },
    );
  }
}
