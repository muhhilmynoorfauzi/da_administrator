import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class QuestPgUserPage extends StatefulWidget {
  const QuestPgUserPage({super.key});

  @override
  State<QuestPgUserPage> createState() => _QuestPgUserPageState();
}

class _QuestPgUserPageState extends State<QuestPgUserPage> {
  var isLogin = true;

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
      appBar: appbarDesk(context: context, featureActive: true, isLogin: isLogin),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
