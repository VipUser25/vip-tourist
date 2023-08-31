import 'dart:async';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/presentation/screens/booking_screens/booking_screen.dart';
import 'package:vip_tourist/presentation/screens/home_screen.dart';
import 'package:vip_tourist/presentation/screens/notification_screen.dart';
import 'package:vip_tourist/presentation/screens/profile_screens/profile_screen.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:vip_tourist/presentation/screens/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:new_version/new_version.dart';

import '../../logic/providers/detail_tour_provider.dart';
import '../../logic/utility/constants.dart';

class BottomNavigationBart extends StatefulWidget {
  final AuthProvider authData;
  final PendingDynamicLinkData? dynamicLink;
  const BottomNavigationBart(
      {Key? key, required this.authData, required this.dynamicLink})
      : super(key: key);

  @override
  _BottomNavigationBartState createState() => _BottomNavigationBartState();
}

class _BottomNavigationBartState extends State<BottomNavigationBart> {
  StreamSubscription? subscription;
  bool? _connected;

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      WishlistScreen(),
      BookingScreen(),
      NotificationScreen(),
      ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
          // textStyle: TextStyle(fontSize: 12),
          iconSize: 22,
          activeColorSecondary: PRIMARY,
          inactiveColorSecondary: GRAY,
          icon: Icon(Icons.home),
          title: (S.of(context).home),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: GRAY,
          contentPadding: 0),
      PersistentBottomNavBarItem(
        // textStyle: TextStyle(fontSize: 12),
        iconSize: 22, contentPadding: 0,
        activeColorSecondary: PRIMARY,
        inactiveColorSecondary: GRAY,
        icon: Icon(Icons.favorite),
        title: (S.of(context).wishlist),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: GRAY,
      ),
      PersistentBottomNavBarItem(
        // textStyle: TextStyle(fontSize: 12),
        iconSize: 22,
        activeColorSecondary: PRIMARY,
        inactiveColorSecondary: GRAY, contentPadding: 0,
        icon: Icon(Icons.book),
        title: (S.of(context).booking),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: GRAY,
      ),
      PersistentBottomNavBarItem(
        //textStyle: TextStyle(fontSize: 12),
        iconSize: 22,
        activeColorSecondary: PRIMARY,
        inactiveColorSecondary: GRAY, contentPadding: 0,
        icon: Icon(Icons.notifications),
        title: S.of(context).notif,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: GRAY,
      ),
      PersistentBottomNavBarItem(
        //textStyle: TextStyle(fontSize: 12),
        iconSize: 22,
        activeColorSecondary: PRIMARY,
        inactiveColorSecondary: GRAY,
        icon: Icon(CupertinoIcons.person_crop_circle),
        title: (S.of(context).profile),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: GRAY, contentPadding: 0,
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    //checkVersion();

    initDynamicLinks();
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) async {

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (notification != null && android != null) {
          String? red = message.data["link"];
          if (red != null) {
            if (red == "profile") {
              await widget.authData.updateUser();
            }
          }
          await Flushbar(
            padding: const EdgeInsets.all(7.0),
            messageText: ListTile(
              leading: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset(
                    "assets/qqq.png",
                    height: 45,
                    width: 45,
                  ),
                ),
              ),
              title: Text(notification.title!),
              subtitle: Text(notification.body!),
            ),
            flushbarStyle: FlushbarStyle.FLOATING,
            onTap: (flush) async {
              String? redirect = message.data["link"];
              if (redirect != null) {
                switch (redirect) {
                  case "home":
                    widget.authData.controller.jumpToTab(0);
                    Navigator.pop(context);
                    break;
                  case "wishlist":
                    widget.authData.controller.jumpToTab(1);
                    Navigator.pop(context);
                    break;
                  case "profile":
                    widget.authData.controller.jumpToTab(4);
                    Navigator.pop(context);
                    break;
                }
              }
            },
            margin: EdgeInsets.all(15),
            duration: Duration(seconds: 120),
            backgroundColor: Colors.white,
            flushbarPosition: FlushbarPosition.TOP,
            borderRadius: BorderRadius.circular(15),
            messageColor: Colors.black,
            titleColor: Colors.black,
          ).show(context);

          // flutterLocalNotificationsPlugin.show(
          //   notification.hashCode,
          //   notification.title,
          //   notification.body,
          //   NotificationDetails(
          //     android: AndroidNotificationDetails(
          //       channel.id,
          //       channel.name,
          //       channelDescription: channel.description,
          //       color: Colors.blue,
          //       playSound: true,
          //     ),
          //   ),
          // );
        }
      },
    );
    //Message for Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new messageopen app event was published');
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        String? redirect = message.data["link"];
        if (redirect != null) {
          switch (redirect) {
            case "home":
              widget.authData.controller.jumpToTab(0);
              break;
            case "wishlist":
              widget.authData.controller.jumpToTab(1);
              break;
            case "profile":
              await widget.authData.updateUser();
              widget.authData.controller.jumpToTab(4);
              break;
          }
        }
      }
    });
    SimpleConnectionChecker _simpleConnectionChecker = SimpleConnectionChecker()
      ..setLookUpAddress('pub.dev'); //Optional method to pass the lookup string
    subscription =
        _simpleConnectionChecker.onConnectionChange.listen((connected) {
      setState(() {
        _connected = connected;
      });
      if (connected) {
        print("INTERNET IS CONNECTED YEAAA");
      } else {
        print("NO INTERNET NOOOOOOO :(");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            backgroundColor: Colors.red[800],
            content: Text(S.of(context).noInternetCon),
            duration: Duration(seconds: 5),
          ),
        );
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.dynamicLink != null) {
        try {
          List<String> sepeatedLink = [];
          sepeatedLink.addAll(widget.dynamicLink!.link.path.split('/'));
          print("DYNAMIC LINKS WORKS FINE? ${widget.dynamicLink!.link}");
          pushNewScreen(context, screen: TourDetailScreen(), withNavBar: false);
          context.read<DetailTourProvider>().getTourDetails(sepeatedLink[1]);
        } catch (e) {
          EasyLoading.show(status: e.toString());
        }
      }
    });
  }

  // void checkVersion() {
  //   final newVersion = NewVersion(
  //       androidId: "com.alishber.vip_tourist",
  //       iOSId: "com.alishber.vipTourist123");
  //   newVersion.showAlertIfNecessary(context: context);
  // }
  void initDynamicLinks() async {
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      List<String> sepeatedLink = [];
      sepeatedLink.addAll(event.link.path.split('/'));
      print("DYNAMIC LINKS WORKS FINE? ${event.link}");
      pushNewScreen(context, screen: TourDetailScreen(), withNavBar: false);
      context.read<DetailTourProvider>().getTourDetails(sepeatedLink[1]);
    }).onError((error) {
      print("DYNAMIC LINKS FUCKED UP? ${error.toString()}");
      Navigator.pop(context);
      context.read<DetailTourProvider>().disposeTour();
      EasyLoading.showInfo(S.of(context).errorOccured);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(context.read<AuthProvider>().isAuth.toString());

    return PersistentTabView(
      context,
      stateManagement: true,
      backgroundColor: Colors.white,
      controller: context.read<AuthProvider>().controller,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      confineInSafeArea: true,
      resizeToAvoidBottomInset: true,
      decoration: NavBarDecoration(
          border: Border.all(width: 0.3, color: GRAY), colorBehindNavBar: GRAY),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      padding: NavBarPadding.all(2.5),
      itemAnimationProperties: ItemAnimationProperties(
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 100),
      ),
      navBarStyle: NavBarStyle.style3,
    );
  }
}
