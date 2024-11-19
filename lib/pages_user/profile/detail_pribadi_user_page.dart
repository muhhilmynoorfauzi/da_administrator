import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailPribadiUserPage extends StatefulWidget {
  const DetailPribadiUserPage({super.key, required this.profile, required this.idProfile, required this.allJurusan, required this.namaUniv});

  final ProfileUserModel profile;
  final String idProfile;
  final List<JurusanModel> allJurusan;
  final List<String> namaUniv;

  @override
  State<DetailPribadiUserPage> createState() => _DetailPribadiUserPageState();
}

class _DetailPribadiUserPageState extends State<DetailPribadiUserPage> {
  bool onLoading = false;
  ProfileUserModel? profile;

  //pisahkan daftar semua jurusan yang berupa sting
  List<String> daftarJurusan = [];

  //pisahkan daftar jurusan yang di pilih
  List<JurusanModel> listJurusanPilihan = [];

  final user = FirebaseAuth.instance.currentUser;

  List<TextEditingController> controllerUniv = List.generate(4, (index) => TextEditingController());
  List<TextEditingController> controllerJurusan = List.generate(4, (index) => TextEditingController());
  List<String> selectedJurusan = List.generate(4, (index) => '');
  List<String> selectedUniv = List.generate(4, (index) => '');

  late TextEditingController controllerAsalSekolah;
  late TextEditingController controllerTempatTinggal;
  late TextEditingController controllerKontak;
  late TextEditingController controllerMotivasi;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);

    profile = widget.profile;
    for (int i = 0; i < widget.allJurusan.length; i++) {
      daftarJurusan.add(widget.allJurusan[i].namaJurusan);
    }
    if (profile != null) {
      controllerAsalSekolah = TextEditingController(text: profile!.asalSekolah);
      controllerTempatTinggal = TextEditingController(text: profile!.tempatTinggal);
      controllerKontak = TextEditingController(text: profile!.kontak);
      controllerMotivasi = TextEditingController(text: profile!.motivasi);
    }
    if (profile!.listPlan.isNotEmpty) {
      controllerUniv = List.generate(4, (index) => TextEditingController(text: profile!.listPlan[index].universitas));
      controllerJurusan = List.generate(4, (index) => TextEditingController(text: profile!.listPlan[index].jurusan));
      selectedJurusan = List.generate(4, (index) => profile!.listPlan[index].jurusan);
      selectedUniv = List.generate(4, (index) => profile!.listPlan[index].universitas);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    for (int i = 0; i < controllerUniv.length; i++) {
      controllerUniv[i].dispose();
    }
    for (int i = 0; i < controllerJurusan.length; i++) {
      controllerJurusan[i].dispose();
    }
    controllerAsalSekolah.dispose();
    controllerTempatTinggal.dispose();
    controllerKontak.dispose();
    controllerMotivasi.dispose();
  }

  void getDataRational() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('rationalization_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('userUID', isEqualTo: user!.uid).get();

      var allRationalUser = querySnapshot.docs.map((doc) => RationalizationUserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      // var idAllRationalUser = querySnapshot.docs.map((doc) => doc.id).toList();

      // Sorting berdasarkan created
      allRationalUser.sort((a, b) => a.created.compareTo(b.created));
      allRationalUser = allRationalUser.reversed.toList();

      //cari jurusan yang sama dengan pilihan jurusan
      for (int i = 0; i < selectedJurusan.length; i++) {
        for (int j = 0; j < widget.allJurusan.length; j++) {
          if (widget.allJurusan[j].namaJurusan == selectedJurusan[i]) {
            listJurusanPilihan.add(JurusanModel(namaJurusan: widget.allJurusan[j].namaJurusan, relevance: widget.allJurusan[j].relevance, value: 0));
          }
        }
      }
      if (allRationalUser.isNotEmpty) {
        List<RationalizationUserModel> rationalUser = [];
        bool isFound = false;
        //mencari yang punya user
        for (int i = 0; i < allRationalUser.length; i++) {
          if (allRationalUser[i].userUID == user!.uid) {
            rationalUser.add(allRationalUser[i]);
            isFound = true;
          }
        }

        if (isFound) {
          print('sudah ada');
          //deteksi jika ada perubahan
          bool ganti = false;
          for (int i = 0; i < rationalUser.first.jurusan.length; i++) {
            if (rationalUser.first.jurusan[i].namaJurusan != listJurusanPilihan[i].namaJurusan) {
              print('sdh ganti');
              ganti = true;
              rationalUser.first.jurusan[i] = listJurusanPilihan[i];
              break;
            }
          }
          if (ganti) {
            await RationalizationUserService.add(
              RationalizationUserModel(jurusan: rationalUser.first.jurusan, created: DateTime.now(), userUID: user!.uid, idTryout: '', idUserTo: ''),
            );
          }
          // print('list jurusan 1 ${rationalUser.first.jurusan[0].namaJurusan} ${rationalUser.first.jurusan[0].relevance} ${rationalUser.first.jurusan[0].value}');
          // print('list jurusan 2 ${rationalUser.first.jurusan[1].namaJurusan} ${rationalUser.first.jurusan[1].relevance} ${rationalUser.first.jurusan[1].value}');
          // print('list jurusan 3 ${rationalUser.first.jurusan[2].namaJurusan} ${rationalUser.first.jurusan[2].relevance} ${rationalUser.first.jurusan[2].value}');
          // print('list jurusan 4 ${rationalUser.first.jurusan[3].namaJurusan} ${rationalUser.first.jurusan[3].relevance} ${rationalUser.first.jurusan[3].value}');
        } else {
          print('sudah ada tapi bukan punya dia');
          await RationalizationUserService.add(RationalizationUserModel(jurusan: listJurusanPilihan, created: DateTime.now(), userUID: user!.uid, idTryout: '', idUserTo: ''));
        }
      } else {
        print('belum ada list, userTO masih kosong');
        await RationalizationUserService.add(RationalizationUserModel(jurusan: listJurusanPilihan, created: DateTime.now(), userUID: user!.uid, idTryout: '', idUserTo: ''));
      }

      listJurusanPilihan = [];
      setState(() {});
    } catch (e) {
      print('salah getDataRational : $e');
    }
  }

  Future<void> onSave(BuildContext context) async {
    setState(() => onLoading = true);

    await ProfileUserService.edit(
      id: widget.idProfile,
      userUID: profile!.userUID,
      imageProfile: profile!.imageProfile,
      userName: profile!.userName,
      email: profile!.email,
      role: profile!.role,
      koin: profile!.koin,
      uniqueUserName: profile!.uniqueUserName,
      asalSekolah: controllerAsalSekolah.text,
      listPlan: profile!.listPlan,
      kontak: controllerKontak.text,
      motivasi: controllerMotivasi.text,
      tempatTinggal: controllerTempatTinggal.text,
      created: profile!.created,
      update: DateTime.now(),
    );

    getDataRational();
    //===========================================================================

    setState(() => onLoading = false);
    await Future.delayed(const Duration(milliseconds: 200));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primary),
            child: Text("Data berhasil disimpan", style: TextStyle(fontSize: h4, color: Colors.white)),
          ),
        ),
        duration: const Duration(seconds: 3),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!onLoading && profile != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 700,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asal Sekolah', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerAsalSekolah,
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Asal Tempat Tinggal', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerTempatTinggal,
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: List.generate(
                          4,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (index == 0)
                                Center(
                                  child: Text(
                                    'Pastikan Jurusan yang Anda pilih tersedia di Universitas yang anda pilih',
                                    style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.2)),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              const SizedBox(height: 10),
                              Text('Pilihan Jurusan ${index + 1}', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(10)),
                                      child: DropdownButton(
                                        dropdownColor: Colors.white,
                                        focusColor: Colors.white,
                                        isExpanded: true,
                                        itemHeight: 60,
                                        padding: EdgeInsets.zero,
                                        borderRadius: BorderRadius.circular(10),
                                        hint: Text(
                                          (selectedJurusan[index] == '') ? 'Jurusan' : selectedJurusan[index],
                                          style: TextStyle(color: (selectedJurusan[index] == '') ? Colors.grey : Colors.black, fontSize: h4, fontWeight: FontWeight.normal),
                                        ),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            selectedJurusan[index] = newValue;
                                            profile!.listPlan[index].jurusan = newValue;
                                            setState(() {});
                                          }
                                        },
                                        underline: const SizedBox(),
                                        items: daftarJurusan
                                            .map((String option) => DropdownMenuItem(
                                                  value: option,
                                                  child: Text(option, style: TextStyle(color: Colors.black, fontSize: h4 - 2, fontWeight: FontWeight.normal)),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  if (selectedJurusan[index] != '')
                                    IconButton(
                                      onPressed: () {
                                        selectedJurusan[index] = '';
                                        profile!.listPlan[index].jurusan = '';
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close, color: Colors.black),
                                    )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Container(
                                      height: 40,
                                      padding: const EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(border: Border.all(color: Colors.black45, width: 1), borderRadius: BorderRadius.circular(10)),
                                      child: DropdownButton(
                                        dropdownColor: Colors.white,
                                        focusColor: Colors.white,
                                        isExpanded: true,
                                        itemHeight: 60,
                                        padding: EdgeInsets.zero,
                                        borderRadius: BorderRadius.circular(10),
                                        hint: Text(
                                          (selectedUniv[index] == '') ? 'Universitas' : selectedUniv[index],
                                          style: TextStyle(color: (selectedUniv[index] == '') ? Colors.grey : Colors.black, fontSize: h4, fontWeight: FontWeight.normal),
                                        ),
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            selectedUniv[index] = newValue;
                                            profile!.listPlan[index].universitas = newValue;
                                            setState(() {});
                                          }
                                        },
                                        underline: const SizedBox(),
                                        items: widget.namaUniv
                                            .map((String option) => DropdownMenuItem(
                                                  value: option,
                                                  child: Text(option, style: TextStyle(color: Colors.black, fontSize: h4 - 2, fontWeight: FontWeight.normal)),
                                                ))
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                  if (selectedUniv[index] != '')
                                    IconButton(
                                      onPressed: () {
                                        selectedUniv[index] = '';
                                        profile!.listPlan[index].universitas = '';
                                        setState(() {});
                                      },
                                      icon: const Icon(Icons.close, color: Colors.black),
                                    )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Kontak', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerKontak,
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text('Motivasi', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black)),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        controller: controllerMotivasi,
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 10,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: 700,
                height: 40,
                child: TextButton(
                  onPressed: () {
                    onSave(context);
                  },
                  style: TextButton.styleFrom(backgroundColor: primary),
                  child: Text('Simpan Pembaharuan', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      );
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
    }
  }
}
