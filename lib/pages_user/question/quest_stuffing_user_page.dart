import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class QuestStuffingUserPage extends StatefulWidget {
  const QuestStuffingUserPage({super.key});

  @override
  State<QuestStuffingUserPage> createState() => _QuestStuffingUserPageState();
}

class _QuestStuffingUserPageState extends State<QuestStuffingUserPage> {
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
