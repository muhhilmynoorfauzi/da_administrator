// QuestPgUserPage
import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ViewPgQuestPage extends StatefulWidget {
  const ViewPgQuestPage({super.key, required this.question});

  final PgModel question;

  @override
  State<ViewPgQuestPage> createState() => _ViewPgQuestPageState();
}

class _ViewPgQuestPageState extends State<ViewPgQuestPage> {
  late PgModel question;
  String? selected;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    question = widget.question;
  }

  @override
  Widget build(BuildContext context) {
    return onDesk(context);
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        leading: const SizedBox(),
        leadingWidth: 0,
        titleSpacing: 0,
        title: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.navigate_before_rounded, color: Colors.black),
          label: Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (question.image.isNotEmpty)
                    Column(
                      children: List.generate(
                        question.image.length,
                        (index) {
                          if (question.image[index] != '') {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 5 / 1,
                                child: CachedNetworkImage(
                                  imageUrl: question.image[index]!,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
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
                        document: Document.fromHtml(question.question),
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
                question.options.length,
                (index) {
                  var options = question.options[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Radio<String>(
                          value: options,
                          groupValue: selected,
                          onChanged: (String? value) {
                            if (value == selected) {
                              selected = null;
                            } else {
                              selected = value;
                            }
                            setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                          child: Text(options, style: TextStyle(color: Colors.black, fontSize: h4), textAlign: TextAlign.justify),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
