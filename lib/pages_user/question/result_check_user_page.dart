import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:youtube_player_iframe_plus/youtube_player_iframe_plus.dart';

class ResultCheckUserPage extends StatefulWidget {
  const ResultCheckUserPage({super.key, required this.question});

  final CheckModel question;

  @override
  State<ResultCheckUserPage> createState() => _ResultCheckUserPageState();
}

class _ResultCheckUserPageState extends State<ResultCheckUserPage> {
  // bool isLogin = true;

  late List<String> listJawaban;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayerController.convertUrlToId(widget.question.urlVideoExplanation)!,
      params: const YoutubePlayerParams(color: 'red', strictRelatedVideos: true, showFullscreenButton: true, autoPlay: false),
    );
    listJawaban = List.generate(widget.question.options.length, (index) => '');
  }

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
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
                  focusNode: FocusNode(),
                  configurations: QuillEditorConfigurations(
                    controller: QuillController(
                      document: Document.fromHtml(widget.question.question),
                      selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                      readOnly: true,
                    ),
                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                    checkBoxReadOnly: true,
                    readOnlyMouseCursor: MouseCursor.uncontrolled,
                    floatingCursorDisabled: true,
                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: List.generate(
              widget.question.options.length,
              (index) {
                var options = widget.question.options[index];
                bool isTrue = widget.question.trueAnswer[index] == widget.question.options[index];
                bool isSelectedTrue = false;
                bool isSelectedFalse = false;

                for (String you in widget.question.yourAnswer) {
                  if (widget.question.trueAnswer.contains(you) && you == options) {
                    isSelectedTrue = true;
                  }
                  if (!widget.question.trueAnswer.contains(you) && you == options) {
                    isSelectedFalse = true;
                  }
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: (isTrue || isSelectedTrue)
                              ? primary
                              : isSelectedFalse
                                  ? secondary
                                  : secondaryWhite,
                        ),
                        child: Text(options, style: TextStyle(color: (isTrue || isSelectedTrue) ? Colors.white : Colors.black, fontSize: h4), textAlign: TextAlign.justify),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Checkbox(value: (isSelectedTrue || isSelectedFalse), onChanged: (bool? value) {}),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: Text('Pembahasan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold), maxLines: 1),
          ),
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuillEditor.basic(
                  focusNode: FocusNode(),
                  configurations: QuillEditorConfigurations(
                    controller: QuillController(
                      document: Document.fromHtml(widget.question.explanation),
                      selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                      readOnly: true,
                    ),
                    customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                    checkBoxReadOnly: true,
                    readOnlyMouseCursor: MouseCursor.uncontrolled,
                    floatingCursorDisabled: true,
                    sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: lebar(context) * .4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: YoutubePlayerIFramePlus(controller: _controller, aspectRatio: 16 / 9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leadingWidth: 0,
        leading: const SizedBox(),
        toolbarHeight: 40,
        title: TextButton.icon(
          style: TextButton.styleFrom(backgroundColor: Colors.black.withOpacity(.1)),
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
                    focusNode: FocusNode(),
                    configurations: QuillEditorConfigurations(
                      controller: QuillController(
                        document: Document.fromHtml(widget.question.question),
                        selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                        readOnly: true,
                      ),
                      customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                      checkBoxReadOnly: true,
                      readOnlyMouseCursor: MouseCursor.uncontrolled,
                      floatingCursorDisabled: true,
                      sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(
                widget.question.options.length,
                (index) {
                  var options = widget.question.options[index];
                  bool isTrue = widget.question.trueAnswer[index] == widget.question.options[index];
                  bool isSelectedTrue = false;
                  bool isSelectedFalse = false;

                  for (String you in widget.question.yourAnswer) {
                    if (widget.question.trueAnswer.contains(you) && you == options) {
                      isSelectedTrue = true;
                    }
                    if (!widget.question.trueAnswer.contains(you) && you == options) {
                      isSelectedFalse = true;
                    }
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: (isTrue || isSelectedTrue)
                                ? primary
                                : isSelectedFalse
                                    ? secondary
                                    : secondaryWhite,
                          ),
                          child: Text(options, style: TextStyle(color: (isTrue || isSelectedTrue) ? Colors.white : Colors.black, fontSize: h4), textAlign: TextAlign.justify),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Checkbox(value: (isSelectedTrue || isSelectedFalse), onChanged: (bool? value) {}),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.only(top: 50, bottom: 10),
              child: Text('Pembahasan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold), maxLines: 1),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuillEditor.basic(
                    focusNode: FocusNode(),
                    configurations: QuillEditorConfigurations(
                      controller: QuillController(
                        document: Document.fromHtml(widget.question.explanation),
                        selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                        readOnly: true,
                      ),
                      customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                      checkBoxReadOnly: true,
                      readOnlyMouseCursor: MouseCursor.uncontrolled,
                      floatingCursorDisabled: true,
                      sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: lebar(context) * .8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: YoutubePlayerIFramePlus(controller: _controller, aspectRatio: 16 / 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
