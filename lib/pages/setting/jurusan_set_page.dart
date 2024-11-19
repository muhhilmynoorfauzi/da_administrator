import 'package:da_administrator/firebase_service/jurusan_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/other/other_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class JurusanSetPage extends StatefulWidget {
  const JurusanSetPage({
    super.key,
    required this.allJurusan,
    required this.idAllJurusan,
    required this.other,
    required this.idOther,
  });

  final List<JurusanModel> allJurusan;
  final List<String> idAllJurusan;

  final OtherModel other;
  final String idOther;

  @override
  State<JurusanSetPage> createState() => _JurusanSetPageState();
}

class _JurusanSetPageState extends State<JurusanSetPage> {
  List<JurusanModel> allJurusan = [];
  List<String> idAllJurusan = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allJurusan = widget.allJurusan;
    idAllJurusan = widget.idAllJurusan;
    setState(() {});
  }

  Future<void> onSaveAdd(BuildContext context, String namaJurusan, List<String> relevance) async {
    await JurusanService.add(JurusanModel(namaJurusan: namaJurusan, relevance: relevance, value: 0));
  }

  Future<void> onSaveEdit(BuildContext context, String id, String namaJurusan, List<String> relevance) async {
    await JurusanService.edit(id: id, namaJurusan: namaJurusan, relevance: relevance, value: 0);
  }

  Future<void> onSaveDelete(BuildContext context, String id) async {
    await JurusanService.delete(id);
  }

  Future<void> funAdd(BuildContext context) async {
    bool onLoadingSave = false;
    List<String> selectedRelevance = [];
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
              title: Text('Tambah Jurusan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: tinggi(context),
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerNama,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Nama Jurusan', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: List.generate(
                                widget.other.subjectRelevance.length,
                                (index) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: selectedRelevance.contains(widget.other.subjectRelevance[index]),
                                            onChanged: (bool? value) {
                                              if (value == true) {
                                                selectedRelevance.add(widget.other.subjectRelevance[index]);
                                                print('tambah ${widget.other.subjectRelevance[index]}');
                                              } else {
                                                selectedRelevance.remove(widget.other.subjectRelevance[index]);
                                                print('hapus ${widget.other.subjectRelevance[index]}');
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                                              child: Text(
                                                widget.other.subjectRelevance[index],
                                                style: TextStyle(color: Colors.black, fontSize: h4),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onLoadingSave)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: tinggi(context),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onLoadingSave)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingSave = true);

                        onSaveAdd(context, controllerNama.text, selectedRelevance);
                        allJurusan.add(JurusanModel(namaJurusan: controllerNama.text, relevance: selectedRelevance, value: 0));
                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingSave = false);
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

  Future<void> funEdit(BuildContext context, String id, JurusanModel jurusan, List<String> relevance, int index) async {
    bool onLoadingSave = false;
    List<String> selectedRelevance = relevance;
    TextEditingController controllerNama = TextEditingController(text: jurusan.namaJurusan);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Edit Jurusan', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: tinggi(context),
                    child: Column(
                      children: [
                        TextField(
                          controller: controllerNama,
                          onChanged: (value) {},
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Nama Jurusan', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: List.generate(
                                widget.other.subjectRelevance.length,
                                (index) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setState) {
                                      return Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Checkbox(
                                            value: selectedRelevance.contains(widget.other.subjectRelevance[index]),
                                            onChanged: (bool? value) {
                                              if (value == true) {
                                                selectedRelevance.add(widget.other.subjectRelevance[index]);
                                                print('tambah ${widget.other.subjectRelevance[index]}');
                                              } else {
                                                selectedRelevance.remove(widget.other.subjectRelevance[index]);
                                                print('hapus ${widget.other.subjectRelevance[index]}');
                                              }
                                              setState(() {});
                                            },
                                          ),
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: secondaryWhite),
                                              child: Text(
                                                widget.other.subjectRelevance[index],
                                                style: TextStyle(color: Colors.black, fontSize: h4),
                                                textAlign: TextAlign.justify,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onLoadingSave)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: tinggi(context),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onLoadingSave)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingSave = true);

                        onSaveEdit(context, id, controllerNama.text, selectedRelevance);
                        allJurusan[index] = JurusanModel(namaJurusan: controllerNama.text, relevance: selectedRelevance, value: 0);

                        await Future.delayed(const Duration(milliseconds: 200));

                        setState(() => onLoadingSave = false);
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

  Future<void> funDelete(BuildContext context, String id, JurusanModel jurusan, int index) async {
    bool onLoadingDelete = false;
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
                    child: Text('Ingin Hapus ${jurusan.namaJurusan}?', style: TextStyle(fontSize: h4, color: Colors.black)),
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

                        onSaveDelete(context, id);
                        allJurusan.removeAt(index);
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
        title: Text('Data Jurusan', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          IconButton(onPressed: () => funAdd(context), icon: const Icon(Icons.add, color: Colors.black)),
          const SizedBox(width: 10),
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text(
              'Ini merupakan data Jurusan yang dapat digunakan user untuk memilih target Jurusan mereka',
              style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.3)),
              textAlign: TextAlign.center,
            ),
          ),
          if (allJurusan.isNotEmpty)
            Column(
              children: List.generate(
                allJurusan.length,
                (i) => Container(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(allJurusan[i].namaJurusan, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List.generate(
                                      allJurusan[i].relevance.length,
                                      (j) => Container(
                                        margin: const EdgeInsets.only(right: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                        decoration: BoxDecoration(color: primary.withOpacity(.2), borderRadius: BorderRadius.circular(50)),
                                        child: Text(allJurusan[i].relevance[j], style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => funEdit(context, idAllJurusan[i], allJurusan[i], allJurusan[i].relevance, i),
                            icon: const Icon(Icons.edit_outlined, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => funDelete(context, idAllJurusan[i], allJurusan[i], i),
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
