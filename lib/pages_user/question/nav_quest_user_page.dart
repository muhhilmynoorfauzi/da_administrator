import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
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

class NavQuestUserPage extends StatefulWidget {
  const NavQuestUserPage({super.key, required this.minutes});

  final int minutes;

  @override
  _NavQuestUserPageState createState() => _NavQuestUserPageState();
}

class _NavQuestUserPageState extends State<NavQuestUserPage> {
  bool loadingQuest = false;
  var jmlSoal = 30;

  dynamic quest;
  dynamic page;
  var listType = [
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'banyak_pilihan',
    'pilihan_ganda',
    'isian',
    'benar_salah',
    'pilihan_ganda',
    'isian',
  ];

  late int totalTimeInMinutes;
  late int remainingTimeInSeconds; // 30 minutes in seconds
  Timer? timer;

  int questId = 0;

  @override
  void initState() {
    super.initState();
    totalTimeInMinutes = widget.minutes;
    remainingTimeInSeconds = widget.minutes * 60;
    setQuestion(questId);
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (remainingTimeInSeconds > 0) {
          remainingTimeInSeconds--;
        } else {
          timer.cancel();
          print("waktu habis"); // Tambahkan perintah print di sini
        }
      });
    });
  }

  void setQuestion(int id) {
    switch (listType[id]) {
      case 'banyak_pilihan':
        page = QuestCheckUserPage(
          question: CheckModel(
            question: 'question',
            options: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', 'Jawaban 4', 'Jawaban 5'],
            trueAnswer: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', '@empty', '@empty'],
            type: 'type',
            yourAnswer: [],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'urlVideoExplanation',
            explanation: 'explanation',
          ),
        );
      case 'pilihan_ganda':
        page = QuestPgUserPage(
          question: PgModel(
            question: 'question',
            options: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', 'Jawaban 4', 'Jawaban 5'],
            trueAnswer: 'Jawaban 2',
            type: 'type',
            yourAnswer: [],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'urlVideoExplanation',
            explanation: 'explanation',
          ),
        );
      case 'isian':
        page = QuestStuffingUserPage(
          question: StuffingModel(
            question: 'question',
            trueAnswer: 'Jawaban 1',
            type: 'type',
            yourAnswer: [],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'urlVideoExplanation',
            explanation: 'explanation',
          ),
        );
      case 'benar_salah':
        page = QuestTruefalseUserPage(
          question: TrueFalseModel(
            question: 'question',
            type: 'type',
            image: [],
            trueAnswer: [
              TrueFalseOption(option: 'option1', trueAnswer: true),
              TrueFalseOption(option: 'option2', trueAnswer: false),
              TrueFalseOption(option: 'option3', trueAnswer: true),
              TrueFalseOption(option: 'option4', trueAnswer: false),
            ],
            yourAnswer: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'urlVideoExplanation',
            explanation: 'explanation',
          ),
        );
      default:
        print('Unknown type');
    }
    setState(() {});
    // for (int i = 0; i < listType.length; i++) {}
  }

  Future<void> onClickQust(int index) async {
    setState(() => questId = index);
    setQuestion(questId);
    setState(() => loadingQuest = !loadingQuest);
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => loadingQuest = !loadingQuest);
  }

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    int minutes = remainingTimeInSeconds ~/ 60;
    int seconds = remainingTimeInSeconds % 60;
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
            Text('Try Out UTBK 2024 #9 - SNBT', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h3)),
            Text('TPS - Kemampuan Penalaran Umum', style: TextStyle(color: Colors.black, fontSize: h4)),
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
                          (index) {
                            var sudahJawab = ['1', '2', '3', '4', '5', '6', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', '', ''];
                            return InkWell(
                              onTap: () => onClickQust(index),
                              child: Container(
                                height: 35,
                                width: 35,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: (questId == index) ? primary : Colors.transparent),
                                  borderRadius: BorderRadius.circular(10),
                                  color: (questId == index)
                                      ? Colors.white
                                      : (sudahJawab[index] != '')
                                          ? primary
                                          : Colors.grey,
                                ),
                                child: Text('${index + 1}', style: TextStyle(color: (questId == index) ? primary : Colors.white, fontSize: h4)),
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
                                  if (questId >= 1) {
                                    onClickQust(questId - 1);
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
                                onPressed: () {
                                  if (questId + 1 < jmlSoal) {
                                    onClickQust(questId + 1);
                                  } else if (questId + 1 == jmlSoal) {
                                    context.read<CounterProvider>().setTitleUserPage('Dream Academy');
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      FadeRoute1(const WaitingUserPage(minutes: 1, isLast: true)),
                                      (Route<dynamic> route) => false,
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(backgroundColor: (questId + 1 == jmlSoal) ? secondary : primary),
                                icon: const Icon(Icons.keyboard_double_arrow_right_rounded, color: Colors.white),
                                iconAlignment: IconAlignment.end,
                                label: Text(
                                  (questId + 1 == jmlSoal) ? 'Selesaikan' : 'Selanjutnya',
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
}
