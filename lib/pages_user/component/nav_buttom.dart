import 'package:da_administrator/pages_user/about_user_page.dart';
import 'package:da_administrator/pages_user/bank_user_page.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/pages_user/rekomendasi_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget NavBottomMo({
  required BuildContext context,
  bool homeActive = false,
  bool featureActive = false,
  bool aboutActive = false,
  double elevation = 1,
  VoidCallback? actionProfile,
}) {
  final profider = Provider.of<CounterProvider>(context, listen: false);
  bool isLogin = (/*profider.getCurrentUser != null*/true);

  final List<String> action = ['Bank Soal', 'TryOut', 'Rekomendasi Belajar'];
  return Container(
    height: 60,
    width: lebar(context),
    color: secondaryWhite,
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 50,
            child: InkWell(
              onTap: () {
                profider.setTitleUserPage('Dream Academy - Home');
                Navigator.pushReplacement(context, FadeRoute1(const HomeUserPage()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_rounded, size: 20, color: homeActive ? Colors.black : Colors.black.withOpacity(.3)),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: homeActive ? Colors.black : Colors.black.withOpacity(.3),
                      fontSize: h4 - 2,
                      fontWeight: homeActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: DropdownButton(
              dropdownColor: Colors.white,
              focusColor: Colors.white,
              isExpanded: true,
              itemHeight: 60,
              alignment: Alignment.center,
              padding: EdgeInsets.zero,
              hint: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.playlist_add_circle_rounded,
                    size: 20,
                    color: featureActive ? Colors.black : Colors.black.withOpacity(.3),
                  ),
                  Text(
                    'Feature',
                    style: TextStyle(
                      color: featureActive ? Colors.black : Colors.black.withOpacity(.3),
                      fontSize: h4 - 2,
                      fontWeight: featureActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              onChanged: (String? newValue) {
                if (newValue == 'Bank Soal') {
                  profider.setTitleUserPage('Dream Academy - Bank Soal');
                  Navigator.pushReplacement(context, FadeRoute1(const BankUserPage()));
                } else if (newValue == 'TryOut') {
                  profider.setTitleUserPage('Dream Academy - TryOut Dream Academy');
                  Navigator.pushReplacement(context, FadeRoute1(const TryoutUserPage()));
                } else if (newValue == 'Rekomendasi Belajar') {
                  profider.setTitleUserPage('Dream Academy - Rekomendasi Belajar');
                  Navigator.pushReplacement(context, FadeRoute1(const RekomendasiUserPage()));
                }
              },
              icon: const SizedBox(),
              underline: const SizedBox(),
              items: action.map((String option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(option, style: TextStyle(color: Colors.black, fontSize: h4 - 2, fontWeight: FontWeight.normal)),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 50,
            child: InkWell(
              onTap: () {
                profider.setTitleUserPage('Dream Academy - About');
                Navigator.pushReplacement(context, FadeRoute1(const AboutUserPage()));
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info, size: 20, color: aboutActive ? Colors.black : Colors.black.withOpacity(.3)),
                  Text(
                    'About',
                    style: TextStyle(
                      color: aboutActive ? Colors.black : Colors.black.withOpacity(.3),
                      fontSize: h4 - 2,
                      fontWeight: aboutActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
