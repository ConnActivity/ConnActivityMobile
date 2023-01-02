import 'package:connactivity/feed_element_data.dart';
import 'package:flutter/cupertino.dart'
import 'package:flutter/material.dart';;

Future<bool> showDetailView() async {
  print("showDetailView");
  return true;
}
class DetailScreen extends StatefulWidget {
  final FeedElementData feedElementData;



  const DetailScreen({super.key, required this.feedElementData});

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(feedElementData.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(feedElementData.description),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

// TODO: implement an edit/delete button if the user is the owner of the event