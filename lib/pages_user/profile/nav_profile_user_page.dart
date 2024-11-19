import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/example.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/profile/detail_pribadi_user_page.dart';
import 'package:da_administrator/pages_user/profile/profile_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';
import 'package:provider/provider.dart';

class NavProfileUserPage extends StatefulWidget {
  const NavProfileUserPage({super.key, this.idPage = 0});

  final int idPage;

  @override
  State<NavProfileUserPage> createState() => _NavProfileUserPageState();
}

class _NavProfileUserPageState extends State<NavProfileUserPage> {
  final user = FirebaseAuth.instance.currentUser;
  int idPage = 0;
  dynamic page = [];

  List<JurusanModel> allJurusan = [];
  List<String> univ = [];

  ProfileUserModel? profile;
  String? idProfile;

  @override
  Widget build(BuildContext context) {
    if (allJurusan.isNotEmpty && univ.isNotEmpty) {
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
    final user = FirebaseAuth.instance.currentUser;
    final profider = Provider.of<CounterProvider>(context, listen: false);
    idPage = widget.idPage;
    profile = profider.getProfile;
    idProfile = profider.getIdProfile;
    // TODO: implement initState
    super.initState();

    if (user != null) {
      getDataJurusan();
      getDataUniv();
      print('sudah didapat getDataUniv getDataJurusan');
    } else {
      print('Belum Login');
    }
    setState(() {});
  }

  void getDataJurusan() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('jurusan_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allJurusan = querySnapshot.docs.map((doc) => JurusanModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    } catch (e) {
      print('salah getDataJurusan: $e');
    }
    setState(() {});
  }

  void getDataUniv() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('univ_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      List<UnivModel> allUniv = querySnapshot.docs.map((doc) => UnivModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      for (int i = 0; i < allUniv.length; i++) {
        univ.add(allUniv[i].namaUniv);
      }
    } catch (e) {
      print('salah getDataUniv: $e');
    }
    setState(() {});
  }

  Future<void> getDataProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final profider = Provider.of<CounterProvider>(context, listen: false);

    if (user == null) {
      print('User belum login.');
      return;
    }

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('profile_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('userUID', isEqualTo: user.uid).get();

      if (querySnapshot.docs.isNotEmpty) {
        profile = ProfileUserModel.fromSnapshot(querySnapshot.docs.first as DocumentSnapshot<Map<String, dynamic>>);

        profider.setProfile(profile);
        profider.setIdProfile(querySnapshot.docs.first.id);
        print('Data dengan userUID tersebut ditemukan.');
      }
    } catch (e) {
      print('salah getDataProfile: $e');
    }
    setState(() {});
  }

  Future<void> onRefresh(BuildContext context) async {
    allJurusan = [];
    univ = [];
    setState(() {});

    getDataProfile();
    getDataJurusan();
    getDataUniv();
    print('sudah didapat getDataUniv getDataJurusan');

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {});
    //
  }

  Widget onDesk(BuildContext context) {
    if (allJurusan.isNotEmpty && univ.isNotEmpty) {
      page = [
        ProfileUserPage(profile: profile!, idProfile: idProfile!),
        DetailPribadiUserPage(profile: profile!, idProfile: idProfile!, allJurusan: allJurusan, namaUniv: univ),
      ];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Container(
            width: 300,
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
                        Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                        const Expanded(child: SizedBox()),
                        IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
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

  Widget onMo(BuildContext context) {
    if (allJurusan.isNotEmpty && univ.isNotEmpty) {
      page = [
        ProfileUserPage(profile: profile!, idProfile: idProfile!),
        DetailPribadiUserPage(profile: profile!, idProfile: idProfile!, allJurusan: allJurusan, namaUniv: univ),
      ];
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Container(
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
              Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
              const Expanded(child: SizedBox()),
              IconButton(onPressed: () => onRefresh(context), icon: const Icon(Icons.refresh_rounded, color: Colors.black)),
            ],
          ),
        ),
        actions: [
          SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: Colors.black, size: 20),
              label: Text('Logout', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: Colors.black)),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: page[idPage],
      bottomNavigationBar: Container(
        height: 50,
        width: lebar(context),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: secondaryWhite),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () => setState(() => idPage = 0),
                  style: TextButton.styleFrom(backgroundColor: (idPage == 0) ? primary : secondaryWhite, padding: const EdgeInsets.symmetric(horizontal: 10)),
                  child: Text('Profile', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: (idPage == 0) ? Colors.white : Colors.black)),
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () => setState(() => idPage = 1),
                  style: TextButton.styleFrom(backgroundColor: (idPage == 1) ? primary : secondaryWhite, padding: const EdgeInsets.symmetric(horizontal: 10)),
                  child: Text('Detail Pribadi', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: (idPage == 1) ? Colors.white : Colors.black)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
