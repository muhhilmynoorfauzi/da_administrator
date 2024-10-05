import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages/example.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/service/color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:da_administrator/service/component.dart';

class TryoutSelengkapnyaUserPage extends StatefulWidget {
  const TryoutSelengkapnyaUserPage({super.key});

  @override
  State<TryoutSelengkapnyaUserPage> createState() => _TryoutSelengkapnyaUserPageState();
}

class _TryoutSelengkapnyaUserPageState extends State<TryoutSelengkapnyaUserPage> {
  var isLogin = true;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  Widget cardTryout({required String imageUrl, required String title, required String desk, required bool readyOnFree}) {
    return SizedBox(
      width: 495,
      height: 170,
      child: Card(
        margin: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {},
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true, isLogin: isLogin),
      body: ListView(
        children: [
          //Tryout Tersedia
          Container(
            width: double.infinity,
            alignment: Alignment.center,
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
                  Text('TryOut Saya', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
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
                  Text('TryOut Selesai', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  Text('Lihat semua TryOut yang telah kamu ikuti', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      12,
                      (index) => cardTryout(
                        imageUrl: 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp',
                        title: 'Try Out UTBK 2024 #11 - SNBT',
                        desk: 'Tes Potensi Skolastik (TPS) dan Tes Literasi',
                        readyOnFree: false,
                      ),
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
            barWidth: 4,
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
            barWidth: 4,
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
            barWidth: 4,
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
