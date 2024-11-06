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

  const NavQuestUserPage({super.key, required this.idUserTo});

  @override
  _NavQuestUserPageState createState() => _NavQuestUserPageState();
}

class _NavQuestUserPageState extends State<NavQuestUserPage> {
  late Timer _timer;
  late double _remainingTime; // Menyimpan waktu yang tersisa dalam detik
  double _progress = 1.0; // Progres untuk LinearProgressIndicator (0 hingga 1)

  bool loadingQuest = false;

  dynamic page;
  int soalKe = 0;

  @override
  Widget build(BuildContext context) {
    if (userTo != null) {
      if (lebar(context) <= 900) {
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
    super.initState();
    getDataUserTo();
  }

  void getDataUserTo() async {
    userTo = null;
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('user_to_v2').doc(widget.idUserTo);
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
              } else {
                if (userTo!.listTest[testKe].listSubtest[subTestKe].remainingTime != 0) {
                  _remainingTime = userTo!.listTest[testKe].listSubtest[subTestKe].remainingTime;
                } else {
                  _remainingTime = userTo!.listTest[testKe].listSubtest[subTestKe].timeMinute;
                }

                print('sekarang kerja soal test ke $testKe, sub test ke $subTestKe');
                setQuestion(soalKe);
                startTimer();

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

  String formatMinute(double seconds) {
    int totalSeconds = seconds.round();
    int minutes = totalSeconds ~/ 60;
    int secondsPart = totalSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = secondsPart.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  void startTimer() {
    const int interval = 1000; // 1000 milidetik atau 1 detik
    _timer = Timer.periodic(const Duration(milliseconds: interval), (timer) {
      setState(() {
        _remainingTime -= 1; // Kurangi 1 detik setiap interval
        _progress = _remainingTime / userTo!.listTest[testKe].listSubtest[subTestKe].timeMinute;

        if (_remainingTime <= 0) {
          timer.cancel();
          _progress = 0;
          print("Waktu habis");
          timeOut(context);
        }
      });
    });
  }

  Future<void> timeOut(BuildContext context) async {
    await onClickQust(soalKe, onSave: true);
    if (testKe == (userTo!.listTest.length - 1)) {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute1(WaitingUserPage(second: 30, isLast: true, idUserTo: widget.idUserTo)),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        FadeRoute1(WaitingUserPage(second: 30, isLast: false, idUserTo: widget.idUserTo)),
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
  }

  Future<void> onClickQust(int indexQuest, {bool onSave = false}) async {
    setState(() => loadingQuest = !loadingQuest);
    soalKe = indexQuest;
    userTo!.listTest[testKe].listSubtest[subTestKe].remainingTime = _remainingTime;
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
          unanswered: userTo!.unanswered,
          correctAnswer: userTo!.correctAnswer,
          wrongAnswer: userTo!.wrongAnswer,
          startWork: userTo!.startWork,
          endWork: userTo!.endWork,
          created: userTo!.created,
          leaderBoard: userTo!.leaderBoard,
          rationalization: userTo!.rationalization,
          listTest: userTo!.listTest,
        );
      }
    }
    setState(() => loadingQuest = !loadingQuest);
  }

  Future<void> markAsDoneAndNavigate({
    required BuildContext context,
    required int testKe,
    required int subTestKe,
    required int soalKe,
    required bool isLastTest,
    required bool isLastSubTest,
  }) async {
    // Mark subtest as done
    userTo!.listTest[testKe].listSubtest[subTestKe].done = true;

    // Check if test should also be marked as done
    if (isLastSubTest) {
      userTo!.listTest[testKe].done = true;
    }

    // If it's the very last test and subtest, mark the entire work as done
    if (isLastTest && isLastSubTest) {
      userTo!.endWork = DateTime.now();
    }

    // Save the question
    await onClickQust(soalKe, onSave: true);

    // Navigate to the next page
    Navigator.pushAndRemoveUntil(
      context,
      FadeRoute1(WaitingUserPage(second: 30, isLast: isLastTest && isLastSubTest, idUserTo: widget.idUserTo)),
      (Route<dynamic> route) => false,
    );
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
                    int lastTest = (userTo!.listTest.length - 1);
                    int lastSubTest = (userTo!.listTest[testKe].listSubtest.length - 1);

                    bool isLastTest = testKe == lastTest;
                    bool isLastSubTest = subTestKe == lastSubTest;

                    if (isLastTest && isLastSubTest) {
                      print('ini test terakhir dan subtest terakhir');
                    } else if (!isLastTest && isLastSubTest) {
                      print('ini bukan test terakhir tapi subtest terakhir dari test ke ${testKe + 1}');
                    } else if (isLastTest && !isLastSubTest) {
                      print('ini test terakhir tapi bukan subtest terakhir');
                    } else {
                      print('ini bukan test terakhir dan bukan subtest terakhir');
                    }

                    await markAsDoneAndNavigate(context: context, testKe: testKe, subTestKe: subTestKe, soalKe: soalKe, isLastTest: isLastTest, isLastSubTest: isLastSubTest);
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
                    Text("Waktu tersisa:", style: TextStyle(color: Colors.black, fontSize: h4)),
                    Text(" ${formatMinute(_remainingTime)}", style: TextStyle(color: Colors.black, fontSize: h4)),
                  ],
                ),
                LinearProgressIndicator(
                  value: _progress,
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor: Colors.black.withOpacity(.2),
                  valueColor: AlwaysStoppedAnimation<Color>((_remainingTime <= 600000) ? Colors.orange : Colors.blue),
                  color: Colors.blue,
                  minHeight: 10,
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
              child: loadingQuest ? CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3) : page,
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

  Widget onMo(BuildContext context) {
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
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Waktu tersisa:", style: TextStyle(color: Colors.black, fontSize: h4)),
                      Text(" ${formatMinute(_remainingTime)}", style: TextStyle(color: Colors.black, fontSize: h4)),
                    ],
                  ),
                  LinearProgressIndicator(
                    value: _progress,
                    borderRadius: BorderRadius.circular(20),
                    backgroundColor: Colors.black.withOpacity(.2),
                    valueColor: AlwaysStoppedAnimation<Color>((_remainingTime <= 600000) ? Colors.orange : Colors.blue),
                    color: Colors.blue,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: tinggi(context),
            width: lebar(context),
            alignment: Alignment.center,
            child: loadingQuest ? CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3) : page,
          ),
          Center(
            child: Container(
              height: 500,
              width: 500,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.grey),
                  ),
                  Text('Ismail Bin Mail', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Center(
                      child: Wrap(
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
                    ),
                  ),
                  //
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                height: 30,
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
              const SizedBox(width: 5),
              SizedBox(
                height: 30,
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
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
