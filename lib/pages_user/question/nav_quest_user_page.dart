import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/user_to_service.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/user_to/user_to_model.dart';
import 'package:da_administrator/pages_user/question/quest_check_user_page.dart';
import 'package:da_administrator/pages_user/question/quest_pg_user_page.dart';
import 'package:da_administrator/pages_user/question/quest_stuffing_user_page.dart';
import 'package:da_administrator/pages_user/question/quest_truefalse_user_page.dart';
import 'package:da_administrator/pages_user/question/waiting_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:provider/provider.dart';

UserToModel? userTo;
int testKe = 0;
int subTestKe = 0;

class NavQuestUserPage extends StatefulWidget {
  final String idUserTo;
  final int minutes;

  const NavQuestUserPage({super.key, required this.minutes, required this.idUserTo});

  @override
  _NavQuestUserPageState createState() => _NavQuestUserPageState();
}

class _NavQuestUserPageState extends State<NavQuestUserPage> {
  late int totalTimeInMinutes;
  late int remainingTimeInSeconds;
  Timer? timer;
  bool loadingQuest = false;

  dynamic page;
  int soalKe = 0;

  @override
  Widget build(BuildContext context) {
    if (userTo != null) {
      if (lebar(context) <= 700) {
        return onMobile(context);
      } else {
        return onDesk(context);
      }
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary)));
    }
  }

  @override
  void initState() {
    super.initState();
    getDataUserTo();

    totalTimeInMinutes = widget.minutes;
    remainingTimeInSeconds = widget.minutes * 60;
    startTimer();
  }

  void getDataUserTo() async {
    userTo = null;
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('user_to_v1').doc(widget.idUserTo);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        userTo = UserToModel.fromSnapshot(docSnapshot);
        if (userTo != null) {
          for (testKe = 0; testKe < userTo!.listTest.length; testKe++) {
            bool testSelesai = userTo!.listTest[testKe].done;
            if (testSelesai) {
              print('test ke $testKe telah selesai');
              break;
            }
            for (subTestKe = 0; subTestKe < userTo!.listTest[testKe].listSubtest.length; subTestKe++) {
              bool subTestSelesai = userTo!.listTest[testKe].listSubtest[subTestKe].done;
              if (subTestSelesai) {
                print('test ke $testKe, sub test ke $subTestKe telah selesai');
                break;
              } else if (!subTestSelesai) {
                // testKe = i;
                // subTestKe = j;
                print('sekarang kerja soal test ke $testKe, sub test ke $subTestKe');
                setQuestion(soalKe);
                return; // Menghentikan seluruh perulangan setelah menemukan nilai false
              }
            }
          }
        }
      }
      setState(() {});
    } catch (e) {
      print('salah detail_tryout_user_page user tryout: $e');
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (remainingTimeInSeconds > 0) {
          remainingTimeInSeconds--;
        } else {
          timer.cancel();
          print("waktu habis");
          timeOut(context);
        }
      });
    });
  }

  Future<void> timeOut(BuildContext context) async {
    context.read<CounterProvider>().setTitleUserPage('Dream Academy');
    await onClickQust(soalKe, onSave: true);
    if (testKe == (userTo!.listTest.length - 1)) {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute1(WaitingUserPage(minutes: 3, isLast: true, idUserTo: widget.idUserTo)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute1(WaitingUserPage(minutes: 3, isLast: false, idUserTo: widget.idUserTo)),
        (Route<dynamic> route) => false,
      );
    }
  }

  void setQuestion(int indexQuest) {
    switch (userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[indexQuest].type) {
      case 'banyak_pilihan':
        page = QuestCheckUserPage(indexQuest: indexQuest);
      case 'pilihan_ganda':
        page = QuestPgUserPage(indexQuest: indexQuest);
      case 'isian':
        page = QuestStuffingUserPage(indexQuest: indexQuest);
      case 'benar_salah':
        page = QuestTruefalseUserPage(indexQuest: indexQuest);
      default:
        print('Unknown type');
    }
    // setState(() {});
    // for (int i = 0; i < listType.length; i++) {}
  }

  Future<void> onClickQust(int indexQuest, {bool onSave = false}) async {
    setState(() => loadingQuest = !loadingQuest);
    soalKe = indexQuest;
    setQuestion(soalKe);
    //save
    if (onSave) {
      if (userTo != null) {
        await UserToService.edit(
          id: widget.idUserTo,
          userUID: userTo!.userUID,
          idTryOut: userTo!.idTryOut,
          toName: userTo!.toName,
          valuesDiscussion: userTo!.valuesDiscussion,
          average: userTo!.average,
          correctAnswer: userTo!.correctAnswer,
          wrongAnswer: userTo!.wrongAnswer,
          startWork: userTo!.startWork,
          endWork: DateTime.now(),
          created: userTo!.created,
          leaderBoard: userTo!.leaderBoard,
          rationalization: userTo!.rationalization,
          listTest: userTo!.listTest,
        );
      }
    }
    //save
    // await Future.delayed(const Duration(milliseconds: 200));
    setState(() => loadingQuest = !loadingQuest);
  }

  Future<void> showSelesaikan({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Ingin selesaikan sekarang?', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
                TextButton(
                  onPressed: () async {
                    userTo!.listTest[testKe].listSubtest[subTestKe].done = true;
                    if (testKe == (userTo!.listTest.length - 1)) {
                      await onClickQust(soalKe, onSave: true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        FadeRoute1(WaitingUserPage(minutes: 3, isLast: true, idUserTo: widget.idUserTo)),
                        (Route<dynamic> route) => false,
                      );
                    } else if (subTestKe == (userTo!.listTest[testKe].listSubtest.length - 1)) {
                      userTo!.listTest[testKe].done = true;
                      await onClickQust(soalKe, onSave: true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        FadeRoute1(WaitingUserPage(minutes: 3, isLast: false, idUserTo: widget.idUserTo)),
                        (Route<dynamic> route) => false,
                      );
                    } else {
                      await onClickQust(soalKe, onSave: true);
                      Navigator.pushAndRemoveUntil(
                        context,
                        FadeRoute1(WaitingUserPage(minutes: 3, isLast: false, idUserTo: widget.idUserTo)),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Text('Ya', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.normal)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget onDesk(BuildContext context) {
    int minutes = remainingTimeInSeconds ~/ 60;
    int seconds = remainingTimeInSeconds % 60;
    int jmlSoal = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions.length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        toolbarHeight: 60,
        leadingWidth: 0,
        leading: const SizedBox(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(userTo!.toName, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h3)),
            Text(
              '${userTo!.listTest[testKe].nameTest} - ${userTo!.listTest[testKe].listSubtest[subTestKe].nameSubTest}',
              style: TextStyle(color: Colors.black, fontSize: h4),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Sisa Waktu', style: TextStyle(color: Colors.black, fontSize: h4)),
                    Text('${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}', style: TextStyle(color: Colors.black, fontSize: h4)),
                  ],
                ),
                LinearProgressIndicator(
                  minHeight: 10,
                  value: remainingTimeInSeconds / (totalTimeInMinutes * 60),
                  backgroundColor: Colors.black.withOpacity(.2),
                  valueColor: AlwaysStoppedAnimation<Color>((minutes <= 10) ? Colors.orange : Colors.blue),
                  borderRadius: BorderRadius.circular(50),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: tinggi(context),
              alignment: Alignment.center,
              child: loadingQuest ? CircularProgressIndicator(color: primary, strokeAlign: 10) : page,
            ),
          ),
          SizedBox(
            height: tinggi(context),
            width: 250,
            child: ListView(
              children: [
                Container(
                  height: 500,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey),
                      ),
                      Text('Ismail Bin Mail', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      const Expanded(child: SizedBox()),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          jmlSoal,
                          (index0) {
                            List<String> yourAnswer = [];
                            // bool isNotTrueFalse;
                            if (userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[index0].type == 'benar_salah') {
                              // isNotTrueFalse = true;
                              List<TrueFalseOption> yourAnswerTrueFalse = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[index0].yourAnswer;
                              yourAnswer = List.generate(yourAnswerTrueFalse.length, (i) => yourAnswerTrueFalse[i].option);
                            } else {
                              // isNotTrueFalse = false;
                              yourAnswer = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[index0].yourAnswer;
                            }
                            bool isiKosong = yourAnswer.every((element) => element.isEmpty);
                            return InkWell(
                              onTap: () => onClickQust(index0, onSave: true),
                              child: Container(
                                height: 35,
                                width: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: (soalKe == index0) ? primary : Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                  color: (soalKe == index0)
                                      ? Colors.white
                                      : (yourAnswer.isNotEmpty)
                                          ? isiKosong
                                              ? Colors.grey
                                              : primary
                                          : Colors.grey,
                                ),
                                child: Text('${index0 + 1}', style: TextStyle(color: (soalKe == index0) ? primary : Colors.white, fontSize: h4)),
                              ),
                            );
                          },
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      SizedBox(
                        height: 65,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () {
                                  if (soalKe >= 1) {
                                    onClickQust(soalKe - 1, onSave: true);
                                  }
                                },
                                style: TextButton.styleFrom(backgroundColor: Colors.grey),
                                icon: const Icon(Icons.keyboard_double_arrow_left_rounded, color: Colors.white),
                                iconAlignment: IconAlignment.start,
                                label: Text('Sebelumnya', style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal)),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 30,
                              width: double.infinity,
                              child: TextButton.icon(
                                onPressed: () async {
                                  if (soalKe + 1 < jmlSoal) {
                                    onClickQust(soalKe + 1, onSave: true);
                                  } else if (soalKe + 1 == jmlSoal) {
                                    await showSelesaikan(context: context);
                                  }
                                },
                                style: TextButton.styleFrom(backgroundColor: (soalKe + 1 == jmlSoal) ? secondary : primary),
                                icon: const Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.white),
                                iconAlignment: IconAlignment.end,
                                label: Text(
                                  (soalKe + 1 == jmlSoal) ? 'Selesaikan' : 'Selanjutnya',
                                  style: TextStyle(color: Colors.white, fontSize: h4, fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
