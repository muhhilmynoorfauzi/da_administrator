import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/firebase_service/tryout_service.dart';
import 'package:da_administrator/model/tryout/claimed_model.dart';
import 'package:da_administrator/pages/detail_to_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/show_image_page.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailClaimed extends StatefulWidget {
  const DetailClaimed({super.key, required this.claimedUid, required this.titleTo});

  final List<ClaimedModel> claimedUid;
  final String titleTo;

  @override
  State<DetailClaimed> createState() => _DetailClaimedState();
}

class _DetailClaimedState extends State<DetailClaimed> {
  bool isLoading = false;
  late List<ClaimedModel> listClaimedUid;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        onMo(context),
        if (isLoading)
          Container(
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
    listClaimedUid = widget.claimedUid;

    // TODO: implement initState
    super.initState();
  }

//----------------------------------------------------------------
  void deleteClaimed(int index) {
    listClaimedUid.removeAt(index);
    setState(() {});
  }

//----------------------------------------------------------------

  Future<void> btnSimpan(BuildContext context, String id) async {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    setState(() => isLoading = !isLoading);
    await TryoutService.edit(
      id: id,
      created: tryoutGlobal!.created,
      updated: DateTime.now(),
      toCode: tryoutGlobal!.toCode,
      toName: tryoutGlobal!.toName,
      started: tryoutGlobal!.started,
      ended: tryoutGlobal!.ended,
      desk: tryoutGlobal!.desk,
      image: tryoutGlobal!.image,
      phase: tryoutGlobal!.phase,
      phaseIRT: tryoutGlobal!.phaseIRT,
      expired: tryoutGlobal!.expired,
      public: tryoutGlobal!.public,
      showFreeMethod: tryoutGlobal!.showFreeMethod,
      totalTime: tryoutGlobal!.totalTime,
      numberQuestions: tryoutGlobal!.numberQuestions,
      listTest: tryoutGlobal!.listTest,
      claimedUid: listClaimedUid,
      listPrice: tryoutGlobal!.listPrice,
    );
    await Future.delayed(const Duration(milliseconds: 200));
    setState(() => isLoading = !isLoading);
    profider.setReload();
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');

    return formatter.format(dateTime);
  }

  Widget onMo(BuildContext context) {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    var id = profider.getIdDetailPage!;
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
          label: Text(widget.titleTo, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        ),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(backgroundColor: primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () => btnSimpan(context, id),
            label: Text('Simpan', style: TextStyle(color: Colors.white, fontSize: h4)),
            icon: const Icon(Icons.check, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: List.generate(
          listClaimedUid.length,
          (index0) => Container(
            height: listClaimedUid[index0].imgFollow != '' ? 320 : 250,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: 1000,
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  //
                  return Card(
                    color: secondaryWhite,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Setujui Pembelian'.toString(), style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                Text(
                                  listClaimedUid[index0].approval ? 'Disetujui' : 'Belum\nDisetujui',
                                  style: TextStyle(color: Colors.black, fontSize: h5),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            value: listClaimedUid[index0].approval,
                            onChanged: (bool value) => setState(() => listClaimedUid[index0].approval = value),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  // color: Colors.blue,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Name User', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                        Text('userUID', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                        if (listClaimedUid[index0].imgFollow != '')
                                          Container(
                                            height: 60,
                                            alignment: Alignment.centerLeft,
                                            child: Text('Bukti Follow', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                          ),
                                        Text('Metode Pembayaran', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                        Text('Harga', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                        Text('Tanggal pembelian', style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                                // const SizedBox(width: 30),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(': ${listClaimedUid[index0].name}', style: TextStyle(fontSize: h4 - 2, fontWeight: FontWeight.bold, color: Colors.black)),
                                        Text(': ${listClaimedUid[index0].userUID}', style: TextStyle(fontSize: h4 - 2, fontWeight: FontWeight.bold, color: Colors.black)),
                                        if (listClaimedUid[index0].imgFollow != '')
                                          InkWell(
                                            onTap: () => Navigator.push(context, FadeRoute1(ShowImagePage(image: listClaimedUid[index0].imgFollow))),
                                            child: SizedBox(
                                              height: 60,
                                              width: 60,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl: listClaimedUid[index0].imgFollow,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeWidth: 3)),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                        Text(': ${listClaimedUid[index0].payment}', style: TextStyle(fontSize: h4 - 2, fontWeight: FontWeight.bold, color: Colors.black)),
                                        Text(
                                          NumberFormat.currency(locale: 'id', decimalDigits: 0, name: ': Rp ').format(listClaimedUid[index0].price),
                                          style: TextStyle(fontSize: h4 - 2, fontWeight: FontWeight.bold, color: Colors.black),
                                        ),
                                        Text(": ${formatDate(listClaimedUid[index0].created)}",
                                            style: TextStyle(fontSize: h4 - 2, fontWeight: FontWeight.bold, color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () => deleteClaimed(index0),
                                  label: Text('Hapus User Claimed'.toString(), style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                  icon: const Icon(Icons.delete, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
