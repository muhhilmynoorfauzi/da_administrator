import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuestStuffingUserPage extends StatefulWidget {
  const QuestStuffingUserPage({super.key, required this.indexQuest});

  final int indexQuest;

  @override
  State<QuestStuffingUserPage> createState() => _QuestStuffingUserPageState();
}

class _QuestStuffingUserPageState extends State<QuestStuffingUserPage> {
  StuffingModel? question;

  var isLogin = true;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    question = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest];
    if (question!.yourAnswer.isNotEmpty) {
      answerController.text = question!.yourAnswer.first;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    answerController.dispose();
    // TODO: implement dispose
    super.dispose();
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Jawaban : ', style: TextStyle(color: Colors.black, fontSize: h4), maxLines: 10),
              ),
              Expanded(
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                  child: TextField(
                    maxLines: 5,
                    controller: answerController,
                    onChanged: (value) {
                      var listJawaban = [answerController.text];
                      question!.yourAnswer = listJawaban;
                      setState(() => userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest] = question!);
                    },
                    style: TextStyle(color: Colors.black, fontSize: h4),
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      border: const OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                    ),
                  ),
                ),
              ),
            ],
          )
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
