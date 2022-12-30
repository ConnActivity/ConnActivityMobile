import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Loginfield extends StatelessWidget {
  final String title, defaultText;
  final TextEditingController controller;
  final bool isNumber;

  const Loginfield(
      {Key? key,
      required this.title,
      required this.defaultText,
      required this.controller
      ,this.isNumber = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: TextField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
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
