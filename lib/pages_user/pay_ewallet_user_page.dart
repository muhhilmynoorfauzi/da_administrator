import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/firebase_service/tryout_service.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/model/tryout/claimed_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/pay_done_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PayEwalletUserPage extends StatefulWidget {
  const PayEwalletUserPage({super.key, required this.docId, required this.tryoutUser});

  final String docId;
  final TryoutModel? tryoutUser;

  @override
  State<PayEwalletUserPage> createState() => _PayEwalletUserPageState();
}

class _PayEwalletUserPageState extends State<PayEwalletUserPage> {
  // bool isLogin = true;
  var total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    total = widget.tryoutUser!.listPrice.first;
  }

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  Future<void> payment(BuildContext context) async {
    var claimedUid = widget.tryoutUser!.claimedUid;
    claimedUid.add(
      ClaimedModel(
        userUID: 'bBm35Y9GYcNR8YHu2bybB61lyEr1',
        payment: 'Gopay',
        created: DateTime.now(),
        tryoutID: widget.docId,
        approval: false,
        name: 'Muh. Hilmy',
        imgFollow: '',
        price: widget.tryoutUser!.listPrice.first,
      ),
    );
    await TryoutService.edit(
      id: widget.docId,
      claimedUid: claimedUid,
      created: widget.tryoutUser!.created,
      updated: widget.tryoutUser!.updated,
      toCode: widget.tryoutUser!.toCode,
      toName: widget.tryoutUser!.toName,
      started: widget.tryoutUser!.started,
      ended: widget.tryoutUser!.ended,
      desk: widget.tryoutUser!.desk,
      image: widget.tryoutUser!.image,
      phase: widget.tryoutUser!.phase,
      phaseIRT: widget.tryoutUser!.phaseIRT,
      expired: widget.tryoutUser!.expired,
      public: widget.tryoutUser!.public,
      showFreeMethod: widget.tryoutUser!.showFreeMethod,
      totalTime: widget.tryoutUser!.totalTime,
      numberQuestions: widget.tryoutUser!.numberQuestions,
      listTest: widget.tryoutUser!.listTest,
      listPrice: widget.tryoutUser!.listPrice,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    Navigator.push(context, FadeRoute1(const PayDoneUserPage(second: 5)));
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
              contentPadding: const EdgeInsets.all(10),
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
      appBar: appbarDesk(context: context, featureActive: true),
      body: ListView(
        children: [
          //tombol kembali
          Center(
            child: Container(
              width: 1000,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    margin: const EdgeInsets.only(right: 10, left: 10),
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
                        imageUrl: widget.tryoutUser!.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Try Out UTBK 2024 #9 - SNBT', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.tryoutUser!.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(widget.tryoutUser!.listPrice.first),
                            style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
                      Text(
                        NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(widget.tryoutUser!.listPrice.first),
                        style: TextStyle(fontSize: h4, color: Colors.black),
                      ),
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
                      Text(
                        NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(total),
                        style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
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

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(context: context, ),
      body: ListView(
        children: [
          //tombol kembali
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(10),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(backgroundColor: primary, padding: EdgeInsets.zero),
                  child: const Icon(Icons.navigate_before_rounded, color: Colors.white),
                ),
              ),
              Text('Kembali', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black))
            ],
          ),
          //judul
          Center(child: Text('Order', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black))),
          //isi
          Center(
            child: Container(
              height: 150,
              width: 700,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: widget.tryoutUser!.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Try Out UTBK 2024 #9 - SNBT', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.tryoutUser!.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(widget.tryoutUser!.listPrice.first),
                            style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
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
              margin: const EdgeInsets.only(right: 10),
              child: SizedBox(
                height: 35,
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
          SizedBox(height: tinggi(context) * .5),
        ],
      ),
      //Ringkasan
      bottomNavigationBar: Container(
        width: 700,
        height: 200,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ringkasan', style: TextStyle(fontSize: h3, fontWeight: FontWeight.bold, color: Colors.black)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Harga', style: TextStyle(fontSize: h4, color: Colors.black)),
                Text(
                  NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(widget.tryoutUser!.listPrice.first),
                  style: TextStyle(fontSize: h4, color: Colors.black),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                Text('Gopay', style: TextStyle(fontSize: h4, color: Colors.black)),
              ],
            ),
            Container(width: double.infinity, height: 1, color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
                Text(
                  NumberFormat.currency(locale: 'id', decimalDigits: 0, name: 'Rp ').format(total),
                  style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
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
    );
  }
}
