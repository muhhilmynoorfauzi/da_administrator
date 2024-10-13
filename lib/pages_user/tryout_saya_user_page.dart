import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/pages/example.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/detail_mytryout_user_page.dart';
import 'package:da_administrator/pages_user/tryout_selengkapnya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TryoutSayaUserPage extends StatefulWidget {
  const TryoutSayaUserPage({super.key});

  @override
  State<TryoutSayaUserPage> createState() => _TryoutSayaUserPageState();
}

class _TryoutSayaUserPageState extends State<TryoutSayaUserPage> {
  var userUid = 'userUID123';
  TextEditingController foundController = TextEditingController();

  // var claimed = false;

  List<TryoutModel> allTryout = [];
  List<String> idAllTryout = [];

  List<TryoutModel> myTryout = [];
  List<String> idMyTryout = [];

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
    final profider = Provider.of<CounterProvider>(context, listen: false);
    super.initState();

    getDataProduct();
    profider.addListener(() => getDataProduct());
  }

  void getDataProduct() async {
    allTryout = [];
    idAllTryout = [];

    myTryout = [];
    idMyTryout = [];

    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('tryout_v1');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('created', descending: false).get();

      allTryout = querySnapshot.docs.map((doc) => TryoutModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllTryout = querySnapshot.docs.map((doc) => doc.id).toList();

      for (int i = 0; i < allTryout.length; i++) {
        if (allTryout[i].claimedUid.isNotEmpty) {
          for (int j = 0; j < allTryout[i].claimedUid.length; j++) {
            if (allTryout[i].claimedUid[j].userUID.contains(userUid)) {
              myTryout.add(allTryout[i]);
              idMyTryout.add(idAllTryout[i]);
            }
          }
        }
      }

      setState(() {});
    } catch (e) {
      print('salah home_page: $e');
    }
  }

  void selengkapnya(BuildContext context) {
    Navigator.push(context, FadeRoute1(const TryoutSelengkapnyaUserPage()));
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(dateTime);
  }

  Widget cardTryout({
    required String imageUrl,
    required String title,
    required String desk,
    required bool readyOnFree,
    required bool claimed,
    required VoidCallback onTap,
    required DateTime started,
    required DateTime ended,
  }) {
    return SizedBox(
      width: 495,
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
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      Text(
                        '${formatDateTime(started)} - ${formatDateTime(ended)}',
                        style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      Text(desk, style: TextStyle(fontSize: h4, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 3),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                            decoration: BoxDecoration(color: claimed ? primary : secondary, borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  claimed ? 'JOINED' : 'Waiting',
                                  style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            height: 500,
            width: double.infinity,
            color: primary,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Grafik Nilai Try Out UTBK', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                Text('Lihat Progresmu disini', style: TextStyle(color: Colors.white, fontSize: h4)),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: 1000,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      children: [
                        const Expanded(child: _LineChart()),
                        SizedBox(
                          width: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text('Jurusan', style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                              ),
                              Row(
                                children: [
                                  Container(height: 10, width: 10, color: Colors.pink, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: Text('Teknik Informatika', style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 30)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 10, width: 10, color: Colors.green, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: Text('Matematika', style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 30)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 10, width: 10, color: Colors.yellow, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: Text('Sasta Inggris', style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 30)
                                ],
                              ),
                              Row(
                                children: [
                                  Container(height: 10, width: 10, color: Colors.blue, margin: const EdgeInsets.symmetric(horizontal: 10)),
                                  Expanded(
                                    child: Text('Desain Komunikasi Visual', style: TextStyle(color: Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 30)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          //Tryout Tersedia
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Belum Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(
                        height: 30,
                        child: OutlinedButton.icon(
                          onPressed: () => selengkapnya(context),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                          iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                          label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                        ),
                      ),
                    ],
                  ),
                  Text('Lihat somua TO kamu milikl korjakan TO nya sokarang!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      myTryout.length,
                      (index) {
                        var claimed = false;

                        for (int i = 0; i < myTryout[index].claimedUid.length; i++) {
                          if (myTryout[index].claimedUid[i].userUID == userUid) {
                            claimed = myTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: myTryout[index].image,
                          title: myTryout[index].toName,
                          desk: myTryout[index].desk,
                          readyOnFree: myTryout[index].showFreeMethod,
                          claimed: claimed,
                          ended: myTryout[index].ended,
                          started: myTryout[index].started,
                          onTap: () {
                            Navigator.push(context, FadeRoute1(const DetailMytryoutUserPage()));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Tryout Selesai
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(
                        height: 30,
                        child: OutlinedButton.icon(
                          onPressed: () => selengkapnya(context),
                          style: OutlinedButton.styleFrom(side: BorderSide(color: primary)),
                          iconAlignment: IconAlignment.end,
                          icon: Icon(Icons.keyboard_double_arrow_right, color: primary, size: 20),
                          label: Text('Selengkapnya', style: TextStyle(fontSize: h4, color: primary)),
                        ),
                      ),
                    ],
                  ),
                  Text('Lihat semua TryOut yang telah kamu ikuti', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      myTryout.length,
                      (index) {
                        var claimed = false;

                        for (int i = 0; i < myTryout[index].claimedUid.length; i++) {
                          if (myTryout[index].claimedUid[i].userUID == userUid) {
                            claimed = myTryout[index].claimedUid[i].approval;
                          }
                        }
                        return cardTryout(
                          imageUrl: myTryout[index].image,
                          title: myTryout[index].toName,
                          desk: myTryout[index].desk,
                          readyOnFree: myTryout[index].showFreeMethod,
                          claimed: claimed,
                          started: myTryout[index].started,
                          ended: myTryout[index].ended,
                          onTap: () {
                            Navigator.push(context, FadeRoute1(const DetailMytryoutUserPage()));
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          //footer
          footerDesk(context: context),
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

//chart
class _LineChart extends StatelessWidget {
  const _LineChart();

  @override
  Widget build(BuildContext context) => LineChart(
        sampleData1,
        duration: const Duration(milliseconds: 200),
      );

  LineChartData get sampleData1 => LineChartData(
        minX: 0,
        maxX: 13,
        maxY: 5,
        minY: 0,
        gridData: const FlGridData(show: true),
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(getTooltipColor: (touchedSpot) => Colors.black.withOpacity(0)),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 35,
              interval: 1,
              getTitlesWidget: bottomTitleWidgets,
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
          leftTitles: AxisTitles(sideTitles: SideTitles(getTitlesWidget: leftTitleWidgets, showTitles: true, interval: 1, reservedSize: 40)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            bottom: BorderSide(color: Colors.black.withOpacity(0.8), width: 2),
            left: const BorderSide(color: Colors.transparent),
            right: const BorderSide(color: Colors.transparent),
            top: const BorderSide(color: Colors.transparent),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            color: Colors.green,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(1, 1),
              FlSpot(3, 1.5),
              FlSpot(5, 1.4),
              FlSpot(7, 3.4),
              FlSpot(10, 2),
              FlSpot(12, 2.2),
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.pink,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(1, 0),
              FlSpot(3, 2.8),
              FlSpot(7, 1.2),
              FlSpot(10, 2.8),
              FlSpot(12, 2.6),
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.orangeAccent,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(1, 2.8),
              FlSpot(3, 1.9),
              FlSpot(6, 3),
              FlSpot(10, 1.3),
            ],
          ),
          LineChartBarData(
            isCurved: true,
            color: Colors.blue,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(show: false),
            spots: const [
              FlSpot(1, 2),
              FlSpot(4, 3),
              FlSpot(7, 2.6),
              FlSpot(10, 3),
              FlSpot(12, 3),
            ],
          ),
        ],
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    String text = '${value}m';
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), textAlign: TextAlign.center);
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text('Jan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 2:
        text = const Text('Feb', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 3:
        text = const Text('Mar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 4:
        text = const Text('Apr', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 5:
        text = const Text('May', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 6:
        text = const Text('Jun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 7:
        text = const Text('Jul', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 8:
        text = const Text('Aug', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 9:
        text = const Text('Sep', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 10:
        text = const Text('Oct', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 11:
        text = const Text('Nov', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      case 12:
        text = const Text('Dec', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      // space: 20,
      // angle: 10,
      child: text,
    );
  }
}
