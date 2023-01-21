import 'dart:convert';
import 'dart:typed_data';

import 'package:connactivity/create-event-page.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/my_event_element.dart';
import 'package:connactivity/user.dart';
import 'package:connactivity/user_auth.dart';
import 'package:connactivity/user_not_logged_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'comms.dart';

/// The "My Page", showing all currently joined events.
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var colors = <Color>[
    const Color(0xff52D1DC),
    const Color(0xffB497D6),
    const Color(0xffDCF763)
  ];

  /// Triggers reloading the page.
  void triggerUpdate() {
    setState(() {});
  }

  Future<List<FeedElementData>?> getUserEvents() async {
    var userToken = await getUserToken();
    UserData user = await getUserData();
    var userId = user.id;

    if (userId == null) return null;

    var response = await http.get(
        Uri.parse("https://api.connactivity.me/list_user_with_events/$userId"),
        headers: {
          "cookie": "user_token=${userToken!}",
        });

    List<FeedElementData> userEvents = [];
    List decodedResponse = json.decode(utf8.decode(response.bodyBytes));
    for (Map<String, dynamic> event in decodedResponse) {
      userEvents.add(
        FeedElementData(
          id: event["id"],
          title: event["title"],
          description: event["description"],
          place: null,
          time: event["date"] != null ? DateTime.parse(event["date"]) : null,
          image: event["image"] == null
              ? Uint8List(0)
              : await getImage(event["image"]),
        ),
      );
    }

    debugPrint(response.statusCode.toString());
    debugPrint(response.body);

    return userEvents;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => CreateEventPage()));
        },
        backgroundColor: const Color(0xffFE7F2D),
        heroTag: "createEventBtn",
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: getUserEvents(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return const UserNotLoggedIn();
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              debugPrint(snapshot.data.toString());
              return ListView.builder(
                shrinkWrap: false,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return MyEvent(
                    data: snapshot.data?[index],
                    color: colors[index % 3],
                    callback: triggerUpdate,
                  );
                },
              );
            }
          }),
    );
  }
}
