import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/pages/login_page.dart';
import 'package:da_administrator/pages_user/about_user_page.dart';
import 'package:da_administrator/pages_user/bank_user_page.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/pages_user/profile/nav_profile_user_page.dart';
import 'package:da_administrator/pages_user/rekomendasi_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dart:html' as html;
import 'package:provider/provider.dart';

AppBar appbarDesk({
  required BuildContext context,
  bool homeActive = false,
  bool featureActive = false,
  bool aboutActive = false,
  double elevation = 1,
  VoidCallback? actionProfile,
}) {
  void onReload() {
    html.window.location.reload();
  }
  final user = FirebaseAuth.instance.currentUser;
  final profider = Provider.of<CounterProvider>(context, listen: false);
  bool isLogin = (user != null);
  final List<String> action = ['Bank Soal', 'TryOut', 'Rekomendasi Belajar'];
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.black,
    scrolledUnderElevation: elevation,
    leadingWidth: 200,
    toolbarHeight: 40,
    leading: InkWell(
      onTap: () => onReload(),
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: SvgPicture.asset('assets/logo1.svg'),
    ),
    actions: [
      SizedBox(
        width: 100,
        height: 40,
        child: TextButton(
          style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            profider.setTitleUserPage('Dream Academy - Home');
            Navigator.pushReplacement(context, FadeRoute1(const HomeUserPage()));
          },
          child: Text('Home', style: TextStyle(color: homeActive ? Colors.black : Colors.black.withOpacity(.3), fontSize: h4, fontWeight: FontWeight.bold)),
        ),
      ),
      SizedBox(
        width: 100,
        height: 40,
        child: DropdownButton(
          dropdownColor: Colors.white,
          focusColor: Colors.white,
          borderRadius: BorderRadius.circular(10),
          isExpanded: true,
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          hint: Text('Feature', style: TextStyle(color: featureActive ? Colors.black : Colors.black.withOpacity(.3), fontSize: h4, fontWeight: FontWeight.bold)),
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
            return DropdownMenuItem(value: option, child: Text(option, style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)));
          }).toList(),
        ),
      ),
      SizedBox(
        width: 100,
        height: 40,
        child: TextButton(
          style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            profider.setTitleUserPage('Dream Academy - About');
            Navigator.pushReplacement(context, FadeRoute1(const AboutUserPage()));
          },
          child: Text('About', style: TextStyle(color: aboutActive ? Colors.black : Colors.black.withOpacity(.3), fontSize: h4, fontWeight: FontWeight.bold)),
        ),
      ),
      const SizedBox(width: 30),
      isLogin
          ? InkWell(
              onTap: () async {
                if (actionProfile != null) {
                  actionProfile();
                }
                Navigator.push(context, FadeRoute1(const NavProfileUserPage()));
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 40,
                width: profider.getProfile == null ? 100 : 130,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.1), borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.money_dollar_circle_fill, color: Colors.orange),
                    Text((profider.getProfile == null) ? ' 0' : ' ${profider.getProfile!.koin}', style: TextStyle(color: Colors.black, fontSize: h4)),
                    const Expanded(child: SizedBox()),
                    const Icon(CupertinoIcons.person_crop_circle_fill, color: Colors.black),
                  ],
                ),
              ),
            )
          : Container(
              height: 50,
              // width: 200,
              margin: const EdgeInsets.all(3),
              // decoration: BoxDecoration(border: Border.all(color: primary, width: 2), borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                    ),
                    onPressed: () {
                      Navigator.push(context, FadeRoute1(const LoginPage()));
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: h4)),
                  ),
                ],
              ),
            ),
      const SizedBox(width: 10),
    ],
  );
}

AppBar appbarMo({
  required BuildContext context,
  double elevation = 1,
  VoidCallback? actionProfile,
}) {
  final user = FirebaseAuth.instance.currentUser;

  bool isLogin = (user != null);

  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    shadowColor: Colors.black,
    scrolledUnderElevation: elevation,
    leadingWidth: 0,
    leading: const SizedBox(),
    toolbarHeight: 40,
    title: SvgPicture.asset('assets/logo1.svg', width: 120),
    actions: [
      (isLogin)
          ? InkWell(
              onTap: () async {
                if (actionProfile != null) {
                  actionProfile();
                }
                Navigator.push(context, FadeRoute1(const NavProfileUserPage()));
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 40,
                width: 130,
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.black.withOpacity(.1), borderRadius: BorderRadius.circular(50)),
                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.money_dollar_circle_fill, color: Colors.orange),
                    Text('120', style: TextStyle(color: Colors.black, fontSize: h4)),
                    const Expanded(child: SizedBox()),
                    const Icon(CupertinoIcons.person_crop_circle_fill, color: Colors.black),
                  ],
                ),
              ),
            )
          : Container(
              height: 50,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(border: Border.all(color: primary, width: 2), borderRadius: BorderRadius.circular(100)),
              child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    ),
                    onPressed: () => Navigator.push(context, SlideTransition1(const LoginPage())),
                    child: Text('Login', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
      const SizedBox(width: 10),
    ],
  );
}
