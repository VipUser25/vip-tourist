import 'package:flutter/material.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/custom_return.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/login_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/auth_screens/email_login_screen.dart';
import 'package:provider/provider.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'dart:io' show Platform;

class LogInOptionScreen extends StatefulWidget {
  const LogInOptionScreen({Key? key}) : super(key: key);

  @override
  _LogInOptionScreenState createState() => _LogInOptionScreenState();
}

class _LogInOptionScreenState extends State<LogInOptionScreen> {
  late bool isTouristt;
  late RoundedLoadingButtonController controller;
  late int statusCode;
  @override
  void initState() {
    isTouristt = false;
    controller = RoundedLoadingButtonController();
    statusCode = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Provider.of<LocalizationProvider>(context).currentLocale;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.close),
            color: Colors.white,
          )
        ],
      ),
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bgimg.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10, bottom: 50),
          child: Container(
            //height: height / 2,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    S.of(context).adventureHasStarted,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    S.of(context).signInOptionTag,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 19,
                        color: Colors.white,
                        fontWeight: FontWeight.w100),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  EmailAuthButton(
                    text: S.of(context).signInWithEmail,
                    style: AuthButtonStyle(
                        borderRadius: 10,
                        iconSize: 20,
                        width: double.maxFinite,
                        padding: EdgeInsets.only(top: 14, bottom: 14),
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                        borderColor: PRIMARY,
                        borderWidth: 2.5,
                        buttonColor: PRIMARY),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const LogInScreen(),
                      ),
                    ),
                    darkMode: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GoogleAuthButton(
                    text: S.of(context).signInWithGoogle,
                    style: AuthButtonStyle(
                        splashColor: Colors.grey[350],
                        borderRadius: 10,
                        iconSize: 20,
                        width: double.maxFinite,
                        textStyle: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                        padding: EdgeInsets.only(
                          top: 14,
                          bottom: 14,
                        )),
                    onPressed: () async {
                      CustomReturn val = await context
                          .read<LoginProvider>()
                          .logInViaGoogle()
                          .catchError((error) {
                        showOkAlertDialog(
                            context: context,
                            message: S.of(context).errorOccured,
                            barrierDismissible: false);
                      });

                      if (val.error == 'user-not-found') {
                        await showAlertDialogK(context, val, locale);
                      } else if (val.error == 'EXISTS!') {
                        await context.read<AuthProvider>().updateUser();

                        Navigator.of(context).pop();
                        await context.read<AuthProvider>().refreshFcm();
                      } else if (val.error == 'error') {
                        showOkAlertDialog(
                            context: context,
                            message: S.of(context).errorOccured,
                            barrierDismissible: false);
                      }
                    },
                    darkMode: false,
                  ),
                  Platform.isIOS
                      ? const SizedBox(
                          height: 20,
                        )
                      : const SizedBox(),
                  Platform.isIOS
                      ? AppleAuthButton(
                          style: AuthButtonStyle(
                              splashColor: Colors.grey[350],
                              borderRadius: 10,
                              iconSize: 20,
                              width: double.maxFinite,
                              textStyle: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              padding: EdgeInsets.only(top: 14, bottom: 14)),
                          onPressed: () async {
                            CustomReturn val = await context
                                .read<LoginProvider>()
                                .logInViaApple()
                                .catchError(
                              (error) {
                                showOkAlertDialog(
                                    context: context,
                                    message: S.of(context).errorOccured,
                                    barrierDismissible: false);
                              },
                            );

                            if (val.error == 'user-not-found') {
                              await showAlertDialogK(context, val, locale);
                            } else if (val.error == 'EXISTS!') {
                              await context.read<AuthProvider>().updateUser();

                              Navigator.of(context).pop();
                              await context.read<AuthProvider>().refreshFcm();
                            } else if (val.error == 'error') {
                              showOkAlertDialog(
                                  context: context,
                                  message: S.of(context).errorOccured,
                                  barrierDismissible: false);
                            }
                          },
                        )
                      : Container(),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget oldOne(Locale locale) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/bgimg.png'),
              fit: BoxFit.fill,
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.5), BlendMode.darken),
            ),
          ),
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Container(
            height: 2.5,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.rectangle,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     Container(
                //       height: 230,
                //       width: 230,
                //       decoration: BoxDecoration(
                //         color: Colors.white.withOpacity(0.5),
                //         shape: BoxShape.circle,
                //         image: DecorationImage(
                //             image: AssetImage('assets/logo.png'),
                //             fit: BoxFit.fill),
                //       ),
                //     )
                //   ],
                // ),
                Text(
                  S.of(context).tagOne,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                  ),
                ),

                GoogleAuthButton(
                  text: S.of(context).signInWithGoogle,
                  style: AuthButtonStyle(
                      splashColor: Colors.grey[350],
                      borderRadius: 20,
                      iconSize: 20,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(top: 14, bottom: 14)),
                  onPressed: () async {
                    CustomReturn val = await context
                        .read<LoginProvider>()
                        .logInViaGoogle()
                        .catchError((error) {
                      showOkAlertDialog(
                          context: context,
                          message: S.of(context).errorOccured,
                          barrierDismissible: false);
                    });

                    if (val.error == 'user-not-found') {
                      await showAlertDialogK(context, val, locale);
                    } else if (val.error == 'EXISTS!') {
                      await context.read<AuthProvider>().updateUser();

                      Navigator.of(context).pop();
                      await context.read<AuthProvider>().refreshFcm();
                    } else if (val.error == 'error') {
                      showOkAlertDialog(
                          context: context,
                          message: S.of(context).errorOccured,
                          barrierDismissible: false);
                    }
                  },
                  darkMode: false,
                ),

                Platform.isIOS
                    ? AppleAuthButton(
                        style: AuthButtonStyle(
                            splashColor: Colors.grey[350],
                            borderRadius: 20,
                            iconSize: 20,
                            width: double.maxFinite,
                            padding: EdgeInsets.only(top: 14, bottom: 14)),
                        onPressed: () async {
                          CustomReturn val = await context
                              .read<LoginProvider>()
                              .logInViaApple()
                              .catchError(
                            (error) {
                              showOkAlertDialog(
                                  context: context,
                                  message: S.of(context).errorOccured,
                                  barrierDismissible: false);
                            },
                          );

                          if (val.error == 'user-not-found') {
                            await showAlertDialogK(context, val, locale);
                          } else if (val.error == 'EXISTS!') {
                            await context.read<AuthProvider>().updateUser();

                            Navigator.of(context).pop();
                            await context.read<AuthProvider>().refreshFcm();
                          } else if (val.error == 'error') {
                            showOkAlertDialog(
                                context: context,
                                message: S.of(context).errorOccured,
                                barrierDismissible: false);
                          }
                        },
                      )
                    : Container(),

                EmailAuthButton(
                  text: S.of(context).signInWithEmail,
                  style: AuthButtonStyle(
                      borderRadius: 20,
                      iconSize: 20,
                      width: double.maxFinite,
                      padding: EdgeInsets.only(top: 14, bottom: 14),
                      borderColor: Colors.blue[600],
                      borderWidth: 2.5,
                      buttonColor: Colors.blue[600]),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const LogInScreen(),
                    ),
                  ),
                  darkMode: false,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Future<void> showAlertDialogK(
      BuildContext cont, CustomReturn val, Locale locale) async {
    showDialog<void>(
      barrierDismissible: false,
      context: cont,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: Text(
            S.of(context).chooseAccountType,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue[600]),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTouristt = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.8,
                            color: isTouristt ? Colors.grey : Colors.blue),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('assets/guide.png'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(S.of(context).guide,
                              style: TextStyle(
                                  fontSize: 18,
                                  color: isTouristt ? Colors.grey : Colors.blue,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isTouristt = true;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1.8,
                            color: isTouristt ? Colors.blue : Colors.grey),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('assets/tourist.png'),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            S.of(context).tourist,
                            style: TextStyle(
                                fontSize: 18,
                                color: isTouristt ? Colors.blue : Colors.grey,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              RoundedLoadingButton(
                onPressed: () async {
                  print(isTouristt);
                  int resp = await context.read<AuthProvider>().registrateUser2(
                      uid: val.uid.toString(),
                      email: val.email.toString(),
                      name: val.name.toString(),
                      number: val.number.toString(),
                      receiveTips: false,
                      isTourist: isTouristt,
                      photo: val.photo.toString(),
                      localeCode: locale);
                  controller.start();
                  print(resp);
                  setState(() {
                    statusCode = resp;
                  });

                  if (resp == 200) {
                    await context.read<AuthProvider>().updateUser();
                    controller.stop();
                    print('WORKS FINE =)');
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    EasyLoading.showInfo(
                      S.of(context).toBecomeFull,
                      duration: Duration(seconds: 4),
                    );
                  } else {
                    print('ERROR APEARED!');
                  }
                },
                child: Text(
                  'Next',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
                color: Colors.blue[600],
                controller: controller,
              ),
            ],
          ),
        ),
      ),
    ).then((value) => null);
  }
}
