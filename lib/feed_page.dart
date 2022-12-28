import 'dart:convert';

import 'package:connactivity/comms.dart';
import 'package:connactivity/feed_element.dart';
import 'package:connactivity/feed_element_data.dart';
import 'package:connactivity/user_auth.dart';
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

class _FeedPageState extends State<FeedPage>
    with AutomaticKeepAliveClientMixin {
  Future<List<FeedElementData>?> getFeedData() async {
    var userToken = await getUserToken();

    if (userToken == null) return null;

    var response = await http
        .get(Uri.parse("https://api.connactivity.me/events/"), headers: {
      "cookie": "user_token=$userToken",
    });

    var userEventIds = await getUserEventIdList();

    List<FeedElementData> feedData = [];
    List decodedResponse = json.decode(utf8.decode(response.bodyBytes));
    for (Map<String, dynamic> event in decodedResponse) {
      feedData.add(
        FeedElementData(
            isMemeber: userEventIds.contains(event["id"]),
            id: event["id"],
            title: event["title"],
            description: event["description"],
            place: null,
            time: event["date"] != null ? DateTime.parse(event["date"]) : null),
      );
    }

    debugPrint(response.statusCode.toString());
    //debugPrint(response.body);

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
        children: [
          FloatingActionButton(
            heroTag: "openSortPageBtn",
            onPressed: () => null,
            backgroundColor: const Color(0xffFE7F2D),
            child: const Icon(Icons.sort),
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.fromLTRB(90, 0, 90, 30),
                duration: Duration(milliseconds: 500),
                content: Text("updating feed..."),
              ));
              setState(() {});
            },
            heroTag: "updateFeedBtn",
            backgroundColor: const Color(0xffFE7F2D),
            child: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: Future.wait([
                  getUserId(),
                  getFeedData(),
                ]),
                builder: (context, AsyncSnapshot<List> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (!snapshot.data![0].isLoggedIn) {
                    return const Center(
                      child: Text(
                        "Your are not logged in",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return ListView.builder(
                      //adding pagination
                      shrinkWrap: false,
                      itemCount: snapshot.data?[1].length,
                      itemBuilder: (context, index) {
                        return FeedElement(
                          feedElementData: snapshot.data?[1][index],
                          backgroundColor: widget.colors[index % 3],
                          height: widget.height,
                        );
                      },
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
                print(currentPage);
              });
            },
            useGroup: false,
            totalPage: 30,
            show: 2,
            currentPage: currentPage,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

//TODO: change icon color to black
//TODO: change navBar icon color to black
