import 'package:flutter/material.dart';

class Loginfield extends StatelessWidget {
  final String title, defaultText;
  final TextEditingController controller;
  final bool isPassword;

  const Loginfield(
      {Key? key,
      required this.title,
      required this.defaultText,
      required this.controller,
      this.isPassword = false})

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
            obscureText: isPassword,
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
