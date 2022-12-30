import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:connactivity/comms.dart';
import 'package:connactivity/loginui.dart';
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
                    color: const Color(0xffFE7F2D)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Add an image to your event",
                        style: GoogleFonts.anton(
                            textStyle: const TextStyle(
                                color: Colors.black, fontSize: 30))),
                        Container(
                          child: imagebytes == null
                              ? const Icon(Icons.image)
                              : Image.memory(imagebytes),
                        ),
                        ElevatedButton(
                          onPressed: ()  {
                            openImage();
                          },
                          child: imagebytes == null ? Text("Pick Image"): Text("Change Image"),
                        ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffFE7F2D)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Loginfield(
                      title: "Event Name",
                      defaultText: "Put your event here",
                      controller: eventNameInput,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffFE7F2D)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Loginfield(
                      title: "Event Description",
                      defaultText: "What is your event about?",
                      controller: eventDescriptionInput,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffFE7F2D)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Loginfield(
                      title: "Location",
                      defaultText: "Where is your event?",
                      controller: eventLocation,
                    ),
                  ],
                ),
              ),
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
              Loginfield(
                  title: "Member limit",
                  defaultText: "Put the member limit here",
                  controller: memberLimit,
              isNumber: true,),
              SwitchListTile(
                title: const Text("Is Event Private"),
                  tileColor: const Color(0xffcc8016),
                  activeColor: const Color(0xfff2d635),
                  value: isPrivate,
                  onChanged: (bool value) {
                    setState(() {
                      isPrivate = value;
                    });
                  }
              ),

             // image == null?Container():
             // Image.file((image.path))
            ],
          ),
        ));
  }
}
