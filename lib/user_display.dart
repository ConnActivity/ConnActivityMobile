import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class UserDisplay extends StatelessWidget {
  final String name;
  final String email;
  final String photoUrl;
  final String id;

  const UserDisplay(
      {super.key,
      required this.name,
      required this.email,
      required this.photoUrl,
      required this.id});

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
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.brown.shade800,
            backgroundImage: NetworkImage(photoUrl),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoChip(icon: Icons.person, text: name),
              InfoChip(icon: Icons.email, text: email),
              InfoChip(icon: Icons.numbers, text: id),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoChip({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    //TODO: fix text overflow
    //https://docs.flutter.dev/development/ui/layout/constraints
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(
          text,
          overflow: TextOverflow.fade,
        )
      ],
    );
  }
}
