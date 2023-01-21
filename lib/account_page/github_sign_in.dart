import 'package:connactivity/account_page.dart';
import 'package:connactivity/comms.dart' as comms;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_sign_in/github_sign_in.dart';

/// A button that signs in with GitHub.
class GitHubSignInBtn extends StatelessWidget {
  final Function() callback;
  final bool isActive;
  final BuildContext context;
  const GitHubSignInBtn(
      {Key? key,
      required this.callback,
      required this.context,
      required this.isActive})
      : super(key: key);

  /// Handles GitHub Sign In on Android and iOS
  void signInWithGitHub() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "92059c6ea0e08cad4256",
        clientSecret: "4ed27f9c322c50dda7cba53856ce66e0c4bffcbd",
        redirectUrl:
            'https://tenacious-moon-348609.firebaseapp.com/__/auth/handler');

    final result = await gitHubSignIn.signIn(context);

    // User canceled login
    if (result.token == null) {
      return;
    }

    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

    final gitHubUser = FirebaseAuth.instance.currentUser;

    // Check if user exists
    var userExists = await comms.userExists();
    if (!userExists) {
      // Register user if it doesn't exist with [name] and [email] (default)
      await comms.registerUser(gitHubUser?.displayName, gitHubUser?.email);
    }

    // Callback used to refresh widget tree
    callback();
  }

  /// Handles GitHub Sign In on Web
  void signInWithGitHubWeb() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    await FirebaseAuth.instance
        .signInWithPopup(githubProvider)
        .then((value) => callback());
  }

  @override
  Widget build(BuildContext context) {
    return AccountButton(
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        disabledColor: Colors.grey,
        // Check for web platform
        onPressed: isActive
            ? kIsWeb
                ? signInWithGitHubWeb
                : (() {
                    try {
                      signInWithGitHub();
                    } catch (error) {
                      debugPrint(error.toString());
                    }
                  })
            : null,
        color: const Color(0xffFE7F2D),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            FaIcon(FontAwesomeIcons.github),
            SizedBox(
              width: 5,
            ),
            Text("Sign in with GitHub"),
          ],
        ),
      ),
    );
  }
}
