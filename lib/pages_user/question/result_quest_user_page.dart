import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/firebase_service/user_to_service.dart';
import 'package:da_administrator/model/questions/check_model.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/model/user_to/leaderboard_model.dart';
import 'package:da_administrator/model/user_to/rationalization_model.dart';
import 'package:da_administrator/model/user_to/user_to_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/question/nav_quest_user_page.dart';
import 'package:da_administrator/pages_user/question/quest_check_user_page.dart';
import 'package:da_administrator/pages_user/question/result_check_user_page.dart';
import 'package:da_administrator/pages_user/question/result_pg_user_page.dart';
import 'package:da_administrator/pages_user/question/result_stuffing_user_page.dart';
import 'package:da_administrator/pages_user/question/result_truefalse_user_page.dart';
import 'package:da_administrator/pages_user/tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultQuestUserPage extends StatefulWidget {
  const ResultQuestUserPage({
    super.key,
    required this.userIndex,
    required this.idUserTo,
    required this.allUserTo,
    required this.allQuestion,
    required this.myTryout,
    required this.rationalUser,
  });

  final List<QuestionsModel> allQuestion;
  final List<UserToModel> allUserTo;
  final int userIndex;
  final TryoutModel myTryout;
  final String idUserTo;
  final List<RationalizationUserModel> rationalUser;

  @override
  _ResultQuestUserPageState createState() => _ResultQuestUserPageState();
}

class _ResultQuestUserPageState extends State<ResultQuestUserPage> {
  final user = FirebaseAuth.instance.currentUser;

  List<RationalizationUserModel> rationalUser = [];
  var onLoading = true;
  ProfileUserModel? profile;
  late int userIndex;
  late List<UserToModel?> allUserTo;
  late String idUserTo;

  @override
  Widget build(BuildContext context) {
    if (onLoading) {
      bool emptyValue = allUserTo[userIndex]!.correctAnswer == 0 &&
          allUserTo[userIndex]!.unanswered == 0 &&
          allUserTo[userIndex]!.wrongAnswer == 0 &&
          allUserTo[userIndex]!.valuesDiscussion == 0 &&
          allUserTo[userIndex]!.average == 0;
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3),
              ),
              Text(
                (emptyValue) ? 'Jangan Keluar dari halaman ini\nSedang menghitung nilai' : 'Harap Tunggu',
                style: TextStyle(fontSize: h3, color: Colors.black.withOpacity(.3), fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    } else {
      if (lebar(context) <= 800) {
        return onMo(context);
      } else {
        return onDesk(context);
      }
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);

    allUserTo = widget.allUserTo;
    idUserTo = widget.idUserTo;
    userIndex = widget.userIndex;
    profile = profider.getProfile;
    rationalUser = widget.rationalUser;

    counting();
  }

  Future<void> counting() async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      if (allUserTo[userIndex]!.correctAnswer == 0 &&
          allUserTo[userIndex]!.unanswered == 0 &&
          allUserTo[userIndex]!.wrongAnswer == 0 &&
          allUserTo[userIndex]!.valuesDiscussion == 0 &&
          allUserTo[userIndex]!.average == 0) {
        if (widget.myTryout.phaseIRT) {
          calculateIRT();
          // calculateNoIRT();
        } else {
          // calculateIRT();
          calculateNoIRT();
        }
      }
      onSave();
    } catch (e) {
      print(e);
    }
    onLoading = false;
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {});
    return;
  }

  //============================================= NoIRT =============================================
  void calculateNoIRT() {
    print("\n============================================= NoIRT =============================================\n\n");
    int totalScore = 0;
    int totalQuestions = 0;

    // print("nilai rationalization jurusan 0 ${rationalUser.first.jurusan[0].namaJurusan}: ${rationalUser.first.jurusan[0].value}");
    // print("nilai rationalization jurusan 1 ${rationalUser.first.jurusan[1].namaJurusan}: ${rationalUser.first.jurusan[1].value}");
    // print("nilai rationalization jurusan 2 ${rationalUser.first.jurusan[2].namaJurusan}: ${rationalUser.first.jurusan[2].value}");
    // print("nilai rationalization jurusan 3 ${rationalUser.first.jurusan[3].namaJurusan}: ${rationalUser.first.jurusan[3].value}");

    print("\n=============== Nilai setelah di hitung ===============\n\n");
    for (int i = 0; i < allUserTo[userIndex]!.listTest.length; i++) {
      var test = allUserTo[userIndex]!.listTest[i];

      for (int j = 0; j < test.listSubtest.length; j++) {
        var subtest = test.listSubtest[j];
        double subtestScore = 0;

        for (int k = 0; k < subtest.listQuestions.length; k++) {
          var question = subtest.listQuestions[k];
          totalQuestions++;
          if (question is CheckModel) {
            if (question.yourAnswer.isEmpty || question.yourAnswer.first == '') {
              allUserTo[userIndex]!.unanswered++;
            } else if (question.yourAnswer.toSet().containsAll(question.trueAnswer)) {
              for (int l = 0; l < rationalUser.first.jurusan.length; l++) {
                for (int m = 0; m < rationalUser.first.jurusan[l].relevance.length; m++) {
                  if (question.subjectRelevance == rationalUser.first.jurusan[l].relevance[m]) {
                    rationalUser.first.jurusan[l].value = rationalUser.first.jurusan[l].value + 1;
                  }
                }
              }

              allUserTo[userIndex]!.correctAnswer++;
              if (question.rating == 1) {
                question.value = 1;
              } else if (question.rating == 2) {
                question.value = 2;
              } else if (question.rating == 3) {
                question.value = 3;
              }

              totalScore += question.value;
              subtestScore += question.value;
            } else {
              allUserTo[userIndex]!.wrongAnswer++;
            }
          } else if (question is PgModel) {
            if (question.yourAnswer.isEmpty || question.yourAnswer.first == '') {
              allUserTo[userIndex]!.unanswered++;
            } else if (question.yourAnswer.contains(question.trueAnswer)) {
              for (int l = 0; l < rationalUser.first.jurusan.length; l++) {
                for (int m = 0; m < rationalUser.first.jurusan[l].relevance.length; m++) {
                  if (question.subjectRelevance == rationalUser.first.jurusan[l].relevance[m]) {
                    rationalUser.first.jurusan[l].value = rationalUser.first.jurusan[l].value + 1;
                  }
                }
              }

              allUserTo[userIndex]!.correctAnswer++;
              if (question.rating == 1) {
                question.value = 1;
              } else if (question.rating == 2) {
                question.value = 2;
              } else if (question.rating == 3) {
                question.value = 3;
              }

              totalScore += question.value;
              subtestScore += question.value;
            } else {
              allUserTo[userIndex]!.wrongAnswer++;
            }
          } else if (question is StuffingModel) {
            if (question.yourAnswer.isEmpty || question.yourAnswer.first == '') {
              allUserTo[userIndex]!.unanswered++;
            } else if (question.yourAnswer.contains(question.trueAnswer)) {
              for (int l = 0; l < rationalUser.first.jurusan.length; l++) {
                for (int m = 0; m < rationalUser.first.jurusan[l].relevance.length; m++) {
                  if (question.subjectRelevance == rationalUser.first.jurusan[l].relevance[m]) {
                    rationalUser.first.jurusan[l].value = rationalUser.first.jurusan[l].value + 1;
                  }
                }
              }

              allUserTo[userIndex]!.correctAnswer++;
              if (question.rating == 1) {
                question.value = 1;
              } else if (question.rating == 2) {
                question.value = 2;
              } else if (question.rating == 3) {
                question.value = 3;
              }

              totalScore += question.value;
              subtestScore += question.value;
            } else {
              allUserTo[userIndex]!.wrongAnswer++;
            }
          } else if (question is TrueFalseModel) {
            if (question.yourAnswer.isEmpty || question.yourAnswer.first.option == '') {
              allUserTo[userIndex]!.unanswered++;
            } else {
              bool isCorrect = true;
              for (int l = 0; l < question.trueAnswer.length; l++) {
                if (question.yourAnswer[l].option != question.trueAnswer[l].option || question.yourAnswer[l].trueAnswer != question.trueAnswer[l].trueAnswer) {
                  isCorrect = false;
                  break;
                }
              }
              if (isCorrect) {
                for (int l = 0; l < rationalUser.first.jurusan.length; l++) {
                  for (int m = 0; m < rationalUser.first.jurusan[l].relevance.length; m++) {
                    if (question.subjectRelevance == rationalUser.first.jurusan[l].relevance[m]) {
                      rationalUser.first.jurusan[l].value = rationalUser.first.jurusan[l].value + 1;
                    }
                  }
                }

                allUserTo[userIndex]!.correctAnswer++;
                if (question.rating == 1) {
                  question.value = 1;
                } else if (question.rating == 2) {
                  question.value = 2;
                } else if (question.rating == 3) {
                  question.value = 3;
                }

                totalScore += question.value;
                subtestScore += question.value;
              } else {
                allUserTo[userIndex]!.wrongAnswer++;
              }
            }
          }
        }
        // print('ini nilai total dari ${test.nameTest} subtest ${subtest.nameSubTest} = $subtestScore');
        allUserTo[userIndex]!.listTest[i].listSubtest[j].totalSubtest = subtestScore;
      }
    }

    allUserTo[userIndex]!.average = totalQuestions > 0 ? totalScore / totalQuestions : 0;
    allUserTo[userIndex]!.valuesDiscussion = totalScore;

    allUserTo[userIndex]!.rationalization = List.generate(
      rationalUser.first.jurusan.length,
      (index) => RationalizationModel(
        value: rationalUser.first.jurusan[index].value,
        jurusan: rationalUser.first.jurusan[index].namaJurusan,
        universitas: profile!.listPlan[index].universitas,
      ),
    );

    print("Total Questions: $totalQuestions");
    print("Correct Answers: ${allUserTo[userIndex]!.correctAnswer}");
    print("Wrong Answers: ${allUserTo[userIndex]!.wrongAnswer}");
    print("Unanswered: ${allUserTo[userIndex]!.unanswered}");
    print("Average Score: ${allUserTo[userIndex]!.average}");

    // print("nilai rationalization jurusan 0 ${rationalUser.first.jurusan[0].namaJurusan}: ${rationalUser.first.jurusan[0].value}");
    // print("nilai rationalization jurusan 1 ${rationalUser.first.jurusan[1].namaJurusan}: ${rationalUser.first.jurusan[1].value}");
    // print("nilai rationalization jurusan 2 ${rationalUser.first.jurusan[2].namaJurusan}: ${rationalUser.first.jurusan[2].value}");
    // print("nilai rationalization jurusan 3 ${rationalUser.first.jurusan[3].namaJurusan}: ${rationalUser.first.jurusan[3].value}");
    //=============== cari peringakat keseluruhan ===============
    List<UserToModel?> sortedList = List.from(allUserTo)..sort((a, b) => b!.average.compareTo(a!.average));
    int position = sortedList.indexWhere((user) => user!.userUID == allUserTo[userIndex]!.userUID);

    int rank = position != -1 ? position + 1 : -1;
    if (rank != -1) {
      allUserTo[userIndex]!.leaderBoard.add(LeaderBoardModel(overallRating: allUserTo.length, tryoutRating: rank));
      // print("User dengan userUID = ${allUserTo[userIndex]!.userUID} berada di peringkat ke: $rank dari keseluruhan user");
    }

    //=============== cari peringkat berdasarkan tryout yang diambil ===============
    var filteredList = allUserTo.where((user) => user!.toName == allUserTo[userIndex]!.toName).toList();
    filteredList.sort((a, b) => b!.average.compareTo(a!.average));
    int positionTO = filteredList.indexWhere((user) => user!.userUID == allUserTo[userIndex]!.userUID);
    int rankTO = positionTO != -1 ? positionTO + 1 : -1;

    if (rankTO != -1) {
      allUserTo[userIndex]!.leaderBoard.add(LeaderBoardModel(overallRating: filteredList.length, tryoutRating: rankTO));
      // print("User dengan userUID = ${allUserTo[userIndex]!.userUID} berada di peringkat ke: $rankTO di tryout ${allUserTo[userIndex]!.toName}");
    }
  }

  //============================================= IRT =============================================
  void calculateIRT() {
    print("\n============================================= IRT =============================================\n\n");
    int totalScore = 0;
    int totalQuestions = 0;

    List<UserToModel?> sameTryoutUsers = allUserTo.where((user) => user!.toName == allUserTo[userIndex]!.toName).toList();

    // print("nilai rationalization jurusan 0 ${rationalUser.first.jurusan[0].namaJurusan}: ${rationalUser.first.jurusan[0].value}");
    // print("nilai rationalization jurusan 1 ${rationalUser.first.jurusan[1].namaJurusan}: ${rationalUser.first.jurusan[1].value}");
    // print("nilai rationalization jurusan 2 ${rationalUser.first.jurusan[2].namaJurusan}: ${rationalUser.first.jurusan[2].value}");
    // print("nilai rationalization jurusan 3 ${rationalUser.first.jurusan[3].namaJurusan}: ${rationalUser.first.jurusan[3].value}");
    print("\n=============== Nilai setelah di hitung dengan IRT ===============\n\n");
    for (int i = 0; i < allUserTo[userIndex]!.listTest.length; i++) {
      var test = allUserTo[userIndex]!.listTest[i];

      for (int j = 0; j < test.listSubtest.length; j++) {
        var subtest = test.listSubtest[j];
        double subtestScore = 0;

        for (int k = 0; k < subtest.listQuestions.length; k++) {
          var question = subtest.listQuestions[k];
          totalQuestions++;

          int correctAnswersCount = 0;
          for (var user in sameTryoutUsers) {
            var userQuestion = user!.listTest[i].listSubtest[j].listQuestions[k];
            bool userCorrect;

            if (userQuestion is CheckModel) {
              userCorrect = userQuestion.yourAnswer.toSet().containsAll(userQuestion.trueAnswer);
            } else if (userQuestion is PgModel || userQuestion is StuffingModel) {
              userCorrect = userQuestion.yourAnswer.contains(userQuestion.trueAnswer);
            } else if (userQuestion is TrueFalseModel) {
              userCorrect = true;
              for (int l = 0; l < userQuestion.trueAnswer.length; l++) {
                if (userQuestion.yourAnswer[l].option != userQuestion.trueAnswer[l].option || userQuestion.yourAnswer[l].trueAnswer != userQuestion.trueAnswer[l].trueAnswer) {
                  userCorrect = false;
                  break;
                }
              }
            } else {
              userCorrect = false;
            }

            if (userCorrect) {
              correctAnswersCount++;

              for (int l = 0; l < rationalUser.first.jurusan.length; l++) {
                for (int m = 0; m < rationalUser.first.jurusan[l].relevance.length; m++) {
                  if (question.subjectRelevance == rationalUser.first.jurusan[l].relevance[m]) {
                    rationalUser.first.jurusan[l].value = rationalUser.first.jurusan[l].value + 1;
                  }
                }
              }
            }
          }

          double correctPercentage = correctAnswersCount / sameTryoutUsers.length;

          int questionScore;
          int difficultyRating;

          if (correctPercentage < 0.2) {
            difficultyRating = 3;
            questionScore = 3;
          } else if (correctPercentage >= 0.2 && correctPercentage <= 0.5) {
            difficultyRating = 2;
            questionScore = 2;
          } else {
            difficultyRating = 1;
            questionScore = 1;
          }

          bool isCorrect;
          bool isUnanswered = false;

          if (question is CheckModel) {
            isCorrect = question.yourAnswer.toSet().containsAll(question.trueAnswer);
            isUnanswered = question.yourAnswer.isEmpty;
          } else if (question is PgModel || question is StuffingModel) {
            isUnanswered = question.yourAnswer.isEmpty;
            isCorrect = question.yourAnswer.contains(question.trueAnswer);
          } else if (question is TrueFalseModel) {
            isUnanswered = question.yourAnswer.isEmpty;
            isCorrect = true;
            for (int l = 0; l < question.trueAnswer.length; l++) {
              if (question.yourAnswer[l].option != question.trueAnswer[l].option || question.yourAnswer[l].trueAnswer != question.trueAnswer[l].trueAnswer) {
                isCorrect = false;
                break;
              }
            }
          } else {
            isCorrect = false;
          }

          if (isUnanswered) {
            allUserTo[userIndex]!.unanswered++;
          } else if (isCorrect) {
            allUserTo[userIndex]!.correctAnswer++;
            question.value = questionScore;
            question.rating = difficultyRating;
            totalScore += questionScore;
            subtestScore += questionScore;
          } else {
            allUserTo[userIndex]!.wrongAnswer++;
          }
        }

        // print('Ini nilai total dari ${test.nameTest} subtest ${subtest.nameSubTest} = $subtestScore');
        allUserTo[userIndex]!.listTest[i].listSubtest[j].totalSubtest = subtestScore;
      }
    }

    allUserTo[userIndex]!.average = totalQuestions > 0 ? totalScore / totalQuestions : 0;
    allUserTo[userIndex]!.valuesDiscussion = totalScore;

    allUserTo[userIndex]!.rationalization = List.generate(
      rationalUser.first.jurusan.length,
      (index) => RationalizationModel(
        value: rationalUser.first.jurusan[index].value,
        jurusan: rationalUser.first.jurusan[index].namaJurusan,
        universitas: profile!.listPlan[index].universitas,
      ),
    );
    print("nilai rationalization jurusan 0 ${rationalUser.first.jurusan[0].namaJurusan}: ${rationalUser.first.jurusan[0].value}");
    print("nilai rationalization jurusan 1 ${rationalUser.first.jurusan[1].namaJurusan}: ${rationalUser.first.jurusan[1].value}");
    print("nilai rationalization jurusan 2 ${rationalUser.first.jurusan[2].namaJurusan}: ${rationalUser.first.jurusan[2].value}");
    print("nilai rationalization jurusan 3 ${rationalUser.first.jurusan[3].namaJurusan}: ${rationalUser.first.jurusan[3].value}");

    print("Total Questions: $totalQuestions");
    print("Correct Answers: ${allUserTo[userIndex]!.correctAnswer}");
    print("Wrong Answers: ${allUserTo[userIndex]!.wrongAnswer}");
    print("Unanswered: ${allUserTo[userIndex]!.unanswered}");
    print("Average Score: ${allUserTo[userIndex]!.average}");

    //=============== cari peringakat keseluruhan ===============
    List<UserToModel?> sortedList = List.from(allUserTo)..sort((a, b) => b!.average.compareTo(a!.average));
    int position = sortedList.indexWhere((user) => user!.userUID == allUserTo[userIndex]!.userUID);

    int rank = position != -1 ? position + 1 : -1;
    if (rank != -1) {
      allUserTo[userIndex]!.leaderBoard.add(LeaderBoardModel(overallRating: allUserTo.length, tryoutRating: rank));
      // print("User dengan userUID = ${allUserTo[userIndex]!.userUID} berada di peringkat ke: $rank dari keseluruhan user");
    }

    //=============== cari peringkat berdasarkan tryout yang diambil ===============
    var filteredList = allUserTo.where((user) => user!.toName == allUserTo[userIndex]!.toName).toList();
    filteredList.sort((a, b) => b!.average.compareTo(a!.average));
    int positionTO = filteredList.indexWhere((user) => user!.userUID == allUserTo[userIndex]!.userUID);
    int rankTO = positionTO != -1 ? positionTO + 1 : -1;

    if (rankTO != -1) {
      allUserTo[userIndex]!.leaderBoard.add(LeaderBoardModel(overallRating: filteredList.length, tryoutRating: rankTO));
      // print("User dengan userUID = ${allUserTo[userIndex]!.userUID} berada di peringkat ke: $rankTO di tryout ${allUserTo[userIndex]!.toName}");
    }
  }

  Future<void> onSave() async {
    RationalizationUserModel newRationalization = RationalizationUserModel(
      jurusan: rationalUser.first.jurusan,
      created: DateTime.now(),
      userUID: rationalUser.first.userUID,
      idTryout: rationalUser.first.idTryout,
      idUserTo: rationalUser.first.idUserTo,
    );
    try {
      await UserToService.edit(
        id: idUserTo,
        userUID: allUserTo[userIndex]!.userUID,
        idTryOut: allUserTo[userIndex]!.idTryOut,
        toName: allUserTo[userIndex]!.toName,
        valuesDiscussion: allUserTo[userIndex]!.valuesDiscussion,
        average: allUserTo[userIndex]!.average,
        unanswered: allUserTo[userIndex]!.unanswered,
        correctAnswer: allUserTo[userIndex]!.correctAnswer,
        wrongAnswer: allUserTo[userIndex]!.wrongAnswer,
        startWork: allUserTo[userIndex]!.startWork,
        endWork: allUserTo[userIndex]!.endWork,
        created: allUserTo[userIndex]!.created,
        leaderBoard: allUserTo[userIndex]!.leaderBoard,
        rationalization: allUserTo[userIndex]!.rationalization,
        listTest: allUserTo[userIndex]!.listTest,
      );
      await RationalizationUserService.add(newRationalization);
    } catch (e) {
      print('ada salah di save result user page,\n$e');
    }
  }

  dynamic page = Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.note_alt_outlined, size: 100, color: Colors.black.withOpacity(.3)),
        Text(
          'Pilih soal untuk melihat detail\nketerangan soal yang sudah di jawab',
          style: TextStyle(fontSize: h1, color: Colors.black.withOpacity(.3), fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  void kembaliKeTryout(BuildContext context) {
    Navigator.pushAndRemoveUntil(context, FadeRoute1(const TryoutUserPage(idPage: 0)), (Route<dynamic> route) => false);
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context),
      body: Row(
        children: [
          SizedBox(height: tinggi(context), width: lebar(context) <= 1100 ? 300 : 500, child: sideInfo(context)),
          Expanded(flex: 4, child: Container(margin: const EdgeInsets.only(left: 10), height: tinggi(context), child: page)),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: appbarMo(
          context: context,
        ),
        body: sideInfo(context),
      );

  Widget sideInfo(BuildContext context) {
    var onMobile = lebar(context) <= 800;
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: TextButton.icon(
            onPressed: () => kembaliKeTryout(context),
            style: TextButton.styleFrom(backgroundColor: primary),
            icon: const Icon(Icons.navigate_before_rounded, color: Colors.white),
            label: Text('Kembali ke Dashboard TryOut', style: TextStyle(fontSize: h4, color: Colors.white)),
          ),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
          child: Column(
            children: [
              Text(
                allUserTo[userIndex]!.toName,
                style: TextStyle(fontSize: h2, color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 70,
                margin: const EdgeInsets.only(top: 30),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(allUserTo[userIndex]!.average.toString(), style: TextStyle(fontSize: h1, color: primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                          Text(allUserTo[userIndex]!.correctAnswer.toString(),
                              style: TextStyle(fontSize: h1, color: primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                          Text(allUserTo[userIndex]!.wrongAnswer.toString(),
                              style: TextStyle(fontSize: h1, color: secondary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                          Text(
                            allUserTo[userIndex]!.unanswered.toString(),
                            style: TextStyle(fontSize: h1, color: Colors.black, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text('Kosong', style: TextStyle(fontSize: h5, color: Colors.black, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
                        Text(
                          '${allUserTo[userIndex]!.leaderBoard[0].tryoutRating}/${allUserTo[userIndex]!.leaderBoard[0].overallRating} peserta',
                          style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Peringkat Tryout', style: TextStyle(fontSize: h5 + 2, color: Colors.black), textAlign: TextAlign.start),
                        Text(
                          '${allUserTo[userIndex]!.leaderBoard[1].tryoutRating}/${allUserTo[userIndex]!.leaderBoard[1].overallRating} peserta',
                          style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
                    profile!.listPlan.length,
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
                              Text(
                                profile!.listPlan[index].jurusan,
                                style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                              Text(
                                profile!.listPlan[index].universitas,
                                style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          ),
                          Text(
                            rationalUser.first.jurusan[index].value.toString(),
                            style: TextStyle(fontSize: h5 + 2, color: Colors.black, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                child: LinearProgressIndicator(borderRadius: BorderRadius.circular(50), color: primary, value: allUserTo[userIndex]!.valuesDiscussion / 1000, minHeight: 10),
              ),
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
              Column(
                children: List.generate(
                  allUserTo[userIndex]!.listTest.length,
                  (indexTest) {
                    return Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            allUserTo[userIndex]!.listTest[indexTest].nameTest,
                            style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                            allUserTo[userIndex]!.listTest[indexTest].listSubtest.length,
                            (indexSubtest) => Container(
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
                                          allUserTo[userIndex]!.listTest[indexTest].listSubtest[indexSubtest].nameSubTest,
                                          style: TextStyle(fontSize: h4, color: Colors.black),
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: primary),
                                        child: Text(
                                          allUserTo[userIndex]!.listTest[indexTest].listSubtest[indexSubtest].totalSubtest.toString(),
                                          style: TextStyle(fontSize: h5 + 1, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: [
                                    Wrap(
                                      children: List.generate(
                                        allUserTo[userIndex]!.listTest[indexTest].listSubtest[indexSubtest].listQuestions.length,
                                        (indexQuest) {
                                          var question = allUserTo[userIndex]!.listTest[indexTest].listSubtest[indexSubtest].listQuestions[indexQuest];
                                          return InkWell(
                                            onTap: () {
                                              if (question is CheckModel) {
                                                page = ResultCheckUserPage(question: question);
                                              } else if (question is PgModel) {
                                                page = ResultPgUserPage(question: question);
                                              } else if (question is StuffingModel) {
                                                page = ResultStuffingUserPage(question: question);
                                              } else if (question is TrueFalseModel) {
                                                page = ResultTruefalseUserPage(question: question);
                                              }
                                              if (onMobile) {
                                                Navigator.push(context, FadeRoute1(page));
                                              }
                                              setState(() {});
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
                                                  child: Text('${indexQuest + 1}', style: TextStyle(fontSize: h4, color: Colors.white), textAlign: TextAlign.start),
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
                                                    child: Icon(
                                                      (question.value != 0) ? Icons.check_circle_rounded : Icons.cancel,
                                                      color: (question.value != 0) ? primary : secondary,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: List.generate(question.rating!, (index3) => const Icon(Icons.star, color: Colors.orange, size: 15)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )),
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
