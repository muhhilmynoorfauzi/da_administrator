// QuestTruefalseUserPage
import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/model/questions/pg_model.dart';
import 'package:da_administrator/model/questions/stuffing_model.dart';
import 'package:da_administrator/model/questions/truefalse_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class ResultTruefalseUserPage extends StatefulWidget {
  const ResultTruefalseUserPage({super.key, required this.question});

  final TrueFalseModel question;

  @override
  State<ResultTruefalseUserPage> createState() => _ResultTruefalseUserPageState();
}

class _ResultTruefalseUserPageState extends State<ResultTruefalseUserPage> {
  var isLogin = true;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  String? selected;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMobile(context);
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 5 / 1,
                    child: CachedNetworkImage(
                      imageUrl: urlImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Text(widget.question.question, style: TextStyle(color: Colors.black, fontSize: h4)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
              widget.question.trueAnswer.length,
                  (index) {
                var option = widget.question.trueAnswer[index];
                int? idSelected;
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      width: lebar(context) * .55,
                      margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                      child: Row(
                        children: [
                          Text(option.option, style: TextStyle(color: Colors.black, fontSize: h4)),
                          const Expanded(child: SizedBox()),
                          InkWell(
                            onTap: () {
                              setState(() => idSelected = 0);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (idSelected == 0) ? primary : Colors.black),
                                color: (idSelected == 0) ? primary : Colors.white,
                              ),
                              child: Text('Benar', style: TextStyle(color: (idSelected == 0) ? Colors.white : Colors.black, fontSize: h4)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              setState(() => idSelected = 1);
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 100,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: (idSelected == 1) ? primary : Colors.black),
                                color: (idSelected == 1) ? primary : Colors.white,
                              ),
                              child: Text('Salah', style: TextStyle(color: (idSelected == 1) ? Colors.white : Colors.black, fontSize: h4)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
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