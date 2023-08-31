import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/auth_screens/login_option_screen.dart';
import 'package:vip_tourist/presentation/screens/bottom_navigation_bart.dart';
import 'package:dots_indicator/dots_indicator.dart';

class SecondIntroScreen extends StatefulWidget {
  final PendingDynamicLinkData? dynamicLink;
  final String locale;
  const SecondIntroScreen(
      {Key? key, required this.locale, required this.dynamicLink})
      : super(key: key);

  @override
  _SecondIntroScreenState createState() => _SecondIntroScreenState();
}

class _SecondIntroScreenState extends State<SecondIntroScreen> {
  int initialPage = 0;
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        //toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeInSine,
        switchOutCurve: Curves.easeInOutSine,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: Offset(1, 0),
              end: Offset(0, 0),
            ).animate(animation),
            child: child,
          );
        },
        child: getPages(height, authData, width),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DotsIndicator(
            dotsCount: 3,
            position: initialPage.toDouble(),
            decorator: DotsDecorator(
              activeColor: GREEN_GRAY,
              color: GRAY,
              activeSize: Size.square(10),
              spacing: EdgeInsets.all(4),
            ),
          ),
          SizedBox(
            height: height / 1.4,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, bottom: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: width / 3,
                    child: TextButton(
                      onPressed: leftButtonAction,
                      style: TextButton.styleFrom(primary: PRIMARY),
                      child: Text(
                        getLeftButtonText(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    width: width / 3,
                    child: ElevatedButton(
                      onPressed: rightButtonAction,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(
                            top: 19, bottom: 19, left: 10, right: 10),
                      ),
                      child: Text(getRightButtonText()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<CurrencyProvider>().noIntroAnymore();
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => BottomNavigationBart(
                    dynamicLink: widget.dynamicLink,
                    authData: authData,
                  ),
                ),
              );
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LogInOptionScreen()));
            },
            child: Text(
              S.of(context).signInOrRegister,
              style: TextStyle(
                  color: PRIMARY, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  void leftButtonAction() {
    if (initialPage == 0) {
      setState(() {
        initialPage = 2;
      });
    } else {
      var e = initialPage;
      setState(() {
        initialPage = e - 1;
      });
    }
  }

  void rightButtonAction() {
    if (initialPage == 2) {
      Navigator.of(context).pop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => BottomNavigationBart(
                  dynamicLink: widget.dynamicLink,
                  authData: context.read<AuthProvider>(),
                )),
      );
      context.read<CurrencyProvider>().noIntroAnymore();
    } else {
      var e = initialPage;
      setState(() {
        initialPage = e + 1;
      });
    }
  }

  String getLeftButtonText() {
    if (initialPage == 0) {
      return S.of(context).skip;
    } else {
      return S.of(context).back;
    }
  }

  String getRightButtonText() {
    if (initialPage == 2) {
      return S.of(context).complete;
    } else {
      return S.of(context).next;
    }
  }

  Widget getPages(double height, AuthProvider authData, double width) {
    if (initialPage == 0) {
      return firstPage(height, authData, width);
    } else if (initialPage == 1) {
      return secondPage(height, authData, width);
    } else if (initialPage == 2) {
      return thirdPage(height, authData, width);
    } else {
      return firstPage(height, authData, width);
    }
  }

  Widget firstPage(double height, AuthProvider authData, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height / 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: Image.asset(
            "assets/fram1.png",
            height: 200,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(
          height: 49,
        ),
        Text(
          S.of(context).tours,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: GREEN_BLACK),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Text(
            S.of(context).introTagThree,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: GREEN_GRAY),
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget secondPage(double height, AuthProvider authData, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height / 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: Image.asset(
            "assets/fram2.png",
            height: 200,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(
          height: 49,
        ),
        Text(
          S.of(context).tickets,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: GREEN_BLACK),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Text(
            S.of(context).introTagFour,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: GREEN_GRAY),
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }

  Widget thirdPage(double height, AuthProvider authData, double width) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: height / 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0, right: 50),
          child: Image.asset(
            "assets/fram3.png",
            height: 200,
            width: double.maxFinite,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(
          height: 49,
        ),
        Text(
          S.of(context).guide,
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: GREEN_BLACK),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30),
          child: Text(
            S.of(context).introTagFive,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: GREEN_GRAY),
          ),
        ),
      ],
      mainAxisSize: MainAxisSize.min,
    );
  }
  // Widget oldOne(){
  //   return Builder(
  //     builder: (BuildContext context) {
  //       return sec.IntroViewsFlutter(
  //         [
  //           sec.PageViewModel(
  //             pageColor: Colors.white,
  //             // iconImageAssetPath: 'assets/air-hostess.png',
  //             bubble: Image.asset('assets/dott.png'),
  //             body: Text(
  //               S.of(context).introTagThree + "\n" + "\n",
  //               style: TextStyle(color: Colors.black),
  //             ),
  //           ),
  //           sec.PageViewModel(
  //             pageColor: const Color(0xFF8BC34A),
  //             iconImageAssetPath: 'assets/dott.png',
  //             body: Text(
  //               S.of(context).introTagFour + "\n" + "\n",
  //             ),
  //             title: Padding(
  //               padding: const EdgeInsets.only(top: 15.0),
  //               child: Text(S.of(context).tickets),
  //             ),
  //             mainImage: Image.asset(
  //               'assets/twin.png',
  //               height: 285.0,
  //               width: 285.0,
  //               alignment: Alignment.center,
  //             ),
  //             titleTextStyle: GoogleFonts.nunito(
  //                 color: Color.fromARGB(255, 100, 88, 62),
  //                 fontWeight: FontWeight.w500),
  //             bodyTextStyle:
  //                 GoogleFonts.nunito(color: Colors.white, fontSize: 20),
  //           ),
  //           sec.PageViewModel(
  //             pageBackground: Container(
  //               decoration: const BoxDecoration(
  //                 gradient: LinearGradient(
  //                   stops: [0.0, 1.0],
  //                   begin: FractionalOffset.topCenter,
  //                   end: FractionalOffset.bottomCenter,
  //                   tileMode: TileMode.repeated,
  //                   colors: [
  //                     Colors.blue,
  //                     Colors.purple,
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             iconImageAssetPath: 'assets/dott.png',
  //             body: Text(
  //               S.of(context).introTagFive + "\n" + "\n",
  //             ),
  //             title: Padding(
  //               padding: const EdgeInsets.only(top: 15),
  //               child: Text(S.of(context).guide),
  //             ),
  //             mainImage: Image.asset(
  //               'assets/pyramid.png',
  //               height: 285.0,
  //               width: 285.0,
  //               alignment: Alignment.center,
  //             ),
  //             titleTextStyle: GoogleFonts.nunito(
  //                 color: Color(0xFFECA951), fontWeight: FontWeight.w500),
  //             bodyTextStyle:
  //                 GoogleFonts.nunito(color: Colors.black, fontSize: 20),
  //           ),
  //         ],
  //         nextText: Padding(
  //           padding: const EdgeInsets.only(right: 5.0),
  //           child: Text(
  //             S.of(context).next,
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         ),
  //         backText: Padding(
  //           padding: const EdgeInsets.only(left: 5.0),
  //           child: Text(
  //             S.of(context).back,
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         ),
  //         skipText: Padding(
  //           padding: const EdgeInsets.only(left: 5.0),
  //           child: Text(
  //             S.of(context).skip,
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         ),
  //         doneText: Padding(
  //           padding: const EdgeInsets.only(right: 5.0),
  //           child: Text(
  //             S.of(context).done,
  //             style: TextStyle(color: Colors.black, fontSize: 16),
  //           ),
  //         ),
  //         showNextButton: true,
  //         showBackButton: true,
  //         onTapDoneButton: () {
  //           Navigator.pushReplacement(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (_) => BottomNavigationBart(
  //                       authData: authData,
  //                     )),
  //           );
  //           context.read<CurrencyProvider>().noIntroAnymore();
  //         },
  //         pageButtonTextStyles: const TextStyle(
  //           color: Colors.white,
  //           fontSize: 18.0,
  //         ),
  //       );
  //     },
  //   );
  // }
}
