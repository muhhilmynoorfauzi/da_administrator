import 'package:da_administrator/model/user_to/user_to_model.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class UserSetPage extends StatefulWidget {
  const UserSetPage({
    super.key,
    required this.allUserTo,
    required this.idAllUserTo,
  });

  final List<UserToModel> allUserTo;
  final List<String> idAllUserTo;

  @override
  State<UserSetPage> createState() => _UserSetPageState();
}

class _UserSetPageState extends State<UserSetPage> {
  @override
  Widget build(BuildContext context) {
    bool onMo = (lebar(context) <= 700);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leading: onMo ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.navigate_before_rounded, color: Colors.black)) : const SizedBox(),
        leadingWidth: onMo ? 50 : 0,
        title: Text('Data User Tryout', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
      ),
    );
  }
}
