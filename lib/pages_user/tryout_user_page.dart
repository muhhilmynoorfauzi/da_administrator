import 'package:da_administrator/pages_user/bundling_user_page.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/pages_user/tryout_public_user_page.dart';
import 'package:da_administrator/pages_user/tryout_saya_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class TryoutUserPage extends StatefulWidget {
  final int idPage;

  const TryoutUserPage({super.key, this.idPage = 1});

  @override
  State<TryoutUserPage> createState() => _TryoutUserPageState();
}

class _TryoutUserPageState extends State<TryoutUserPage> {
  var isLogin = true;
  var idPage = 1;

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMobile(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() => idPage = widget.idPage);
  }

  Widget onDesk(BuildContext context) {
    var listHeaders = ['TryOut Saya', 'TryOut Dream Academy', 'Bundling TryOut Dream Academy'];
    var listPage = [const TryoutSayaUserPage(), const TryoutPublicUserPage(), const BundlingUserPage()];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, featureActive: true, isLogin: isLogin, elevation: 0),
      body: (isLogin)
          ? Column(
              children: [
                Container(
                  height: 30,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey, width: 1))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                      listHeaders.length,
                      (index) {
                        return InkWell(
                          onTap: () {
                            context.read<CounterProvider>().setTitleUserPage('Dream Academy - ${listHeaders[index]}');
                            idPage = index;
                            setState(() {});
                          },
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: Container(
                            height: 30,
                            // duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: (index == idPage) ? Colors.black : Colors.transparent, width: 2))),
                            child: Text(listHeaders[index], style: TextStyle(color: Colors.black, fontSize: h4)),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(child: listPage[idPage]),
              ],
            )
          : ListView(
              children: [
                Container(
                  height: tinggi(context) - 200,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    width: 1000,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 80,
                          width: 80,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(height: 80, width: 80, decoration: BoxDecoration(color: secondary.withOpacity(.5), borderRadius: BorderRadius.circular(100))),
                              SvgPicture.asset('assets/tryout.svg', height: 60)
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                alignment: Alignment.centerLeft,
                                child: Text('TryOut', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h1 + 10)),
                              ),
                              Text(
                                'Soal TryOut dibuat oleh alumni PTN terbaik dengan sistem penilaian IRT untuk membantu kamu masuk PTN impian!\n',
                                style: TextStyle(color: Colors.black, fontSize: h3),
                              ),
                              Text('Tunggu apa lagi? Yuk, Daftar Dream Academy!', style: TextStyle(color: Colors.black, fontSize: h3)),
                              const SizedBox(height: 30),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(backgroundColor: primary, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                                child: Text('Daftar Sekarang', style: TextStyle(color: Colors.white, fontSize: h3, fontWeight: FontWeight.normal)),
                              )
                            ],
                          ),
                        ),
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
