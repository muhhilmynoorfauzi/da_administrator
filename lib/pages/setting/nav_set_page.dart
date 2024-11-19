import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/other/other_model.dart';
import 'package:da_administrator/pages/setting/jurusan_set_page.dart';
import 'package:da_administrator/pages/setting/mapel_set_page.dart';
import 'package:da_administrator/pages/setting/univ_set_page.dart';
import 'package:da_administrator/pages/setting/user_set_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/jurusan/jurusan_model.dart';
import '../../model/user_to/user_to_model.dart';

class NavSetPage extends StatefulWidget {
  const NavSetPage({super.key});

  @override
  State<NavSetPage> createState() => _NavSetPageState();
}

class _NavSetPageState extends State<NavSetPage> {
  // bool onLoading = false;
  bool onLoadingDetail = false;
  List<JurusanModel> allJurusan = [];
  List<String> idAllJurusan = [];

  List<UnivModel> allUniv = [];
  List<String> idAllUniv = [];

  List<OtherModel> allMapel = [];
  List<String> idAllMapel = [];

  List<UserToModel> allUserTo = [];
  List<String> idAllUserTo = [];

  List<String> listCollection = [
    'Universitas',
    'Jurusan',
    'Mata Pelajaran Terkait',
    // 'User Tryout',
  ];
  int idCollection = 0;

  var page = [];

  @override
  Widget build(BuildContext context) {
    if (allUniv.isNotEmpty && allJurusan.isNotEmpty && allMapel.isNotEmpty) {
      page = [
        UnivSetPage(allUniv: allUniv, idAllUniv: idAllUniv),
        JurusanSetPage(allJurusan: allJurusan, idAllJurusan: idAllJurusan, other: allMapel.first, idOther: idAllMapel.first),
        MapelSetPage(allOther: allMapel, idAllOther: idAllMapel),
        UserSetPage(allUserTo: allUserTo, idAllUserTo: idAllUserTo),
      ];
      if (lebar(context) <= 700) {
        return onMo(context);
      } else {
        return onDesk(context);
      }
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataJurusan();
    getDataUniv();
    getDataOther();
    // getDataUserTo();
    setState(() {});
  }

  void getDataJurusan() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('jurusan_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('namaJurusan', descending: false).get();

      allJurusan = querySnapshot.docs.map((doc) => JurusanModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllJurusan = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('salah getDataJurusan: $e');
    }
    setState(() {});
  }

  void getDataUniv() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('univ_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('namaUniv', descending: false).get();

      allUniv = querySnapshot.docs.map((doc) => UnivModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllUniv = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('salah getDataUniv: $e');
    }
    setState(() {});
  }

  void getDataOther() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('other_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allMapel = querySnapshot.docs.map((doc) => OtherModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllMapel = querySnapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('salah getDataOther: $e');
    }
    setState(() {});
  }

  void getDataUserTo() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('user_to_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('created', descending: false).get();

      allUserTo = querySnapshot.docs.map((doc) => UserToModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllUserTo = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {});
    } catch (e) {
      print('salah detail_mytryout : $e');
    }
  }

  Future<void> logout() async => await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Yakin ingin Logout?', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<CounterProvider>(context, listen: false);
                // provider.logout();
                Navigator.of(context).pop();
                onReload();
              },
              child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        ),
      );

  void onReload() {
    html.window.location.reload();
  }

  Future<void> onRefresh(BuildContext context) async {
    allJurusan = [];
    allUniv = [];
    allMapel = [];
    allUserTo = [];
    setState(() {});

    getDataJurusan();
    getDataUniv();
    getDataOther();
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {});
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: secondaryWhite,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.navigate_before_rounded, color: Colors.black)),
        centerTitle: true,
        title: Text('Pengaturan', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
        ],
      ),
      body: Container(
        width: lebar(context),
        color: secondaryWhite,
        child: ListView(
          children: List.generate(
            listCollection.length,
            (i) => Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: TextButton(
                onPressed: () async {
                  setState(() => onLoadingDetail = true);
                  idCollection = i;
                  setState(() => onLoadingDetail = false);
                  Navigator.push(context, SlideTransition1(page[idCollection]));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(listCollection[i], style: TextStyle(fontSize: h4, color: Colors.black)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.navigate_next_rounded, color: Colors.black)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 40,
        width: lebar(context),
        margin: const EdgeInsets.all(10),
        color: secondaryWhite,
        child: OutlinedButton(
          onPressed: () => logout(),
          child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4)),
        ),
      ),
    );
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Row(
          children: [
            Container(
              width: 300,
              color: secondaryWhite,
              child: Column(
                children: [
                  Container(
                    width: lebar(context),
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.navigate_before_rounded, color: Colors.black)),
                        Text('Pengaturan', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                        IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: List.generate(
                        listCollection.length,
                        (i) => Container(
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: TextButton(
                            onPressed: () async {
                              setState(() => onLoadingDetail = true);
                              idCollection = i;
                              await Future.delayed(const Duration(milliseconds: 200));
                              setState(() => onLoadingDetail = false);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: (idCollection == i) ? primary : Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(listCollection[i], style: TextStyle(fontSize: h4, color: (idCollection == i) ? Colors.white : Colors.black)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: lebar(context),
                    margin: const EdgeInsets.all(10),
                    child: OutlinedButton(onPressed: () => logout(), child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4))),
                  ),
                ],
              ),
            ),
            Expanded(
              child: (!onLoadingDetail) ? page[idCollection] : Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
            ),
          ],
        ),
      ),
    );
  }
}
