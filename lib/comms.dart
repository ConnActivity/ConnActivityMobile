import 'dart:convert';

import 'package:connactivity/user.dart';
import 'package:connactivity/user_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:http/http.dart' as http;

Future<bool> joinEvent(int id) async {
  var userToken = await getUserToken();

  var response = await http
      .put(Uri.parse("https://api.connactivity.me/join_event/$id"), headers: {
    "cookie": "user_token=${userToken!}",
  });

  return response.statusCode == 202;
}

Future<bool> leaveEvent(int id) async {
  var userToken = await getUserToken();

  var response = await http
      .put(Uri.parse("https://api.connactivity.me/leave_event/$id"), headers: {
    "cookie": "user_token=${userToken!}",
  });

  return response.statusCode == 200;
}

Future<List<int>> getUserEventIdList() async {
  var userToken = await getUserToken();

  UserData user = await getUserId();
  var userId = user.id;

  var response = await http.get(
      Uri.parse("https://api.connactivity.me/list_user_with_events/${userId!}"),
      headers: {
        "cookie": "user_token=${userToken!}",
      });

  List<int> userEventIds = [];
  List decodedResponse = json.decode(utf8.decode(response.bodyBytes));
  for (Map<String, dynamic> event in decodedResponse) {
    userEventIds.add(event["id"]);
  }

  return userEventIds;
}

Future<bool> registerUser(String? name, String? email) async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;

  var body = {
    "username": name,
    "user_email": email,
    "gender": "x",
    "user_age": 1337,
    "university": "DHBW",
    "user_bio": "test-bio",
    "user_id": uid,
  };

  var response = await http.post(Uri.parse("https://api.connactivity.me/user/"),
      headers: {
        "cookie": "user_token=${userToken!}",
        "Content-Type": "application/json"
      },
      body: json.encode(body));
  debugPrint(response.statusCode.toString());
  debugPrint(response.body.toString());
  return response.statusCode == 200;
}

Future<bool> userExists() async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;

  debugPrint(userToken.toString());

  var response = await http.get(
      Uri.parse("https://api.connactivity.me/user/$uid"),
      headers: {"cookie": "user_token=$userToken"});

  return response.statusCode != 404;
}

Future<bool> createEvent(String eventName, String eventDescription,
    String location, DateTime time, memberLimit) async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;

  //debugPrint(time.toUtc().toIso8601String());

  var requestBody = <String, dynamic>{};
  print("MemberLimit: ${memberLimit.text}");
  print(memberLimit);
  requestBody["title"] = eventName;
  requestBody["date_published"] = DateTime.now().toLocal().toIso8601String();
  requestBody["date"] = time.toLocal().toIso8601String();
  requestBody["location"] = location;
  requestBody["description"] = eventDescription;
  requestBody["member_list"] = uid;
  requestBody["creator"] = uid;
  //requestBody["member_limit"] = memberLimit;
  //requestBody["is_private"] = false;

  var response =
      await http.post(Uri.parse("https://api.connactivity.me/events/"),
          headers: {
            "cookie": "user_token=${userToken!}",
            //"Content-Type" : "application/json"
          },
          body: requestBody);
  debugPrint(response.statusCode.toString());
  debugPrint(response.body.toString());
  return response.statusCode == 201;
}
