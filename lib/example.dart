import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/firebase_service/jurusan_service.dart';
import 'package:da_administrator/firebase_service/other_service.dart';
import 'package:da_administrator/firebase_service/profile_user_service.dart';
import 'package:da_administrator/firebase_service/rationalization_user_service.dart';
import 'package:da_administrator/firebase_service/tryout_review_service.dart';
import 'package:da_administrator/firebase_service/univ_service.dart';
import 'package:da_administrator/model/jurusan/jurusan_model.dart';
import 'package:da_administrator/model/jurusan/univ_model.dart';
import 'package:da_administrator/model/other/other_model.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/model/user_profile/rationalization_user_model.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:flutter/material.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  var userUid = 'bBm35Y9GYcNR8YHu2bybB61lyEr1';
  OtherModel? otherModel;

  Future<void> onRatingReview(BuildContext context) async {
    int rating = 1;
    bool onSave = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: secondaryWhite,
              surfaceTintColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              title: Text('Beri Rating', style: TextStyle(fontSize: h4, color: Colors.black, fontWeight: FontWeight.bold)),
              titlePadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(10),
              content: Stack(
                children: [
                  SizedBox(
                    width: 500,
                    height: 300,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Row(children: List.generate(3, (index) => const Padding(padding: EdgeInsets.all(3), child: Icon(Icons.star, size: 25, color: Colors.grey)))),
                            Row(
                              children: List.generate(
                                3,
                                (index) => InkWell(
                                  onTap: () => setState(() => rating = index + 1),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3),
                                    child: Icon(Icons.star, size: 25, color: (rating >= index + 1) ? secondary : Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          maxLines: 5,
                          onChanged: (value) {},
                          style: TextStyle(color: Colors.black, fontSize: h4),
                          decoration: InputDecoration(
                            fillColor: Colors.black,
                            alignLabelWithHint: true,
                            border: const OutlineInputBorder(),
                            label: Text('Komentar Anda', style: TextStyle(fontSize: h4, color: Colors.black)),
                            labelStyle: TextStyle(color: Colors.black, fontSize: h4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (onSave)
                    Expanded(
                      child: Container(
                        width: 500,
                        height: 300,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: CircularProgressIndicator(color: primary, strokeAlign: 10),
                      ),
                    ),
                ],
              ),
              actionsPadding: const EdgeInsets.all(10),
              actions: [
                if (!onSave)
                  SizedBox(
                    height: 30,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        setState(() => onSave = true);
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() => onSave = false);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide.none,
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      icon: const Icon(Icons.send, color: Colors.white),
                      label: Text('Kirim', style: TextStyle(fontSize: h4, color: Colors.white)),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // if (otherModel != null) Text(otherModel!.question),
            OutlinedButton(
              onPressed: () async {
                // onRatingReview(context);
                /*
                ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: CachedNetworkImage(
                                  imageUrl: 'https://avatars.githubusercontent.com/u/61872710?v=4',
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                            */
                //=======================================================================================================================================
                /*for (int i = 0; i < 10; i++) {
                  await TryoutReviewService.add(
                    TryoutReviewModel(
                      userUID: 'bBm35Y9GYcNR8YHu2bybB61lyEr1',
                      userName: 'Muh Hilmy Noor Fauzi ${i + 1}',
                      text: 'saya sangat senang belajar di Dream Academy karena memiliki banyak contoh soal dan penjelasan yang mudah dipahami ${i + 1}',
                      idTryOut: '6V60h5OYCITAf3dcGM5u',
                      image: 'https://avatars.githubusercontent.com/u/61872710?v=4',
                      rating: 5,
                      created: DateTime.now(),
                      isPublic: true,
                    ),
                  );
                }*/

                //=======================================================================================================================================

                // await OtherService.add(OtherModel(subjectRelevance: mataPelajaranSMA));

                //=======================================================================================================================================
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
                //=======================================================================================================================================
                await JurusanService.add(JurusanModel(
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
                ));

                //=======================================================================================================================================

                await UnivService.add(UnivModel(namaUniv: "Universitas Indonesia", lokasiUniv: "Depok"));
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
                await UnivService.add(UnivModel(namaUniv: "Universitas Katolik Parahyangan", lokasiUniv: "Bandung"));
              },
              child: const Text('pencet'),
            ),
          ],
        ),
      ),
    );
  }
}
