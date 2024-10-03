import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CounterProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int? _pageIndex;
  String? _idDetailPage;

  int? get getPage => _pageIndex;

  String? get getIdDetailPage => _idDetailPage;

  void setPage({int? idPage = 0, String? idDetailPage}) {
    _pageIndex = idPage;
    _idDetailPage = idDetailPage;
    notifyListeners();
  }

  void setReload() {
    notifyListeners();
  }

//-------------------------------------------------

  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('error ni we $e');
    }
    notifyListeners();
  }

  Future logout() async {
    try {
      await googleSignIn.disconnect();
      FirebaseAuth.instance.signOut();
    } catch (e) {
      print('error ni we $e');
    }
    notifyListeners();
  }
/*
  int _categories = 0;

  int get categories => _categories;

  void goCategories({int index = 0}) {
    _categories = index;
    notifyListeners();
  }

//-------------------------------------------------
  int _sizeCup = 1;

  int get sizeCup => _sizeCup;

  void setSizeCup({int index = 0}) {
    _sizeCup = index;
    notifyListeners();
  }
*/
//-------------------------------------------------
/*bool _isLogin = false;

  bool get getLogin => _isLogin;

  void setLogin(bool value) {
    _isLogin = value;
    notifyListeners();
  }*/
//-------------------------------------------------
/*String? _uid;

  String? get getUID => _uid;

  void setUID(String? value) {
    _uid = value;
    notifyListeners();
  }*/
// context.watch<CounterProvider>().isLight
// context.read<CounterProvider>().setUID()
}
