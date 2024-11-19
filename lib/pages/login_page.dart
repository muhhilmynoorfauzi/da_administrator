import 'dart:html' as html;
import 'package:da_administrator/pages/home_page.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var googleLogo = 'https://firebasestorage.googleapis.com/v0/b/dreamacademy-example.appspot.com/o/assets%2Fgoogle.png?alt=media&token=0ea77249-b001-45f3-ad47-c3629b7ef504';
  var vector =
      'https://firebasestorage.googleapis.com/v0/b/dreamacademy-example.appspot.com/o/assets%2F_6a02f6ef-b2ca-4ebb-a45f-dfc8c9e7611f.jpeg?alt=media&token=ac8b5fd9-e6b8-45f6-bd38-e2d033c46f07';
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return loginDesk(context);
  }

  void onReload() {
    html.window.location.reload();
  }

  Widget loginDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        leading: SvgPicture.asset('assets/logo1.svg', fit: BoxFit.fitWidth),
        leadingWidth: 150,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: tinggi(context),
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset('assets/bg.svg', fit: BoxFit.fitWidth, width: lebar(context)),
          ),
          SizedBox(
            height: lebar(context) <= 400 ? lebar(context) + 250 : 550,
            width: 380,
            child: cardLogin(context),
          ),
        ],
      ),
    );
  }

  Widget cardLogin(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
            child: AspectRatio(aspectRatio: 1, child: Image.network(vector, fit: BoxFit.cover)),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Login with Google', style: TextStyle(color: Colors.black, fontSize: h2, fontWeight: FontWeight.bold)),
          ),
          Container(
            height: 40,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 30),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                onPressed: () async {
                  setState(() => isLoading = !isLoading);
                  try {
                    final provider = Provider.of<CounterProvider>(context, listen: false);
                    await provider.googleLogin();

                    setState(() => isLoading = !isLoading);
                    FirebaseAuth.instance.authStateChanges().listen((User? user) {
                      if (user != null) {
                        if (user.email == 'kikiamaliaaa725@gmail.com') {
                          Navigator.pushAndRemoveUntil(context, FadeRoute1(const HomePage()), (Route<dynamic> route) => false);
                        } else {
                          Navigator.pushAndRemoveUntil(context, FadeRoute1(const HomeUserPage()), (Route<dynamic> route) => false);
                        }
                      }
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: (isLoading)
                    ? Center(child: Padding(padding: const EdgeInsets.all(5), child: AspectRatio(aspectRatio: 1, child: CircularProgressIndicator(color: primary, strokeWidth: 3))))
                    : Stack(
                        alignment: Alignment.centerLeft,
                        children: [
                          SizedBox(height: 25, child: Image.network(googleLogo)),
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: Text('Google', style: TextStyle(color: Colors.black, fontSize: h4)),
                          ),
                        ],
                      )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By clicking continue, you agree to our ',
                style: TextStyle(color: Colors.black, fontSize: h4 - 2, fontWeight: FontWeight.normal),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4 - 2),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(color: Colors.black, fontSize: h4 - 2, fontWeight: FontWeight.normal),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4 - 2),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                ],
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}
