import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class TryoutSayaUserPage extends StatefulWidget {
  const TryoutSayaUserPage({super.key});

  @override
  State<TryoutSayaUserPage> createState() => _TryoutSayaUserPageState();
}

class _TryoutSayaUserPageState extends State<TryoutSayaUserPage> {
  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
