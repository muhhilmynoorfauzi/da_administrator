import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class ProfileUserPage extends StatefulWidget {
  const ProfileUserPage({super.key});

  @override
  State<ProfileUserPage> createState() => _ProfileUserPageState();
}

class _ProfileUserPageState extends State<ProfileUserPage> {
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
                    Container(
                      height: 200,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.grey,
                          child: Image.network('https://avatars.githubusercontent.com/u/61872710?v=4'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('Pilih Gambar', style: TextStyle(fontSize: h5 + 2, color: Colors.black)),
                            ),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 30,
                            child: OutlinedButton(
                              onPressed: () {},
                              child: Text('Hapus Gambar', style: TextStyle(fontSize: h5 + 2, color: Colors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    Text('Nama (Maks. 50 Karakter)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
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
                    const SizedBox(height: 20),
                    Text('Nama pengguna (Maks. 50 Karakter)', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
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
                    const SizedBox(height: 20),
                    Text('Email Address', style: TextStyle(fontSize: h5 + 2, fontWeight: FontWeight.normal, color: Colors.black)),
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
