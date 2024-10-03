import 'package:da_administrator/pages/home_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
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

    /*if (lebar(context) <= 700) {
      return loginMobile(context);
    } else if (lebar(context) >= 700 && lebar(context) <= 1200) {
      return loginTablet(context);
    } else {
      return loginDesk(context);
    }*/
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
            height: lebar(context) <= 400 ? lebar(context) + 250 : 600,
            width: 400,
            child: cardLogin(),
          ),
        ],
      ),
    );
  }

  Widget cardLogin() {
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
            child: AspectRatio(aspectRatio: 1, child: Image.network(vector)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
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
                  } catch (e) {
                    print(e);
                  }
                },
                child: (isLoading)
                    ? Center(
                        child: AspectRatio(
                        aspectRatio: 1,
                        child: CircularProgressIndicator(color: primary),
                      ))
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
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'By clicking continue, you agree to our ',
                style: TextStyle(color: Colors.black, fontSize: h4),
                children: [
                  TextSpan(
                    text: 'Terms of Service',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()..onTap = () {},
                  ),
                  TextSpan(
                    text: ' and ',
                    style: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
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
