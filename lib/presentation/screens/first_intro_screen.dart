import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';
import 'package:vip_tourist/presentation/screens/second_intro_screen.dart';

class FirstIntroScreen extends StatefulWidget {
  final PendingDynamicLinkData? dynamicLink;
  const FirstIntroScreen({Key? key, required this.dynamicLink})
      : super(key: key);

  @override
  _FirstIntroScreenState createState() => _FirstIntroScreenState();
}

class _FirstIntroScreenState extends State<FirstIntroScreen> {
  String flag = "us";
  String currency = "USD";
  String locale = "en";
  late AlertDialogAction currentLang;
  late AlertDialogAction<String> currentCurency;
  int initialPage = 0;
  late TextEditingController languageController;
  late TextEditingController currencyController;

  @override
  void initState() {
    // TODO: implement initState
    languageController = TextEditingController(text: "English");
    currencyController = TextEditingController(text: "USD");
    currentCurency =
        AlertDialogAction(key: "USD", label: "USD - American Dollar");
    currentLang = AlertDialogAction(key: "en", label: "English");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);
    final height = MediaQuery.of(context).size.height;
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
        child: getPages(height, authData),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 30),
        child: ElevatedButton(
          onPressed: () {
            if (initialPage == 0) {
              setState(() {
                initialPage = 1;
              });
            } else {
              pushNewScreen(context,
                  screen: SecondIntroScreen(
                    locale: locale,
                    dynamicLink: widget.dynamicLink,
                  ));
            }
          },
          child: Text(S.of(context).next),
        ),
      ),
    );
  }

  Widget getPages(double height, AuthProvider authData) {
    if (initialPage == 0) {
      return getFirstPage(height, authData);
    } else {
      return getSecondPage(height, authData);
    }
  }

  Widget getFirstPage(double height, AuthProvider authData) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/newbg.jpg'), fit: BoxFit.cover),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "VIP TOURIST",
              style: GoogleFonts.cinzel(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: Text(
                S.of(context).tagOne,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(
              height: unitHeightValue * 10,
            ),
            languageBlock(authData),
            currencyBlock(authData)
          ],
        ),
      )
    ]);
  }

  Widget getSecondPage(double height, AuthProvider authData) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.01;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          initialPage = 0;
        });
        return Future.value(false);
      },
      child: Stack(alignment: Alignment.center, children: [
        Container(
          height: height,
          decoration: BoxDecoration(color: Colors.white),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).introTagOne,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: GREEN_BLACK),
              ),
              SizedBox(
                height: 20,
              ),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: S.of(context).introNew1 + "\n" + "\n",
                      style: TextStyle(fontSize: 18, color: GREEN_BLACK),
                    ),
                    TextSpan(
                      text: S.of(context).introNew2 + "\n" + "\n",
                      style: TextStyle(fontSize: 18, color: GREEN_BLACK),
                    ),
                    TextSpan(
                      text: S.of(context).introNew4 + "\n" + "\n",
                      style: TextStyle(fontSize: 18, color: GREEN_BLACK),
                    ),
                    TextSpan(
                      text: S.of(context).weWorkForU + "\n" + "\n",
                      style: TextStyle(fontSize: 18, color: GREEN_BLACK),
                    ),
                    TextSpan(
                      text: S.of(context).introNew3,
                      style: TextStyle(fontSize: 18, color: GREEN_BLACK),
                    ),
                    TextSpan(
                      text: " " + S.of(context).privacyPolicy.toLowerCase(),
                      style: TextStyle(
                          fontSize: 18,
                          color: GREEN_BLACK,
                          fontWeight: FontWeight.bold),
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
        )
      ]),
    );
  }

  void setFlag(String value) {
    if (value == "ru") {
      setState(() {
        flag = "russian";
      });
    } else if (value == "de") {
      setState(() {
        flag = "german";
      });
    } else if (value == "th") {
      setState(() {
        flag = "thai";
      });
    } else if (value == "tr") {
      setState(() {
        flag = "turkish";
      });
    } else if (value == "fr") {
      setState(() {
        flag = "french";
      });
    } else if (value == "ar") {
      setState(() {
        flag = "arab";
      });
    } else if (value == "es") {
      setState(() {
        flag = "spanish";
      });
    } else if (value == "it") {
      setState(() {
        flag = "italian";
      });
    } else if (value == "en") {
      setState(() {
        flag = "us";
      });
    } else {
      setState(() {
        flag = "us";
      });
    }
  }

  Widget languageBlock(AuthProvider authData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              CupertinoIcons.globe,
              color: GRAY,
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              S.of(context).selectLanguage,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          enableInteractiveSelection: false, // will disable paste operation
          focusNode: new AlwaysDisabledFocusNode(), maxLines: 1,
          controller: languageController,
          onTap: () async {
            String? res = await showConfirmationDialog(
                context: context,
                title: S.of(context).choseLang,
                shrinkWrap: true,
                initialSelectedActionKey: currentLang.key,
                actions: <AlertDialogAction>[
                  AlertDialogAction(
                      key: 'en', label: "English", isDefaultAction: true),
                  AlertDialogAction(key: 'ru', label: "Русский"),
                  AlertDialogAction(key: 'de', label: "Deutsch"),
                  AlertDialogAction(key: 'th', label: "ไทย"),
                  AlertDialogAction(key: 'tr', label: "Türk"),
                  AlertDialogAction(key: 'fr', label: "Français"),
                  AlertDialogAction(key: 'ar', label: "عربي"),
                  AlertDialogAction(key: 'es', label: "Español"),
                  AlertDialogAction(key: 'it', label: "italiano"),
                ]).catchError((error) {});
            String? id = authData.user.getIdd;
            if (res != null) {
              //dialog.show(message: "Loading...");

              setState(() {
                locale = res;
                languageController.text = getFullLanguageName(res);
                currentLang = AlertDialogAction(
                    key: res, label: getFullLanguageName(res));
              });
              setFlag(res);
              await context.read<LocalizationProvider>().setLanguageLocaly(res);
              await context
                  .read<LocalizationProvider>()
                  .setLanguageStrapi(localeCode: res, id: id);
              //dialog.hide();
            } else {}
          },
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () async {
                String? res = await showConfirmationDialog(
                    context: context,
                    title: S.of(context).choseLang,
                    shrinkWrap: true,
                    initialSelectedActionKey: currentLang.key,
                    actions: <AlertDialogAction>[
                      AlertDialogAction(
                          key: 'en', label: "English", isDefaultAction: true),
                      AlertDialogAction(key: 'ru', label: "Русский"),
                      AlertDialogAction(key: 'de', label: "Deutsch"),
                      AlertDialogAction(key: 'th', label: "ไทย"),
                      AlertDialogAction(key: 'tr', label: "Türk"),
                      AlertDialogAction(key: 'fr', label: "Français"),
                      AlertDialogAction(key: 'ar', label: "عربي"),
                      AlertDialogAction(key: 'es', label: "Español"),
                      AlertDialogAction(key: 'it', label: "italiano"),
                    ]).catchError((error) {});
                String? id = authData.user.getIdd;
                if (res != null) {
                  //dialog.show(message: "Loading...");

                  setState(() {
                    locale = res;
                    languageController.text = getFullLanguageName(res);
                    currentLang = AlertDialogAction(
                        key: res, label: getFullLanguageName(res));
                  });
                  setFlag(res);
                  await context
                      .read<LocalizationProvider>()
                      .setLanguageLocaly(res);
                  await context
                      .read<LocalizationProvider>()
                      .setLanguageStrapi(localeCode: res, id: id);
                  //dialog.hide();
                } else {}
              },
              child: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: GREEN_GRAY,
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GRAY,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GRAY,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  Widget currencyBlock(AuthProvider authData) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              color: GRAY,
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              S.of(context).selectCurrency,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            )
          ],
        ),
        const SizedBox(
          height: 14,
        ),
        TextFormField(
          enableInteractiveSelection: false, // will disable paste operation
          focusNode: new AlwaysDisabledFocusNode(), maxLines: 1,
          controller: currencyController,
          onTap: () async {
            String? res = await showConfirmationDialog(
              context: context,
              title: S.of(context).chooseCurrency,
              initialSelectedActionKey: currentCurency.key,
              actions: [
                AlertDialogAction<String>(
                    key: "USD", label: "USD - American Dollar"),
                AlertDialogAction<String>(key: "EUR", label: "EUR - Euro"),
                AlertDialogAction<String>(
                    key: "AED", label: "AED - UAE Dirham"),
                // AlertDialogAction<String>(
                //     key: "RUB", label: "RUB - Russian Rouble"),
                AlertDialogAction<String>(key: "THB", label: "THB - Thai Baht"),
                AlertDialogAction<String>(
                    key: "TRY", label: "TRY - Turkish Lira"),
                AlertDialogAction<String>(
                    key: "GBP", label: "GBP - Great Britain Pound"),
              ],
            );
            if (res != null) {
              setState(() {
                currency = res;
                currencyController.text = res;
                currentCurency = AlertDialogAction(key: res, label: "");
              });
              context.read<CurrencyProvider>().setCurrencyLocaly(res);
            }
          },
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: () async {
                  String? res = await showConfirmationDialog(
                    context: context,
                    title: S.of(context).chooseCurrency,
                    initialSelectedActionKey: currentCurency.key,
                    actions: [
                      AlertDialogAction<String>(
                          key: "USD", label: "USD - American Dollar"),
                      AlertDialogAction<String>(
                          key: "EUR", label: "EUR - Euro"),
                      AlertDialogAction<String>(
                          key: "AED", label: "AED - UAE Dirham"),
                      // AlertDialogAction<String>(
                      //     key: "RUB", label: "RUB - Russian Rouble"),
                      AlertDialogAction<String>(
                          key: "THB", label: "THB - Thai Baht"),
                      AlertDialogAction<String>(
                          key: "TRY", label: "TRY - Turkish Lira"),
                      AlertDialogAction<String>(
                          key: "GBP", label: "GBP - Great Britain Pound"),
                    ],
                  );
                  if (res != null) {
                    setState(() {
                      currency = res;
                      currencyController.text = res;
                      currentCurency = AlertDialogAction(key: res, label: "");
                    });
                    context.read<CurrencyProvider>().setCurrencyLocaly(res);
                  }
                },
                child: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: GREEN_GRAY,
                )),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GRAY,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: GRAY,
                width: 1,
                style: BorderStyle.solid,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }

  String getFullLanguageName(String res) {
    if (res == "en") {
      return "English";
    } else if (res == "ru") {
      return "Русский";
    } else if (res == "de") {
      return "Deutsch";
    } else if (res == "th") {
      return "ไทย";
    } else if (res == "tr") {
      return "Türk";
    } else if (res == "fr") {
      return "Français";
    } else if (res == "ar") {
      return "عربي";
    } else if (res == "es") {
      return "Español";
    } else if (res == "it") {
      return "italiano";
    } else {
      return "English";
    }
  }
}
