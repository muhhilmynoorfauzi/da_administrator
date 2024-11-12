import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/detail_tryout_user_page.dart';
import 'package:da_administrator/pages_user/tryout_selengkapnya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/tryout/tryout_model.dart';

class TryoutPublicUserPage extends StatefulWidget {
  const TryoutPublicUserPage({super.key});

  @override
  State<TryoutPublicUserPage> createState() => _TryoutPublicUserPageState();
}

class _TryoutPublicUserPageState extends State<TryoutPublicUserPage> {
  String userUid = 'bBm35Y9GYcNR8YHu2bybB61lyEr1';
  TextEditingController foundController = TextEditingController();
  List<TryoutModel> allTryout = [];
  List<String> idAllTryout = [];

  List<TryoutModel> ongoingTryout = [];
  List<String> idOngoingTryout = [];

  List<TryoutModel> filteredTryout = [];
  List<String> idFilteredTryout = [];

  TryoutModel? foundTryout;
  String? idFoundTryout;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 800) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDataProduct();
  }

  void getDataProduct() async {
    allTryout = [];
    idAllTryout = [];

    ongoingTryout = [];
    idOngoingTryout = [];

    filteredTryout = [];
    idFilteredTryout = [];

    foundTryout = null;
    idFoundTryout = null;
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('tryout_v2');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('created', descending: false).get();

      allTryout = querySnapshot.docs.map((doc) => TryoutModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idAllTryout = querySnapshot.docs.map((doc) => doc.id).toList();

      for (int i = 0; i < allTryout.length; i++) {
        if (allTryout[i].public) {
          filteredTryout.add(allTryout[i]);
          idFilteredTryout.add(idAllTryout[i]);
          if (DateTime.now().isAfter(allTryout[i].started) && DateTime.now().isBefore(allTryout[i].ended)) {
            ongoingTryout.add(allTryout[i]);
            idOngoingTryout.add(idAllTryout[i]);
          }
        }
      }

      setState(() {});
    } catch (e) {
      print('salah public user: $e');
    }
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    return formatter.format(dateTime);
  }

  void selengkapnya(BuildContext context) {
    Navigator.push(context, FadeRoute1(const TryoutSelengkapnyaUserPage()));
  }

  Widget onDesk(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: lebar(context),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text('TryOut Kerjasama', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  //Cari Kode
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextFormField(
                          controller: foundController,
                          style: TextStyle(color: Colors.black, fontSize: h4 - 2),
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Kode TryOut',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(.3), fontSize: h4 - 2),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 2, color: primary)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 2, color: primary)),
                            prefixIcon: Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black.withOpacity(.1)),
                              child: const Icon(Icons.search, color: Colors.grey, size: 20),
                            ),
                          ),
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            foundTryout = null;
                            idFoundTryout = null;
                            for (int i = 0; i < allTryout.length; i++) {
                              if (allTryout[i].toCode == foundController.text) {
                                foundTryout = allTryout[i];
                                idFoundTryout = idAllTryout[i];
                              }
                            }
                            setState(() {});
                          },
                          style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                          child: Text('Cari', style: TextStyle(color: Colors.white, fontSize: h4)),
                        ),
                      ),
                    ],
                  ),
                  if (foundTryout != null) const SizedBox(height: 10),
                  if (foundTryout != null) Text('TryOut Ditemukan', style: TextStyle(fontSize: h4, color: Colors.black)),
                  if (foundTryout != null)
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        var claimed = false;
                        for (int i = 0; i < foundTryout!.claimedUid.length; i++) {
                          if (foundTryout?.claimedUid[i].userUID == userUid) {
                            claimed = true;
                          }
                        }
                        return cardTryoutDesk(
                          context: context,
                          imageUrl: foundTryout!.image,
                          title: foundTryout!.toName,
                          desk: foundTryout!.desk,
                          readyOnFree: true,
                          started: foundTryout!.started,
                          ended: foundTryout!.ended,
                          claimed: claimed,
                          onTap: () {
                            Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idFoundTryout!)));
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 50),
                  //Tryout Sedang berlangsung
                  Text('TryOut Sedang Berlangsung', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  if (ongoingTryout.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        ongoingTryout.length,
                        (index) {
                          var claimed = false;
                          for (int i = 0; i < ongoingTryout[index].claimedUid.length; i++) {
                            if (ongoingTryout[index].claimedUid[i].userUID == userUid) {
                              claimed = true;
                            }
                          }
                          return cardTryoutDesk(
                            context: context,
                            imageUrl: ongoingTryout[index].image,
                            title: ongoingTryout[index].toName,
                            desk: ongoingTryout[index].desk,
                            readyOnFree: ongoingTryout[index].showFreeMethod,
                            started: ongoingTryout[index].started,
                            ended: ongoingTryout[index].ended,
                            claimed: claimed,
                            onTap: () {
                              Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idOngoingTryout[index])));
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 50),

                  //Tryout Tersedia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Tersedia', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  Text('Butuh tantangan? Ikuti TryOut ini!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  if (filteredTryout.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        filteredTryout.length,
                        (index) {
                          var claimed = false;
                          for (int i = 0; i < filteredTryout[index].claimedUid.length; i++) {
                            if (filteredTryout[index].claimedUid[i].userUID == userUid) {
                              claimed = true;
                            }
                          }
                          return cardTryoutDesk(
                            context: context,
                            imageUrl: filteredTryout[index].image,
                            title: filteredTryout[index].toName,
                            desk: filteredTryout[index].desk,
                            readyOnFree: filteredTryout[index].showFreeMethod,
                            started: filteredTryout[index].started,
                            ended: filteredTryout[index].ended,
                            claimed: claimed,
                            onTap: () {
                              Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idFilteredTryout[index])));
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 50),
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

  Widget onMo(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            width: lebar(context),
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            child: SizedBox(
              width: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  Text('TryOut Kerjasama', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  //Cari Kode
                  Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: TextFormField(
                          controller: foundController,
                          style: TextStyle(color: Colors.black, fontSize: h4 - 2),
                          maxLines: 1,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Kode TryOut',
                            hintStyle: TextStyle(color: Colors.black.withOpacity(.3), fontSize: h4 - 2),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 2, color: primary)),
                            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide(width: 2, color: primary)),
                            prefixIcon: Container(
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.all(5),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.black.withOpacity(.1)),
                              child: const Icon(Icons.search, color: Colors.grey, size: 20),
                            ),
                          ),
                          inputFormatters: [
                            TextInputFormatter.withFunction((oldValue, newValue) => TextEditingValue(text: newValue.text.toUpperCase(), selection: newValue.selection)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 40,
                        child: TextButton(
                          onPressed: () {
                            foundTryout = null;
                            idFoundTryout = null;
                            for (int i = 0; i < allTryout.length; i++) {
                              if (allTryout[i].toCode == foundController.text) {
                                foundTryout = allTryout[i];
                                idFoundTryout = idAllTryout[i];
                              }
                            }
                            setState(() {});
                          },
                          style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 20)),
                          child: Text('Cari', style: TextStyle(color: Colors.white, fontSize: h4)),
                        ),
                      ),
                    ],
                  ),
                  if (foundTryout != null) const SizedBox(height: 10),
                  if (foundTryout != null) Text('TryOut Ditemukan', style: TextStyle(fontSize: h4, color: Colors.black)),
                  if (foundTryout != null)
                    StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        var claimed = false;
                        for (int i = 0; i < foundTryout!.claimedUid.length; i++) {
                          if (foundTryout?.claimedUid[i].userUID == userUid) {
                            claimed = true;
                          }
                        }
                        return cardTryoutDesk(
                          context: context,
                          imageUrl: foundTryout!.image,
                          title: foundTryout!.toName,
                          desk: foundTryout!.desk,
                          readyOnFree: true,
                          started: foundTryout!.started,
                          ended: foundTryout!.ended,
                          claimed: claimed,
                          onTap: () {
                            Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idFoundTryout!)));
                          },
                        );
                      },
                    ),
                  const SizedBox(height: 50),
                  //Tryout Sedang berlangsung
                  Text('TryOut Sedang Berlangsung', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  if (ongoingTryout.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        ongoingTryout.length,
                        (index) {
                          var claimed = false;
                          for (int i = 0; i < ongoingTryout[index].claimedUid.length; i++) {
                            if (ongoingTryout[index].claimedUid[i].userUID == userUid) {
                              claimed = true;
                            }
                          }
                          return cardTryoutMo(
                            context: context,
                            imageUrl: ongoingTryout[index].image,
                            title: ongoingTryout[index].toName,
                            desk: ongoingTryout[index].desk,
                            readyOnFree: ongoingTryout[index].showFreeMethod,
                            started: ongoingTryout[index].started,
                            ended: ongoingTryout[index].ended,
                            claimed: claimed,
                            onTap: () {
                              Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idOngoingTryout[index])));
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 50),

                  //Tryout Tersedia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TryOut Tersedia', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  Text('Butuh tantangan? Ikuti TryOut ini!', style: TextStyle(fontSize: h4, color: Colors.black)),
                  const SizedBox(height: 5),
                  if (filteredTryout.isNotEmpty)
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: List.generate(
                        filteredTryout.length,
                        (index) {
                          var claimed = false;
                          for (int i = 0; i < filteredTryout[index].claimedUid.length; i++) {
                            if (filteredTryout[index].claimedUid[i].userUID == userUid) {
                              claimed = true;
                            }
                          }
                          return cardTryoutMo(
                            context: context,
                            imageUrl: filteredTryout[index].image,
                            title: filteredTryout[index].toName,
                            desk: filteredTryout[index].desk,
                            readyOnFree: filteredTryout[index].showFreeMethod,
                            started: filteredTryout[index].started,
                            ended: filteredTryout[index].ended,
                            claimed: claimed,
                            onTap: () {
                              Navigator.push(context, FadeRoute1(DetailTryoutUserPage(docId: idFilteredTryout[index])));
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          //footer
          footerMo(context: context)
        ],
      ),
    );
  }

  Widget cardTryoutDesk({
    required BuildContext context,
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
      width: (lebar(context) <= 1000) ? 380 : 480,
      height: (lebar(context) <= 1000) ? 200 : 170,
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
                    aspectRatio: (lebar(context) <= 1000) ? 3 / 4 : 1,
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
                      Text(
                        '${formatDateTime(started)} - ${formatDateTime(ended)}',
                        style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        desk,
                        style: TextStyle(fontSize: h4, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: claimed
                            ? 3
                            : (lebar(context) <= 1000)
                                ? 5
                                : 3,
                        textAlign: TextAlign.justify,
                      ),
                      const Expanded(child: SizedBox()),
                      if (!(lebar(context) <= 1000))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (claimed)
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                                    const SizedBox(width: 5),
                                    Text('JOINED', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.white)),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            Text(readyOnFree ? 'Berbayar dan Gratis' : 'Berbayar', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: primary)),
                          ],
                        ),
                      if ((lebar(context) <= 1000))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (claimed)
                              Container(
                                width: 150,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                                    const SizedBox(width: 5),
                                    Text('JOINED', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget cardTryoutMo({
    required BuildContext context,
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
      width: 600,
      height: 190,
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
                    aspectRatio: (lebar(context) <= 500) ? 3 / 4 : 1,
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
                      Text(
                        '${formatDateTime(started)} - ${formatDateTime(ended)}',
                        style: TextStyle(fontSize: h5 + 2, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 4,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        desk,
                        style: TextStyle(fontSize: h4, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                      ),
                      const Expanded(child: SizedBox()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (claimed)
                            Container(
                              width: 140,
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(50)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
                                  const SizedBox(width: 5),
                                  Text('JOINED', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.white)),
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
}
