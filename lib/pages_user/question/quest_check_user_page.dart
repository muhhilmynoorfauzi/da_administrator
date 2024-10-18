import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuestCheckUserPage extends StatefulWidget {
  const QuestCheckUserPage({super.key, required this.indexQuest});

  final int indexQuest;

  @override
  State<QuestCheckUserPage> createState() => _QuestCheckUserPageState();
}

class _QuestCheckUserPageState extends State<QuestCheckUserPage> {
  var isLogin = true;

  CheckModel? question;
  late List<String> listJawaban;

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
    started();
    // TODO: implement initState
    super.initState();
  }

  void started() {
    question = userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest];
    if (question != null) {
      if (question!.yourAnswer.isNotEmpty) {
        listJawaban = question!.yourAnswer;
      } else {
        listJawaban = List.generate(question!.options.length, (index) => '');
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
            children: List.generate(
              question!.options.length,
              (index) {
                var options = question!.options[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                        child: Text(options, style: TextStyle(color: Colors.black, fontSize: h4), maxLines: 10),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Checkbox(
                          value: listJawaban[index] == options,
                          onChanged: (bool? value) {
                            if (listJawaban[index] != options) {
                              listJawaban[index] = options;
                            } else if (listJawaban[index] == options) {
                              listJawaban[index] = '';
                            }
                            question!.yourAnswer = listJawaban;
                            setState(() => userTo!.listTest[testKe].listSubtest[subTestKe].listQuestions[widget.indexQuest] = question!);
                          },
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
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
