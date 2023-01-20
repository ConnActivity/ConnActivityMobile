import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

/// Displays the user's [name], [email], and [photoUrl].
class UserDisplay extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String id;
  final bool? isVerified;

  const UserDisplay(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id,
      this.isVerified});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.brown.shade800,
              backgroundImage: NetworkImage(photoUrl),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InfoChip(icon: Icons.person, text: name),
                InfoChip(icon: Icons.email, text: email),
                isVerifiedInfoChip(isEmailVerified: isVerified),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Displays an [icon] and [text] in a row. Sub-part of [UserDisplay].
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 5,
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            text,
            overflow: TextOverflow.fade,
          ),
        )
      ],
    );
  }
}

/// Returns an [InfoChip] with the appropriate text based on [isEmailVerified].
InfoChip isVerifiedInfoChip({bool? isEmailVerified}) {
  return InfoChip(
      icon: isEmailVerified == null
          ? Icons.help
          : isEmailVerified
              ? Icons.verified
              : Icons.cancel,
      text: isEmailVerified == null
          ? "Not available"
          : isEmailVerified
              ? "Email is verified"
              : "Please verify your email");
}
