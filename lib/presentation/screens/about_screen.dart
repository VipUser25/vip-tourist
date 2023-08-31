import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';

import '../../logic/utility/constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          "VIP Tourist",
        ),
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pop(context);
          },
          elevation: 2,
          backgroundColor: Colors.white,
          mini: true,
          child: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: GREEN_BLACK,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 12, left: 18, right: 18),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).introTagOne,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: S.of(context).introNew1 + "\n" + "\n",
                      style: TextStyle(fontSize: 17.5, color: Colors.black),
                    ),
                    TextSpan(
                      text: S.of(context).introNew2 + "\n" + "\n",
                      style: TextStyle(fontSize: 17.5, color: Colors.black),
                    ),
                    TextSpan(
                      text: S.of(context).introNew4 + "\n" + "\n",
                      style: TextStyle(fontSize: 17.5, color: Colors.black),
                    ),
                    TextSpan(
                      text: S.of(context).weWorkForU + "\n" + "\n",
                      style: TextStyle(fontSize: 17.5, color: Colors.black),
                    ),
                    TextSpan(
                      text: S.of(context).introNew3,
                      style: TextStyle(fontSize: 17.5, color: Colors.black),
                    ),
                    TextSpan(
                      text: " " + S.of(context).privacyPolicy.toLowerCase(),
                      style: TextStyle(
                        fontSize: 17.5,
                        color: PRIMARY,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          print("PRIVACTY POLICY PRESSED!");
                          pushNewScreen(context, screen: PolicyPrivacyScreen());
                        },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
