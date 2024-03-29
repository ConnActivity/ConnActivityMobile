import 'package:connactivity/comms.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/time_formater.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'event_detail_view.dart';

/// A widget that displays a feed element based on [FeedElementData].
class FeedElement extends StatefulWidget {
  const FeedElement(
      {Key? key,
      required this.feedElementData,
      required this.backgroundColor,
      required this.height})
      : super(key: key);
  final FeedElementData feedElementData;
  final Color backgroundColor;
  final double height;

  @override
  State<FeedElement> createState() => _FeedElementState();
}

class _FeedElementState extends State<FeedElement>
    with AutomaticKeepAliveClientMixin {
  bool joint = false;

  @override
  void initState() {
    super.initState();
    // Display if user joined event
    if (widget.feedElementData.isMember != null &&
        widget.feedElementData.isMember!) {
      setState(() {
        joint = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.9,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: SizedBox(
              width: 320,
              height: 200,
              child: (widget.feedElementData.image.isEmpty)
                  ? const Icon(Icons.image)
                  : Image.memory(
                      widget.feedElementData.image,
                      fit: BoxFit.fitHeight,
                    ),
            ),
          ),
          Text(widget.feedElementData.title,
              style: GoogleFonts.anton(
                  textStyle:
                      const TextStyle(color: Colors.black, fontSize: 30))),
          Row(
            children: [
              const Icon(Icons.schedule),
              Text(
                  widget.feedElementData.time != null
                      ? timeToString(widget.feedElementData.time!.toLocal())
                      : "No date data",
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const Icon(Icons.info_outline),
                Flexible(
                    child: Text(
                  maxLines: 3,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  widget.feedElementData.description,
                  style: const TextStyle(
                      fontSize: 20, fontStyle: FontStyle.italic),
                )),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 5, 0),
                  width: double.infinity,
                  child: ElevatedButton(
                    // User can only join if the user is not already a member
                    onPressed: () async {
                      bool response = joint;
                      if (!joint) {
                        response = await joinEvent(widget.feedElementData.id);
                      } else {
                        response = await leaveEvent(widget.feedElementData.id);
                        response = !response;
                      }
                      setState(() {
                        // Refresh the state of the button
                        joint = response;
                      });
                    },
                    style: ButtonStyle(
                        // Change the color of the button depending on the joint state
                        backgroundColor: joint
                            ? MaterialStateProperty.all(Colors.black)
                            : MaterialStateProperty.all(
                                const Color(0xffFE7F2D)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    // Display a checkmark if the user is a member
                    child: joint
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                          )
                        : const Text(
                            "Join",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(5, 15, 0, 0),
                  child: ElevatedButton(
                    // Navigate to the detail screen
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                  widget.feedElementData,
                                  widget.backgroundColor,
                                  widget.height)));
                    },
                    style: ButtonStyle(
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color(0xffFE7F2D), width: 2),
                          borderRadius: BorderRadius.circular(20.0),
                        ))),
                    child: const Text(
                      "Details",
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Keep scroll position
  @override
  bool get wantKeepAlive => true;
}
