import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/pages/detail_claimed.dart';
import 'package:da_administrator/example.dart';
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
  User? currentUser;
  String userUid = 'z';
  ProfileUserModel? profile;

  @override
  void initState() {
    super.initState();

    final profider = Provider.of<CounterProvider>(context, listen: false);

    checkCurrentUser();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      currentUser = user;
      profider.setCurrentUser(user);
      profider.setProfile(profile);
      profider.setReload();
      if (currentUser != null) {
        getDataProfile();
      }
      setState(() {});
    });
  }

  void checkCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() => currentUser = user);
  }

  Future<void> getDataProfile() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('profile_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      List<ProfileUserModel> allProfile = querySnapshot.docs.map((doc) => ProfileUserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      bool userFound = false;
      // List<String> idAllProfile = querySnapshot.docs.map((doc) => doc.id).toList();

      for (int i = 0; i < allProfile.length; i++) {
        if (allProfile[i].userUID == currentUser!.uid) {
          profile = allProfile[i];
          userFound = true;
          setState(() {});
          return;
        }
      }
      if (!userFound) {
        await ProfileUserService.add(
          ProfileUserModel(
            userUID: userUid,
            imageProfile: '',
            userName: 'Muh Hilmy Noor Fauzi',
            uniqueUserName: 'muhhilmynoorfauzi',
            asalSekolah: 'MAN',
            listPlan: [
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
            ],
            email: 'fauzizaelano@gmail.com',
            role: 'user',
            koin: 0,
            kontak: '082195012789',
            motivasi: '-',
            tempatTinggal: 'Makassar',
            created: DateTime.now(),
            update: DateTime.now(),
          ),
        );
        getDataProfile();
      }
    } catch (e) {
      print('salah getDataProfile: $e');
    }
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
          if (codeRoom.isNotEmpty || codeRoom != ' ') {
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
              // return const Example();
              // return const HomePage();
              return const HomeUserPage();
              // return const TryoutUserPage(idPage: 0);
              // return const NavProfileUserPage(idPage: 1);
              // return const LoginPage();
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
