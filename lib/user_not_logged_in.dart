import 'package:flutter/material.dart';

/// This is the stateless widget that indicates that the user is not in. It is used in the FeedPage and MyPage.
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
