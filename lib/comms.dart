import 'dart:convert';
import 'package:connactivity/user.dart';
import 'package:connactivity/user_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const server_url = "https://api.connactivity.me";
Future<bool> joinEvent(int id) async {
  var userToken = await getUserToken();

  var response =
      await http.put(Uri.parse("$server_url/join_event/$id"), headers: {
    "cookie": "user_token=${userToken!}",
  });
  print("body:");
  print(response.body);
  return response.statusCode == 202;
}

Future<bool> leaveEvent(int id) async {
  var userToken = await getUserToken();
  var response =
      await http.put(Uri.parse("$server_url/leave_event/$id"), headers: {
    "cookie": "user_token=$userToken",
  });

  return response.statusCode == 200;
}

Future<List<int>> getUserEventIdList() async {
  var userToken = await getUserToken();

  UserData user = await getUserId();
  var userId = user.id;

  var response = await http
      .get(Uri.parse("$server_url/list_user_with_events/${userId!}"), headers: {
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
    //"gender": "x",
    //"user_age": 1337,
    "university": "DHBW",
    "user_bio": "DEFAULT BIO",
    //"user_id": uid,
  };

  var response = await http.post(Uri.parse("$server_url/user/"),
      headers: {
        "Cookie": "user_token=${userToken!}",
        "Content-Type": "application/json"
      },
      body: json.encode(body));
  var resp_body = response.body;
  debugPrint(response.statusCode.toString());
  debugPrint(userToken.toString());
  debugPrint("End user registration");
  return response.statusCode == 201;
}

Future<bool> userExists() async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;

  debugPrint(userToken.toString());

  var response = await http.get(Uri.parse("$server_url/user/$uid"),
      headers: {"cookie": "user_token=$userToken"});

  return response.statusCode != 404;
}

Future<List> createEvent(
  String eventName,
  String eventDescription,
  String location,
  DateTime time,
  memberLimit,
  isPrivate,
  imagebytes,
) async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;

  var request = http.MultipartRequest('POST', Uri.parse("$server_url/events/"));
  request.headers.addAll({"cookie": "user_token=${userToken!}"});
  request.fields["title"] = eventName;
  request.fields["date_published"] = DateTime.now().toLocal().toIso8601String();
  request.fields["date"] = time.toLocal().toIso8601String();
  request.fields["location"] = location;
  request.fields["description"] = eventDescription;
  request.fields["member_list"] = uid.toString();
  request.fields["creator"] = uid.toString();
  request.fields["member_limit"] = memberLimit.text;
  if (isPrivate) {
    request.fields["is_private"] = "true";
  } else {
    request.fields["is_private"] = "false";
  }

  if (imagebytes != null) {
    var imageName = "${imagebytes.hashCode.toString()}.jpg";
    var picture =
        http.MultipartFile.fromBytes('image', imagebytes, filename: imageName);
    request.files.add(picture);
  }
  var response = await request.send();
  var responseData = await response.stream.bytesToString();
  debugPrint(responseData);

  debugPrint(response.statusCode.toString());
  return [response.statusCode == 201, response.statusCode, responseData];
}

Future<dynamic> get_event_detail(int event_id) async {
  var userToken = await getUserToken();
  UserData user = await getUserId();
  var uid = user.id;
  var response =
      await http.get(Uri.parse("$server_url/events/$event_id"), headers: {
    "cookie": "user_token=$userToken",
  });
  var data = json.decode(utf8.decode(response.bodyBytes));
  debugPrint("F: get_event_detail(): ${data}");
  return data;
}
