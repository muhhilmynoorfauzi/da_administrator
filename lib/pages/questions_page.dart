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

import '../model/other/other_model.dart';

class QuestionsPage extends StatefulWidget {
  final String idQuestion;
  final String nameSubTest;

  const QuestionsPage({super.key, required this.idQuestion, required this.nameSubTest});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

QuestionsModel? subtest;

class _QuestionsPageState extends State<QuestionsPage> {
  bool onLoading = false;
  OtherModel? otherModel;

  @override
  Widget build(BuildContext context) {
    contextF = context;
    var page = (lebar(context) <= 700) ? onMo(context) : onDesk(context);
    return Stack(
      children: [
        page,
        if (onLoading)
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
    getDataOther();
    getDataQuestion(widget.idQuestion);
    setState(() {});
  }

  void getDataQuestion(String docId) async {
    try {
      DocumentReference<Map<String, dynamic>> docRef = FirebaseFirestore.instance.collection('subtest_v03').doc(docId);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        subtest = QuestionsModel.fromSnapshot(docSnapshot);
        print('Dokumen subtest ditemukan');
      } else {
        print('Dokumen tidak ditemukan');
      }
    } catch (e) {
      print('Error: $e');
    }
    setState(() {});
  }

  void getDataOther() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('other_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.get();

      var listAll = querySnapshot.docs.map((doc) => OtherModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      // var idListAll = querySnapshot.docs.map((doc) => doc.id).toList();
      if (listAll.isNotEmpty) {
        otherModel = listAll.first;
      } else {
        print('Tidak ada data TryOut');
      }
    } catch (e) {
      print('salah home_page: $e');
    }
    setState(() {});
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
                            document: Document.fromHtml(subtest!.listQuestions[index].question),
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
                          await subtest!.listQuestions.removeAt(index);
                          await QuestionsService.edit(id: widget.idQuestion, idTryOut: subtest!.idTryOut, listQuestions: subtest!.listQuestions);
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

  Future<void> saveSubtest() async {
    setState(() => onLoading = true);

    await QuestionsService.edit(id: widget.idQuestion, idTryOut: subtest!.idTryOut, listQuestions: subtest!.listQuestions);

    await Future.delayed(const Duration(milliseconds: 200));
    // getDataQuestion(widget.idQuestion);
    setState(() => onLoading = false);
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
          label: Text(widget.nameSubTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => saveSubtest(),
            child: Text('Simpan', style: TextStyle(color: Colors.black, fontSize: h4)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: (subtest != null)
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
                        Text('Jumlah Soal ${subtest!.listQuestions.length}', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(
                      child: (subtest!.listQuestions.isNotEmpty)
                          ? ListView.builder(
                              itemCount: subtest!.listQuestions.length,
                              itemBuilder: (context, indexQuest) {
                                int rating = subtest!.listQuestions[indexQuest].rating;
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
                                                      formatType(subtest!.listQuestions[indexQuest].type),
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
                                                                subtest!.listQuestions[indexQuest].rating = rating;
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
                                                        if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          Navigator.push(context, FadeRoute1(ViewCheckQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          Navigator.push(context, FadeRoute1(ViewPgQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                          Navigator.push(context, FadeRoute1(ViewStuffingQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          Navigator.push(context, FadeRoute1(ViewTruefalseQuestPage(question: subtest!.listQuestions[indexQuest])));
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
                                                    document: Document.fromHtml(subtest!.listQuestions[indexQuest].question),
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
                                              if (otherModel != null)
                                                SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Container(
                                                    height: 40,
                                                    margin: const EdgeInsets.only(top: 10),
                                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(50)),
                                                    child: DropdownButton<String>(
                                                      dropdownColor: Colors.white,
                                                      focusColor: Colors.white,
                                                      borderRadius: BorderRadius.circular(10),
                                                      value: _selectedOption,
                                                      padding: const EdgeInsets.only(left: 20, right: 10),
                                                      hint: Text(
                                                        (subtest!.listQuestions[indexQuest].subjectRelevance != '')
                                                            ? subtest!.listQuestions[indexQuest].subjectRelevance
                                                            : 'Pilih Mapel Terkait',
                                                        style: TextStyle(color: Colors.black, fontSize: h4),
                                                      ),
                                                      icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                                                      underline: const SizedBox(),
                                                      items: otherModel!.subjectRelevance.map((String value) {
                                                        return DropdownMenuItem<String>(
                                                          value: value,
                                                          child: Text(value, style: TextStyle(color: Colors.black, fontSize: h4)),
                                                        );
                                                      }).toList(),
                                                      onChanged: (String? newValue) async {
                                                        if (newValue != null) {
                                                          if (subtest!.listQuestions[indexQuest].subjectRelevance == '') {
                                                            subtest!.listQuestions[indexQuest].subjectRelevance = newValue;
                                                          } else {
                                                            subtest!.listQuestions[indexQuest].subjectRelevance = '';
                                                          }
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () async {
                                                      if (lebar(context) <= 700) {
                                                        if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          await editMultiJawabanDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          await editPGDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                          await editIsianDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          await editBenarSalahDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        }
                                                      } else {
                                                        if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                          await editMultiJawabanDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                          await editPGDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                          await editIsianDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                          await editBenarSalahDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                        }
                                                      }
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(Icons.edit_outlined),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      // print(question!.listQuestions[indexQuest]);
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
          label: Text(widget.nameSubTest, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => saveSubtest(),
            child: Text('Simpan', style: TextStyle(color: Colors.black, fontSize: h4)),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: (subtest != null)
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
                        Text('Jumlah Soal ${subtest!.listQuestions.length}', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Expanded(
                      child: (subtest!.listQuestions.isNotEmpty)
                          ? ListView.builder(
                              itemCount: subtest!.listQuestions.length,
                              itemBuilder: (context, indexQuest) {
                                int rating = subtest!.listQuestions[indexQuest].rating;
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
                                                formatType(subtest!.listQuestions[indexQuest].type),
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
                                                          subtest!.listQuestions[indexQuest].rating = rating;
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
                                                  if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    Navigator.push(context, FadeRoute1(ViewCheckQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    Navigator.push(context, FadeRoute1(ViewPgQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                    Navigator.push(context, FadeRoute1(ViewStuffingQuestPage(question: subtest!.listQuestions[indexQuest])));
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    Navigator.push(context, FadeRoute1(ViewTruefalseQuestPage(question: subtest!.listQuestions[indexQuest])));
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
                                              document: Document.fromHtml(subtest!.listQuestions[indexQuest].question),
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
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            //
                                            if (otherModel != null)
                                              Container(
                                                height: 40,
                                                margin: const EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1), borderRadius: BorderRadius.circular(50)),
                                                child: DropdownButton<String>(
                                                  dropdownColor: Colors.white,
                                                  focusColor: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  value: _selectedOption,
                                                  padding: const EdgeInsets.only(left: 20, right: 10),
                                                  hint: Text(
                                                    (subtest!.listQuestions[indexQuest].subjectRelevance != '')
                                                        ? subtest!.listQuestions[indexQuest].subjectRelevance
                                                        : 'Pilih Mapel Terkait',
                                                    style: TextStyle(color: Colors.black, fontSize: h4),
                                                  ),
                                                  icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.black),
                                                  underline: const SizedBox(),
                                                  items: otherModel!.subjectRelevance.map((String value) {
                                                    return DropdownMenuItem<String>(
                                                      value: value,
                                                      child: Text(value, style: TextStyle(color: Colors.black, fontSize: h4)),
                                                    );
                                                  }).toList(),
                                                  onChanged: (String? newValue) async {
                                                    if (newValue != null) {
                                                      if (subtest!.listQuestions[indexQuest].subjectRelevance == '') {
                                                        subtest!.listQuestions[indexQuest].subjectRelevance = newValue;
                                                      } else {
                                                        subtest!.listQuestions[indexQuest].subjectRelevance = '';
                                                      }
                                                      setState(() {});
                                                    }
                                                  },
                                                ),
                                              ),
                                            const Expanded(child: SizedBox()),
                                            IconButton(
                                              onPressed: () async {
                                                if (lebar(context) <= 700) {
                                                  if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    await editMultiJawabanDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    await editPGDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                    await editIsianDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    await editBenarSalahDialogSmallDevice(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  }
                                                } else {
                                                  if (subtest!.listQuestions[indexQuest].type == 'banyak_pilihan') {
                                                    await editMultiJawabanDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'pilihan_ganda') {
                                                    await editPGDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'isian') {
                                                    await editIsianDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  } else if (subtest!.listQuestions[indexQuest].type == 'benar_salah') {
                                                    await editBenarSalahDialog(soal: subtest!.listQuestions[indexQuest], index: indexQuest);
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              icon: const Icon(Icons.edit_outlined),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                // print(question!.listQuestions[indexQuest]);
                                                deleteQuestion(indexQuest);
                                              },
                                              icon: const Icon(Icons.delete_outline),
                                            ),
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
