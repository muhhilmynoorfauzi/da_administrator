import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:da_administrator/model/review/tryout_review_model.dart';
import 'package:da_administrator/pages_user/component/appbar.dart';
import 'package:da_administrator/pages_user/component/footer.dart';
import 'package:da_administrator/pages_user/component/nav_buttom.dart';
import 'package:da_administrator/pages_user/home_user_page.dart';
import 'package:da_administrator/service/color.dart';
import 'package:da_administrator/service/component.dart';
import 'package:da_administrator/service/state_manajement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AboutUserPage extends StatefulWidget {
  const AboutUserPage({super.key});

  @override
  State<AboutUserPage> createState() => _AboutUserPageState();
}

class _AboutUserPageState extends State<AboutUserPage> {
  final user = FirebaseAuth.instance.currentUser;
  List<TryoutReviewModel> listReviewPublic = [];

  @override
  Widget build(BuildContext context) {
    if (lebar(context) <= 700) {
      return onMo(context);
    } else {
      return onDesk(context);
    }
  }

  @override
  void initState() {
    final user = FirebaseAuth.instance.currentUser;
    // TODO: implement initState
    super.initState();
    getDataReview();
  }

  void getDataReview() async {
    try {
      // Ambil hanya data dengan isPublic = true dari Firestore
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('review_v03');
      QuerySnapshot<Object?> querySnapshot = await collectionRef.where('isPublic', isEqualTo: true).get();

      // Mapping hasil Firestore ke model
      List<TryoutReviewModel> allReviews = querySnapshot.docs.map((doc) => TryoutReviewModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();

      // Filter untuk rating = 5
      List<TryoutReviewModel> filteredReviews = [];
      for (var review in allReviews) {
        if (review.rating == 5) {
          filteredReviews.add(review);
        }
      }

      // Sorting berdasarkan created
      filteredReviews.sort((a, b) => a.created.compareTo(b.created));
      filteredReviews = filteredReviews.reversed.toList();

      // Set hasil akhir ke listReviewPublic
      listReviewPublic = filteredReviews;

      setState(() {});
    } catch (e) {
      print('salah home_page: $e');
    }
  }

  Widget onDesk(BuildContext context) {
    bool isLogin = (user != null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarDesk(context: context, aboutActive: true),
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
            Center(
              child: SizedBox(
                height: 400,
                width: 1200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listReviewPublic.length,
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
                                    imageUrl: listReviewPublic[index].image,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              listReviewPublic[index].userName,
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(listReviewPublic[index].rating, (index) => const Icon(Icons.star, color: Colors.orange, size: 25)),
                            ),
                            Expanded(
                              child: Text(
                                listReviewPublic[index].text,
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
            ),
          //footer
          footerDesk(context: context),
        ],
      ),
    );
  }

  Widget onMo(BuildContext context) {
    bool isLogin = (user != null);
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
                itemCount: listReviewPublic.length,
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
                                  imageUrl: listReviewPublic[index].image,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(child: CircularProgressIndicator(color: primary, strokeAlign: 10, strokeWidth: 3)),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            listReviewPublic[index].userName,
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: h4),
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(listReviewPublic[index].rating, (index) => const Icon(Icons.star, color: Colors.orange, size: 25)),
                          ),
                          Expanded(
                            child: Text(
                              listReviewPublic[index].text,
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
