// QuestTruefalseUserPage
import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuestTruefalseUserPage extends StatefulWidget {
  const QuestTruefalseUserPage({super.key, required this.indexQuest});

  final int indexQuest;

  @override
  State<QuestTruefalseUserPage> createState() => _QuestTruefalseUserPageState();
}

class _QuestTruefalseUserPageState extends State<QuestTruefalseUserPage> {
  var isLogin = true;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  TrueFalseModel? question;

  List<TrueFalseOption> listJawaban = [];

  // int idSelected = 0;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    question = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest];
    if (question != null) {
      if (question!.yourAnswer.isNotEmpty) {
        listJawaban = question!.yourAnswer;
      } else {
        listJawaban = List.generate(question!.trueAnswer.length, (index) => TrueFalseOption(option: '', trueAnswer: false));
      }
    }
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(right: 10, bottom: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (question!.image.isNotEmpty)
                  Column(
                    children: List.generate(
                      question!.image.length,
                          (index) {
                        if (question!.image[index] != '') {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: AspectRatio(
                              aspectRatio: 5 / 1,
                              child: CachedNetworkImage(
                                imageUrl: question!.image[index]!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      },
                    ),
                  ),
                QuillEditor.basic(
                  configurations: QuillEditorConfigurations(
                    controller: QuillController(
                      document: Document.fromHtml(question!.question),
                      selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                      readOnly: true,
                    ),
                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              question!.trueAnswer.length,
              (index0) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: lebar(context) * .55,
                      margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                      child: Row(
                        children: [
                          Expanded(child: Text(question!.trueAnswer[index0].option, style: TextStyle(color: Colors.black, fontSize: h4))),
                          InkWell(
                            onTap: () {
                              listJawaban[index0].option = question!.trueAnswer[index0].option;
                              listJawaban[index0].trueAnswer = true;
                              // setState(() => idSelected = 0);
                              question!.yourAnswer = listJawaban;
                              setState(() => userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest] = question!);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (listJawaban[index0].trueAnswer == true) ? primary : Colors.black),
                                color: (listJawaban[index0].trueAnswer == true) ? primary : Colors.white,
                              ),
                              child: Text('Benar', style: TextStyle(color: (listJawaban[index0].trueAnswer == true) ? Colors.white : Colors.black, fontSize: h4)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              listJawaban[index0].option = question!.trueAnswer[index0].option;
                              listJawaban[index0].trueAnswer = false;
                              // setState(() => idSelected = 1);
                              question!.yourAnswer = listJawaban;
                              setState(() => userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest] = question!);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (listJawaban[index0].trueAnswer == false) ? primary : Colors.black),
                                color: (listJawaban[index0].trueAnswer == false) ? primary : Colors.white,
                              ),
                              child: Text('Salah', style: TextStyle(color: (listJawaban[index0].trueAnswer == false) ? Colors.white : Colors.black, fontSize: h4)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
