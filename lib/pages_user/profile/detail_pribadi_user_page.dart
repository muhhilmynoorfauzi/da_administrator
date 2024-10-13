import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class DetailPribadiUserPage extends StatefulWidget {
  const DetailPribadiUserPage({super.key});

  @override
  State<DetailPribadiUserPage> createState() => _DetailPribadiUserPageState();
}

class _DetailPribadiUserPageState extends State<DetailPribadiUserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 700,
          child: ListView(
            children: [
              if (lebar(context) > 900) SizedBox(height: tinggi(context) * .1),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: secondaryWhite, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asal Sekolah', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Asal Tempat Tinggal', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Universitas Tujuan (wajib)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Pilihan Jurusan 1 (wajib)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Pilihan Jurusan 2 (wajib)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Pilihan Jurusan 3 (wajib)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Pilihan Jurusan 4 (wajib)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Kontak', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 40,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text('Motivasi', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
                    SizedBox(
                      height: 100,
                      child: TextFormField(
                        style: TextStyle(color: Colors.black, fontSize: h4),
                        maxLines: 10,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                width: double.infinity,
                height: 40,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(backgroundColor: primary),
                  child: Text('Simpan Pembaharuan', style: TextStyle(fontSize: h4, fontWeight: FontWeight.normal, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
