import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/pages/detail_claimed.dart';
import 'package:da_administrator/example.dart';
import 'package:da_administrator/pages/home_page.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages/setting/nav_set_page.dart';
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
import 'package:da_administrator/service/show_image_page.dart';
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
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() => currentUser = user);
      }
    });
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
        // Uri uri = Uri.parse(settings.name!);
/*
        TryoutModel? tryoutUser;
        List<QuestionsModel> allQuestion = [];
        List<String> idAllQuestion = [];

        void getDataTryOut(String docId) async {
          tryoutUser = null;
          try {
            DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('tryout_v03').doc(docId);
            DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
            if (docSnapshot.exists) {
              tryoutUser = TryoutModel.fromSnapshot(docSnapshot);
            }

            setState(() {});
          } catch (e) {
            print('salah detail_tryout_user_page getDataTryOut : $e');
          }
        }

        void getDataQuestion() async {
          allQuestion = [];
          idAllQuestion = [];
          try {
            CollectionReference collectionRef = FirebaseFirestore.instance.collection('subtest_v03');
            QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

            allQuestion = querySnapshot.docs.map((doc) => QuestionsModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
            idAllQuestion = querySnapshot.docs.map((doc) => doc.id).toList();

            setState(() {});
          } catch (e) {
            print('salah detail_tryout_user_page data quest: $e');
          }
        }

        if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'tryout') {
          String codeRoom = uri.pathSegments.length > 1 ? uri.pathSegments[1] : '';
          getDataTryOut(codeRoom);
          getDataQuestion();
          if (codeRoom.isNotEmpty || codeRoom != ' ') {
            if (tryoutUser != null) {
              return MaterialPageRoute(
                builder: (context) => DetailTryoutUserPage(idTryout: codeRoom, tryoutUser: tryoutUser!, allQuestion: allQuestion, idAllQuestion: idAllQuestion),
              );
            }
          }
        }*/
        return MaterialPageRoute(
          builder: (context) {
            if (currentUser != null) {
              if (currentUser!.email == 'kikiamaliaaa725@gmail.com') {
                return const HomePage();
              } else {
                return const HomeUserPage();
                // return const TryoutUserPage(idPage: 1);
              }
            } else {
              // return const Example();
              // return const NavSetPage();
              // return const NavProfileUserPage(idPage: 0);
              // return const TryoutUserPage(idPage: 1);
              return const HomeUserPage();
                // return const HomePage();
              // return const LoginPage();
            }
          },
        );
      },
    );
  }
}
