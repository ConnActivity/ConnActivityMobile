import 'package:connactivity/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<String?> getUserToken() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var currentUser = FirebaseAuth.instance.currentUser;
  return currentUser?.getIdToken(true);
}

Future<UserData> getUserId() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var currentUser = FirebaseAuth.instance.currentUser;

  return UserData(
      name: currentUser?.displayName,
      email: currentUser?.email,
      id: currentUser?.uid,
      photoUrl: currentUser?.photoURL,
      isLoggedIn: (currentUser!=null));
}
