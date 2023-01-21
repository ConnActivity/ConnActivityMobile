import 'package:flutter/material.dart';

/// A widget that displays a message that the user is not logged in.
class UserNotLoggedIn extends StatelessWidget {
  const UserNotLoggedIn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "You are not logged in",
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
