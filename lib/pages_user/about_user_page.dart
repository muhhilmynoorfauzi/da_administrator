import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AboutUserPage extends StatefulWidget {
  // final String id;

  const AboutUserPage({
    super.key,
    // required this.id,
  });

  @override
  State<AboutUserPage> createState() => _AboutUserPageState();
}

class _AboutUserPageState extends State<AboutUserPage> {
  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return aboutUserMobile(context);
    } else {
      return aboutUserDesk(context);
    }
  }

  Widget aboutUserDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, aboutActive: true, isLogin: true),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 100),
            alignment: Alignment.center,
            child: SizedBox(
              width: 700,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tentang',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 30),
                    ),
                    SvgPicture.asset('assets/logo2.svg', height: 200),
                    Text(
                      'Dream Academy',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1),
                    ),
                    Text(
                      '#Berproses&RaihBersama',
                      style: TextStyle(color: Colors.black, fontSize: h3, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Subheading for description or instructions',
                      style: TextStyle(color: Colors.black, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Body text for your whole article or post. We’ll put in some lorem ipsum to show how a filled-out page might look',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          //footer
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget aboutUserMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
