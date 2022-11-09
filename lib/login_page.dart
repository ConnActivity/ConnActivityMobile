import 'package:connactivity/comms.dart' as comms;
import 'package:connactivity/loginui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _State();
}

class _State extends State<LoginPage> {
  var userEmailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff02020A),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  textAlign: TextAlign.center,
                  textScaleFactor: 2.5,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lobster(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: const Color(0xffFE7F2D),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Loginfield(
                  title: 'Accountname:',
                  defaultText: 'name',
                  controller: userEmailController,
                ),
                const SizedBox(
                  height: 50,
                ),
                Loginfield(
                  title: 'Password:',
                  defaultText: 'topsecret123',
                  controller: passwordController,
                ),
                MaterialButton(
                    onPressed: () => loginUser(
                        userEmailController.text, passwordController.text),
                    color: const Color(0xffFE7F2D),
                    child: const Text("Login"))
              ],
            ),
          ),
        ));
  }

  //TODO: Think about account linking
  void loginUser(String email, String password) async {
    Firebase.initializeApp;
    try {
      var creds = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      debugPrint(creds.user?.uid.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    }
    var userExists = await comms.userExists();
    debugPrint(userExists.toString());
    if (!userExists) await comms.registerUser("DEBUG_USER", email);
    debugPrint("Login end");

    Navigator.pop(context);
  }

  @override
  void dispose() {
    userEmailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
