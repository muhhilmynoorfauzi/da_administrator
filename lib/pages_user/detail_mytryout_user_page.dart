import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/user_to_service.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_to/rationalization_model.dart';
import 'package:da_administrator/model/user_to/user_subtest_model.dart';
import 'package:da_administrator/model/user_to/user_test_model.dart';
import 'package:da_administrator/model/user_to/user_to_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/result_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/show_image_page.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailMytryoutUserPage extends StatefulWidget {
  final String idTryOut;
  final bool approval;
  final TryoutModel myTryout;

  const DetailMytryoutUserPage({super.key, required this.idTryOut, required this.myTryout, required this.approval});

  @override
  State<DetailMytryoutUserPage> createState() => _DetailMytryoutUserPageState();
}

class _DetailMytryoutUserPageState extends State<DetailMytryoutUserPage> {
  String userUid = 'bBm35Y9GYcNR8YHu2bybB61lyEr1';
  ProfileUserModel? profile;

  List<QuestionsModel> allQuestion = [];
  List<String> idAllQuestion = [];

  List<UserTestModel> listTest = [];

  List<UserToModel> allUserTo = [];
  List<String> idAllUserTo = [];

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);
    profile = profider.getProfile;
    if (profider.getProfile == null) {
      getDataProfile();
    }
    getDataQuestion();
    getDataUserTo();
  }

  String formatMinutes(double seconds) {
    double minutes = seconds / 60; // Konversi detik ke menit
    return minutes.toStringAsFixed(1); // Mengembalikan nilai string dengan 1 angka di belakang koma
  }

  void getDataQuestion() async {
    allQuestion = [];
    idAllQuestion = [];
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('questions_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allQuestion = querySnapshot.docs.map((doc) => QuestionsModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllQuestion = querySnapshot.docs.map((doc) => doc.id).toList();

      if (allQuestion.isNotEmpty) {
        listTest = List.generate(
          widget.myTryout.listTest.length,
          (index0) => UserTestModel(
            done: false,
            nameTest: widget.myTryout.listTest[index0].nameTest,
            listSubtest: List.generate(
              widget.myTryout.listTest[index0].listSubtest.length,
              (index1) {
                QuestionsModel userQuestion = QuestionsModel(idTryOut: '', listQuestions: []);
                for (int i = 0; i < idAllQuestion.length; i++) {
                  if (idAllQuestion[i] == widget.myTryout.listTest[index0].listSubtest[index1].idQuestions) {
                    userQuestion = allQuestion[i];
                  }
                }
                return UserSubtestModel(
                  done: false,
                  nameSubTest: widget.myTryout.listTest[index0].listSubtest[index1].nameSubTest,
                  timeMinute: widget.myTryout.listTest[index0].listSubtest[index1].timeMinute,
                  totalSubtest: 0,
                  remainingTime: 0,
                  listQuestions: userQuestion.listQuestions,
                );
              },
            ),
          ),
        );
      }

      setState(() {});
    } catch (e) {
      print('salah detail_tryout_user_page data quest: $e');
    }
  }

  void getDataUserTo() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('user_to_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      allUserTo = querySnapshot.docs.map((doc) => UserToModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllUserTo = querySnapshot.docs.map((doc) => doc.id).toList();

      setState(() {});
    } catch (e) {
      print('salah detail_mytryout : $e');
    }
  }

  void getDataProfile() async {
    profile = null;
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('profile_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      List<ProfileUserModel> allProfile = querySnapshot.docs.map((doc) => ProfileUserModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      bool userFound = false;

      for (int i = 0; i < allProfile.length; i++) {
        if (allProfile[i].userUID == userUid) {
          print('User Ditemukan');
          profile = allProfile[i];
          userFound = true;

          setState(() {});
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
    } catch (e) {
      print('salah getDataProfile: $e');
    }
    setState(() {});
  }

  Future<void> onPressMulai(BuildContext context) async {
    var userToModel = UserToModel(
      userUID: userUid,
      idTryOut: widget.idTryOut,
      toName: widget.myTryout.toName,
      valuesDiscussion: 0,
      average: 0,
      unanswered: 0,
      correctAnswer: 0,
      wrongAnswer: 0,
      startWork: DateTime.now(),
      endWork: DateTime(0),
      created: DateTime.now(),
      leaderBoard: [],
      rationalization: [
        RationalizationModel(value: 0, jurusan: profile!.listPlan[0].jurusan, universitas: profile!.listPlan[0].universitas),
        RationalizationModel(value: 0, jurusan: profile!.listPlan[1].jurusan, universitas: profile!.listPlan[1].universitas),
        RationalizationModel(value: 0, jurusan: profile!.listPlan[2].jurusan, universitas: profile!.listPlan[2].universitas),
        RationalizationModel(value: 0, jurusan: profile!.listPlan[3].jurusan, universitas: profile!.listPlan[3].universitas),
      ],
      listTest: listTest,
    );
    if (allUserTo.isNotEmpty) {
      bool isFound = false;
      String id = '';
      for (int i = 0; i < allUserTo.length; i++) {
        if (allUserTo[i].userUID == userUid) {
          isFound = true;
          id = idAllUserTo[i];
          print('sudah ada');
          return;
        }
      }
      if (isFound) {
        Navigator.pushAndRemoveUntil(
          context,
          FadeRoute1(NavQuestUserPage(idUserTo: id)),
          (Route<dynamic> route) => false,
        );
      } else {
        print('sudah ada tapi bukan punya dia');
        String idUserToModel = await UserToService.addGetId(userToModel);
        Navigator.pushAndRemoveUntil(
          context,
          FadeRoute1(NavQuestUserPage(idUserTo: idUserToModel)),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      print('belum ada list, userTO masih kosong');
      String idUserToModel = await UserToService.addGetId(userToModel);
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute1(NavQuestUserPage(idUserTo: idUserToModel)),
        (Route<dynamic> route) => false,
      );
    }
  }

  void onPressResult(BuildContext context) {
    // cari to yang sesuai dengan user
    for (int i = 0; i < allQuestion.length; i++) {}

    // cari user to yang sesuai dengan uid
    for (int i = 0; i < allUserTo.length; i++) {
      if (allUserTo[i].userUID == userUid) {
        print('user to sudah dapat');

        Navigator.pushReplacement(
          context,
          FadeRoute1(
            ResultQuestUserPage(userIndex: i, idUserTo: idAllUserTo[i], allUserTo: allUserTo, allQuestion: allQuestion, myTryout: widget.myTryout),
          ),
        );
        return;
      }
    }
    //
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(dateTime);
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(
        context: context,
        featureActive: true,
      ),
      body: ListView(
        children: [
          //tombol kembali
          Container(
            width: double.infinity,
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
                  Text('TryOut Saya', style: TextStyle(fontSize: h4, color: Colors.black))
                ],
              ),
            ),
          ),
          //Image dan deskripsi
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Container(
              width: 1000,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                        child: InkWell(
                          onTap: () => Navigator.push(context, FadeRoute1(ShowImagePage(image: widget.myTryout.image))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: CachedNetworkImage(
                                imageUrl: widget.myTryout.image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.myTryout.toName,
                                      style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (!widget.approval)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                      decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(50)),
                                      child: Text(
                                        'Sedang mengkonfirmasi',
                                        style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              Text(
                                '${formatDateTime(widget.myTryout.started)} s.d. ${formatDateTime(widget.myTryout.ended)}',
                                style: TextStyle(fontSize: h4, color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                widget.myTryout.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                              ),
                              const Expanded(child: SizedBox()),
                              const SizedBox(height: 10),
                              StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState) {
                                  bool allDone = false;
                                  bool notFirstTime = false;

                                  if (allUserTo.isNotEmpty) {
                                    for (int i = 0; i < allUserTo.length; i++) {
                                      if (allUserTo[i].userUID == userUid) {
                                        notFirstTime = allUserTo[i].listTest.first.listSubtest.first.done;
                                        allDone = allUserTo[i].listTest.last.done;
                                        setState(() {});
                                        break;
                                      }
                                    }
                                  }
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        (widget.myTryout.phase)
                                            ? Container(
                                                height: 30,
                                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                                child: Text('Fase tryout telah selesai', style: TextStyle(fontSize: h4, color: Colors.white)),
                                              )
                                            : (widget.approval)
                                                ? (allDone)
                                                    ? Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                            alignment: Alignment.center,
                                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                                            child: Text('Semua soal Tryout telah selesai', style: TextStyle(fontSize: h4, color: Colors.white)),
                                                          ),
                                                          const SizedBox(height: 5),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: [
                                                              const Icon(Icons.info, color: Colors.grey),
                                                              const SizedBox(width: 5),
                                                              Text(
                                                                'Detail pengerjaan dan nilai dapat dilihat setelah fase tryout telah selesai',
                                                                style: TextStyle(fontSize: h4, color: Colors.grey),
                                                                textAlign: TextAlign.left,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : SizedBox(
                                                        height: 30,
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            onPressMulai(context);
                                                          },
                                                          style: OutlinedButton.styleFrom(
                                                            side: BorderSide(color: primary),
                                                            padding: const EdgeInsets.symmetric(horizontal: 30),
                                                            backgroundColor: primary,
                                                          ),
                                                          child: Text(
                                                            notFirstTime ? 'Lanjut mengerjakan' : 'Mulai Mengerjakan',
                                                            style: TextStyle(fontSize: h4, color: Colors.white),
                                                          ),
                                                        ),
                                                      )
                                                : Container(
                                                    height: 30,
                                                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                                    child: Text('Proses', style: TextStyle(fontSize: h4, color: Colors.white)),
                                                  ),
                                        const SizedBox(width: 10),
                                        if (widget.myTryout.phase)
                                          SizedBox(
                                            height: 30,
                                            child: OutlinedButton(
                                              onPressed: () => onPressResult(context),
                                              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(horizontal: 30)),
                                              child: Text('Detail Pengerjaan', style: TextStyle(fontSize: h4, color: Colors.black)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Rincian Test
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //fase
                  Container(
                    height: 200,
                    width: 300,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) {
                          var icon = [Icons.calendar_month_rounded, Icons.timer, Icons.note_alt_rounded];
                          var title = ['Fase TO', 'Total Waktu', 'Jumlah Soal'];
                          var deks = [widget.myTryout.phase ? 'Selesai' : 'Belum Selesai', (formatMinutes(widget.myTryout.totalTime)), '${widget.myTryout.numberQuestions}'];
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: index != 2 ? Colors.black.withOpacity(.1) : Colors.transparent))),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                    child: Icon(icon[index], color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(title[index], style: TextStyle(fontSize: h4, color: Colors.black)),
                                  const Expanded(child: SizedBox()),
                                  Text(deks[index], style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        widget.myTryout.listTest.length,
                        (index0) {
                          var test = widget.myTryout.listTest[index0];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.circle, color: primary, size: 15),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(test.nameTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: List.generate(
                                  test.listSubtest.length,
                                  (index1) {
                                    String jumlahSoal = '0';
                                    var subTest = test.listSubtest[index1];

                                    for (int i = 0; i < idAllQuestion.length; i++) {
                                      if (idAllQuestion[i] == subTest.idQuestions) {
                                        jumlahSoal = '${allQuestion[i].listQuestions.length}';
                                      }
                                    }
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(subTest.nameSubTest, style: TextStyle(fontSize: h4, color: Colors.black)),
                                          Text(
                                            '${formatMinutes(subTest.timeMinute)} Menit | $jumlahSoal Soal',
                                            style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 50),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          footerDesk(context: context),
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
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                      child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                    ),
                  ),
                  Text('TryOut Saya', style: TextStyle(fontSize: h4, color: Colors.black))
                ],
              ),
            ),
          ),
          //Image dan deskripsi
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Container(
              width: 1000,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: 250,
                      child: InkWell(
                        onTap: () => Navigator.push(context, FadeRoute1(ShowImagePage(image: widget.myTryout.image))),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: CachedNetworkImage(
                              imageUrl: widget.myTryout.image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                widget.myTryout.toName,
                                style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (!widget.approval)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                                decoration: BoxDecoration(color: secondary, borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  'Sedang mengkonfirmasi',
                                  style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                        Text(
                          '${formatDateTime(widget.myTryout.started)} s.d. ${formatDateTime(widget.myTryout.ended)}',
                          style: TextStyle(fontSize: h4, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.myTryout.desk,
                          style: TextStyle(fontSize: h4, color: Colors.black),
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 5,
                        ),
                        const Expanded(child: SizedBox()),
                        const SizedBox(height: 10),
                        StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            bool allDone = false;
                            bool notFirstTime = false;

                            if (allUserTo.isNotEmpty) {
                              for (int i = 0; i < allUserTo.length; i++) {
                                if (allUserTo[i].userUID == userUid) {
                                  notFirstTime = allUserTo[i].listTest.first.listSubtest.first.done;
                                  allDone = allUserTo[i].listTest.last.done;
                                  setState(() {});
                                  break;
                                }
                              }
                            }
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  (widget.myTryout.phase)
                                      ? Container(
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                          child: Text('Fase tryout telah selesai', style: TextStyle(fontSize: h4, color: Colors.white)),
                                        )
                                      : (widget.approval)
                                          ? (allDone)
                                              ? Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 30,
                                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                                      child: Text('Semua soal Tryout telah selesai', style: TextStyle(fontSize: h4, color: Colors.white)),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        const Icon(Icons.info, color: Colors.grey),
                                                        const SizedBox(width: 5),
                                                        Text(
                                                          'Detail pengerjaan dan nilai dapat dilihat setelah fase tryout telah selesai',
                                                          style: TextStyle(fontSize: h4, color: Colors.grey),
                                                          textAlign: TextAlign.left,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(
                                                  height: 30,
                                                  child: OutlinedButton(
                                                    onPressed: () {
                                                      onPressMulai(context);
                                                    },
                                                    style: OutlinedButton.styleFrom(
                                                      side: BorderSide(color: primary),
                                                      padding: const EdgeInsets.symmetric(horizontal: 30),
                                                      backgroundColor: primary,
                                                    ),
                                                    child: Text(
                                                      notFirstTime ? 'Lanjut mengerjakan' : 'Mulai Mengerjakan',
                                                      style: TextStyle(fontSize: h4, color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                          : Container(
                                              height: 30,
                                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: secondary),
                                              child: Text('Proses', style: TextStyle(fontSize: h4, color: Colors.white)),
                                            ),
                                  const SizedBox(width: 10),
                                  if (widget.myTryout.phase)
                                    SizedBox(
                                      height: 30,
                                      child: OutlinedButton(
                                        onPressed: () => onPressResult(context),
                                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(horizontal: 30)),
                                        child: Text('Detail Pengerjaan', style: TextStyle(fontSize: h4, color: Colors.black)),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Rincian Test
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //fase
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: List.generate(
                        3,
                        (index) {
                          var icon = [Icons.calendar_month_rounded, Icons.timer, Icons.note_alt_rounded];
                          var title = ['Fase TO', 'Total Waktu', 'Jumlah Soal'];
                          var deks = [widget.myTryout.phase ? 'Selesai' : 'Belum Selesai', (formatMinutes(widget.myTryout.totalTime)), '${widget.myTryout.numberQuestions}'];
                          return Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: index != 2 ? Colors.black.withOpacity(.1) : Colors.transparent))),
                              child: Row(
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                    child: Icon(icon[index], color: Colors.white),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(title[index], style: TextStyle(fontSize: h4, color: Colors.black)),
                                  const Expanded(child: SizedBox()),
                                  Text(deks[index], style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  //test
                  Column(
                    children: List.generate(
                      widget.myTryout.listTest.length,
                      (index0) {
                        var test = widget.myTryout.listTest[index0];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.circle, color: primary, size: 15),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(test.nameTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: List.generate(
                                test.listSubtest.length,
                                (index1) {
                                  String jumlahSoal = '0';
                                  var subTest = test.listSubtest[index1];

                                  for (int i = 0; i < idAllQuestion.length; i++) {
                                    if (idAllQuestion[i] == subTest.idQuestions) {
                                      jumlahSoal = '${allQuestion[i].listQuestions.length}';
                                    }
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(subTest.nameSubTest, style: TextStyle(fontSize: h4, color: Colors.black)),
                                        Text(
                                          '${formatMinutes(subTest.timeMinute)} Menit | $jumlahSoal Soal',
                                          style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 50),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          footerMo(context: context),
        ],
      ),
    );
  }
}
