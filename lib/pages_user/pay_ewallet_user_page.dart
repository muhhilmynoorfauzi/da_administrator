import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/pay_done_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PayEwalletUserPage extends StatefulWidget {
  const PayEwalletUserPage({super.key});

  @override
  State<PayEwalletUserPage> createState() => _PayEwalletUserPageState();
}

class _PayEwalletUserPageState extends State<PayEwalletUserPage> {
  var isLogin = true;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  void payment(BuildContext context) {
    Navigator.push(context, FadeRoute1(const PayDoneUserPage()));
  }

  Future<void> showMetode({required BuildContext context}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              titlePadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.all(20),
              content: SizedBox(
                width: 500,
                child: ListView(
                  children: [],
                ),
              ),
              actionsPadding: EdgeInsets.zero,
            );
          },
        );
      },
    );
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true, isLogin: isLogin = true),
      body: ListView(
        children: [
          //tombol kembali
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 700,
              alignment: Alignment.centerLeft,
              child: Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.only(right: 10),
                child: TextButton(
                  onPressed: () {
                    context.read<CounterProvider>().setTitleUserPage('Dream Academy - TryOut Dream Academy');
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                  child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                ),
              ),
            ),
          ),
          //
          Center(child: Text('Order', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black))),
          Center(
            child: Container(
              height: 150,
              width: 700,
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: urlImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Try Out UTBK 2024 #9 - SNBT', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                        Text('Tes Potensi Skolastik (TPS) dan Tes Literasi', style: TextStyle(fontSize: h4, color: Colors.black)),
                        const Expanded(child: SizedBox()),
                        Text('Rp 20.000', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          //metode
          Center(
            child: Container(
              width: 700,
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 35,
                // width: 300,
                child: OutlinedButton.icon(
                  onPressed: () => showMetode(context: context),
                  style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30)),
                  icon: const Icon(Icons.navigate_next_rounded, color: Colors.black),
                  iconAlignment: IconAlignment.end,
                  label: Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                ),
              ),
            ),
          ),
          SizedBox(height: tinggi(context) * .37),
          //Ringkasan
          Center(
            child: Container(
              width: 700,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 30),
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ringkasan', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Harga', style: TextStyle(fontSize: h4, color: Colors.black)),
                      Text('Rp 20.000', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                      Text('Gopay', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          //Total
          Center(
            child: Container(
              width: 700,
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('Rp 20.000', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => payment(context),
                      style: TextButton.styleFrom(backgroundColor: primary),
                      child: Text('Bayar', style: TextStyle(fontSize: h4, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
