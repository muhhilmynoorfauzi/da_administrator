import 'package:da_administrator/firebase_service/other_service.dart';
import 'package:da_administrator/firebase_service/other_service.dart';
import 'package:da_administrator/firebase_service/other_service.dart';
import 'package:da_administrator/model/other/other_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class MapelSetPage extends StatefulWidget {
  const MapelSetPage({
    super.key,
    required this.allOther,
    required this.idAllOther,
  });

  final List<OtherModel> allOther;
  final List<String> idAllOther;

  @override
  State<MapelSetPage> createState() => _MapelSetPageState();
}

class _MapelSetPageState extends State<MapelSetPage> {
  List<OtherModel> allOther = [];
  List<String> idAllOther = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    allOther = widget.allOther;
    idAllOther = widget.idAllOther;
    setState(() {});
  }

  Future<void> onSaveEdit(BuildContext context, String id, List<String> subjectRelevance) async {
    await OtherService.edit(id: id, subjectRelevance: subjectRelevance);
  }

  Future<void> funAdd(BuildContext context, String id, List<String> listData) async {
    List<String> subjectRelevance = listData;
    bool onLoadingDelete = false;
    TextEditingController controllerNama = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Edit', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: 200,
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerNama,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Nama Mata Pelajaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  if (onLoadingDelete)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onLoadingDelete)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingDelete = true);

                        subjectRelevance.add(controllerNama.text);
                        allOther.first.subjectRelevance = subjectRelevance;
                        onSaveEdit(context, id, subjectRelevance);
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingDelete = false);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                      child: Text('Simpan', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  Future<void> funEdit(BuildContext context, String id, List<String> listData, int index) async {
    List<String> subjectRelevance = listData;
    bool onLoadingDelete = false;
    TextEditingController controllerNama = TextEditingController(text: listData[index]);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Edit', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: 200,
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerNama,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Nama Mata Pelajaran', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  if (onLoadingDelete)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onLoadingDelete)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingDelete = true);

                        subjectRelevance[index] = controllerNama.text;
                        allOther.first.subjectRelevance = subjectRelevance;
                        onSaveEdit(context, id, subjectRelevance);
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingDelete = false);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                      child: Text('Simpan', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  Future<void> funDelete(BuildContext context, String id, List<String> listData, int index) async {
    List<String> subjectRelevance = listData;
    bool onLoadingDelete = false;
    var data = listData[index];
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Hapus', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: 200,
                    child: Text('Ingin Hapus $data?', style: TextStyle(fontSize: h4, color: Colors.black)),
                  ),
                  if (onLoadingDelete)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onLoadingDelete)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingDelete = true);

                        subjectRelevance.removeAt(index);
                        allOther.first.subjectRelevance = subjectRelevance;
                        onSaveEdit(context, id, subjectRelevance);
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingDelete = false);
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20)),
                      child: Text('Hapus', style: TextStyle(fontSize: h4, color: Colors.black)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool onMo = (lebar(context) <= 700);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        scrolledUnderElevation: 1,
        leading: onMo ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.navigate_before_rounded, color: Colors.black)) : const SizedBox(),
        leadingWidth: onMo ? 50 : 0,
        title: Text('Data Mata Pelajaran', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(onPressed: () => funAdd(context, idAllOther.first, allOther.first.subjectRelevance), icon: const Icon(Icons.add, color: Colors.black)),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'Ini merupakan data Mata Pelajaran yang terkait dengan jurusan, Mata Pelajaran ini dapat digunakan user untuk memilih target Jurusan mereka',
              style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.3)),
              textAlign: TextAlign.center,
            ),
          ),
          if (allOther.isNotEmpty)
            if (allOther.first.subjectRelevance.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: allOther.first.subjectRelevance.length,
                  itemBuilder: (context, i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    width: lebar(context),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(allOther.first.subjectRelevance[i], style: TextStyle(fontSize: h4, color: Colors.black)),
                            ),
                            IconButton(
                              onPressed: () => funEdit(context, idAllOther.first, allOther.first.subjectRelevance, i),
                              icon: const Icon(Icons.edit_outlined, color: Colors.black),
                            ),
                            IconButton(
                              onPressed: () => funDelete(context, idAllOther.first, allOther.first.subjectRelevance, i),
                              icon: const Icon(Icons.delete_outline_rounded, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
