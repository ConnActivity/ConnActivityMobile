import 'dart:convert';

import 'package:connactivity/alert_dialog.dart';
import 'package:connactivity/comms.dart';
import 'package:connactivity/event_detail_view.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/user.dart';
import 'package:connactivity/user_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// The Elements from the "My Events" page, offering the option to either view
/// the event or leave it.
class MyEvent extends StatefulWidget {
  const MyEvent(
      {Key? key,
      required this.data,
      required this.color,
      required this.callback})
      : super(key: key);

  //const MyEvent({Key? key}) : super(key: key);
  final Color color;
  final FeedElementData data;
  final Function callback;

  @override
  State<MyEvent> createState() => _MyEventState();
}

class _MyEventState extends State<MyEvent> {
  @override
  Widget build(BuildContext context) {
    //return Card(color: Colors.white, child: Text(widget.data.title),);
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          tileColor: widget.color,
          leading: const SizedBox(
              height: double.infinity,
              child: Icon(
                Icons.local_activity,
                color: Colors.black,
              )),
          title: Text(widget.data.title,
              style: const TextStyle(color: Colors.black)),
          subtitle: Text(
            widget.data.description,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: GestureDetector(
              child: const Icon(
                Icons.logout,
                color: Colors.black,
              ),
              onTap: () async {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
                  duration: Duration(milliseconds: 900),
                  content: Text("leaving event..."),
                ));
                var userToken = await getUserToken();
                var event = await http.get(
                    Uri.parse(
                        "https://api.connactivity.me/events/${widget.data.id}"),
                    headers: {
                      "cookie": "user_token=$userToken",
                    });
                var jsnondecoded = json.decode(event.body);
                var creator = jsnondecoded["creator"];
                UserData user = await getUserId();
                var uid = user.id;
                if (creator == uid) {
                  showAlertDialog(context, "You could not leave the event.",
                      "You are the owner of the event and therefore cannot leave the event.\nYou can delete the event instead.");
                } else {
                  var hasLeft = await leaveEvent(widget.data.id);
                  if (hasLeft)
                    widget.callback();
                  else {
                    showAlertDialog(context, "Unable to leave the event.",
                        "There was an unexpected error.\n\nPlease try again later.");
                  }
                }
              }),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        DetailScreen(widget.data, widget.color, 500)));
          },
        ),
      ),
    );
  }
}
