import 'package:flutter/material.dart';

/// The Navigation Bar containing the Feed, My, and Account tabs
class ConnActivityNavBar extends StatelessWidget {
  const ConnActivityNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white70,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorPadding: const EdgeInsets.all(5.0),
      indicatorColor: const Color(0xffFE7F2D),
      indicator: BoxDecoration(
          color: const Color(0xffFE7F2D),
          borderRadius: BorderRadius.circular(50)),
      tabs: const [
        Tab(
          text: "Feed",
          icon: Icon(Icons.feed),
        ),
        Tab(
          text: "My",
          icon: Icon(Icons.event),
        ),
        Tab(
          text: "Account",
          icon: Icon(Icons.person),
        )
      ],
    );
  }
}
