import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/example.dart';
import 'package:da_administrator/model/questions/questions_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/detail_tryout_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';

class TryoutSelengkapnyaUserPage extends StatefulWidget {
  final List<TryoutModel> allTryout;
  final List<String> idAllTryout;
  final List<QuestionsModel> allSubtest;
  final List<String> idAllSubtest;
  final List<TryoutReviewModel> allReview;
  final List<String> idAllReview;

  const TryoutSelengkapnyaUserPage({
    super.key,
    required this.allTryout,
    required this.idAllTryout,
    required this.allSubtest,
    required this.idAllSubtest,
    required this.allReview,
    required this.idAllReview,
  });

  @override
  State<TryoutSelengkapnyaUserPage> createState() => _TryoutSelengkapnyaUserPageState();
}

class _TryoutSelengkapnyaUserPageState extends State<TryoutSelengkapnyaUserPage> {
  // bool isLogin = true;

  List<TryoutModel> allTryout = [];
  List<String> idAllTryout = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allTryout = widget.allTryout;
    idAllTryout = widget.idAllTryout;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (allTryout.isNotEmpty) {
      return onDesk(context);
    } else {
      return Scaffold(backgroundColor: Colors.white, body: Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)));
    }
  }

  Widget cardTryout({
    required String imageUrl,
    required String title,
    required String desk,
    required bool readyOnFree,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 410,
      height: 170,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () => onTap(),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text(desk, style: TextStyle(fontSize: h4, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 4),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(readyOnFree ? 'Berbayar dan Gratis' : 'Berbayar', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: primary)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget onDesk(BuildContext context) {
    var onMo = (lebar(context) <= 700);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: onMo ? appbarMo(context: context) : appbarDesk(context: context, featureActive: true),
      body: ListView(
        children: [
          //Tryout Tersedia
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                      child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                    ),
                  ),
                  Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
                ],
              ),
            ),
          ),
          //Tryout Selesai
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daftar Semua TryOut',
                    style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  Text('Lihat semua TryOut yang tersedia!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      allTryout.length,
                      (index) => cardTryout(
                        imageUrl: allTryout[index].image,
                        title: allTryout[index].toName,
                        desk: allTryout[index].desk,
                        readyOnFree: allTryout[index].showFreeMethod,
                        onTap: () {
                          Navigator.push(
                            context,
                            FadeRoute1(
                              DetailTryoutUserPage(
                                tryoutUser: allTryout[index],
                                idTryout: idAllTryout[index],
                                allSubtest: widget.allSubtest,
                                idAllSubtest: widget.idAllSubtest,
                                allReview: widget.allReview,
                                idAllReview: widget.idAllReview,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          onMo ? footerMo(context: context) : footerDesk(context: context),
        ],
      ),
    );
  }
}
