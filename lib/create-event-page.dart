import 'dart:io';
import 'dart:typed_data';

import 'package:connactivity/alert_dialog.dart';
import 'package:connactivity/comms.dart';
import 'package:connactivity/create_event_ui.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/time_formater.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

/// Displays the create and edit event page showing the form to create/edit
class CreateEventPage extends StatefulWidget {
  FeedElementData? feedElementData;
  String? limit;
  String? place;

  CreateEventPage({this.feedElementData, Key? key, this.limit, this.place})
      : super(key: key);

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.now();

  String time = "";
  var eventNameInput = TextEditingController();
  var eventDescriptionInput = TextEditingController();
  var eventLocation = TextEditingController();
  var memberLimit = TextEditingController();
  var isPrivate = false;
  var imagebytes = null;
  final ImagePicker imgpicker = ImagePicker();
  String imagepath = "";
  late File imagefile;

  @override

  /// If the user is editing an event, the form is filled with the event data
  void initState() {
    if (widget.feedElementData != null) {
      eventNameInput.text = widget.feedElementData!.title;
      eventDescriptionInput.text = widget.feedElementData!.description;
      eventLocation.text = widget.place != null ? widget.place! : "No location";
      eventDate = widget.feedElementData!.time ?? DateTime.now();
      eventTime = TimeOfDay.fromDateTime(widget.feedElementData!.time!);
      memberLimit.text = widget.limit ?? "Unlimited"; // todo: get member limit
      imagebytes = widget.feedElementData!.image.isEmpty
          ? null
          : widget.feedElementData!.image;
    }
    super.initState();
  }

  openImage() async {
    try {
      var pickedFile = await imgpicker.pickImage(source: ImageSource.gallery);
      //you can use ImageCourse.camera for Camera capture
      if (pickedFile != null) {
        imagepath = pickedFile.path;
        imagefile = File(imagepath);
        imagebytes = imagefile.readAsBytesSync();
        setState(() {});
      } else {
        debugPrint("No image is selected.");
      }
    } catch (e) {
      showAlertDialog(context, "Error while loading image", "Exception: $e");
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
            if (widget.feedElementData == null) {
              eventDate = DateTime(eventDate.year, eventDate.month,
                  eventDate.day, eventTime.hour, eventTime.minute);
              var creation = await createEvent(
                  eventNameInput.text,
                  eventDescriptionInput.text,
                  eventLocation.text,
                  eventDate,
                  memberLimit,
                  isPrivate,
                  imagebytes);
              debugPrint(creation.toString());
              if (creation[0]) {
                Navigator.pop(context);
              } else {
                if (creation[1] == 400 || creation[1] == 401) {
                  showAlertDialog(context, "Error while creating the event",
                      "Not all required fields are filled or your are not logged in.\nPlease fill all fields and try again.\nError Message: ${creation[2].toString()}");
                } else {
                  showAlertDialog(context, "Error",
                      "An unexpected Error occured while creating event\nPlease try again later");
                }
              }
              //Navigator.pop(context);
            } else {
              eventDate = DateTime(eventDate.year, eventDate.month,
                  eventDate.day, eventTime.hour, eventTime.minute);
              var creation = await editEvent(
                  widget.feedElementData!.id,
                  eventNameInput.text,
                  eventDescriptionInput.text,
                  eventLocation.text,
                  eventDate,
                  memberLimit,
                  isPrivate,
                  imagebytes);
              debugPrint(creation.toString());
              if (creation[0]) {
                Navigator.pop(context);
              } else {
                if (creation[1] == 400 || creation[1] == 401) {
                  showAlertDialog(context, "Error while editing the event",
                      "Not all required fields are filled or your are not logged in.\nPlease fill all fields and try again.\nError Message: ${creation[2].toString()}");
                } else {
                  showAlertDialog(context, "Error",
                      "An unexpected Error occured while editing event\nPlease try again later");
                }
              }
            }
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
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            width: 320,
                            height: 200,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: imagebytes == null
                                  ? const Icon(Icons.image)
                                  : Image.memory(imagebytes),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            openImage();
                          },
                          child: imagebytes == null
                              ? Text("Pick Image")
                              : Text("Change Image"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            imagebytes = null;
                            setState(() {});
                          },
                          child: Text("Remove Image"),
                        ),
                      ],
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
                      title: "Location\u002A",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select Date\u002A: ",
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: TextButton(
                              onPressed: () async {
                                var selectedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now()
                                        .add(const Duration(days: 1)),
                                    firstDate: DateTime(2022),
                                    lastDate: DateTime(2025));
                                if (selectedDate != null) {
                                  setState(() {
                                    eventDate = selectedDate;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xffa173bd)),
                              ),
                              child: Text(dateToString(eventDate),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Select Time\u002A: ",
                            style: GoogleFonts.lato(
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                        SizedBox(
                          height: 50,
                          width: 150,
                          child: TextButton(
                              onPressed: () async {
                                var selectedTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (selectedTime != null) {
                                  setState(() {
                                    eventTime = selectedTime;
                                  });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xffa173bd)),
                              ),
                              child: Text(eventTime.format(context),
                                  style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)))),
                        )
                      ],
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
                      title: "Member Limit",
                      defaultText: "How many participants? (Default: 4)",
                      controller: memberLimit,
                      isNumber: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ));
  }
}
