import 'package:da_administrator/firebase_service/univ_service.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class UnivSetPage extends StatefulWidget {
  const UnivSetPage({
    super.key,
    required this.allUniv,
    required this.idAllUniv,
  });

  final List<UnivModel> allUniv;
  final List<String> idAllUniv;

  @override
  State<UnivSetPage> createState() => _UnivSetPageState();
}

class _UnivSetPageState extends State<UnivSetPage> {
  List<UnivModel> allUniv = [];
  List<String> idAllUniv = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allUniv = widget.allUniv;
    idAllUniv = widget.idAllUniv;
    setState(() {});
  }

  Future<void> onSaveAdd(BuildContext context, String namaUniv, String lokasiUniv) async {
    await UnivService.add(UnivModel(namaUniv: namaUniv, lokasiUniv: lokasiUniv));
  }

  Future<void> onSaveEdit(BuildContext context, String id, String namaUniv, String lokasiUniv) async {
    await UnivService.edit(
      id: id,
      namaUniv: namaUniv,
      lokasiUniv: lokasiUniv,
    );
  }

  Future<void> onSaveDelete(BuildContext context, String id) async {
    await UnivService.delete(id);
  }

  Future<void> funAdd(BuildContext context) async {
    int rating = 1;
    bool onLoadingSave = false;
    // UnivModel univBaru = univ;
    TextEditingController controllerNama = TextEditingController();
    TextEditingController controllerLokasi = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Tambah Universitas', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
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
                            label: Text('Nama Universitas', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controllerLokasi,
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Lokasi Universitas', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onLoadingSave)
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
                if (!onLoadingSave)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingSave = true);

                        onSaveAdd(context, controllerNama.text, controllerLokasi.text);
                        allUniv.add(UnivModel(namaUniv: controllerNama.text, lokasiUniv: controllerLokasi.text));
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

  Future<void> funEdit(BuildContext context, String id, UnivModel univ, int index) async {
    int rating = 1;
    bool onLoadingSave = false;
    // UnivModel univBaru = univ;
    TextEditingController controllerNama = TextEditingController(text: univ.namaUniv);
    TextEditingController controllerLokasi = TextEditingController(text: univ.lokasiUniv);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Edit Universitas', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
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
                          onChanged: (value) {},
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Nama Universitas', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: controllerLokasi,
                          onChanged: (value) {},
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            border: const OutlineInputBorder(),
                            label: Text('Lokasi Universitas', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onLoadingSave)
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
                if (!onLoadingSave)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton(
                      onPressed: () async {
                        setState(() => onLoadingSave = true);

                        onSaveEdit(context, id, controllerNama.text, controllerLokasi.text);
                        allUniv[index] = UnivModel(namaUniv: controllerNama.text, lokasiUniv: controllerLokasi.text);
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

  Future<void> funDelete(BuildContext context, String id, UnivModel univ, int index) async {
    int rating = 1;
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
              title: Text('Hapus Universitas', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: 200,
                    child: Text('Ingin Hapus ${univ.namaUniv}?', style: TextStyle(fontSize: h4, color: Colors.black)),
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
                        allUniv.removeAt(index);
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
        title: Text('Data Universitas', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
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
              'Ini merupakan data Universitas yang dapat digunakan user untuk memilih target Kampus mereka',
              style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.3)),
              textAlign: TextAlign.center,
            ),
          ),
          if (allUniv.isNotEmpty)
            Column(
              children: List.generate(
                allUniv.length,
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
                                Text(allUniv[i].namaUniv, style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                                Text(allUniv[i].lokasiUniv, style: TextStyle(fontSize: h4 - 2, color: Colors.black)),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => funEdit(context, idAllUniv[i], allUniv[i], i),
                            icon: const Icon(Icons.edit_outlined, color: Colors.black),
                          ),
                          IconButton(
                            onPressed: () => funDelete(context, idAllUniv[i], allUniv[i], i),
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
