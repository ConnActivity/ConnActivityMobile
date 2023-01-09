import 'package:connactivity/comms.dart' as comms;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInBtn extends StatelessWidget {
  final Function() callback;
  const GoogleSignInBtn({Key? key, required this.callback}) : super(key: key);

  void signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();

    final googleAuth = await googleUser?.authentication;

    if (googleAuth == null) {
      debugPrint("Google Auth didn't function");
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    //untested...

    var name = googleUser?.displayName;
    var email = googleUser?.email;

    var userExists = await comms.userExists();
    debugPrint(userExists.toString());
    if (!userExists) await comms.registerUser(name, email);

    callback();
  }

  void signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    googleProvider.setCustomParameters({'login_hint': 'email@example.com'});

    await FirebaseAuth.instance
        .signInWithPopup(googleProvider)
        .then((value) => callback());

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: kIsWeb
          ? signInWithGoogleWeb
          : () {
              try {
                signInWithGoogle();
              } catch (error) {
                debugPrint(error.toString());
              }
            },
      color: const Color(0xffFE7F2D),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          FaIcon(FontAwesomeIcons.google),
          SizedBox(
            width: 5,
          ),
          Text("Sign in with Google"),
        ],
      ),
    );
  }
}
