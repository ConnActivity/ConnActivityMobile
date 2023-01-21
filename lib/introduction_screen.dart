import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account_page.dart';
import 'feed_page.dart';
import 'my_page.dart';
import 'nav_bar.dart';

class IntroductionScreens extends StatefulWidget {
  const IntroductionScreens({Key? key}) : super(key: key);

  @override
  State<IntroductionScreens> createState() => _IntroductionScreensState();
}

class _IntroductionScreensState extends State<IntroductionScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: IntroductionScreen(
          globalBackgroundColor: Colors.orange,
          pages: [
            PageViewModel(
              titleWidget: const Text(
                "What is ConnActivity?",
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'ConnActivity is a simple app where you can connect with your friends or other people and share your activities with them.',
                    style: TextStyle(
                        color: Colors.orange,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: const Text(
                "What you can do with ConnActivity?",
                style: TextStyle(
                    color: Color(0xff52D1DC),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'You can share your activities with others.\n\nYou can see the activities of all people.\n\nYou can join these activities to connect with them.\n\nYou can create your own activities.',
                    style: TextStyle(
                        color: Color(0xffB497D6),
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              titleWidget: const Text(
                "Your first steps",
                style: TextStyle(
                    color: Color(0xffDCF763),
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: const [
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'Create an account.\n\nCreate your first activity.\n\nJoin other activities.\n\nConnect with others\n\nEnjoy! 🎉',
                    style: TextStyle(
                        color: Color(0xff52D1DC),
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              //getPageDecoration, a method to customise the page style
              decoration: getPageDecoration(),
            ),
          ],
          onDone: () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isInit', true);
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DefaultTabController(
                            initialIndex: 2,
                            length: 3,
                            child: Scaffold(
                              appBar: AppBar(
                                backgroundColor: const Color(0xff02020A),
                                foregroundColor: const Color(0xff02020A),
                                title: Center(
                                  child: Text("ConnActivity",
                                      style: GoogleFonts.lobster(
                                          color: const Color(0xffFE7F2D),
                                          fontSize: 30)),
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
                          )));
            });
            print("done");
          },
          //ClampingScrollPhysics prevent the scroll offset from exceeding the bounds of the content.
          scrollPhysics: const ClampingScrollPhysics(),
          showDoneButton: true,
          showNextButton: true,
          showSkipButton: true,
          isBottomSafeArea: true,
          skip: const Text("Skip",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20)),
          next: const Icon(
            Icons.forward,
            color: Colors.black,
            size: 30,
          ),
          done: const Text("Done",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontSize: 20)),
          dotsDecorator: getDotsDecorator()),
    );
  }

  //method to customise the page style
  PageDecoration getPageDecoration() {
    return const PageDecoration(
      imagePadding: EdgeInsets.only(top: 120),
      pageColor: Colors.black,
      bodyPadding: EdgeInsets.only(top: 8, left: 20, right: 20),
      titlePadding: EdgeInsets.only(top: 50),
      bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 15),
    );
  }

  //method to customize the dots style
  DotsDecorator getDotsDecorator() {
    return const DotsDecorator(
      spacing: EdgeInsets.symmetric(horizontal: 2),
      activeColor: Colors.black,
      color: Colors.grey,
      activeSize: Size(15, 10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
    );
  }
}
