import 'dart:io';
import 'dart:ui';

import 'package:connactivity/comms.dart';
import 'package:connactivity/create_event_ui.dart';
import 'package:connactivity/time_formater.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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
  var memberLimit = TextEditingController();
  var isPrivate = false;
  var imagebytes = null;
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late File imagefile;

  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if(pickedFile != null){
        imagepath = pickedFile.path;
        imagefile = File(imagepath);
        imagebytes = imagefile.readAsBytesSync();
        setState(() {

        });
      }else{
        print("No image is selected.");
      }
    }catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xff1b1c1f),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff0e0f0f),
          foregroundColor: const Color(0xff0e0f0f),
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
                eventLocation.text, eventDate, memberLimit, isPrivate, imagebytes);
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
              // Display image
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff52D1DC)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Add an image to your event",
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                      ],
                    ),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [Container(
                          child: imagebytes == null
                              ? const Icon(Icons.image)
                              : Image.memory(imagebytes),
                        ),],),
                        Row(mainAxisAlignment: MainAxisAlignment.center,
                        children: [ElevatedButton(
                          onPressed: ()  {
                            openImage();
                          },
                          child: imagebytes == null ? Text("Pick Image"): Text("Change Image"),
                        ),],),

                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffB497D6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventField(
                      title: "Event Name\u002A",
                      defaultText: "Put your event here",
                      controller: eventNameInput,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffDCF763)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventField(
                      title: "Event Description\u002A",
                      defaultText: "What is your event about?",
                      controller: eventDescriptionInput,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff52D1DC)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventField(
                      title: "Location",
                      defaultText: "Where is your event?",
                      controller: eventLocation,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffB497D6)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Selcet Date\u002A: ", style: GoogleFonts.lato(
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                      SizedBox(
                        height: 50,
                        width: 150,
                        child: TextButton(
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(const Color(
                                  0xffa173bd)),
                            ),
                            child: Text(dateToString(eventDate),style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)))),)
                      ,],),

                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffDCF763)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EventField(
                      title: "Member Limit",
                      defaultText: "How many participants? (Default: 4)",
                      controller: memberLimit,
                      isNumber: true,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff52D1DC)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SwitchListTile(
                        title: Text("Event private?",
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))),
                        tileColor: const Color(0xff1f2121),
                        activeColor: const Color(0xfff2d635),
                        value: isPrivate,
                        onChanged: (bool value) {
                          setState(() {
                            isPrivate = value;
                          });
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
// TODO: Add event tags
