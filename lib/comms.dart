import 'dart:convert';
import 'package:connactivity/user.dart';
import 'package:connactivity/user_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// The server url, you can change this to localhost for testing
const serverUrl = "https://api.connactivity.me";

/// Tries to join an event, returning true if successful
Future<bool> joinEvent(int id) async {
  var userToken = await getUserToken();

  var response =
      await http.put(Uri.parse("$serverUrl/join_event/$id"), headers: {
    "cookie": "user_token=${userToken!}",
  });
  return response.statusCode == 202;
}

/// Tries to leave an event, returning true if successful
Future<bool> leaveEvent(int id) async {
  var userToken = await getUserToken();
  var response =
      await http.put(Uri.parse("$serverUrl/leave_event/$id"), headers: {
    "cookie": "user_token=$userToken",
  });

  return response.statusCode == 200;
}

/// Retrieves the joined events of the user
Future<List<int>> getUserEventIdList() async {
  var userToken = await getUserToken();

  UserData user = await getUserData();
  var userId = user.id;

  var response = await http
      .get(Uri.parse("$serverUrl/list_user_with_events/${userId!}"), headers: {
    "cookie": "user_token=${userToken!}",
  });

  List<int> userEventIds = [];
  List decodedResponse = json.decode(utf8.decode(response.bodyBytes));
  for (Map<String, dynamic> event in decodedResponse) {
    userEventIds.add(event["id"]);
  }

  return userEventIds;
}

/// Retrieves the joined events of the user
Future<bool> registerUser(String? name, String? email) async {
  var userToken = await getUserToken();
  UserData user = await getUserData();
  var uid = user.id;

  var body = {
    "username": name,
    "user_email": email,
    "university": "DHBW",
    "user_bio": "DEFAULT BIO",
  };

  var response = await http.post(Uri.parse("$serverUrl/user/"),
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

/// Retrieves whether or not a user exists
Future<bool> userExists() async {
  var userToken = await getUserToken();
  UserData user = await getUserData();
  var uid = user.id;

  debugPrint(userToken.toString());

  var response = await http.get(Uri.parse("$serverUrl/user/$uid"),
      headers: {"cookie": "user_token=$userToken"});

  return response.statusCode != 404;
}

/// Creates an event. If successful returns the event data
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
  UserData user = await getUserData();
  var uid = user.id;

  var request = http.MultipartRequest('POST', Uri.parse("$serverUrl/events/"));
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

  return [response.statusCode == 201, response.statusCode, responseData];
}

/// Requests the event details for a given event id from the server
Future<dynamic> get_event_detail(int event_id) async {
  var userToken = await getUserToken();
  UserData user = await getUserData();
  var uid = user.id;
  var response =
      await http.get(Uri.parse("$serverUrl/events/$event_id"), headers: {
    "cookie": "user_token=$userToken",
  });
  var data = json.decode(utf8.decode(response.bodyBytes));
  debugPrint("F: get_event_detail(): $data");
  return data;
}

/// Deletes the user from the server, returning true if successful
Future<bool> deleteUser() async {
  var userToken = await getUserToken();
  UserData user = await getUserData();
  var uid = user.id;
  var response = await http.delete(Uri.parse("$serverUrl/user/$uid"), headers: {
    "cookie": "user_token=$userToken",
  });
  return response.statusCode == 200;
}

/// Edits an event given the new data. If successful returns the event data
Future<List> editEvent(
  int eventId,
  String eventName,
  String eventDescription,
  String location,
  DateTime time,
  memberLimit,
  isPrivate,
  imagebytes,
) async {
  var userToken = await getUserToken();
  UserData user = await getUserData();
  var uid = user.id;

  var request =
      http.MultipartRequest('PUT', Uri.parse("$serverUrl/events/$eventId"));
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

  return [response.statusCode == 200, response.statusCode, responseData];
}

/// Deletes an event given the event id. If successful returns
Future<bool> deleteEvent(int eventId) async {
  var userToken = await getUserToken();

  var request =
      http.MultipartRequest('DELETE', Uri.parse("$serverUrl/events/$eventId"));
  request.headers.addAll({"cookie": "user_token=${userToken!}"});
  var response = await request.send();
  var responseData = await response.stream.bytesToString();
  debugPrint(responseData);

  debugPrint(response.statusCode.toString());
  return response.statusCode == 200;
}

/// Returns the image of the event
getImage(event) async {
  try {
    var response = await http
        .get(Uri.parse("https://api.connactivity.me$event"))
        .timeout(const Duration(seconds: 5));
    return response.bodyBytes;
  } catch (e) {
    return Uint8List(0);
  }
}
