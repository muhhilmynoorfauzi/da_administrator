import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/questions_service.dart';
import 'package:da_administrator/firebase_service/tryout_service.dart';
import 'package:da_administrator/model/tryout/subtest_model.dart';
import 'package:da_administrator/model/tryout/test_model.dart';
import 'package:da_administrator/model/tryout/tryout_model.dart';
import 'package:da_administrator/pages/detail_to_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int expiredID = 0;
  ScrollController homeController = ScrollController();

  bool onLoading = false;
  final List<String> menuOptions = ['Delete'];
  List<TryoutModel>? listTryOut;
  List<String> idListTryOut = [];

  List<TryoutModel> listAll = [];
  List<String> idListAll = [];

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return homeMobile(context);
    } else {
      return homeDesk(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final profider = Provider.of<CounterProvider>(context, listen: false);
    profider.addListener(() {
      getDataProduct();
    });
    getDataProduct();
  }

  void getDataProduct() async {
    try {
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('tryout_v1');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.orderBy('created', descending: false).get();

      listTryOut = querySnapshot.docs.map((doc) => TryoutModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      idListTryOut = querySnapshot.docs.map((doc) => doc.id).toList();

      listAll = listTryOut!;
      idListAll = idListTryOut;

      setState(() {});
    } catch (e) {
      print('salah Error: $e');
    }
  }

  Widget expiredWidget(int id, String title) {
    bool selected = (id == expiredID);
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: InkWell(
        onTap: () {
          List<TryoutModel> listSelected = [];
          List<String> idListSelected = [];
          DateTime now = DateTime.now();

          if (title == 'All') {
            listTryOut = listAll;
            idListTryOut = idListAll;
          } else if (title == 'Expired') {
            for (int i = 0; i < listAll.length; i++) {
              if (listAll[i].expired == true) {
                listSelected.add(listAll[i]);
                idListSelected.add(idListAll[i]);
              }
            }
            listTryOut = listSelected;
            idListTryOut = idListSelected;
          } else if (title == 'Publish') {
            for (int i = 0; i < listAll.length; i++) {
              if (listAll[i].public == true) {
                listSelected.add(listAll[i]);
                idListSelected.add(idListAll[i]);
              }
            }
            listTryOut = listSelected;
            idListTryOut = idListSelected;
          } else if (title == 'On-Going') {
            for (int i = 0; i < listAll.length; i++) {
              if ((now.isAtSameMomentAs(listAll[i].started) || now.isAfter(listAll[i].started)) && (now.isAtSameMomentAs(listAll[i].ended) || now.isBefore(listAll[i].ended))) {
                listSelected.add(listAll[i]);
                idListSelected.add(idListAll[i]);
              }
            }
            listTryOut = listSelected;
            idListTryOut = idListSelected;
          }

          expiredID = id;
          setState(() {});
        },
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: 25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: selected ? primary : Colors.black.withOpacity(.1),
          ),
          child: Text(title, style: TextStyle(color: selected ? Colors.white : Colors.black, fontSize: h5, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy');

    return formatter.format(dateTime);
  }

  Future<void> tambahTryout() async {
    var nowTime = DateTime.now();
    var img = 'https://firebasestorage.googleapis.com/v0/b/dreamacademy-example.appspot.com/o/question%2Fdefault_image.png?alt=media&token=d058ce51-799c-4f60-bf69-eb33efefb390';
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController controller = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          title: Text('Masukkan Nama Tryout', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(20),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder()),
            style: TextStyle(color: Colors.black, fontSize: h4),
          ),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.isNotEmpty) {
                  await TryoutService.add(
                    TryoutModel(
                      created: nowTime,
                      updated: nowTime,
                      toCode: '',
                      toName: controller.text,
                      ended: nowTime,
                      started: nowTime,
                      startWork: nowTime,
                      endWork: nowTime,
                      public: false,
                      showFreeMethod: false,
                      desk: '',
                      image: img,
                      phase: false,
                      expired: false,
                      totalTime: 30,
                      numberQuestions: 155,
                      listTest: [
                        TestModel(
                          nameTest: 'TPS',
                          listSubtest: [],
                        ),
                        TestModel(
                          nameTest: 'Tes Literasi',
                          listSubtest: [],
                        ),
                      ],
                      claimedUid: [],
                      listPrice: [200000, 400000, 700000, 1000000],
                    ),
                  );
                  getDataProduct();
                }
                Navigator.of(context).pop();
              },
              child: Text('Selesai', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteTryout({required String title, required String id}) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          title: Text(title, style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          contentPadding: const EdgeInsets.all(20),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                setState(() => onLoading = true);
                if (tryout!.listTest.isNotEmpty) {
                  tryout!.listTest.forEach((test) => test.listSubtest.forEach((subTest) async {
                        if (subTest.idQuestions.isNotEmpty) {
                          await QuestionsService.delete(subTest.idQuestions);
                        }
                      }));
                }

                await TryoutService.delete(id);
                expiredID = 0;
                context.read<CounterProvider>().setPage(idPage: null, idDetailPage: null);
                setState(() => onLoading = false);
                Navigator.of(context).pop();
              },
              child: Text('Hapus', style: TextStyle(color: Colors.red, fontSize: h4)),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async => await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          title: Text('Yakin ingin Logout?', style: TextStyle(color: Colors.black, fontSize: h3, fontWeight: FontWeight.bold)),
          actionsPadding: const EdgeInsets.all(10),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
            TextButton(
              onPressed: () async {
                final provider = Provider.of<CounterProvider>(context, listen: false);
                provider.logout();
                Navigator.of(context).pop();
              },
              child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4)),
            ),
          ],
        ),
      );

  void refresh() async {
    expiredID = 0;
    context.read<CounterProvider>().setPage(idPage: null, idDetailPage: null);
  }

  Widget homeMobile(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: secondaryWhite,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            CustomScrollView(
              controller: homeController,
              slivers: [
                SliverAppBar(
                  surfaceTintColor: secondaryWhite,
                  backgroundColor: secondaryWhite,
                  title: SvgPicture.asset('assets/logo1.svg'),
                  titleSpacing: 0,
                  floating: true,
                  snap: true,
                  actions: [
                    IconButton(
                      onPressed: () => refresh(),
                      icon: const Icon(Icons.refresh, color: Colors.black),
                    ),
                    OutlinedButton(
                      onPressed: () => logout(),
                      child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4)),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                (listTryOut == null)
                    ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: primary)))
                    : (listTryOut!.isNotEmpty)
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              childCount: listTryOut!.length,
                              (BuildContext context, int index) {
                                var tryOut = listTryOut![index];
                                var id = idListTryOut[index];
                                return Column(
                                  children: [
                                    if (index == 0)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        child: Row(children: [expiredWidget(0, 'All'), expiredWidget(1, 'Expired'), expiredWidget(2, 'Publish'), expiredWidget(3, 'On-Going')]),
                                      ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      height: 90,
                                      width: double.infinity,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                        ),
                                        onPressed: () async {
                                          context.read<CounterProvider>().setPage(idPage: index, idDetailPage: id);

                                          Navigator.push(context, SlideTransition1(const DetailToPage()));
                                        },
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(tryOut.toName, style: TextStyle(color: Colors.black, fontSize: h4, fontWeight: FontWeight.bold)),
                                                PopupMenuButton<String>(
                                                  onSelected: (String value) async {
                                                    if (value == 'Delete') {
                                                      context.read<CounterProvider>().setPage(idPage: index, idDetailPage: id);

                                                      deleteTryout(title: "Hapus ${tryOut.toName}?", id: id);
                                                    }
                                                  },
                                                  color: Colors.white,
                                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  icon: const Icon(Icons.more_vert_rounded, color: Colors.black, size: 20),
                                                  itemBuilder: (BuildContext context) {
                                                    return menuOptions.map((String option) => PopupMenuItem<String>(value: option, child: Text(option))).toList();
                                                  },
                                                ),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('${tryOut.claimedUid.length} member', style: TextStyle(color: Colors.black, fontSize: h5)),
                                                Text(formatDateTime(tryOut.created), style: TextStyle(color: Colors.black, fontSize: h5)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (index == listTryOut!.length) const SizedBox(height: 90),
                                  ],
                                );
                              },
                            ),
                          )
                        : SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    child: Row(children: [expiredWidget(0, 'All'), expiredWidget(1, 'Expired'), expiredWidget(2, 'Publish'), expiredWidget(3, 'On-Going')]),
                                  ),
                                  Text('Tidak ada data TryOut', style: TextStyle(color: Colors.grey, fontSize: h4), textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          )
              ],
            ),
            Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: primaryGradient),
              margin: const EdgeInsets.all(15),
              child: FloatingActionButton(
                elevation: 0,
                hoverElevation: 0,
                highlightElevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                backgroundColor: Colors.transparent,
                onPressed: () => tambahTryout(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, color: Colors.white, size: 20),
                    const SizedBox(width: 5),
                    Text('Tambah TryOut', style: TextStyle(color: Colors.white, fontSize: h4), textAlign: TextAlign.center)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget homeDesk(BuildContext context) {
    bool onTablet = (lebar(context) >= 700 && lebar(context) <= 1200);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          Expanded(
            flex: onTablet ? 3 : 2,
            child: Container(
              color: secondaryWhite,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CustomScrollView(
                    controller: homeController,
                    slivers: [
                      SliverAppBar(
                        surfaceTintColor: secondaryWhite,
                        backgroundColor: secondaryWhite,
                        title: SvgPicture.asset('assets/logo1.svg'),
                        titleSpacing: 0,
                        floating: true,
                        snap: true,
                        actions: [
                          IconButton(
                            onPressed: () => refresh(),
                            icon: const Icon(Icons.refresh, color: Colors.black),
                          ),
                          OutlinedButton(
                            onPressed: () => logout(),
                            child: Text('Logout', style: TextStyle(color: Colors.black, fontSize: h4)),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      (listTryOut == null)
                          ? SliverToBoxAdapter(child: Center(child: CircularProgressIndicator(color: primary)))
                          : (listTryOut!.isNotEmpty)
                              ? SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    childCount: listTryOut!.length,
                                    (BuildContext context, int index) {
                                      var tryOut = listTryOut![index];
                                      var id = idListTryOut[index];
                                      return Column(
                                        children: [
                                          if (index == 0)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              child:
                                                  Row(children: [expiredWidget(0, 'All'), expiredWidget(1, 'Expired'), expiredWidget(2, 'Publish'), expiredWidget(3, 'On-Going')]),
                                            ),
                                          Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 10),
                                            height: 90,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: context.watch<CounterProvider>().getPage == index ? primaryGradient : null,
                                            ),
                                            child: TextButton(
                                              style: TextButton.styleFrom(
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                              ),
                                              onPressed: () async {
                                                context.read<CounterProvider>().setPage(idPage: index, idDetailPage: id);
                                                if (context.read<CounterProvider>().getPage != null) {
                                                  setState(() => onLoading = true);
                                                  await Future.delayed(const Duration(milliseconds: 500));
                                                  setState(() => onLoading = false);
                                                }
                                              },
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        tryOut.toName,
                                                        style: TextStyle(
                                                          color: context.watch<CounterProvider>().getPage == index ? Colors.white : Colors.black,
                                                          fontSize: h4,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      PopupMenuButton<String>(
                                                        onSelected: (String value) async {
                                                          if (value == "Delete") {
                                                            context.read<CounterProvider>().setPage(idPage: index, idDetailPage: id);

                                                            deleteTryout(title: "Hapus ${tryOut.toName}?", id: id);
                                                          }
                                                        },
                                                        color: Colors.white,
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                        icon: Icon(
                                                          Icons.more_vert_rounded,
                                                          color: context.watch<CounterProvider>().getPage == index ? Colors.white : Colors.black,
                                                          size: 20,
                                                        ),
                                                        itemBuilder: (BuildContext context) => menuOptions.map((String option) {
                                                          return PopupMenuItem<String>(
                                                            value: option,
                                                            child: Text(option),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${tryOut.claimedUid.length} member',
                                                        style: TextStyle(color: context.watch<CounterProvider>().getPage == index ? Colors.white : Colors.black, fontSize: h5),
                                                      ),
                                                      Text(
                                                        formatDateTime(tryOut.created),
                                                        style: TextStyle(color: context.watch<CounterProvider>().getPage == index ? Colors.white : Colors.black, fontSize: h5),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          if (index == listTryOut!.length) const SizedBox(height: 90),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              : SliverToBoxAdapter(
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Row(children: [expiredWidget(0, 'All'), expiredWidget(1, 'Expired'), expiredWidget(2, 'Publish'), expiredWidget(3, 'On-Going')]),
                                        ),
                                        Text('Tidak ada data TryOut', style: TextStyle(color: Colors.grey, fontSize: h4), textAlign: TextAlign.center),
                                      ],
                                    ),
                                  ),
                                )
                    ],
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: primaryGradient),
                    margin: const EdgeInsets.all(15),
                    child: FloatingActionButton(
                      elevation: 0,
                      hoverElevation: 0,
                      highlightElevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.transparent,
                      onPressed: () => tambahTryout(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white, size: 20),
                          const SizedBox(width: 5),
                          Text('Tambah TryOut', style: TextStyle(color: Colors.white, fontSize: h4), textAlign: TextAlign.center)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              final profider = Provider.of<CounterProvider>(context, listen: false);
              profider.addListener(() async {
                setState(() => onLoading = true);
                await Future.delayed(const Duration(milliseconds: 500));
                setState(() => onLoading = false);
              });
              return Expanded(
                flex: 6,
                child: context.read<CounterProvider>().getPage == null
                    ? Scaffold(
                        backgroundColor: Colors.white,
                        body: Center(
                          child: SingleChildScrollView(
                            child: SizedBox(
                              height: 400,
                              width: lebar(context),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(margin: const EdgeInsets.all(20), height: 200, width: 200, child: SvgPicture.asset('assets/logo2.svg')),
                                  Text(
                                    'Selamat Datang Admin',
                                    style: TextStyle(color: Colors.black.withOpacity(.5), fontWeight: FontWeight.bold, fontSize: h3),
                                  ),
                                  Text('Dihalaman ini Anda akan dapat mengatur TryOut anda', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h3)),
                                  const Expanded(child: SizedBox()),
                                  Text('Dream Academy', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h4, fontWeight: FontWeight.bold)),
                                  Text('#Berproses&RaihBersama', style: TextStyle(color: Colors.black.withOpacity(.5), fontSize: h5, fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    : onLoading
                        ? Center(child: CircularProgressIndicator(color: primary))
                        : const DetailToPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}
