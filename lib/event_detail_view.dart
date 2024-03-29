import 'package:connactivity/create-event-page.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/time_formater.dart';
import 'package:connactivity/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'comms.dart';

/// The Detail Screen of an Event, showing a scrollable description, the time
/// and place of the event, joining/leaving and (if you are the owner) the
/// options to edit or delete the event.
class DetailScreen extends StatefulWidget {
  FeedElementData feedElementData;
  final Color backgroundColor;
  final double height;

  DetailScreen(this.feedElementData, this.backgroundColor, this.height);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool user = false;

  @override
  void initState() {
    super.initState();
    is_owner();
  }

  /// Checks if the user is the owner of the event
  void is_owner() async {
    var userid = await getUserData();
    var event_details = await get_event_detail(widget.feedElementData.id);
    var creatorid = event_details["creator"];
    if (userid.id == creatorid) {
      setState(() {
        user = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Loads the Event details asynchronously
    get_future() async {
      var data = await get_event_detail(widget.feedElementData.id);
      return data;
    }

    return Material(
      type: MaterialType.transparency,
      child: FutureBuilder(
          future: get_future(),
          builder: (build_context, snapshot) {
            if (!snapshot.hasData) {
              debugPrint("no data yet");
              return const Center(child: CircularProgressIndicator());
            } else {
              Map data = snapshot.data as Map;
              return Container(
                height: widget.height,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: widget.backgroundColor),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            flex: 1,
                            child: SizedBox(
                              width: 320,
                              height: 200,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: (widget.feedElementData.image.isEmpty)
                                    ? const Icon(Icons.image)
                                    : Image.memory(
                                        widget.feedElementData.image,
                                        fit: BoxFit.fitHeight,
                                      ),
                              ),
                            ),
                          ),
                          Text(widget.feedElementData.title,
                              style: GoogleFonts.anton(
                                  textStyle: const TextStyle(
                                      color: Colors.black, fontSize: 30))),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined),
                              Text(
                                  data["location"] != null
                                      ? data["location"] as String
                                      : "No location data",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.schedule),
                              Text(
                                  widget.feedElementData.time != null
                                      ? timeToString(widget
                                          .feedElementData.time!
                                          .toLocal())
                                      : "No date data",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 20)),
                            ],
                          ),
                          Row(children: [
                            const Icon(Icons.people),
                            Text("Limit: ${data["member_limit"].toString()}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20)),
                          ]),
                          Row(children: [
                            const Icon(Icons.people),
                            Text(
                                "Joined: ${(data["member_list"]) == null ? "?" : (data["member_list"]).length}",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 20)),
                          ]),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //const Icon(Icons.info_outline),
                              Flexible(
                                  child: Text(
                                widget.feedElementData.description,
                                style: const TextStyle(
                                    fontSize: 20, fontStyle: FontStyle.italic),
                              )),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: user == true
                              ? Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: ElevatedButton(
                                    //on pressed opens edit event page
                                    onPressed: () async {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CreateEventPage(
                                                      feedElementData: widget
                                                          .feedElementData,
                                                      limit:
                                                          data["member_limit"]
                                                              .toString(),
                                                      place:
                                                          data["location"])));
                                    },
                                    style: ButtonStyle(
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color(0xffFE7F2D),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ))),
                                    child: const Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                )
                              : Container(),
                        ),
                        Expanded(
                          flex: 1,
                          child: user == true
                              ? Container(
                                  width: double.infinity,
                                  margin:
                                      const EdgeInsets.fromLTRB(5, 15, 0, 0),
                                  child: ElevatedButton(
                                    //on pressed opens edit event page
                                    onPressed: () async {
                                      await deleteEvent(
                                          widget.feedElementData.id);
                                      Navigator.pop(context);
                                    },
                                    style: ButtonStyle(
                                        shadowColor: MaterialStateProperty.all(
                                            Colors.transparent),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.transparent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                          side: const BorderSide(
                                              color: Color(0xffFE7F2D),
                                              width: 2),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ))),
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                )
                              : Container(),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
