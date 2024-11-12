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
  int idPage = 0;
  String userUid = 'bBm35Y9GYcNR8YHu2bybB61lyEr1';
  dynamic page = [];

  List<JurusanModel> allJurusan = [];
  List<String> univ = [];

  List<ProfileUserModel> allProfile = [];
  List<String> idAllProfile = [];

  ProfileUserModel? profile;
  String? idProfile;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);
    idPage = widget.idPage;
    profile = profider.getProfile;
    getDataJurusan();
    getDataUniv();

    if (profider.getProfile == null) {
      getDataProfile();
    }
  }

  void getDataProfile() async {
    profile = null;
    idProfile = null;
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('profile_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allProfile = querySnapshot.docs.map((doc) => ProfileUserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllProfile = querySnapshot.docs.map((doc) => doc.id).toList();
      bool userFound = false;

      // print('dapat');
      for (int i = 0; i < allProfile.length; i++) {
        if (allProfile[i].userUID == userUid) {
          profile = allProfile[i];
          idProfile = idAllProfile[i];

          userFound = true;

          page = [
            ProfileUserPage(idProfile: idProfile!, profile: profile!),
            DetailPribadiUserPage(idProfile: idProfile!, profile: profile!, listJurusan: allJurusan, daftarUniv: univ),
          ];

          return;
        }
      }
      if (!userFound) {
        await ProfileUserService.add(
          ProfileUserModel(
            userUID: userUid,
            imageProfile: '',
            userName: 'Muh Hilmy Noor Fauzi',
            uniqueUserName: 'muhhilmynoorfauzi',
            asalSekolah: 'MAN',
            listPlan: [
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
              PlanOptions(universitas: '', jurusan: ''),
            ],
            email: 'fauzizaelano@gmail.com',
            role: 'user',
            koin: 0,
            kontak: '082195012789',
            motivasi: '-',
            tempatTinggal: 'Makassar',
            created: DateTime.now(),
            update: DateTime.now(),
          ),
        );
        getDataProfile();
      }
      setState(() {});
    } catch (e) {
      print('salah getDataProfile: $e');
    }
  }

  void getDataJurusan() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('jurusan_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allJurusan = querySnapshot.docs.map((doc) => JurusanModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();

      setState(() {});
    } catch (e) {
      print('salah getDataJurusan: $e');
    }
  }

  void getDataUniv() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('univ_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      List<UnivModel> allUniv = querySnapshot.docs.map((doc) => UnivModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      for (int i = 0; i < allUniv.length; i++) {
        univ.add(allUniv[i].namaUniv);
      }
      setState(() {});
    } catch (e) {
      print('salah getDataUniv: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (profile != null) {
      if (lebar(context) <= 700) {
        return onMo(context);
      } else {
        return onDesk(context);
      }
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
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

  Widget onMo(BuildContext context) {
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
              Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
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
