import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:octo_image/octo_image.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/user_profile_look_provider.dart';
import 'package:flutter_launch/flutter_launch.dart';
import '../../logic/utility/constants.dart';

class UserProfileLookScreen extends StatefulWidget {
  const UserProfileLookScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileLookScreenState createState() => _UserProfileLookScreenState();
}

class _UserProfileLookScreenState extends State<UserProfileLookScreen> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<UserProfileLookProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StatefulBuilder(
      builder: (BuildContext cnt, StateSetter setState) {
        return Container(
          color: Colors.transparent,
          height: height * 0.45,
          child: Padding(
            padding: const EdgeInsets.only(left: 23, right: 23),
            child: data.isLoaded
                ? profileLookBody(setState: setState, data: data)
                : Padding(
                    padding: EdgeInsets.only(top: height * 0.06),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(PRIMARY),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget profileLookBody(
      {required StateSetter setState, required UserProfileLookProvider data}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            maxRadius: 40,
            backgroundImage: NetworkImage(data.user.photo),
          ),
          const SizedBox(
            height: 25,
          ),
          listTileTemplate(
              icon: CupertinoIcons.person_fill,
              title: data.user.name,
              subtitle: S.of(context).name),
          const SizedBox(
            height: 13,
          ),
          emailTile(
            title: data.user.email,
          ),
          const SizedBox(
            height: 13,
          ),
          numberTile(title: data.user.phone, data: data),
          const SizedBox(
            height: 13,
          ),
          listTileTemplate(
              icon: Icons.verified_user_sharp,
              title: S.of(context).verified,
              subtitle: S.of(context).verStatus)
        ],
      ),
    );
  }

  Widget listTileTemplate(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      children: [
        Icon(
          icon,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: GREEN_BLACK),
            ),
            Text(subtitle, style: TextStyle(color: GRAY, fontSize: 12)),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget emailTile({
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          Icons.mail,
          color: GREEN_GRAY,
        ),
        const SizedBox(
          width: 13,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: GREEN_BLACK),
                ),
                const SizedBox(
                  width: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: title,
                      ),
                    );

                    EasyLoading.showSuccess(S.of(context).copiedToClipboard,
                        duration: const Duration(seconds: 2));
                  },
                  child: Icon(
                    Icons.copy,
                    color: PRIMARY,
                    size: 18,
                  ),
                )
              ],
            ),
            Text(S.of(context).email,
                style: TextStyle(color: GRAY, fontSize: 12)),
          ],
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  void whatsAppOpen({required String phone}) async {
    var whatsappUrl = Uri.parse("whatsapp://send?phone=+$phone");
    try {
      launchUrl(whatsappUrl);
    } catch (e) {
      EasyLoading.showError(S.of(context).cantLaunchWhatsapp);
    }
  }

  void telegramOpen({required String phone}) async {
    var whatsappUrl = Uri.parse("https://t.me/$phone");
    try {
      launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      EasyLoading.showError(S.of(context).cantLaunchTelegram);
    }
  }

  void viberOpen({required String phone}) async {
    var whatsappUrl = Uri.parse("viber://chat/?number=$phone");
    try {
      launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      EasyLoading.showError(S.of(context).cantLaunchViber);
    }
  }

  Widget numberTile(
      {required String title, required UserProfileLookProvider data}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.phone,
              color: GREEN_GRAY,
            ),
            const SizedBox(
              width: 13,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      isAbsoluteNull(title)
                          ? S.of(context).noPhoneNumber
                          : title,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: GREEN_BLACK),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    isAbsoluteNull(title)
                        ? SizedBox()
                        : GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: title,
                                ),
                              );

                              EasyLoading.showSuccess(
                                  S.of(context).copiedToClipboard,
                                  duration: const Duration(seconds: 2));
                            },
                            child: Icon(
                              Icons.copy,
                              color: PRIMARY,
                              size: 18,
                            ),
                          )
                  ],
                ),
                Text(S.of(context).phoneNumber,
                    style: TextStyle(color: GRAY, fontSize: 12)),
              ],
            )
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        Row(
          children: [
            (data.user.hasWhatsapp && !isAbsoluteNull(data.user.phone))
                ? GestureDetector(
                    onTap: () {
                      print("WHATSAPP TAPPED!");
                      whatsAppOpen(phone: data.user.phone);
                    },
                    child: Image.asset(
                      'assets/whatsapp.png',
                      width: 30,
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              width: 5,
            ),
            (data.user.hasViber && !isAbsoluteNull(data.user.phone))
                ? GestureDetector(
                    onTap: () {
                      print("VIBER TAPPED!");
                      viberOpen(phone: data.user.phone);
                    },
                    child: Image.asset('assets/viber.png', width: 30),
                  )
                : SizedBox(),
            const SizedBox(
              width: 5,
            ),
            (data.user.hasTelegram && !isAbsoluteNull(data.user.phone))
                ? GestureDetector(
                    onTap: () {
                      print("TELEGRAM TAPPED!");
                      telegramOpen(phone: data.user.phone);
                    },
                    child: Image.asset('assets/telegram.png', width: 30),
                  )
                : SizedBox()
          ],
        )
      ],
    );
  }

  bool isAbsoluteNull(String? value) {
    if (value == null) {
      return true;
    } else {
      if (value.isEmpty ||
          value.length == 0 ||
          value == "null" ||
          value == "" ||
          value == " ") {
        return true;
      } else {
        return false;
      }
    }
  }

// Column(
//                 children: <Widget>[
//                   StackContainer(data: data),
//                   SizedBox(
//                     height: 7,
//                   ),
//                   CardItem(
//                     icon: Icons.person,
//                     title: data.user.name,
//                     subtitle: S.of(context).name,
//                   ),
//                   CardItem(
//                     icon: Icons.email,
//                     title: data.user.email,
//                     subtitle: S.of(context).email,
//                   ),
//                   CardItem(
//                     icon: Icons.phone,
//                     title: getPhoneNumber(data.user.phone),
//                     subtitle: S.of(context).phoneNumber,
//                   ),
//                   specialCardItem(
//                       color: data.user.isVerified ? Colors.green : Colors.red,
//                       icon: data.user.isVerified
//                           ? Icons.check
//                           : Icons.do_not_disturb_on_outlined,
//                       title: data.user.isVerified
//                           ? S.of(context).verified
//                           : S.of(context).unverified,
//                       subtitle: S.of(context).verStatus)
//                 ],
//               )
  String getPhoneNumber(String value) {
    if (value == "null" || value == "" || value == " ") {
      return S.of(context).noPhoneNumber;
    } else {
      return value;
    }
  }

  Widget specialCardItem(
      {required Color color,
      required IconData icon,
      required String title,
      required String subtitle}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 21.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  size: 40.0,
                  color: color,
                ),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(fontSize: 18.0, color: color),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 150);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class StackContainer extends StatelessWidget {
  final UserProfileLookProvider data;
  const StackContainer({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300.0,
      child: Stack(
        children: <Widget>[
          Container(),
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 300.0,
              color: Colors.green[600],
            ),
          ),
          Align(
            alignment: Alignment(0, 1),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProfileAvatar(
                  data.user.photo,
                  borderWidth: 4.0,
                  radius: 60.0,
                  onTap: () => showAFullPhoto(context, data.user.photo),
                ),
                SizedBox(height: 4.0),
                Text(
                  data.user.name,
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  data.user.isTourist
                      ? S.of(context).tourist
                      : S.of(context).guide,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          TopBar(data: data),
        ],
      ),
    );
  }

  Future<void> showAFullPhoto(BuildContext cont, String image) async {
    showDialog<void>(
      barrierDismissible: true,
      context: cont,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.all(0),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OctoImage(
                image: NetworkImage(image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final UserProfileLookProvider data;
  const TopBar({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          IconButton(
            onPressed: () {
              data.disposeUser();
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CardItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const CardItem(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 21.0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.green,
                ),
              ),
              SizedBox(width: 24.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
