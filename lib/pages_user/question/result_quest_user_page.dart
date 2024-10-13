import 'dart:async';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/result_check_user_page.dart';
import 'package:da_administrator/pages_user/question/result_pg_user_page.dart';
import 'package:da_administrator/pages_user/question/result_stuffing_user_page.dart';
import 'package:da_administrator/pages_user/question/result_truefalse_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultQuestUserPage extends StatefulWidget {
  const ResultQuestUserPage({super.key});

  //list hasil user

  @override
  _ResultQuestUserPageState createState() => _ResultQuestUserPageState();
}

class _ResultQuestUserPageState extends State<ResultQuestUserPage> {
  /*dynamic page = ResultTruefalseUserPage(
    question: TrueFalseModel(
      question:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
      type: 'benar_salah',
      image: [],
      trueAnswer: [
        TrueFalseOption(option: 'option1', trueAnswer: true),
        TrueFalseOption(option: 'option2', trueAnswer: true),
        TrueFalseOption(option: 'option3', trueAnswer: true),
        TrueFalseOption(option: 'option4', trueAnswer: true),
      ],
      yourAnswer: [
        TrueFalseOption(option: 'option1', trueAnswer: false),
        TrueFalseOption(option: 'option2', trueAnswer: true),
        TrueFalseOption(option: 'option3', trueAnswer: true),
        TrueFalseOption(option: 'option4', trueAnswer: true),
      ],
      value: 0,
      rating: 0,
      urlVideoExplanation: 'https://youtu.be/pRfmrE0ToTo?si=lfQzFVco5ehOUwD3',
      explanation:
          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
    ),
  );*/

  dynamic page = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.note_alt_rounded, size: 100, color: Colors.black.withOpacity(.3)),
        Text(
          'Pilih soal untuk melihat detail\nketerangan soal yang sudah di jawab',
          style: TextStyle(fontSize: h1, color: Colors.black.withOpacity(.3), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

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

  void onChangeQuestion(int index) {
    switch (listType[index]) {
      case 'banyak_pilihan':
        page = ResultCheckUserPage(
          question: CheckModel(
            question:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
            options: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', 'Jawaban 4', 'Jawaban 5'],
            trueAnswer: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', '@empty', '@empty'],
            type: 'type',
            yourAnswer: ['', '', 'Jawaban 3', 'Jawaban 4', 'Jawaban 5'],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'https://youtu.be/pRfmrE0ToTo?si=lfQzFVco5ehOUwD3',
            explanation:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
          ),
        );
      case 'pilihan_ganda':
        page = ResultPgUserPage(
          question: PgModel(
            question:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
            options: ['Jawaban 1', 'Jawaban 2', 'Jawaban 3', 'Jawaban 4', 'Jawaban 5'],
            trueAnswer: 'Jawaban 2',
            type: 'pilihan_ganda',
            yourAnswer: ['Jawaban 1'],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'https://youtu.be/pRfmrE0ToTo?si=lfQzFVco5ehOUwD3',
            explanation:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
          ),
        );
      case 'isian':
        page = ResultStuffingUserPage(
          question: StuffingModel(
            question:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
            trueAnswer: 'Jawaban 1',
            type: 'isian',
            yourAnswer: ['Jawaban 1'],
            image: [],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'https://youtu.be/pRfmrE0ToTo?si=lfQzFVco5ehOUwD3',
            explanation:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
          ),
        );
      case 'benar_salah':
        page = ResultTruefalseUserPage(
          question: TrueFalseModel(
            question:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
            type: 'benar_salah',
            image: [],
            trueAnswer: [
              TrueFalseOption(option: 'option1', trueAnswer: true),
              TrueFalseOption(option: 'option2', trueAnswer: false),
              TrueFalseOption(option: 'option3', trueAnswer: true),
              TrueFalseOption(option: 'option4', trueAnswer: false),
            ],
            yourAnswer: [
              TrueFalseOption(option: 'option1', trueAnswer: true),
              TrueFalseOption(option: 'option2', trueAnswer: false),
              TrueFalseOption(option: 'option3', trueAnswer: true),
              TrueFalseOption(option: 'option4', trueAnswer: false),
            ],
            value: 0,
            rating: 0,
            urlVideoExplanation: 'https://youtu.be/pRfmrE0ToTo?si=lfQzFVco5ehOUwD3',
            explanation:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s w",
          ),
        );
      default:
        print('Unknown type');
    }
    setState(() {});
  }
  
  void kembaliKeTryout(){
    context.read<CounterProvider>().setTitleUserPage('Dream Academy - TryOut Saya');
    Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
    Navigator.push(context, FadeRoute1(const DetailMytryoutUserPage()));
    // Navigator.pop(context);
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, isLogin: true),
      body: Row(
        children: [
          SizedBox(height: tinggi(context), width: lebar(context) <= 1100 ? 300 : 500, child: sideInfo(context)),
          Expanded(flex: 4, child: Container(margin: const EdgeInsets.only(left: 10), height: tinggi(context), child: page)),
        ],
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: sideInfo(context),
    );
  }

  Widget sideInfo(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextButton(
            onPressed: () => kembaliKeTryout(),
            style: TextButton.styleFrom(backgroundColor: primary),
            child: Text('Kembali ke Dashboard TryOut', style: TextStyle(fontSize: h4, color: Colors.white)),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
          child: Column(
            children: [
              //header
              Text(
                'Try Out UTBK 2024 #9 - SNBT',
                style: TextStyle(fontSize: h2, color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              //nilai
              Container(
                height: 70,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('780', style: TextStyle(fontSize: h1, color: primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    Text('Nilai Rata-rata', style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 70,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('21', style: TextStyle(fontSize: h1, color: primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text('Benar', style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 70,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('9', style: TextStyle(fontSize: h1, color: secondary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text('Salah', style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Container(
                      height: 70,
                      margin: const EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                      alignment: Alignment.center,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('0', style: TextStyle(fontSize: h1, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                          Text('Kosong', style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              //Leaderboard
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text('Leaderboard', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Peringkat Keseluruhan', style: TextStyle(fontSize: h5 + 2, color: Colors.black), textAlign: TextAlign.start),
                        Text('100/50.000 peserta', style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Peringkat Tryout', style: TextStyle(fontSize: h5 + 2, color: Colors.black), textAlign: TextAlign.start),
                        Text('100/50.000 peserta', style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.end),
                      ],
                    ),
                  ],
                ),
              ),
              //raisonalisasi
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Text('Rasionalisas Jurusan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Column(
                  children: List.generate(
                    4,
                    (index) => Container(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black.withOpacity((index == 3) ? 0 : .1))),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('STEI', style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                              Text('Institute Teknologi Bandung', style: TextStyle(fontSize: h5 + 2, color: Colors.black), textAlign: TextAlign.start),
                            ],
                          ),
                          Text('50/1000', style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              //raisonalisasi
              Container(
                margin: const EdgeInsets.only(top: 10),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nilai dan Pembahasan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    InkWell(
                      onTap: () {},
                      child: Text(
                        'Report TO',
                        style: TextStyle(fontSize: h4 - 2, color: Colors.black, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), border: Border.all(color: Colors.black)),
                child: LinearProgressIndicator(borderRadius: BorderRadius.circular(50), color: primary, value: 90 / 100, minHeight: 10),
              ),
              // Cara melihat pembahasan
              Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.grey, size: 20),
                        const SizedBox(width: 5),
                        Text('Cara Melihat Pembahasan', style: TextStyle(fontSize: h4, color: Colors.black), textAlign: TextAlign.start),
                      ],
                    ),
                    Text('Klik nomor soal untuk melihat pembahasan', style: TextStyle(fontSize: h5 + 2, color: Colors.black), textAlign: TextAlign.start),
                  ],
                ),
              ),
              // Test
              Column(
                children: List.generate(
                  2,
                  (index0) {
                    var listTitle = ['TPS', 'Tes Potensi Skolastik'];
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(listTitle[index0], style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            4,
                            (index1) => Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                              child: ExpansionTile(
                                backgroundColor: Colors.white,
                                collapsedBackgroundColor: Colors.white,
                                collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                dense: true,
                                expansionAnimationStyle: AnimationStyle.noAnimation,
                                iconColor: Colors.black,
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Kemampuan Penalaran Umum',
                                        style: TextStyle(fontSize: h4, color: Colors.black),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: primary),
                                      child: Text('300', style: TextStyle(fontSize: h5 + 1, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ),
                                  ],
                                ),
                                children: [
                                  Wrap(
                                    children: List.generate(
                                      30,
                                      (index2) => InkWell(
                                        onTap: () {
                                          onChangeQuestion(index2);
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Container(
                                              height: 40,
                                              width: 40,
                                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primary),
                                              child: Text('${index2 + 1}', style: TextStyle(fontSize: h4, color: Colors.white), textAlign: TextAlign.start),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(50),
                                                  border: Border.all(color: Colors.white),
                                                  color: Colors.white,
                                                ),
                                                child: Icon(Icons.check_circle_rounded, color: primary, size: 20),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: List.generate(3, (index3) => const Icon(Icons.star, color: Colors.orange, size: 15)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
