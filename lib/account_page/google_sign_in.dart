import 'package:connactivity/comms.dart' as comms;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A button that signs in with Google.
class GoogleSignInBtn extends StatelessWidget {
  final Function() callback;
  final bool isActive;
  const GoogleSignInBtn(
      {Key? key, required this.callback, required this.isActive})
      : super(key: key);

  /// Handles Google Sign In on Android and iOS
  void signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;

    if (googleAuth == null) {
      debugPrint("Google Auth couldn't authenticate a user");
      return;
    }

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    // Check if user exists
    var userExists = await comms.userExists();
    debugPrint(userExists.toString());
    // Register user if it doesn't exist with [name] and [email] (default)
    if (!userExists) {
      await comms.registerUser(googleUser?.displayName, googleUser?.email);
    }

    // Callback used to refresh widget tree
    callback();
  }

  /// Handles Google Sign In on Web
  void signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    // Add scopes needed (email and profile)
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
      disabledColor: Colors.grey,
      // Check for web platform and if button is active / logged in
      onPressed: isActive
          ? kIsWeb
              ? signInWithGoogleWeb
              : () {
                  try {
                    signInWithGoogle();
                  } catch (error) {
                    debugPrint(error.toString());
                  }
                }
          : null,
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