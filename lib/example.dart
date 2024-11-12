import 'package:da_administrator/firebase_service/jurusan_service.dart';
import 'package:da_administrator/firebase_service/other_service.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/firebase_service/univ_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/other/other_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var userUid = 'bBm35Y9GYcNR8YHu2bybB61lyEr1';

  @override
  Widget build(BuildContext context) {
    List<String> mapel = [
      // Mata Pelajaran Umum Wajib
      "Pendidikan Agama dan Budi Pekerti",
      "Pendidikan Pancasila dan Kewarganegaraan (PPKn)",
      "Bahasa Indonesia",
      "Matematika Wajib",
      "Sejarah Indonesia",
      "Bahasa Inggris",

      // Mata Pelajaran Pemrograman IPA
      "Matematika Peminatan",
      "Fisika",
      "Kimia",
      "Biologi",

      // Mata Pelajaran Pemrograman IPS
      "Ekonomi",
      "Geografi",
      "Sosiologi",
      "Sejarah Peminatan",

      // Mata Pelajaran Pemrograman Bahasa
      "Bahasa dan Sastra Indonesia",
      "Bahasa dan Sastra Inggris",
      "Bahasa Asing Lainnya (misalnya Bahasa Jepang, Bahasa Arab, Bahasa Mandarin)",

      // Mata Pelajaran Tambahan / Pilihan
      "Informatika",
      "Seni Budaya",
      "Prakarya dan Kewirausahaan",
      "Pendidikan Jasmani, Olahraga, dan Kesehatan",
    ];

    return Scaffold(
      body: Column(
        children: [
          OutlinedButton(
            onPressed: () async {
              List<String> mataPelajaranSMA = [
                "Matematika",
                "Fisika",
                "Teknologi Informasi",
                "Komputer",
                "Ekonomi",
                "Teknik",
                "Teknologi",
                "Seni Rupa",
                "Bahasa Indonesia",
                "Sejarah",
                "Sosiologi",
                "Biologi",
                "Kimia",
                "Geografi",
                "Bahasa Inggris",
                "Seni Budaya",
                "Pendidikan Agama Islam",
                "Pendidikan Agama Kristen",
                "Pendidikan Agama Katolik",
                "Pendidikan Agama Hindu",
                "Pendidikan Agama Buddha",
                "Pendidikan Agama Khonghucu",
                "Pendidikan Pancasila dan Kewarganegaraan (PPKn)",
                "Bahasa Arab",
                "Bahasa Mandarin",
                "Bahasa Jepang",
                "Bahasa Jerman",
                "Bahasa Perancis",
                "Bahasa Korea",
                "Antropologi",
                "Ilmu Pengetahuan Alam (IPA)",
                "Ilmu Pengetahuan Sosial (IPS)",
                "Kewirausahaan",
                "Seni Musik",
                "Seni Tari",
                "Seni Teater",
                "Prakarya dan Kewirausahaan",
                "Pendidikan Jasmani, Olahraga, dan Kesehatan (PJOK)",
                "Sejarah Peminatan",
                "Matematika Peminatan",
                "Fisika Peminatan",
                "Kimia Peminatan",
                "Biologi Peminatan",
                "Ekonomi Peminatan",
                "Sosiologi Peminatan",
                "Geografi Peminatan",
                "Ilmu Lingkungan",
                "Statistika",
                "Astronomi",
                "Kesehatan",
                "Teknik Mesin",
                "Teknik Elektro",
                "Agribisnis",
                "Perhotelan",
                "Teknologi Jaringan Komputer dan Telekomunikasi",
                "Teknik Komputer dan Informatika",
                "Manajemen Perkantoran",
              ];

              await OtherService.add(OtherModel(subjectRelevance: mataPelajaranSMA));

//========================================================================================================================================================================
              /*await RationalizationUserService.add(
                RationalizationUserModel(
                  jurusan: [
                    JurusanModel(namaJurusan: 'Ilmu Komputer', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 1),
                    JurusanModel(namaJurusan: 'Teknik Sipil', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 1),
                    JurusanModel(namaJurusan: 'Statistika', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 1),
                    JurusanModel(namaJurusan: 'Sistem Informasi', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 1),
                  ],
                  created: DateTime.now(),
                  userUID: 'userUID',
                  idTryout: 'idTryout',
                  idUserTo: 'idUserTo',
                ),
              );
              await RationalizationUserService.add(
                RationalizationUserModel(
                  jurusan: [
                    JurusanModel(namaJurusan: 'Ilmu Komputer', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 3),
                    JurusanModel(namaJurusan: 'Teknik Sipil', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 4),
                    JurusanModel(namaJurusan: 'Statistika', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 5),
                    JurusanModel(namaJurusan: 'Sistem Informasi', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 7),
                  ],
                  created: DateTime.now(),
                  userUID: 'userUID',
                  idTryout: 'idTryout',
                  idUserTo: 'idUserTo',
                ),
              );
              await RationalizationUserService.add(
                RationalizationUserModel(
                  jurusan: [
                    JurusanModel(namaJurusan: 'Ilmu Komputer', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 11),
                    JurusanModel(namaJurusan: 'Teknik Sipil', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 11),
                    JurusanModel(namaJurusan: 'Statistika', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 17),
                    JurusanModel(namaJurusan: 'Sistem Informasi', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 13),
                  ],
                  created: DateTime.now(),
                  userUID: 'userUID',
                  idTryout: 'idTryout',
                  idUserTo: 'idUserTo',
                ),
              );
              await RationalizationUserService.add(
                RationalizationUserModel(
                  jurusan: [
                    JurusanModel(namaJurusan: 'Ilmu Komputer', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 18),
                    JurusanModel(namaJurusan: 'Teknik Sipil', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 15),
                    JurusanModel(namaJurusan: 'Statistika', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 20),
                    JurusanModel(namaJurusan: 'Sistem Informasi', relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"], value: 22),
                  ],
                  created: DateTime.now(),
                  userUID: 'userUID',
                  idTryout: 'idTryout',
                  idUserTo: 'idUserTo',
                ),
              );*/
//========================================================================================================================================================================
              /*await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Informatika",
                relevance: ["Matematika", "Fisika", "Teknologi Informasi", "Komputer"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Sistem Informasi",
                relevance: ["Matematika", "Ekonomi", "Teknologi Informasi", "Komputer"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Sipil",
                relevance: ["Matematika", "Fisika", "Teknik", "Teknologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Arsitektur",
                relevance: ["Matematika", "Fisika", "Seni Rupa", "Teknologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ekonomi",
                relevance: ["Matematika", "Ekonomi", "Geografi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Manajemen",
                relevance: ["Matematika", "Ekonomi", "Bahasa Inggris"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Akuntansi",
                relevance: ["Matematika", "Ekonomi", "Bahasa Inggris"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ilmu Hukum",
                relevance: ["Bahasa Indonesia", "Sejarah", "Sosiologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ilmu Komunikasi",
                relevance: ["Bahasa Indonesia", "Bahasa Inggris", "Sosiologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Psikologi",
                relevance: ["Biologi", "Matematika", "Sosiologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Pendidikan Dokter",
                relevance: ["Biologi", "Kimia", "Matematika"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Farmasi",
                relevance: ["Kimia", "Biologi", "Matematika"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ilmu Keperawatan",
                relevance: ["Biologi", "Kimia", "Psikologi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Kedokteran Gigi",
                relevance: ["Biologi", "Kimia", "Matematika"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Mesin",
                relevance: ["Matematika", "Fisika", "Teknik"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Elektro",
                relevance: ["Matematika", "Fisika", "Teknik"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Kimia",
                relevance: ["Matematika", "Kimia", "Fisika"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Teknik Lingkungan",
                relevance: ["Biologi", "Kimia", "Geografi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ilmu Kelautan",
                relevance: ["Biologi", "Kimia", "Geografi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Agroteknologi",
                relevance: ["Biologi", "Kimia", "Geografi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Ilmu Komputer",
                relevance: ["Matematika", "Teknologi Informasi", "Komputer"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Statistika",
                relevance: ["Matematika", "Ekonomi", "Teknologi Informasi"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Sastra Indonesia",
                relevance: ["Bahasa Indonesia", "Sejarah", "Seni Budaya"],
                value: 0.0,
              ));
              await JurusanService.add(JurusanModel(
                namaJurusan: "Sastra Inggris",
                relevance: ["Bahasa Inggris", "Sejarah", "Seni Budaya"],
                value: 0.0,
              ));*/

//========================================================================================================================================================================

              /*await UnivService.add(UnivModel(namaUniv: "Universitas Indonesia", lokasiUniv: "Depok"));
              await UnivService.add(UnivModel(namaUniv: "Institut Teknologi Bandung", lokasiUniv: "Bandung"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Gadjah Mada", lokasiUniv: "Yogyakarta"));
              await UnivService.add(UnivModel(namaUniv: "Institut Pertanian Bogor", lokasiUniv: "Bogor"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Airlangga", lokasiUniv: "Surabaya"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Brawijaya", lokasiUniv: "Malang"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Padjadjaran", lokasiUniv: "Bandung"));
              await UnivService.add(UnivModel(namaUniv: "Institut Teknologi Sepuluh Nopember", lokasiUniv: "Surabaya"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Diponegoro", lokasiUniv: "Semarang"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Hasanuddin", lokasiUniv: "Makassar"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Sumatera Utara", lokasiUniv: "Medan"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Sebelas Maret", lokasiUniv: "Surakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Pendidikan Indonesia", lokasiUniv: "Bandung"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Negeri Jakarta", lokasiUniv: "Jakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Udayana", lokasiUniv: "Denpasar"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Andalas", lokasiUniv: "Padang"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Negeri Yogyakarta", lokasiUniv: "Yogyakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Lampung", lokasiUniv: "Bandar Lampung"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Jenderal Soedirman", lokasiUniv: "Purwokerto"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Islam Indonesia", lokasiUniv: "Yogyakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Telkom", lokasiUniv: "Bandung"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Negeri Malang", lokasiUniv: "Malang"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Negeri Semarang", lokasiUniv: "Semarang"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Negeri Surabaya", lokasiUniv: "Surabaya"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Mercu Buana", lokasiUniv: "Jakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Muhammadiyah Surakarta", lokasiUniv: "Surakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Islam Negeri Syarif Hidayatullah", lokasiUniv: "Jakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Islam Negeri Sunan Kalijaga", lokasiUniv: "Yogyakarta"));
              await UnivService.add(UnivModel(namaUniv: "Universitas Katolik Parahyangan", lokasiUniv: "Bandung"));*/
            },
            child: Text('pencet'),
          ),
        ],
      ),
    );
  }
}
