import 'package:cached_network_image/cached_network_image.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/component/nav_buttom.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AboutUserPage extends StatefulWidget {
  // final String id;

  const AboutUserPage({
    super.key,
    // required this.id,
  });

  @override
  State<AboutUserPage> createState() => _AboutUserPageState();
}

class _AboutUserPageState extends State<AboutUserPage> {
  // bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  Widget onDesk(BuildContext context) {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    bool isLogin = (/*profider.getCurrentUser != null*/true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(
        context: context,
        aboutActive: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 100),
            alignment: Alignment.center,
            child: SizedBox(
              width: 700,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tentang',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 30),
                    ),
                    SvgPicture.asset('assets/logo2.svg', height: 200),
                    Text(
                      'Dream Academy',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1),
                    ),
                    Text(
                      '#Berproses&RaihBersama',
                      style: TextStyle(color: Colors.black, fontSize: h3, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Subheading for description or instructions',
                      style: TextStyle(color: Colors.black, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Body text for your whole article or post. We’ll put in some lorem ipsum to show how a filled-out page might look',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLogin)
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) => SizedBox(
                  width: 250,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
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
                          ),
                          Text(
                            'Muh. Hilmy Noor Fauzi',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 25)),
                          ),
                          Expanded(
                            child: Text(
                              'saya sangat senang belajar di Dream Academy karena memiliki banyak contoh soal dan penjelasan yang mudah dipahami',
                              style: TextStyle(color: Colors.black, fontSize: h5 + 1),
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          //footer
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    final profider = Provider.of<CounterProvider>(context, listen: false);
    bool isLogin = (/*profider.getCurrentUser != null*/true);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarMo(context: context),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(vertical: 100),
            alignment: Alignment.center,
            child: SizedBox(
              width: 700,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tentang',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 30),
                    ),
                    SvgPicture.asset('assets/logo2.svg', height: 200),
                    Text(
                      'Dream Academy',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1),
                    ),
                    Text(
                      '#Berproses&RaihBersama',
                      style: TextStyle(color: Colors.black, fontSize: h3, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 50),
                    Text(
                      'Subheading for description or instructions',
                      style: TextStyle(color: Colors.black, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Body text for your whole article or post. We’ll put in some lorem ipsum to show how a filled-out page might look',
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h3),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isLogin)
            SizedBox(
              height: 400,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) => SizedBox(
                  width: 250,
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: ClipRRect(
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
                          ),
                          Text(
                            'Muh. Hilmy Noor Fauzi',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 25)),
                          ),
                          Expanded(
                            child: Text(
                              'saya sangat senang belajar di Dream Academy karena memiliki banyak contoh soal dan penjelasan yang mudah dipahami',
                              style: TextStyle(color: Colors.black, fontSize: h5 + 1),
                              textAlign: TextAlign.justify,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          //footer
          footerMo(context: context)
        ],
      ),
      bottomNavigationBar: NavBottomMo(context: context, aboutActive: true),
    );
  }
}
