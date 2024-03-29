import 'package:connactivity/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

///Returns the user token if the user is logged in or throws an error
///if not logged in
Future<String?> getUserToken() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) throw Exception("User not logged in");
  return currentUser.getIdToken(true);
}

/// Returns the current user's data
Future<UserData> getUserData() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var currentUser = FirebaseAuth.instance.currentUser;

  debugPrint("F:getUserId() -> currentUser: $currentUser");

  return UserData(
      name: currentUser?.displayName,
      email: currentUser?.email,
      id: currentUser?.uid,
      photoUrl: currentUser?.photoURL,
      isLoggedIn: (currentUser != null));
}
