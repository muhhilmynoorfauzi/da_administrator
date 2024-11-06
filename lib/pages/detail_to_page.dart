import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/questions_service.dart';
import 'package:da_administrator/firebase_service/tryout_service.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/tryout/subtest_model.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/pages/detail_claimed.dart';
import 'package:da_administrator/pages/questions_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailToPage extends StatefulWidget {
  const DetailToPage({super.key});

  @override
  State<DetailToPage> createState() => _DetailToPageState();
}

TryoutModel? tryout;

class _DetailToPageState extends State<DetailToPage> {
  bool isLoading = false;
  int countSoal = 1;

  @override
  Widget build(BuildContext context) {
    var page = (lebar(context) <= 1200) ? onMo(context) : onDesk(context);
    return Stack(
      children: [
        page,
        if (isLoading)
          Container(
            height: tinggi(context),
            width: lebar(context),
            color: Colors.white,
            child: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    final profider = Provider.of<CounterProvider>(context, listen: false);
    /*profider.addListener(() {
      getDataTryOut(profider.getIdDetailPage!);
    });*/
    getDataTryOut(profider.getIdDetailPage!);
  }

  void getDataTryOut(String docId) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('tryout_v2').doc(docId);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        setState(() => tryout = TryoutModel.fromSnapshot(docSnapshot));
        print('Dokumen ditemukan');
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');

    return formatter.format(dateTime);
  }

  String formatTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  String formatMinutes(double seconds) {
    double minutes = seconds / 60; // Konversi detik ke menit
    return minutes.toStringAsFixed(1); // Mengembalikan nilai string dengan 1 angka di belakang koma
  }

//----------------------------------------------------------------

  PlatformFile? pickedFileTO;
  UploadTask? uploadTaskTO;

  bool onUploadTO = false;

  Future<void> selectedImageTO() async {
    setState(() => onUploadTO = !onUploadTO);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      pickedFileTO = result.files.first;
    } catch (e) {
      print('salah ni $e');
    }
    setState(() => onUploadTO = !onUploadTO);
  }

  Future<void> uploadImageTO() async {
    if (kIsWeb) {
      // Pada platform web, gunakan bytes untuk mengupload berkas
      final bytes = pickedFileTO!.bytes!;
      final ref = FirebaseStorage.instance.ref().child('question/${pickedFileTO?.name}');
      uploadTaskTO = ref.putData(bytes);

      final snapshot = await uploadTaskTO!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      tryout!.image = urlDownload;
    } else {
      // Pada platform native, gunakan path seperti biasa
      final path = 'question_${tryout!.toName}/${pickedFileTO?.name}';
      final file = File(pickedFileTO!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTaskTO = ref.putFile(file);

      final snapshot = await uploadTaskTO!.whenComplete(() {});

      final urlDownload = await snapshot.ref.getDownloadURL();
      tryout!.image = urlDownload;
    }
  }

//----------------------------------------------------------------

  Future<void> btnSimpan(BuildContext context, String id) async {
    setState(() => isLoading = !isLoading);
    final profider = Provider.of<CounterProvider>(context, listen: false);
    if (pickedFileTO != null) {
      await uploadImageTO();
    }
    await TryoutService.edit(
      id: id,
      created: tryout!.created,
      updated: DateTime.now(),
      toCode: tryout!.toCode,
      toName: tryout!.toName,
      started: tryout!.started,
      ended: tryout!.ended,
      desk: tryout!.desk,
      image: tryout!.image,
      phase: tryout!.phase,
      phaseIRT: tryout!.phaseIRT,
      expired: tryout!.expired,
      public: tryout!.public,
      showFreeMethod: tryout!.showFreeMethod,
      totalTime: tryout!.totalTime,
      numberQuestions: tryout!.numberQuestions,
      listTest: tryout!.listTest,
      claimedUid: tryout!.claimedUid,
      listPrice: tryout!.listPrice,
    );
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() => isLoading = !isLoading);
    profider.setReload();
  }

//----------------------------------------------------------------
  Future<void> totalWaktu() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: tryout!.totalTime.toString());
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Total Waktu', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black, fontSize: h4),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.totalTime = double.parse(controller.text));
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> jumlahSoal() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: tryout!.numberQuestions.toString());
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Jumlah Soal', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black, fontSize: h4),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.numberQuestions = int.parse(controller.text));
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> berakhir() async {
    var date = await showDatePicker(context: context, initialDate: tryout!.ended, firstDate: DateTime(2000), lastDate: DateTime(3000));
    if (date != null) {
      setState(() => tryout!.ended = date);
    }
  }

  Future<void> berakhirTime() async {
    final DateTime now = tryout!.ended;
    var date = await showTimePicker(context: context, initialTime: TimeOfDay(hour: now.hour, minute: now.minute));
    if (date != null) {
      setState(() => tryout!.ended = DateTime(tryout!.ended.year, tryout!.ended.month, tryout!.ended.day, date.hour, date.minute));
    }
  }

  Future<void> mulai() async {
    var date = await showDatePicker(context: context, initialDate: tryout!.created, firstDate: DateTime(2000), lastDate: DateTime(3000));
    if (date != null) {
      setState(() => tryout!.created = date);
    }
  }

  Future<void> mulaiTime() async {
    final DateTime now = tryout!.created;
    var date = await showTimePicker(context: context, initialTime: TimeOfDay(hour: now.hour, minute: now.minute));
    if (date != null) {
      setState(() => tryout!.created = DateTime(tryout!.created.year, tryout!.created.month, tryout!.created.day, date.hour, date.minute));
    }
  }

//----------------------------------------------------------------
  void deleteTest({required int indexTest}) => setState(() => tryout!.listTest.removeAt(indexTest));

  Future<void> addTest() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Jenis Test', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 150,
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Nama Tes',
                    labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: h4),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.listTest.add(TestModel(nameTest: nameController.text, listSubtest: [])));
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> editTest({required int index}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController(text: tryout!.listTest[index].nameTest);
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Jenis TPS', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 150,
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Nama Tes',
                    labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: h4),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  tryout!.listTest[index].nameTest = nameController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------
  void deleteSubtest({required int indexTest, required int indexSubtest}) => setState(() => tryout!.listTest[indexTest].listSubtest.removeAt(indexSubtest));

  Future<void> addSubtestDialog({required int i}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController();
        final TextEditingController minuteController = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Jenis Sub Test', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 150,
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Nama Sub Tes',
                    labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: h4),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: TextField(
                    controller: minuteController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Detik',
                      labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: h4),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  SubtestModel test = SubtestModel(nameSubTest: nameController.text, timeMinute: double.parse(minuteController.text), idQuestions: '');
                  tryout!.listTest[i].listSubtest.add(test);
                });
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> editSubtestDialog({required int i, required int j}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController nameController = TextEditingController(text: tryout!.listTest[i].listSubtest[j].nameSubTest);
        final TextEditingController minuteController = TextEditingController(text: tryout!.listTest[i].listSubtest[j].timeMinute.toString());
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Jenis Sub Test', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 150,
            width: 500,
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Nama Sub Tes',
                    labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: h4),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: minuteController,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Detik',
                    labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: h4),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  tryout!.listTest[i].listSubtest[j].nameSubTest = nameController.text;
                  tryout!.listTest[i].listSubtest[j].timeMinute = double.parse(minuteController.text);
                });
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------

  Future<void> editDesk() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: tryout!.desk);
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Deskripsi TryOut', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: SizedBox(
            height: 500,
            width: 500,
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                border: const OutlineInputBorder(),
                labelText: 'Deskripsi',
                labelStyle: TextStyle(color: Colors.black, fontSize: h4),
              ),
              maxLines: 20,
              style: TextStyle(color: Colors.black, fontSize: h4),
            ),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.desk = controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> editToName() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: tryout!.toName);
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Deskripsi TryOut', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              // alignLabelWithHint: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              border: const OutlineInputBorder(),
              labelText: 'Judul TryOut',
              labelStyle: TextStyle(color: Colors.black, fontSize: h4),
            ),
            style: TextStyle(color: Colors.black, fontSize: h4),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.toName = controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> priceTO(int price, int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: price.toString());
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Total Waktu', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black, fontSize: h4),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.listPrice[index] = int.parse(controller.text));
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------

  Future<void> toCode() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController(text: tryout!.toCode);
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          title: Text('Masukkan Tryout Code', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(10),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black, fontSize: h4),
            inputFormatters: [TextInputFormatter.withFunction((oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection))],
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => tryout!.toCode = controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

//----------------------------------------------------------------

  Widget onMo(BuildContext context) {
    var id = context.watch<CounterProvider>().getIdDetailPage!;
    // bool smallDevice = lebar(context) <= 700;

    if (tryout != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              // context.read<CounterProvider>().setPage(idPage: null, idDetailPage: null);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.navigate_before_rounded, color: Colors.black),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  tryout!.toName,
                  style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(onPressed: () => editToName(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => context.read<CounterProvider>().setReload(),
              icon: const Icon(Icons.close, color: Colors.black),
            ),
            IconButton(
              onPressed: () => btnSimpan(context, id),
              icon: const Icon(Icons.check, color: Colors.black),
            ),
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (pickedFileTO != null)
                              ? AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                                    child: kIsWeb ? Image.memory(pickedFileTO!.bytes!, fit: BoxFit.cover) : Image.file(File(pickedFileTO!.path!), fit: BoxFit.cover),
                                  ),
                                )
                              : (tryout!.image == '')
                                  ? AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(.2)),
                                        child: const Icon(Icons.image, color: Colors.white, size: 100),
                                      ),
                                    )
                                  : AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: CachedNetworkImage(
                                        imageUrl: tryout!.image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async => await selectedImageTO(),
                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                            child: onUploadTO
                                ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                                : Text('Edit', style: TextStyle(color: Colors.black, fontSize: h4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(tryout!.desk, style: TextStyle(color: Colors.black, fontSize: h4), maxLines: 10, overflow: TextOverflow.ellipsis)),
                          IconButton(onPressed: () => editDesk(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 10, bottom: 10, right: 10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  4,
                  (index) {
                    return Row(
                      children: [
                        Text(
                          NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(tryout!.listPrice[index]),
                          style: TextStyle(color: Colors.black, fontSize: h4),
                        ),
                        const Expanded(child: SizedBox()),
                        IconButton(onPressed: () => priceTO(tryout!.listPrice[index], index), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Claim', style: TextStyle(color: Colors.black, fontSize: h4)),
                        OutlinedButton.icon(
                          onPressed: () => Navigator.push(context, FadeRoute1(DetailClaimed(claimedUid: tryout!.claimedUid, titleTo: tryout!.toName))),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.only(left: 20, right: 10)),
                          iconAlignment: IconAlignment.end,
                          label: Text('${tryout!.claimedUid.length} Member', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                          icon: const Icon(Icons.navigate_next_rounded, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dibuat pada tanggal', style: TextStyle(color: Colors.black, fontSize: h4)),
                        Text(formatDate(tryout!.created), style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  SizedBox(
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Diedit pada tanggal ', style: TextStyle(color: Colors.black, fontSize: h4)),
                        Text(formatDate(tryout!.updated), style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                Text('Mulai pada ', style: TextStyle(color: Colors.black, fontSize: h4)),
                                Text('${formatDate(tryout!.started)},', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                TextButton(
                                  style: TextButton.styleFrom(foregroundColor: Colors.black),
                                  onPressed: () => mulaiTime(),
                                  child: Text(
                                    'Pukul ${formatTime(tryout!.started)} ${tryout!.started.timeZoneName}',
                                    style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      IconButton(onPressed: () => mulai(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                    ],
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Text('Berakhir pada ', style: TextStyle(color: Colors.black, fontSize: h4)),
                              Text('${formatDate(tryout!.ended)},', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              TextButton(
                                style: TextButton.styleFrom(foregroundColor: Colors.black),
                                onPressed: () => berakhirTime(),
                                child: Text(
                                  'Pukul ${formatTime(tryout!.ended)} ${tryout!.ended.timeZoneName}',
                                  style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => berakhir(),
                        icon: const Icon(Icons.edit_outlined, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Publish Tryout', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                        Text(
                          tryout!.public ? 'Published' : 'Not\nPublished',
                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    value: tryout!.public,
                    onChanged: (bool value) => setState(() => tryout!.public = value),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Free Methods Available', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                        Text(
                          tryout!.showFreeMethod ? 'Free' : 'Not\nFree',
                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    value: tryout!.showFreeMethod,
                    onChanged: (bool value) => setState(() => tryout!.showFreeMethod = value),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Tryout Expire', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                        Text(
                          tryout!.expired ? 'Expired' : 'Not\nExpired',
                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    value: tryout!.expired,
                    onChanged: (bool value) => setState(() => tryout!.expired = value),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  Row(
                    children: [
                      Text('Tryout Code', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      const Expanded(child: SizedBox()),
                      Text(tryout!.toCode, style: TextStyle(color: Colors.black, fontSize: h4)),
                      IconButton(onPressed: () => toCode(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Fase TryOut', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                        Text(
                          tryout!.phase ? 'Selesai' : 'Belum\nSelesai',
                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    value: tryout!.phase,
                    onChanged: (bool value) => setState(() => tryout!.phase = value),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('IRT System', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                        Text(
                          tryout!.phaseIRT ? 'Active' : 'Not\nActive',
                          style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    value: tryout!.phaseIRT,
                    onChanged: (bool value) => setState(() => tryout!.phaseIRT = value),
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  Row(
                    children: [
                      Text('Total Waktu', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      const Expanded(child: SizedBox()),
                      Text('${formatMinutes(tryout!.totalTime)} Menit', style: TextStyle(color: Colors.black, fontSize: h4)),
                      IconButton(onPressed: () => totalWaktu(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                    ],
                  ),
                  Container(
                    color: Colors.black.withOpacity(.1),
                    height: 1,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  Row(
                    children: [
                      Text('Jumlah Soal', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      const Expanded(child: SizedBox()),
                      Text('${tryout!.numberQuestions} Soal', style: TextStyle(color: Colors.black, fontSize: h4)),
                      IconButton(onPressed: () => jumlahSoal(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Tambah Test', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  onPressed: () => addTest(),
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            Column(
              children: List.generate(
                tryout!.listTest.length,
                (indexTest) => Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(tryout!.listTest[indexTest].nameTest, style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () => editTest(index: indexTest),
                            icon: const Icon(Icons.edit_outlined, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => deleteTest(indexTest: indexTest),
                            icon: const Icon(Icons.delete_outline, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => addSubtestDialog(i: indexTest),
                            icon: const Icon(Icons.add, color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(
                          tryout!.listTest[indexTest].listSubtest.length,
                          (indexSubtest) {
                            bool questionsloading = false;
                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) => Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: Column(
                                  children: [
                                    Container(
                                      color: Colors.black.withOpacity(.1),
                                      height: 1,
                                      width: double.infinity,
                                      margin: const EdgeInsets.symmetric(vertical: 10),
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  tryout!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                                  style: TextStyle(color: Colors.black, fontSize: h4),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              Container(
                                                height: 30,
                                                width: 150,
                                                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '${formatMinutes(tryout!.listTest[indexTest].listSubtest[indexSubtest].timeMinute)} Menit',
                                                  style: TextStyle(color: Colors.white, fontSize: h4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: () => editSubtestDialog(i: indexTest, j: indexSubtest),
                                                  icon: const Icon(Icons.edit_outlined, color: Colors.black),
                                                ),
                                                IconButton(
                                                  onPressed: () => deleteSubtest(indexSubtest: indexSubtest, indexTest: indexTest),
                                                  icon: const Icon(Icons.delete_outline, color: Colors.black),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                              child: OutlinedButton(
                                                onPressed: () async {
                                                  setState(() => questionsloading = true);

                                                  if (tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions != '') {
                                                    await Future.delayed(const Duration(milliseconds: 500));
                                                    Navigator.push(
                                                      context,
                                                      FadeRoute1(
                                                        QuestionsPage(
                                                          idQuestion: tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions,
                                                          subTest: tryout!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    String newDocId = await QuestionsService.addGetId(QuestionsModel(idTryOut: id, listQuestions: []));

                                                    tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions = newDocId;
                                                    await btnSimpan(context, id);
                                                  }

                                                  setState(() => questionsloading = false);
                                                },
                                                child: questionsloading
                                                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primary, strokeWidth: 3))
                                                    : Text(
                                                        tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions != '' ? 'Soal Selengkapnya' : 'Tambah Soal',
                                                        style: TextStyle(color: Colors.black, fontSize: h4),
                                                      ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    // if (indexSubtest != tryout!.listTest[indexTest].listSubtest.length - 1)
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
      );
    }
  }

  Widget onDesk(BuildContext context) {
    var id = context.watch<CounterProvider>().getIdDetailPage!;

    if (tryout != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          title: Row(
            children: [
              Expanded(
                child: Text(
                  tryout!.toName,
                  style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(onPressed: () => editToName(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
            ],
          ),
          actions: [
            TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: Colors.grey, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () => context.read<CounterProvider>().setReload(),
              label: Text('Batal', style: TextStyle(color: Colors.white, fontSize: h4)),
              icon: const Icon(Icons.close, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            TextButton.icon(
              style: TextButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              onPressed: () => btnSimpan(context, id),
              label: Text('Simpan', style: TextStyle(color: Colors.white, fontSize: h4)),
              icon: const Icon(Icons.check, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              margin: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: (pickedFileTO != null)
                              ? AspectRatio(
                                  aspectRatio: 3 / 4,
                                  child: Container(
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.grey),
                                    child: kIsWeb ? Image.memory(pickedFileTO!.bytes!, fit: BoxFit.cover) : Image.file(File(pickedFileTO!.path!), fit: BoxFit.cover),
                                  ),
                                )
                              : (tryout!.image == '')
                                  ? AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: Container(
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(.2)),
                                        child: const Icon(Icons.image, color: Colors.white, size: 100),
                                      ),
                                    )
                                  : AspectRatio(
                                      aspectRatio: 3 / 4,
                                      child: CachedNetworkImage(
                                        imageUrl: tryout!.image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                        ),
                        SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () async => await selectedImageTO(),
                            style: OutlinedButton.styleFrom(padding: EdgeInsets.zero),
                            child: onUploadTO
                                ? Container(height: 40, width: 40, padding: const EdgeInsets.all(5), child: const CircularProgressIndicator())
                                : Text('Edit', style: TextStyle(color: Colors.black, fontSize: h4)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                      alignment: Alignment.topLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: Text(tryout!.desk, style: TextStyle(color: Colors.black, fontSize: h4), maxLines: 10, overflow: TextOverflow.ellipsis)),
                          IconButton(onPressed: () => editDesk(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        4,
                        (index) {
                          return Row(
                            children: [
                              Text(
                                NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(tryout!.listPrice[index]),
                                style: TextStyle(color: Colors.black, fontSize: h4),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(onPressed: () => priceTO(tryout!.listPrice[index], index), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                            ],
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 35,
                          child: Row(
                            children: [
                              Text('Total Claim', style: TextStyle(color: Colors.black, fontSize: h4)),
                              const Expanded(child: SizedBox()),
                              OutlinedButton.icon(
                                onPressed: () => Navigator.push(context, FadeRoute1(DetailClaimed(claimedUid: tryout!.claimedUid, titleTo: tryout!.toName))),
                                style: OutlinedButton.styleFrom(padding: const EdgeInsets.only(left: 20, right: 10)),
                                iconAlignment: IconAlignment.end,
                                label: Text('${tryout!.claimedUid.length} Member', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                icon: const Icon(Icons.navigate_next_rounded, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Dibuat pada tanggal', style: TextStyle(color: Colors.black, fontSize: h4)),
                              Text(formatDate(tryout!.created), style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SizedBox(
                          height: 35,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Diedit pada tanggal ', style: TextStyle(color: Colors.black, fontSize: h4)),
                              Text(formatDate(tryout!.updated), style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SizedBox(
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      Text('Mulai pada ', style: TextStyle(color: Colors.black, fontSize: h4)),
                                      Text('${formatDate(tryout!.started)},', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                      TextButton(
                                        style: TextButton.styleFrom(foregroundColor: Colors.black),
                                        onPressed: () => mulaiTime(),
                                        child: Text(
                                          'Pukul ${formatTime(tryout!.started)} ${tryout!.started.timeZoneName}',
                                          style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            IconButton(onPressed: () => mulai(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                          ],
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Text('Berakhir pada ', style: TextStyle(color: Colors.black, fontSize: h4)),
                                    Text('${formatDate(tryout!.ended)},', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                    TextButton(
                                      style: TextButton.styleFrom(foregroundColor: Colors.black),
                                      onPressed: () => berakhirTime(),
                                      child: Text(
                                        'Pukul ${formatTime(tryout!.ended)} ${tryout!.ended.timeZoneName}',
                                        style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => berakhir(),
                              icon: const Icon(Icons.edit_outlined, color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Publish Tryout', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                tryout!.public ? 'Published' : 'Not\nPublished',
                                style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          value: tryout!.public,
                          onChanged: (bool value) => setState(() => tryout!.public = value),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Free Methods Available', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                tryout!.showFreeMethod ? 'Free' : 'Not\nFree',
                                style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          value: tryout!.showFreeMethod,
                          onChanged: (bool value) => setState(() => tryout!.showFreeMethod = value),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Tryout Expire', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                tryout!.expired ? 'Expired' : 'Not\nExpired',
                                style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          value: tryout!.expired,
                          onChanged: (bool value) => setState(() => tryout!.expired = value),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        Row(
                          children: [
                            Text('Tryout Code', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                            const Expanded(child: SizedBox()),
                            Text(tryout!.toCode, style: TextStyle(color: Colors.black, fontSize: h4)),
                            IconButton(onPressed: () => toCode(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Fase TryOut', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                tryout!.phase ? 'Selesai' : 'Belum\nSelesai',
                                style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          value: tryout!.phase,
                          onChanged: (bool value) => setState(() => tryout!.phase = value),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('IRT System', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              Text(
                                tryout!.phaseIRT ? 'Active' : 'Not\nActive',
                                style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          value: tryout!.phaseIRT,
                          onChanged: (bool value) => setState(() => tryout!.phaseIRT = value),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        SizedBox(
                          height: 47,
                          child: Row(
                            children: [
                              Text('Total Waktu', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              const Expanded(child: SizedBox()),
                              Text('${formatMinutes(tryout!.totalTime)} Menit', style: TextStyle(color: Colors.black, fontSize: h4)),
                              IconButton(onPressed: () => totalWaktu(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.black.withOpacity(.1),
                          height: 1,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        Row(
                          children: [
                            Text('Jumlah Soal', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                            const Expanded(child: SizedBox()),
                            Text('${tryout!.numberQuestions} Soal', style: TextStyle(color: Colors.black, fontSize: h4)),
                            IconButton(onPressed: () => jumlahSoal(), icon: const Icon(Icons.edit_outlined, color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('Tambah Test', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  onPressed: () => addTest(),
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              ],
            ),
            Column(
              children: List.generate(
                tryout!.listTest.length,
                (indexTest) => Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  width: double.infinity,
                  decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(tryout!.listTest[indexTest].nameTest, style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                          const Expanded(child: SizedBox()),
                          IconButton(
                            onPressed: () => editTest(index: indexTest),
                            icon: const Icon(Icons.edit_outlined, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => deleteTest(indexTest: indexTest),
                            icon: const Icon(Icons.delete_outline, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => addSubtestDialog(i: indexTest),
                            icon: const Icon(Icons.add, color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: List.generate(
                          tryout!.listTest[indexTest].listSubtest.length,
                          (indexSubtest) {
                            bool questionsloading = false;

                            /*int questionLength = 0;
                            void getLength(String docId) async {
                              QuestionsModel questions = QuestionsModel(idTryOut: '', listQuestions: []);

                              try {
                                DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('questions_v2').doc(docId);
                                DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
                                if (docSnapshot.exists) {
                                  questions = QuestionsModel.fromSnapshot(docSnapshot);
                                  setState(() => questionLength = questions.listQuestions.length);
                                }
                              } catch (e) {
                                print('Error ini we: $e');
                              }
                            }*/

                            return StatefulBuilder(
                              builder: (BuildContext context, StateSetter setState) {
                                /*if (tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions != '') {
                                  getLength(tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions);
                                }*/

                                return Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                tryout!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                                style: TextStyle(color: Colors.black, fontSize: h4),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Container(
                                              height: 30,
                                              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '${formatMinutes(tryout!.listTest[indexTest].listSubtest[indexSubtest].timeMinute)} Menit',
                                                style: TextStyle(color: Colors.white, fontSize: h4),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            setState(() => questionsloading = true);

                                            if (tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions != '') {
                                              await Future.delayed(const Duration(milliseconds: 500));
                                              Navigator.push(
                                                context,
                                                FadeRoute1(
                                                  QuestionsPage(
                                                    idQuestion: tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions,
                                                    subTest: tryout!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              String newDocId = await QuestionsService.addGetId(QuestionsModel(idTryOut: id, listQuestions: []));

                                              tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions = newDocId;
                                              await btnSimpan(context, id);

                                              await Future.delayed(const Duration(milliseconds: 500));

                                              Navigator.push(
                                                context,
                                                FadeRoute1(
                                                  QuestionsPage(
                                                    idQuestion: tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions,
                                                    subTest: tryout!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                                  ),
                                                ),
                                              );
                                            }

                                            setState(() => questionsloading = false);
                                          },
                                          child: questionsloading
                                              ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: primary, strokeWidth: 3))
                                              : Text(
                                                  tryout!.listTest[indexTest].listSubtest[indexSubtest].idQuestions != '' ? 'Soal Selengkapnya' : 'Tambah Soal',
                                                  style: TextStyle(color: Colors.black, fontSize: h4),
                                                ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => editSubtestDialog(i: indexTest, j: indexSubtest),
                                        icon: const Icon(Icons.edit_outlined, color: Colors.black),
                                      ),
                                      IconButton(
                                        onPressed: () => deleteSubtest(indexSubtest: indexSubtest, indexTest: indexTest),
                                        icon: const Icon(Icons.delete_outline, color: Colors.black),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
      );
    }
  }
}
