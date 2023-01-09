import 'package:connactivity/comms.dart' as comms;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:github_sign_in/github_sign_in.dart';

class GitHubSignInBtn extends StatelessWidget {
  final Function() callback;
  final BuildContext context;
  const GitHubSignInBtn(
      {Key? key, required this.callback, required this.context})
      : super(key: key);

  void signInWithGitHub() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: "92059c6ea0e08cad4256",
        clientSecret: "4ed27f9c322c50dda7cba53856ce66e0c4bffcbd",
        redirectUrl:
            'https://tenacious-moon-348609.firebaseapp.com/__/auth/handler');

    final result = await gitHubSignIn.signIn(context);

    if (result.token == null) {
      return;
    }

    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);

    final gitHubUser = FirebaseAuth.instance.currentUser;

    var userExists = await comms.userExists();
    if (!userExists) {
      await comms.registerUser(gitHubUser?.displayName, gitHubUser?.email);
    }

    callback();
    //.then((value) => callback());
  }

  void signInWithGitHubWeb() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();

    await FirebaseAuth.instance
        .signInWithPopup(githubProvider)
        .then((value) => callback());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: kIsWeb
          ? signInWithGitHubWeb
          : (() {
              try {
                signInWithGitHub();
              } catch (error) {
                debugPrint(error.toString());
              }
            }),
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
    );
  }
}
