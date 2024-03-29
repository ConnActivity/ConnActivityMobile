import 'package:connactivity/account_page/github_sign_in.dart';
import 'package:connactivity/account_page/google_sign_in.dart';
import 'package:connactivity/comms.dart' as comms;
import 'package:connactivity/account_page/user_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'comms.dart';
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
                    isVerified: emailVerified,
                  ),
                  // Logout button
                  LogoutBtn(
                    callback: userAuth,
                    isActive: userEmail != null,
                  ),
                  // Google sign in button
                  GoogleSignInBtn(
                    callback: userAuth,
                    isActive: userEmail == null,
                  ),
                  // GitHub sign in button
                  GitHubSignInBtn(
                      callback: userAuth,
                      isActive: userEmail == null,
                      context: context),
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
                  // Account delete button
                  DeleteAccount(
                    isActive: userEmail != null,
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
    return AccountButton(
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          // Navigate to login page
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()))
              .then((value) => callback());
        },
        color: const Color(0xffFE7F2D),
        child: const Text(
          "Login",
        ),
      ),
    );
  }
}

/// Logout user regardless of account type
class LogoutBtn extends StatelessWidget {
  final void Function() callback;
  final bool isActive;

  const LogoutBtn({Key? key, required this.callback, required this.isActive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AccountButton(
      child: MaterialButton(
        disabledColor: Colors.grey,
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: isActive
            ? () {
                // Sign out of Firebase and refresh after sign out
                FirebaseAuth.instance.signOut().then(((value) => callback()));
              }
            : null,
        color: const Color(0xffFE7F2D),
        child: const Text(
          "Logout",
        ),
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

  /// Change the display name of the user
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
                // close the dialog
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
    return AccountButton(
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        // If the button is not active it is still displayed in the UI but greyed out
        disabledColor: Colors.grey,
        // If the button is active it can be pressed otherwise the function is null, making it disabled (see disabledColor)
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
      ),
    );
  }
}

/// Delete the user account (from firebase and server)
class DeleteAccount extends StatelessWidget {
  final bool isActive;
  const DeleteAccount({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AccountButton(
      child: MaterialButton(
        height: 50,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        // if the button is not active it is still displayed in the UI but greyed out
        disabledColor: Colors.grey,
        onPressed: isActive
            ? () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    // Ask user for confirmation before deleting account
                    return AlertDialog(
                      title: const Text('Delete Account'),
                      titleTextStyle:
                          const TextStyle(color: Colors.white, fontSize: 25),
                      backgroundColor: Colors.grey,
                      content: const Text(
                          'Are you sure you want to delete your account? This action cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          // Closes the dialog if the user does not want to delete their account
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white)),
                          // Triggers the deletion flow
                          onPressed: () async {
                            // Deletes the user from the server
                            bool isDeleted = await deleteUser();
                            // Deletes the user from firebase if it has been deleted from the server
                            // That way the user id can still be accessed for manual removal
                            if (isDeleted) {
                              FirebaseAuth.instance.currentUser?.delete();
                            }
                            // Widget will still be mounted
                            // Close the dialog
                            Navigator.of(context).pop();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              }
            : null,
        color: const Color.fromARGB(255, 254, 45, 45),
        child: const Text(
          "Delete Account",
        ),
      ),
    );
  }
}

/// Wrapper to have a consistent margin for all account buttons
class AccountButton extends StatelessWidget {
  final Widget child;
  const AccountButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Add a margin to the bottom of the child
      margin: const EdgeInsets.only(bottom: 15),
      child: child,
    );
  }
}
