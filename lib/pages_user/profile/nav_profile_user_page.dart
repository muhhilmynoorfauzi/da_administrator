import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages/example.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/profile/detail_pribadi_user_page.dart';
import 'package:da_administrator/pages_user/profile/profile_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';

class NavProfileUserPage extends StatefulWidget {
  const NavProfileUserPage({super.key});

  @override
  State<NavProfileUserPage> createState() => _NavProfileUserPageState();
}

class _NavProfileUserPageState extends State<NavProfileUserPage> {
  int idPage = 0;
  var page = [const ProfileUserPage(), const DetailPribadiUserPage()];

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 200,
            height: tinggi(context),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  alignment: Alignment.center,
                  child: Container(
                    width: 1000,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          margin: const EdgeInsets.only(right: 10),
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                            child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                          ),
                        ),
                        Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () => setState(() => idPage = 0),
                    style: TextButton.styleFrom(backgroundColor: (idPage == 0) ? primary : secondaryWhite),
                    child: Text('Profile', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: (idPage == 0) ? Colors.white : Colors.black)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: double.infinity,
                  height: 40,
                  child: TextButton(
                    onPressed: () => setState(() => idPage = 1),
                    style: TextButton.styleFrom(backgroundColor: (idPage == 1) ? primary : secondaryWhite),
                    child: Text('Detail Pribadi', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: (idPage == 1) ? Colors.white : Colors.black)),
                  ),
                ),
                const Expanded(child: SizedBox()),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.logout, color: Colors.black, size: 20),
                    label: Text('Logout', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: Colors.black)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: page[idPage])
        ],
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
