import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/utility/methods.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';
import 'package:vip_tourist/presentation/screens/profile_screens/upload_document_screen.dart';

import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class ProfilePage extends StatefulWidget {
  final bool isVerified;

  const ProfilePage({Key? key, required this.isVerified}) : super(key: key);
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final FocusNode myFocusNode = FocusNode();
  late TextEditingController nameController;
  late TextEditingController numberController;
  late TextEditingController emailController;
  late bool whatsapp;
  late bool viber;
  late bool telegram;
  File? file;

  @override
  void initState() {
    nameController = new TextEditingController(
        text: context.read<AuthProvider>().user.getName);
    numberController = new TextEditingController(
        text: isAbsoluteNull(context.read<AuthProvider>().user.getPhoneNumber)
            ? ""
            : context.read<AuthProvider>().user.getPhoneNumber);
    emailController = new TextEditingController(
        text: context.read<AuthProvider>().user.email);
    whatsapp = context.read<AuthProvider>().user.hasWhatsapp;
    viber = context.read<AuthProvider>().user.hasViber;
    telegram = context.read<AuthProvider>().user.hasTelegram;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);

    final authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).profile,
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
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: 180.0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Stack(fit: StackFit.loose, children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FutureBuilder<String>(
                                future: authData.getUserPhotoURL(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return CircleAvatar(
                                        minRadius: 70,
                                        child: CircularProgressIndicator(),
                                      );
                                    default:
                                      if (snapshot.hasData &&
                                          snapshot.data != "" &&
                                          snapshot.data != "null") {
                                        return CircleAvatar(
                                          minRadius: 70,
                                          backgroundImage:
                                              NetworkImage(snapshot.data!),
                                        );
                                      } else {
                                        return CircleAvatar(
                                          minRadius: 70,
                                          backgroundImage: AssetImage(
                                              'assets/user_placeholder.png'),
                                        );
                                      }
                                  }
                                },
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, left: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () async {
                                      final result =
                                          await showModalActionSheet<String>(
                                        context: context,
                                        actions: [
                                          SheetAction(
                                              label: S.of(context).gallery,
                                              key: 'Gallery'),
                                          SheetAction(
                                              label: S.of(context).camera,
                                              key: 'Camera'),
                                          SheetAction(
                                              label: "Remove photo",
                                              key: "remove")
                                        ],
                                      );
                                      if (result == 'Gallery' ||
                                          result == 'Camera') {
                                        int response = await context
                                            .read<AuthProvider>()
                                            .updatePhoto(result!);
                                        if (response == 200) {
                                          await authData.updateUser();
                                          context
                                              .read<AuthProvider>()
                                              .setProfileUpdated();
                                        }
                                      } else if (result == "remove") {
                                        dialog.show(
                                            message: S.of(context).loading,
                                            type:
                                                SimpleFontelicoProgressDialogType
                                                    .hurricane);
                                        int response = await context
                                            .read<AuthProvider>()
                                            .deletePhotoRequest();
                                        if (response == 200) {
                                          await authData.updateUser();
                                          context
                                              .read<AuthProvider>()
                                              .setProfileUpdated();
                                        }
                                        dialog.hide();
                                      } else {}
                                    },
                                    child: new CircleAvatar(
                                      backgroundColor: PRIMARY,
                                      radius: 20.0,
                                      child: new Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      )
                    ],
                  ),
                ),
                customSubtitle(authProvider: authData),
                new Container(
                  color: Color(0xffFFFFFF),
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 25.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 13.0, right: 13.0, top: 25.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.mail,
                                  color: GRAY,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  S.of(context).email,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: GREEN_GRAY),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.0, right: 13.0, top: 10.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextFormField(
                                  controller: emailController,
                                  focusNode: new AlwaysDisabledFocusNode(),
                                  decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                      hintText: S.of(context).enterYourName,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(18, 24, 18, 16),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      )),
                                  enabled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 13.0, right: 13.0, top: 25.0),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.person,
                                  color: GRAY,
                                  size: 20,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  S.of(context).name,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: GREEN_GRAY),
                                ),
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.0, right: 13.0, top: 10.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                      hintStyle:
                                          TextStyle(color: Colors.grey[700]),
                                      hintText: S.of(context).enterYourName,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      ),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(18, 24, 18, 16),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: GRAY),
                                      )),
                                  enabled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.0, right: 13.0, top: 25.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                size: 20,
                                color: GRAY,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                S.of(context).newMobile,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: GREEN_GRAY),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 13.0, right: 13.0, top: 10.0, bottom: 10),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  controller: numberController,
                                  decoration: InputDecoration(
                                    hintText: "+ X XXX XXX XXXX",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: GRAY),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: GRAY),
                                    ),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(18, 24, 18, 16),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(color: GRAY),
                                    ),
                                  ),
                                  enabled: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 13.0, right: 13),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: whatsapp,
                                    onChanged: (value) {
                                      setState(() {
                                        whatsapp = value!;
                                      });
                                    },
                                    activeColor: PRIMARY,
                                  ),
                                  Text(
                                    "Whatsapp",
                                    style: TextStyle(
                                        color: GREEN_GRAY, fontSize: 16),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: viber,
                                    onChanged: (value) {
                                      setState(() {
                                        viber = value!;
                                      });
                                    },
                                    activeColor: PRIMARY,
                                  ),
                                  Text(
                                    "Viber",
                                    style: TextStyle(
                                        color: GREEN_GRAY, fontSize: 16),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Checkbox(
                                    value: telegram,
                                    onChanged: (value) {
                                      setState(() {
                                        telegram = value!;
                                      });
                                    },
                                    activeColor: PRIMARY,
                                  ),
                                  Text(
                                    "Telegram",
                                    style: TextStyle(
                                        color: GREEN_GRAY, fontSize: 16),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        getActionButtons(dialog),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget getActionButtons(SimpleFontelicoProgressDialog dialog) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    EasyLoading.show(status: S.of(context).loading);
                    int code = await context
                        .read<AuthProvider>()
                        .updateNamePhone(nameController.text,
                            numberController.text, whatsapp, viber, telegram);
                    EasyLoading.dismiss();
                    setState(() {
                      FocusScope.of(context).requestFocus(new FocusNode());
                    });
                    if (code == 200) {
                      showOkAlertDialog(
                          context: context,
                          message: S.of(context).successfull,
                          barrierDismissible: false);
                      context.read<AuthProvider>().updateUser().then((value) =>
                          context.read<AuthProvider>().setProfileUpdated());
                    } else {
                      showOkAlertDialog(
                          context: context,
                          message: S.of(context).somethingWentWrong,
                          barrierDismissible: false);
                    }
                  },
                  child: Text(S.of(context).save),
                ),
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.orangeAccent[400],
        radius: 18.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 18.0,
        ),
      ),
      onTap: () {},
    );
  }

  Widget dynamicActionButton(
    String title,
    String value,
  ) {
    return GestureDetector(
      onTap: () => pushNewScreen(context,
          screen: UploadDocumentScreen(), withNavBar: false),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text(
                  value,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 11,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[850],
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget goToPrivacyPolicyScreen() {
    return GestureDetector(
      onTap: () => pushNewScreen(context,
          screen: PolicyPrivacyScreen(), withNavBar: false),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).privacyPolicy,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text(
                  "",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 11,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[850],
                  size: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget customSubtitle({required AuthProvider authProvider}) {
    if (authProvider.user.isTourist) {
      return Container();
    } else {
      if (authProvider.user.haveDocuments &&
          authProvider.user.isVerified! &&
          !authProvider.user.isTourist) {
        return Text(
          S.of(context).verified,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: PRIMARY, fontSize: 16),
        );
      } else if (authProvider.user.haveDocuments &&
          !authProvider.user.isVerified! &&
          !authProvider.user.isTourist) {
        return Text(
          S.of(context).onConsider,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue[700],
              fontSize: 16),
        );
      } else if (!authProvider.user.haveDocuments &&
          !authProvider.user.isVerified!) {
        return Text(
          S.of(context).unverified,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.bold, color: RED, fontSize: 16),
        );
      } else {
        return Text(
          S.of(context).undefined,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: GREEN_GRAY, fontSize: 16),
        );
      }
    }
  }
}
