import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/detail_tryout_user_page.dart';
import 'package:da_administrator/pages_user/tryout_selengkapnya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TryoutPublicUserPage extends StatefulWidget {
  const TryoutPublicUserPage({super.key});

  @override
  State<TryoutPublicUserPage> createState() => _TryoutPublicUserPageState();
}

class _TryoutPublicUserPageState extends State<TryoutPublicUserPage> {
  var found = false;
  var urlImage = 'https://fikom.umi.ac.id/wp-content/uploads/elementor/thumbs/Landscape-FIKOM-1-qmvnvvxai3ee9g7f3uxrd0i2h9830jt78pzxkltrtc.webp';

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  void selengkapnya(BuildContext context) {
    Navigator.push(context, FadeRoute1(const TryoutSelengkapnyaUserPage()));
  }

  Widget cardTryout({
    required String imageUrl,
    required String title,
    required String desk,
    required bool readyOnFree,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 495,
      height: 170,
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
                    aspectRatio: 1,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary)),
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
                      Text(desk, style: TextStyle(fontSize: h4, color: Colors.black), overflow: TextOverflow.ellipsis, maxLines: 4),
                      const Expanded(child: SizedBox()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: primary,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                          ),
                          child: Text('Cari', style: TextStyle(color: Colors.white, fontSize: h4)),
                        ),
                      ),
                    ],
                  ),
                  if (found)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: cardTryout(
                        imageUrl: urlImage,
                        title: 'TryOut UTBK 2024 #11 - SNBT',
                        desk: 'Tes Potensi Skolastik (TPS) dan Tes Literasi',
                        readyOnFree: true,
                        onTap: () {},
                      ),
                    ),
                  const SizedBox(height: 50),
                  //Tryout Sedang berlangsung
                  Text('TryOut Sedang Berlangsung', style: TextStyle(fontSize: h4, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      3,
                      (index) => cardTryout(
                        imageUrl: urlImage,
                        title: 'TryOut UTBK 2024 #11 - SNBT',
                        desk: 'Tes Potensi Skolastik (TPS) dan Tes Literasi',
                        readyOnFree: true,
                        onTap: () {
                          Navigator.push(context, FadeRoute1(const DetailTryoutUserPage()));
                        },
                      ),
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
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      2,
                      (index) => cardTryout(
                        imageUrl: urlImage,
                        title: 'TryOut UTBK 2024 #11 - SNBT',
                        desk: 'Tes Potensi Skolastik (TPS) dan Tes Literasi',
                        readyOnFree: false,
                        onTap: () {},
                      ),
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

  Widget onMobile(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
