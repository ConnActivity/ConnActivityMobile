import 'package:flutter/material.dart';

class Loginfield extends StatelessWidget {
  final String title, defaultText;
  final TextEditingController controller;

  const Loginfield(
      {Key? key,
      required this.title,
      required this.defaultText,
      required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.amber)),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Colors.white),
            obscureText: false,
            decoration: InputDecoration(
              labelStyle: const TextStyle(color: Colors.amber),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.amber,
                ),
              ),
              labelText: defaultText,
            ),
          ),
        )
      ],
    );
  }
}
