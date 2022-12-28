import 'package:connactivity/comms.dart';
import 'package:connactivity/loginui.dart';
import 'package:connactivity/time_formater.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key? key}) : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  DateTime eventDate = DateTime.now();

  var eventNameInput = TextEditingController();
  var eventDescriptionInput = TextEditingController();
  var eventLocation = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff02020A),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff02020A),
          foregroundColor: const Color(0xff02020A),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Create Event",
                  style: GoogleFonts.lobster(
                      color: const Color(0xffFE7F2D), fontSize: 30)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "createEvent",
          onPressed: () async {
            await createEvent(eventNameInput.text, eventDescriptionInput.text,
                eventLocation.text, eventDate);
            Navigator.pop(context);
          },
          backgroundColor: const Color(0xffFE7F2D),
          child: const Icon(
            Icons.check,
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Loginfield(
                  title: "Event-Name",
                  defaultText: "Put your event here",
                  controller: eventNameInput),
              const SizedBox(
                height: 10,
              ),
              Loginfield(
                  title: "Event-Description",
                  defaultText: "What is your event about",
                  controller: eventDescriptionInput),
              const SizedBox(
                height: 10,
              ),
              Loginfield(
                  title: "Location",
                  defaultText: "Where does your event happen",
                  controller: eventLocation),
              TextButton(
                  onPressed: () async {
                    var selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2025));
                    if (selectedDate != null) {
                      setState(() {
                        eventDate = selectedDate;
                      });
                    }
                  },
                  child: Text(dateToString(eventDate))),
            ],
          ),
        ));
  }
}
