import 'package:connactivity/account_page/github_sign_in.dart';
import 'package:connactivity/account_page/google_sign_in.dart';
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

/// The AccountPage shows the user their current account information
/// and allows them to sign in or out.
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

  /// Gets information about current user and triggers widgets to be updated
  void userAuth() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var currentUser = FirebaseAuth.instance.currentUser;

    setState(() {
      displayName = currentUser?.displayName;
      userEmail = currentUser?.email;
      emailVerified = currentUser?.emailVerified;
      firebaseId = currentUser?.uid;
      photoUrl = currentUser?.photoURL;
    });
  }

  /// Returns Text widget describing verification state of user email according to [isEmailVerified]
  Text isVerified(bool? isEmailVerified) {
    if (isEmailVerified == null) {
      return const Text("Email verification state not available",
          style: TextStyle(color: Colors.white));
    }
    return isEmailVerified
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
                  // Display login button if user is not logged in and vice versa (Email-Login)
                  userEmail == null
                      ? LoginBtn(callback: userAuth)
                      : LogoutBtn(callback: userAuth),
                  // Offer option to send verification email if user is logged in and email is not verified
                  userEmail != null && emailVerified == false
                      ? SendVerificationEmailBtn(
                          callback: userAuth,
                          isActive: true,
                        )
                      : SendVerificationEmailBtn(
                          callback: userAuth, isActive: false),
                  GoogleSignInBtn(
                    callback: userAuth,
                    isActive: userEmail == null,
                  ),
                  GitHubSignInBtn(callback: userAuth, isActive: userEmail == null, context: context),
                  // Offer option to change display name if user is logged in
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
                ]),
          )
        ],
      )),
    );
  }
}

/// Login user with email and password
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

/// Logout user regardless of account type
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

/// Change the display name of the user
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

  /// Show the dialog to change the display name
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        var nickNameController = TextEditingController();
        nickNameController.text = oldDisplayName ??
            ""; // Prepopulate the text field with the old display name
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
                // change nickname asynchrnously
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
      // if the button is not active it is still displayed in the UI but greyed out
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

/// Request a verification email to be sent to the user
class SendVerificationEmailBtn extends StatelessWidget {
  final Function() callback;
  final bool isActive;

  const SendVerificationEmailBtn(
      {Key? key, required this.callback, required this.isActive})
      : super(key: key);

  /// Request firebase to send a verification email to the user
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
      // if the button is not active it is still displayed in the UI but greyed out
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
