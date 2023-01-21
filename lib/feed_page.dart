import 'dart:convert';
import 'dart:typed_data';

import 'package:connactivity/comms.dart';
import 'package:connactivity/feed_element.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/user_auth.dart';
import 'package:connactivity/user_not_logged_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pagination/flutter_pagination.dart';
import 'package:flutter_pagination/widgets/button_styles.dart';
import 'package:http/http.dart' as http;
//import 'package:http/browser_client.dart' as bc;

class FeedPage extends StatefulWidget {
  FeedPage({Key? key, required this.height}) : super(key: key);
  final double height;
  var colors = <Color>[
    const Color(0xff52D1DC),
    const Color(0xffB497D6),
    const Color(0xffDCF763)
  ];

  @override
  State<FeedPage> createState() => _FeedPageState();
}

var currentPage = 1;
var maxpages = 1;

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  Future<List<FeedElementData>?> getFeedData() async {
    var userToken = await getUserToken();
    debugPrint("F:getFeedData() -> userToken: $userToken");

    if (userToken == null) return null;

    var response = await http
        .get(Uri.parse("$server_url/events/?page=$currentPage"), headers: {
      "cookie": "user_token=$userToken",
    });
    maxpages = int.parse(response.headers['link']!);

    var userEventIds = await getUserEventIdList();

    List<FeedElementData> feedData = [];
    List decodedResponse = json.decode(utf8.decode(response.bodyBytes));
    for (Map<String, dynamic> event in decodedResponse) {
      feedData.add(
        FeedElementData(
          isMember: userEventIds.contains(event["id"]),
          id: event["id"],
          title: event["title"],
          description: event["description"],
          place: event["location"],
          time: event["date"] != null ? DateTime.parse(event["date"]) : null,
          image: event["image"] == null
              ? Uint8List(0)
              : await getImage(event["image"]),
        ),
      );
    }
    return feedData;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getFeedData(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasError) {
                    return const UserNotLoggedIn();
                  } else if (!snapshot.hasData) {
                    debugPrint("F:build() -> snapshot.hasData: false");
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    debugPrint("F:build() -> snapshot.hasData: true");
                    return RefreshIndicator(
                      onRefresh: () {
                        setState(() {});
                        return Future.value();
                      },
                      child: ListView.builder(
                        shrinkWrap: false,
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return FeedElement(
                            feedElementData: snapshot.data?[index],
                            backgroundColor: widget.colors[index % 3],
                            height: widget.height,
                          );
                        },
                      ),
                    );
                  }
                }),
          ),
          Pagination(
            paginateButtonStyles: PaginateButtonStyles(),
            prevButtonStyles: PaginateSkipButton(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20))),
            nextButtonStyles: PaginateSkipButton(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            onPageChange: (number) {
              setState(() {
                currentPage = number;
              });
            },
            useGroup: true,
            totalPage: maxpages,
            show: maxpages > 3 ? 3 : 0,
            currentPage: currentPage,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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
}

//TODO: change icon color to black
//TODO: change navBar icon color to black
