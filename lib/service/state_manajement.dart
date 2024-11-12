import 'package:da_administrator/model/user_profile/profile_user_model.dart';
import 'package:da_administrator/pages_user/about_user_page.dart';
import 'package:da_administrator/service/component.dart';
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

  User? _currentUser;

  User? get getCurrentUser => _currentUser;

  void setCurrentUser(User? user) {
    _currentUser = user;
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

  String _titleUserPage = 'Dream Academy';

  String? get getTitleUserPage => _titleUserPage;

  void setTitleUserPage(String value) {
    _titleUserPage = value;
    notifyListeners();
  }
//-------------------------------------------------

  ProfileUserModel? _profile;

  ProfileUserModel? get getProfile => _profile;

  void setProfile(ProfileUserModel? profile) {
    _profile = profile;
  }

// final profider = Provider.of<CounterProvider>(context, listen: false);
// context.watch<CounterProvider>().isLight
// context.read<CounterProvider>().setUID()
}
