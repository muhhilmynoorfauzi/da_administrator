import 'package:da_administrator/pages/function_qustion/add_qustion.dart';
import 'package:da_administrator/pages/function_qustion/edit_questions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/questions_service.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/pages/user_view_question/view_check_quest_page.dart';
import 'package:da_administrator/pages/user_view_question/view_pg_quest_page.dart';
import 'package:da_administrator/pages/user_view_question/view_stuffing_quest_page.dart';
import 'package:da_administrator/pages/user_view_question/view_truefalse_quest_page.dart';
import 'package:da_administrator/pages_user/question/quest_pg_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class QuestionsPage extends StatefulWidget {
  final String idQuestion;
  final String subTest;

  const QuestionsPage({super.key, required this.idQuestion, required this.subTest});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

QuestionsModel? question;

class _QuestionsPageState extends State<QuestionsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    contextF = context;
    var page = (lebar(context) <= 800) ? onMo(context) : onDesk(context);
    return Stack(
      children: [
        page,
        if (isLoading)
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: tinggi(context),
            width: lebar(context),
            color: Colors.white,
            child: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
          ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataTryOut(widget.idQuestion);
  }

  void getDataTryOut(String docId) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('questions_v2').doc(docId);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        setState(() => question = QuestionsModel.fromSnapshot(docSnapshot));
        print('Dokumen ditemukan');
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

//==============================================================================================================

  String formatType(String dataType) {
    var type = '';
    if (dataType == 'pilihan_ganda') {
      type = 'Pilihan Ganda';
    } else if (dataType == 'isian') {
      type = 'Isian';
    } else if (dataType == 'benar_salah') {
      type = 'Benar Salah';
    } else if (dataType == 'banyak_pilihan') {
      type = 'Banyak Pilihan';
    }
    return type;
  }

//==============================================================================================================
  Future<void> deleteQuestion(int index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        var loading = false;
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              title: SizedBox(
                width: 1000,
                child: loading
                    ? Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3))
                    : QuillEditor.basic(
                        focusNode: FocusNode(),
                        configurations: QuillEditorConfigurations(
                          controller: QuillController(
                            document: Document.fromHtml(question!.listQuestions[index].question),
                            selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                            readOnly: true,
                          ),
                          placeholder: 'Soal',
                          customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                          checkBoxReadOnly: true,
                          sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                        ),
                      ),
              ),
              contentPadding: const EdgeInsets.all(10),
              actionsPadding: const EdgeInsets.all(10),
              actions: loading
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
                      ),
                      TextButton(
                        onPressed: () async {
                          setState(() => loading = true);
                          await question!.listQuestions.removeAt(index);
                          await QuestionsService.edit(id: widget.idQuestion, idTryOut: question!.idTryOut, listQuestions: question!.listQuestions);
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Hapus', style: TextStyle(color: Colors.black, fontSize: h4)),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<void> saveQuestion() async {
    setState(() => isLoading = true);

    await QuestionsService.edit(id: widget.idQuestion, idTryOut: question!.idTryOut, listQuestions: question!.listQuestions);

    await Future.delayed(const Duration(milliseconds: 500));
    getDataTryOut(widget.idQuestion);
    setState(() => isLoading = false);
  }

//==============================================================================================================
  Document toStringHtml(String value) {
    var data = Document.fromHtml(value);
    return data;
  }

//==============================================================================================================
  String? _selectedOption;

  Widget onMo(BuildContext context) {
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
          label: Text(widget.subTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => saveQuestion(),
            child: Text('Simpan', style: TextStyle(color: Colors.black, fontSize: h4)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: (question != null)
          ? Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: tinggi(context),
                width: 1300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            value: _selectedOption,
                            hint: Text('Tambah Soal', style: TextStyle(color: Colors.white, fontSize: h4)),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                            underline: const SizedBox(),
                            items: ['Banyak Pilihan', 'Pilihan Ganda', 'Isian', 'Benar Salah'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.black, fontSize: h4)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (lebar(context) <= 700) {
                                if (newValue == 'Banyak Pilihan') {
                                  await addMultiJawabanDialogSmallDevice();
                                } else if (newValue == 'Pilihan Ganda') {
                                  await addPGDialogSmallDevice();
                                } else if (newValue == 'Isian') {
                                  await addIsianDialogSmallDevice();
                                } else if (newValue == 'Benar Salah') {
                                  await addBenarSalahDialogSmallDevice();
                                }
                              } else {
                                if (newValue == 'Banyak Pilihan') {
                                  await addMultiJawabanDialog();
                                } else if (newValue == 'Pilihan Ganda') {
                                  await addPGDialog();
                                } else if (newValue == 'Isian') {
                                  await addIsianDialog();
                                } else if (newValue == 'Benar Salah') {
                                  await addBenarSalahDialog();
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Text('Jumlah Soal ${question!.listQuestions.length}', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(
                      child: (question!.listQuestions.isNotEmpty)
                          ? ListView.builder(
                              itemCount: question!.listQuestions.length,
                              itemBuilder: (context, indexQuest) {
                                int rating = question!.listQuestions[indexQuest].rating;
                                return Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height: 30,
                                                    margin: const EdgeInsets.only(bottom: 10),
                                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: primary),
                                                    child: Text(
                                                      formatType(question!.listQuestions[indexQuest].type),
                                                      style: TextStyle(color: Colors.white, fontSize: h4),
                                                      textAlign: TextAlign.justify,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                                    return Stack(
                                                      children: [
                                                        Row(
                                                          children: List.generate(
                                                            3,
                                                            (index) => const Padding(padding: EdgeInsets.all(3), child: Icon(Icons.star, size: 25, color: Colors.grey)),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: List.generate(
                                                            3,
                                                            (index) => InkWell(
                                                              onTap: () => setState(() {
                                                                rating = index + 1;
                                                                question!.listQuestions[indexQuest].rating = rating;
                                                              }),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(3),
                                                                child: Icon(Icons.star, size: 25, color: (rating >= index + 1) ? secondary : Colors.grey),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                  const Expanded(child: SizedBox()),
                                                  SizedBox(
                                                    height: 30,
                                                    child: OutlinedButton(
                                                      onPressed: () {
                                                        if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          Navigator.push(context, FadeRoute1(ViewCheckQuestPage(question: question!.listQuestions[indexQuest])));
                                                        } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          Navigator.push(context, FadeRoute1(ViewPgQuestPage(question: question!.listQuestions[indexQuest])));
                                                        } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                          Navigator.push(context, FadeRoute1(ViewStuffingQuestPage(question: question!.listQuestions[indexQuest])));
                                                        } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          Navigator.push(context, FadeRoute1(ViewTruefalseQuestPage(question: question!.listQuestions[indexQuest])));
                                                        }
                                                      },
                                                      child: Text('Preview', style: TextStyle(color: Colors.black, fontSize: h4), textAlign: TextAlign.justify),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              QuillEditor.basic(
                                                focusNode: FocusNode(),
                                                configurations: QuillEditorConfigurations(
                                                  controller: QuillController(
                                                    document: Document.fromHtml(question!.listQuestions[indexQuest].question),
                                                    selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                                                    readOnly: true,
                                                  ),
                                                  placeholder: 'Soal',
                                                  customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                                  checkBoxReadOnly: true,
                                                  readOnlyMouseCursor: MouseCursor.uncontrolled,
                                                  floatingCursorDisabled: true,
                                                  sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      if (lebar(context) <= 700) {
                                                        if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          await editMultiJawabanDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          await editPGDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                          await editIsianDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          await editBenarSalahDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        }
                                                      } else {
                                                        if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          await editMultiJawabanDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          await editPGDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                          await editIsianDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          await editBenarSalahDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                        }
                                                      }
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(Icons.edit_outlined),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      print(question!.listQuestions[indexQuest]);
                                                      deleteQuestion(indexQuest);
                                                    },
                                                    icon: const Icon(Icons.delete_outline),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.hourglass_empty_rounded, size: 100, color: Colors.grey),
                                  Text('Belum ada Soal', style: TextStyle(color: Colors.grey, fontSize: h4)),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
    );
  }

  onDesk(BuildContext context) {
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
          label: Text(widget.subTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => saveQuestion(),
            child: Text('Simpan', style: TextStyle(color: Colors.black, fontSize: h4)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: (question != null)
          ? Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: tinggi(context),
                width: 1300,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                          child: DropdownButton<String>(
                            dropdownColor: Colors.white,
                            focusColor: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            value: _selectedOption,
                            hint: Text('Tambah Soal', style: TextStyle(color: Colors.white, fontSize: h4)),
                            icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white),
                            underline: const SizedBox(),
                            items: ['Banyak Pilihan', 'Pilihan Ganda', 'Isian', 'Benar Salah'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value, style: TextStyle(color: Colors.black, fontSize: h4)),
                              );
                            }).toList(),
                            onChanged: (String? newValue) async {
                              if (lebar(context) <= 700) {
                                if (newValue == 'Banyak Pilihan') {
                                  await addMultiJawabanDialogSmallDevice();
                                } else if (newValue == 'Pilihan Ganda') {
                                  await addPGDialogSmallDevice();
                                } else if (newValue == 'Isian') {
                                  await addIsianDialogSmallDevice();
                                } else if (newValue == 'Benar Salah') {
                                  await addBenarSalahDialogSmallDevice();
                                }
                              } else {
                                if (newValue == 'Banyak Pilihan') {
                                  await addMultiJawabanDialog();
                                } else if (newValue == 'Pilihan Ganda') {
                                  await addPGDialog();
                                } else if (newValue == 'Isian') {
                                  await addIsianDialog();
                                } else if (newValue == 'Benar Salah') {
                                  await addBenarSalahDialog();
                                }
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        Text('Jumlah Soal ${question!.listQuestions.length}', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(
                      child: (question!.listQuestions.isNotEmpty)
                          ? ListView.builder(
                              itemCount: question!.listQuestions.length,
                              itemBuilder: (context, indexQuest) {
                                int rating = question!.listQuestions[indexQuest].rating;
                                return Card(
                                  color: Colors.white,
                                  surfaceTintColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 30,
                                              margin: const EdgeInsets.only(bottom: 10),
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: primary),
                                              child: Text(
                                                formatType(question!.listQuestions[indexQuest].type),
                                                style: TextStyle(color: Colors.white, fontSize: h4),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                              return Stack(
                                                children: [
                                                  Row(
                                                    children: List.generate(
                                                      3,
                                                      (index) => const Padding(padding: EdgeInsets.all(3), child: Icon(Icons.star, size: 25, color: Colors.grey)),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: List.generate(
                                                      3,
                                                      (index) => InkWell(
                                                        onTap: () => setState(() {
                                                          rating = index + 1;
                                                          question!.listQuestions[indexQuest].rating = rating;
                                                        }),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(3),
                                                          child: Icon(Icons.star, size: 25, color: (rating >= index + 1) ? secondary : Colors.grey),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                            const Expanded(child: SizedBox()),
                                            SizedBox(
                                              height: 30,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    Navigator.push(context, FadeRoute1(ViewCheckQuestPage(question: question!.listQuestions[indexQuest])));
                                                  } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    Navigator.push(context, FadeRoute1(ViewPgQuestPage(question: question!.listQuestions[indexQuest])));
                                                  } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                    Navigator.push(context, FadeRoute1(ViewStuffingQuestPage(question: question!.listQuestions[indexQuest])));
                                                  } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    Navigator.push(context, FadeRoute1(ViewTruefalseQuestPage(question: question!.listQuestions[indexQuest])));
                                                  }
                                                },
                                                child: Text('Preview', style: TextStyle(color: Colors.black, fontSize: h4), textAlign: TextAlign.justify),
                                              ),
                                            ),
                                          ],
                                        ),
                                        QuillEditor.basic(
                                          focusNode: FocusNode(),
                                          configurations: QuillEditorConfigurations(
                                            controller: QuillController(
                                              document: Document.fromHtml(question!.listQuestions[indexQuest].question),
                                              selection: const TextSelection(baseOffset: 0, extentOffset: 0),
                                              readOnly: true,
                                            ),
                                            placeholder: 'Soal',
                                            customStyleBuilder: (attribute) => TextStyle(color: Colors.black, fontSize: h4),
                                            checkBoxReadOnly: true,
                                            readOnlyMouseCursor: MouseCursor.uncontrolled,
                                            floatingCursorDisabled: true,
                                            sharedConfigurations: const QuillSharedConfigurations(locale: Locale('id')),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () async {
                                                if (lebar(context) <= 700) {
                                                  if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    await editMultiJawabanDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    await editPGDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                    await editIsianDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    await editBenarSalahDialogSmallDevice(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  }
                                                } else {
                                                  if (question!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    await editMultiJawabanDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    await editPGDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'isian') {
                                                    await editIsianDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (question!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    await editBenarSalahDialog(soal: question!.listQuestions[indexQuest], index: indexQuest);
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.edit_outlined),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                print(question!.listQuestions[indexQuest]);
                                                deleteQuestion(indexQuest);
                                              },
                                              icon: const Icon(Icons.delete_outline),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.hourglass_empty_rounded, size: 100, color: Colors.grey),
                                  Text('Belum ada Soal', style: TextStyle(color: Colors.grey, fontSize: h4)),
                                ],
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
    );
  }
}
