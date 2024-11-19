import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key, required this.profile, required this.idProfile});

  final ProfileUserModel profile;
  final String idProfile;

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
  bool onLoading = false;
  ProfileUserModel? profile;
  final user = FirebaseAuth.instance.currentUser;

  late TextEditingController controllerUniqueUserName;
  late TextEditingController controllerUserName;
  late TextEditingController controllerEmail;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    profile = widget.profile;
    controllerUniqueUserName = TextEditingController(text: profile!.uniqueUserName);
    controllerUserName = TextEditingController(text: profile!.userName);
    controllerEmail = TextEditingController(text: profile!.email);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    controllerUniqueUserName.dispose();
    controllerUserName.dispose();
    controllerEmail.dispose();
  }

  Future<void> onSave(BuildContext context) async {
    setState(() => onLoading = true);
    if (pickedFile != null) {
      await uploadImageUser();
    }
    await ProfileUserService.edit(
      id: widget.idProfile,
      userUID: profile!.userUID,
      imageProfile: profile!.imageProfile,
      userName: controllerUserName.text,
      email: controllerEmail.text,
      role: profile!.role,
      koin: profile!.koin,
      uniqueUserName: controllerUniqueUserName.text,
      asalSekolah: profile!.asalSekolah,
      listPlan: profile!.listPlan,
      kontak: profile!.kontak,
      motivasi: profile!.motivasi,
      tempatTinggal: profile!.tempatTinggal,
      created: profile!.created,
      update: DateTime.now(),
    );

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

//----------------------------------------------------------------

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  bool onUpload = false;

  Future<void> selectedImageUser() async {
    setState(() => onUpload = !onUpload);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      pickedFile = result.files.first;
    } catch (e) {
      print('salah ni $e');
    }
    setState(() => onUpload = !onUpload);
  }

  Future<void> uploadImageUser() async {
    if (kIsWeb) {
      // Pada platform web, gunakan bytes untuk mengupload berkas
      final bytes = pickedFile!.bytes!;
      final ref = FirebaseStorage.instance.ref().child('userProfile_${user!.uid}/${pickedFile?.name}');
      uploadTask = ref.putData(bytes);

      final snapshot = await uploadTask!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      profile!.imageProfile = urlDownload;
    } else {
      // Pada platform native, gunakan path seperti biasa
      final path = 'userProfile_${user!.uid}/${pickedFile?.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      profile!.imageProfile = urlDownload;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!onLoading && profile != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            if (lebar(context) > 900) SizedBox(height: tinggi(context) * .1),
            Center(
              child: Container(
                width: 700,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey,
                          child: (pickedFile != null)
                              ? Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                                  child: kIsWeb ? Image.memory(pickedFile!.bytes!, fit: BoxFit.cover) : Image.file(File(pickedFile!.path!), fit: BoxFit.cover),
                                )
                              : (profile!.imageProfile == '')
                                  ? const Icon(Icons.person_rounded, color: Colors.white, size: 120)
                                  : CachedNetworkImage(
                                      imageUrl: profile!.imageProfile,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () async => await selectedImageUser(),
                              child: Text('Pilih Gambar', style: TextStyle(fontSize: h5 + 2, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          if (pickedFile == null)
                            SizedBox(
                              height: 30,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Text('Hapus Gambar', style: TextStyle(fontSize: h5 + 2, color: Colors.black)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text('Nama (Maks. 50 Karakter)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerUserName,
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
                    Text('Nama pengguna (Maks. 50 Karakter)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerUniqueUserName,
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
                    Text('Email Address', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        controller: controllerEmail,
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
                  ],
                ),
              ),
            ),
            Center(
              child: Container(
                width: 700,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                height: 40,
                child: TextButton(
                  onPressed: () => onSave(context),
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
