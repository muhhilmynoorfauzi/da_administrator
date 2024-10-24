import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ViewStuffingQuestPage extends StatefulWidget {
  const ViewStuffingQuestPage({super.key, required this.question});

  final StuffingModel question;

  @override
  State<ViewStuffingQuestPage> createState() => _ViewStuffingQuestPageState();
}

class _ViewStuffingQuestPageState extends State<ViewStuffingQuestPage> {
  late StuffingModel question;
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
    // TODO: implement initState
    super.initState();
    question = widget.question;
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
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(right: 10, bottom: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.question.image.isNotEmpty)
                    Column(
                      children: List.generate(
                        widget.question.image.length,
                        (index) {
                          if (widget.question.image[index] != '') {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 5 / 1,
                                child: CachedNetworkImage(
                                  imageUrl: widget.question.image[index]!,
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
                        document: Document.fromHtml(widget.question.question),
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
                        widget.question.yourAnswer = listJawaban;
                        setState(() {});
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
      ),
    );
  }

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
