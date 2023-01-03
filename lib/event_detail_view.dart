import 'package:connactivity/feed_element_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showDetailView() async {
  print("showDetailView");
  return true;
}

class DetailScreen extends StatefulWidget {
  final FeedElementData feedElementData;

  DetailScreen(this.feedElementData);

  @override
  State<DetailScreen> createState() => DetailScreenState();

}

  //const DetailScreen({super.key, required this.feedElementData});


class DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    // ...
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.feedElementData.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(widget.feedElementData.description, style: const TextStyle(fontSize: 25, color: Colors.black)),
      ),
    );
  }

}



// TODO: implement an edit/delete button if the user is the owner of the event