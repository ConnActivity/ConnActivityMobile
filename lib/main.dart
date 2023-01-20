import 'package:connactivity/account_page.dart';
import 'package:connactivity/feed_page.dart';
import 'package:connactivity/introduction_screen.dart';
import 'package:connactivity/my_page.dart';
import 'package:connactivity/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

//https://coolors.co/dcf763-02020a-fe7f2d-b497d6-52d1dc

void main() {
  runApp(const MainConnActivity());
}

class MainConnActivity extends StatelessWidget {
  const MainConnActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: const Color(0xFF02020A),
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: const Color(0xFFFE7F2D)),
          textTheme:
              const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
      home: const ConnActivityHome(),
    );
  }
}

class ConnActivityHome extends StatefulWidget {
  const ConnActivityHome({Key? key}) : super(key: key);

  @override
  State<ConnActivityHome> createState() => _ConnActivityHomeState();
}

class _ConnActivityHomeState extends State<ConnActivityHome> {
  var _isInit = false;
  @override
  initState() {
    super.initState();
    helper();
  }

  helper() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isInit = prefs.getBool("isInit") ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isInit == true
        ? DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: const Color(0xff02020A),
                foregroundColor: const Color(0xff02020A),
                title: Center(
                  child: Text("ConnActivity",
                      style: GoogleFonts.lobster(
                          color: const Color(0xffFE7F2D), fontSize: 30)),
                ),
              ),
              backgroundColor: Colors.black,
              body: TabBarView(children: [
                LayoutBuilder(builder: (context, constraints) {
                  debugPrint(constraints.maxHeight.toString());
                  return FeedPage(
                    height: constraints.maxHeight,
                  );
                }),
                //const Center(child: Text("👋 You have not entered any events yet", style: TextStyle(color: Colors.white),)),
                const MyPAge(),
                const AccountPage(),
              ]),
              bottomNavigationBar: const ConnActivityNavBar(),
            ),
          )
        : const IntroductionScreens();
  }
}
