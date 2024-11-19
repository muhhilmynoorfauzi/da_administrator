import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/firebase_service/tryout_service.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/tryout/claimed_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/pay_done_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PayFreeUserPage extends StatefulWidget {
  const PayFreeUserPage({super.key, required this.idTryout, required this.tryoutUser});

  final String idTryout;
  final TryoutModel? tryoutUser;

  @override
  State<PayFreeUserPage> createState() => _PayFreeUserPageState();
}

class _PayFreeUserPageState extends State<PayFreeUserPage> {
  final user = FirebaseAuth.instance.currentUser;
  bool onLoading = false;

  String urlImage = '';

  @override
  Widget build(BuildContext context) {
    if (!onLoading) {
      if (lebar(context) <= 700) {
        return onMo(context);
      } else {
        return onDesk(context);
      }
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
    }
  }

  Future<void> payment(BuildContext context) async {
    setState(() => onLoading = true);
    List<ClaimedModel> claimedUid = widget.tryoutUser!.claimedUid;
    if (pickedFileOrder != null) {
      await uploadImageOrder();
    }
    claimedUid.add(
      ClaimedModel(
        userUID: user!.uid,
        payment: 'FreeMethod',
        created: DateTime.now(),
        tryoutID: widget.idTryout,
        approval: false,
        name: user!.displayName!,
        imgFollow: urlImage,
        price: 0,
      ),
    );
    await TryoutService.edit(
      id: widget.idTryout,
      claimedUid: claimedUid,
      created: widget.tryoutUser!.created,
      updated: widget.tryoutUser!.updated,
      toCode: widget.tryoutUser!.toCode,
      toName: widget.tryoutUser!.toName,
      started: widget.tryoutUser!.started,
      ended: widget.tryoutUser!.ended,
      desk: widget.tryoutUser!.desk,
      image: widget.tryoutUser!.image,
      phase: widget.tryoutUser!.phase,
      phaseIRT: widget.tryoutUser!.phaseIRT,
      expired: widget.tryoutUser!.expired,
      public: widget.tryoutUser!.public,
      showFreeMethod: widget.tryoutUser!.showFreeMethod,
      totalTime: widget.tryoutUser!.totalTime,
      numberQuestions: widget.tryoutUser!.numberQuestions,
      listTest: widget.tryoutUser!.listTest,
      listPrice: widget.tryoutUser!.listPrice,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => onLoading = false);
    Navigator.push(context, FadeRoute1(const PayDoneUserPage(second: 5)));
  }

//----------------------------------------------------------------

  PlatformFile? pickedFileOrder;
  UploadTask? uploadTaskOrder;

  bool onUploadOrder = false;

  Future<void> selectedImageOrder() async {
    setState(() => onUploadOrder = !onUploadOrder);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      pickedFileOrder = result.files.first;
    } catch (e) {
      print('salah ni $e');
    }
    setState(() => onUploadOrder = !onUploadOrder);
  }

  Future<void> uploadImageOrder() async {
    if (kIsWeb) {
      // Pada platform web, gunakan bytes untuk mengupload berkas
      final bytes = pickedFileOrder!.bytes!;
      final ref = FirebaseStorage.instance.ref().child('orderFree_${user!.uid}/${pickedFileOrder?.name}');
      uploadTaskOrder = ref.putData(bytes);

      final snapshot = await uploadTaskOrder!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      urlImage = urlDownload;
    } else {
      // Pada platform native, gunakan path seperti biasa
      final path = 'orderFree_${user!.uid}/${pickedFileOrder?.name}';
      final file = File(pickedFileOrder!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTaskOrder = ref.putFile(file);

      final snapshot = await uploadTaskOrder!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      urlImage = urlDownload;
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true),
      body: ListView(
        children: [
          //tombol kembali
          Center(
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10, left: 10),
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
          //
          Center(child: Text('Order', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black))),
          Center(
            child: Container(
              height: 150,
              width: 700,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: widget.tryoutUser!.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.tryoutUser!.toName, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.tryoutUser!.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //metode
          Center(
            child: Container(
              width: 700,
              alignment: Alignment.centerRight,
              child: Column(
                children: [
                  /*SizedBox(
                    height: 40,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: h4),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(.3), fontSize: h4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),*/
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Upload Bukti Follow', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey,
                          //image boxfit.cover
                        ),
                        Text(
                          'belum ada gambar\nsilahkan pilih gambar',
                          style: TextStyle(fontSize: h5, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('Pilih Gambar', style: TextStyle(fontSize: h4, color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tinggi(context) * .1),
          //Ringkasan
          Center(
            child: Container(
              width: 700,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ringkasan', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Harga', style: TextStyle(fontSize: h4, color: Colors.black)),
                      Text('Rp 0', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                      Text('Follow (free)', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Total
          Center(
            child: Container(
              width: 700,
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('Rp 0', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => payment(context),
                      style: TextButton.styleFrom(backgroundColor: primary),
                      child: Text('Bayar', style: TextStyle(fontSize: h4, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(
        context: context,
      ),
      body: ListView(
        children: [
          //tombol kembali
          Center(
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10, left: 10),
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
          //
          Center(child: Text('Order', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black))),
          Center(
            child: Container(
              height: 150,
              width: 700,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: widget.tryoutUser!.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.tryoutUser!.toName, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.tryoutUser!.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          //metode
          Center(
            child: Container(
              width: 700,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  /*SizedBox(
                    height: 40,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: h4),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(.3), fontSize: h4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),*/
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Upload Bukti Follow', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey,
                            child: (pickedFileOrder != null)
                                ? kIsWeb
                                    ? Image.memory(pickedFileOrder!.bytes!, fit: BoxFit.cover)
                                    : Image.file(
                                        File(pickedFileOrder!.path!),
                                        fit: BoxFit.cover,
                                      )
                                : const Icon(Icons.image, color: Colors.white, size: 50),
                            //image boxfit.cover
                          ),
                        ),
                        if (pickedFileOrder == null)
                          Text(
                            'belum ada gambar\nsilahkan pilih gambar',
                            style: TextStyle(fontSize: h5, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: OutlinedButton(
                            onPressed: () {
                              selectedImageOrder();
                            },
                            child: Text((pickedFileOrder == null) ? 'Pilih Gambar' : 'Edit Gambar', style: TextStyle(fontSize: h4, color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tinggi(context) * .5),
        ],
      ),
      //Ringkasan
      bottomNavigationBar: Container(
        width: 700,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Harga', style: TextStyle(fontSize: h4, color: Colors.black)),
                Text('Rp 0', style: TextStyle(fontSize: h4, color: Colors.black)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                Text('Follow (free)', style: TextStyle(fontSize: h4, color: Colors.black)),
              ],
            ),
            Container(width: double.infinity, height: 1, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                Text('Rp 0', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
              ],
            ),
            SizedBox(
              height: 35,
              width: double.infinity,
              child: TextButton(
                onPressed: () => payment(context),
                style: TextButton.styleFrom(backgroundColor: primary),
                child: Text('Bayar', style: TextStyle(fontSize: h4, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
