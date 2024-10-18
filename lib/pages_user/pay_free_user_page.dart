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

class PayFreeUserPage extends StatefulWidget {
  const PayFreeUserPage({super.key, required this.docId, required this.tryoutUser});

  final String docId;
  final TryoutModel? tryoutUser;

  @override
  State<PayFreeUserPage> createState() => _PayFreeUserPageState();
}

class _PayFreeUserPageState extends State<PayFreeUserPage> {
  var isLogin = true;

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
    super.initState();
    // print('ini merupakan id yang mau di beli ${widget.docId}');
  }

  Future<void> payment(BuildContext context) async {
    var claimedUid = widget.tryoutUser!.claimedUid;
    claimedUid.add(
      ClaimedModel(
        userUID: 'userUID123',
        payment: 'FreeMethod',
        created: DateTime.now(),
        tryoutID: widget.docId,
        approval: false,
        name: 'Muh. Hilmy',
        imgFollow: '/image',
        price: 0,
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
                        imageUrl: widget.tryoutUser!.image,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
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
                          Text(widget.tryoutUser!.toName, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                          Expanded(
                            child: Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                widget.tryoutUser!.desk,
                                style: TextStyle(fontSize: h4, color: Colors.black),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.justify,
                              ),
                            ),
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
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                    child: TextFormField(
                      style: TextStyle(color: Colors.black, fontSize: h4),
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Nama',
                        hintStyle: TextStyle(color: Colors.black.withOpacity(.3), fontSize: h4),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                      ),
                    ),
                  ),
                  Container(
                    height: 250,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Upload Bukti Follow', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Container(
                          height: 100,
                          width: 100,
                          color: Colors.grey,
                          //image boxfit.cover
                        ),
                        Text(
                          'belum ada gambar\nsilahkan pilih gambar',
                          style: TextStyle(fontSize: h5, color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 35,
                          child: OutlinedButton(
                            onPressed: () {},
                            child: Text('Pilih Gambar', style: TextStyle(fontSize: h4, color: Colors.black)),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: tinggi(context) * .1),
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
                      Text('Rp 0', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Metode Pembayaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                      Text('Follow (free)', style: TextStyle(fontSize: h4, color: Colors.black)),
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
                      Text('Rp 0', style: TextStyle(fontSize: h2, fontWeight: FontWeight.bold, color: Colors.black)),
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
