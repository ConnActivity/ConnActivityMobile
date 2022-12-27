import 'package:connactivity/comms.dart' as comms;
import 'package:connactivity/user_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'firebase_options.dart';
import 'login_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String? displayName;
  String? userEmail;
  String? firebaseId;
  String? photoUrl;
  bool? emailVerified;

  @override
  void initState() {
    super.initState();
    userAuth();
  }

  void userAuth() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //await FirebaseAuth.instance.signOut();
    var currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = currentUser?.displayName;
      userEmail = currentUser?.email;
      emailVerified = currentUser?.emailVerified;
      firebaseId = currentUser?.uid;
      photoUrl = currentUser?.photoURL;
    });
  }

  Text isVerified(bool? isVerified) {
    if (isVerified == null) {
      return const Text("Email verification state not available",
          style: TextStyle(color: Colors.white));
    }
    return isVerified
        ? const Text("Email is verified", style: TextStyle(color: Colors.white))
        : const Text("Please verify your email",
            style: TextStyle(color: Colors.white));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff02020A),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black45),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserDisplay(
                    name: displayName ?? "No name",
                    email: userEmail ?? "No email",
                    photoUrl: photoUrl ?? "No photo",
                    id: firebaseId ?? "No id",
                  ),
                  isVerified(emailVerified),
                  userEmail == null
                      ? LoginBtn(callback: userAuth)
                      : LogoutBtn(callback: userAuth),
                  userEmail != null && emailVerified == false
                      ? SendVerificationEmailBtn(
                          callback: userAuth,
                          isActive: true,
                        )
                      : SendVerificationEmailBtn(
                          callback: userAuth, isActive: false),
                  GoogleSignInBtn(callback: userAuth),
                  GitHubSignInBtn(callback: userAuth, context: context),
                  userEmail != null
                      ? ChangeDisplayNameBtn(
                          callback: userAuth,
                          context: context,
                          oldDisplayName: displayName,
                          isActive: true,
                        )
                      : ChangeDisplayNameBtn(
                          callback: userAuth,
                          context: context,
                          oldDisplayName: displayName,
                          isActive: false,
                        ),
                  RefreshTokenBtn(callback: userAuth)
                ]),
          )
        ],
      )),
    );
  }
}

//UI - Buttons
class LoginBtn extends StatelessWidget {
  final void Function() callback;
  const LoginBtn({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()))
            .then((value) => callback());
      },
      color: const Color(0xffFE7F2D),
      child: const Text(
        "Login",
      ),
    );
  }
}

class LogoutBtn extends StatelessWidget {
  final void Function() callback;
  const LogoutBtn({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        FirebaseAuth.instance.signOut().then(((value) => callback()));
      },
      color: const Color(0xffFE7F2D),
      child: const Text(
        "Logout",
      ),
    );
  }
}

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
    if (!userExists)
      await comms.registerUser(gitHubUser?.displayName, gitHubUser?.email);

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

class ChangeDisplayNameBtn extends StatelessWidget {
  final Function() callback;
  final BuildContext context;
  final String? oldDisplayName;
  final bool isActive;
  const ChangeDisplayNameBtn(
      {Key? key,
      required this.callback,
      required this.context,
      required this.oldDisplayName,
      required this.isActive})
      : super(key: key);

  void changeNickname(String newDisplayName) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseAuth.instance.currentUser
        ?.updateDisplayName(newDisplayName)
        .then((value) => callback());
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var nickNameController = TextEditingController();
        nickNameController.text = oldDisplayName ?? "";
        return AlertDialog(
          title: const Text('Nickname Settings'),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
          backgroundColor: Colors.grey,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nickNameController,
                  style: const TextStyle(color: Colors.white),
                  obscureText: false,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white30),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: "Enter Nickname",
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white)),
              onPressed: () {
                changeNickname(nickNameController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: Colors.grey,
      onPressed: isActive
          ? () async {
              _showMyDialog(context);
            }
          : null,
      color: const Color(0xffFE7F2D),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text("Change Nickname"),
        ],
      ),
    );
  }
}

//DEBUGGING-only
class RefreshTokenBtn extends StatelessWidget {
  final Function() callback;
  const RefreshTokenBtn({Key? key, required this.callback}) : super(key: key);

  Future<void> refreshToken() async {
    FirebaseAuth.instance.currentUser
        ?.getIdToken(true)
        .then((value) => debugPrint(value));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        refreshToken().then((value) => callback());
      },
      color: const Color(0xffFE7F2D),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.refresh),
          SizedBox(
            width: 5,
          ),
          Text("Refresh Token"),
        ],
      ),
    );
  }
}

class SendVerificationEmailBtn extends StatelessWidget {
  final Function() callback;
  final bool isActive;
  const SendVerificationEmailBtn(
      {Key? key, required this.callback, required this.isActive})
      : super(key: key);

  void sendVerificationEmail(BuildContext context) async {
    debugPrint("Sending verification email");
    try {
      await FirebaseAuth.instance.currentUser
          ?.sendEmailVerification()
          .whenComplete(() => callback());
    } on Exception catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Verification email already sent!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      disabledColor: Colors.grey,
      onPressed: isActive
          ? () {
              sendVerificationEmail(context);
            }
          : null,
      color: const Color(0xffFE7F2D),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.send),
          SizedBox(
            width: 5,
          ),
          Text("Send verification email"),
        ],
      ),
    );
  }
}
