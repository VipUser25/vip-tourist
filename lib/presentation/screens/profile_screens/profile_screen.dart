import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:octo_image/octo_image.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/user.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/localization_provider.dart';
import 'package:vip_tourist/logic/providers/payment_cards_provider.dart';
import 'package:vip_tourist/presentation/screens/about_screen.dart';
import 'package:vip_tourist/presentation/screens/booking_screens/qr_code_scanner_screen.dart';

import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';
import 'package:vip_tourist/presentation/screens/profile_screens/upload_document_screen.dart';
import 'package:vip_tourist/presentation/screens/terms_user_screen.dart';

import 'package:vip_tourist/presentation/screens/auth_screens/login_option_screen.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offers_list_screen.dart';

import 'package:vip_tourist/presentation/screens/profile_screens/detailed_profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:system_settings/system_settings.dart';
import 'package:vip_tourist/presentation/screens/your_balance_screen.dart';
import 'package:in_app_review/in_app_review.dart';

import '../../../logic/utility/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String flag;
  @override
  void initState() {
    // TODO: implement initState
    String s = context.read<LocalizationProvider>().currentLocale.languageCode;
    if (s == "ru") {
      flag = "russian";
    } else if (s == "de") {
      flag = "german";
    } else if (s == "th") {
      flag = "thai";
    } else if (s == "tr") {
      flag = "turkish";
    } else if (s == "fr") {
      flag = "french";
    } else if (s == "ar") {
      flag = "arab";
    } else if (s == "es") {
      flag = "spanish";
    } else if (s == "it") {
      flag = "italian";
    } else if (s == "en") {
      flag = "us";
    } else {
      flag = "us";
    }

    print("COUNTRY FLAG CHECING");
    print(flag);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(
    //     context: context, barrierDimisable: false);
    final authData = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        toolbarHeight: 10,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async => authData.updateUser(),
        color: PRIMARY,
        child: profileBuilder(authData
            //dialog
            ),
      ),
    );
  }

  Widget profileBuilder(AuthProvider authProvider
      //, SimpleFontelicoProgressDialog dialog
      ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder<UserModel>(
            future: authProvider.getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 100,
                  );
                default:
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.getUid.isEmpty ||
                      snapshot.data!.getUid == '') {
                    return logInOrSignUp();
                  } else {
                    return newUserTile(
                        authProvider: authProvider, cont: context);
                  }
              }
            },
          ),
          scanQrCodeBlock(authProvider: authProvider),
          !authProvider.user.isTourist
              ? staticTile(S.of(context).account)
              : Container(),
          !authProvider.user.isTourist
              ? staticTile2(S.of(context).account)
              : Container(),
          !authProvider.user.isTourist
              ? dynamicActionButton(S.of(context).accountBalance,
                  authProvider.user.balance + "\$", () {
                  if (authProvider.user.haveDocuments &&
                      authProvider.user.isVerified! &&
                      !authProvider.user.isTourist) {
                    context
                        .read<PaymentCardsProvider>()
                        .setBalance(authProvider.user.balance);
                    pushNewScreen(context,
                        screen: YourBalanceScreen(), withNavBar: false);
                  } else {
                    EasyLoading.showError(
                      S.of(context).youHaveToVerify,
                      duration: Duration(seconds: 3),
                    );
                  }
                })
              : Container(),
          !authProvider.user.isTourist
              ? Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15),
                  child: Divider(
                    color: LIGHT_GRAY,
                    thickness: 0.5,
                  ),
                )
              : Container(),

          myToursTile(authProvider),

          //////////////////
          staticTile(S.of(context).settings),
          staticTile2(S.of(context).settings),
          becomeGuideButton(authData: authProvider),
          dynamicActionButton(
              S.of(context).notifSettings, '', () => SystemSettings.app()),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
          SizedBox(
            height: 3,
          ),
          languageSelect(authProvider
              //, dialog
              ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
          currencySelect(authProvider),
          SizedBox(
            height: 6,
          ),
          staticTile(S.of(context).support),
          staticTile2(S.of(context).support),
          dynamicActionButton(
            S.of(context).aboutApp,
            '',
            () => pushNewScreen(context,
                screen: AboutScreen(), withNavBar: false),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
          dynamicActionButton(S.of(context).helpCenter, '', whatsAppOpen),
          SizedBox(
            height: 6,
          ),
          staticTile(S.of(context).feedback),
          staticTile2(S.of(context).feedback),
          dynamicActionButton(
            S.of(context).rateApp,
            '',
            rateApp,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
          dynamicActionButton(S.of(context).leaveFeedback, '', leaveFeedback),
          SizedBox(
            height: 6,
          ),
          staticTile(S.of(context).legal),
          staticTile2(S.of(context).legal),
          dynamicActionButton(
              S.of(context).termsOfUse,
              '',
              () => pushNewScreen(context,
                  screen: TermsUseScreen(), withNavBar: false)),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
          dynamicActionButton(
            S.of(context).privacy,
            '',
            () => pushNewScreen(context,
                screen: PolicyPrivacyScreen(), withNavBar: false),
          ),
          SizedBox(
            height: 6,
          ),
          FutureBuilder<UserModel>(
            future: authProvider.getUser(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                    height: 100,
                  );
                default:
                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.getUid.isEmpty ||
                      snapshot.data!.getUid == '') {
                    return Container();
                  } else {
                    return logOut(context);
                  }
              }
            },
          ),
          SizedBox(
            height: 6,
          ),
          staticTile(""),
          Container(
            color: Colors.white,
            child: Text(
              'Version 1.0.5',
              style: TextStyle(
                  fontSize: 16, color: GRAY, fontWeight: FontWeight.bold),
            ),
            padding: EdgeInsets.only(top: 20, bottom: 20),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  Widget staticTile(String text) {
    return Container(
      width: double.maxFinite,
      height: 7,
      color: LIGHT_GRAY,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
    );
  }

  Widget userTile(
      {required AuthProvider authProvider,
      required UserModel userModel,
      required BuildContext ctx}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      leading: (authProvider.user.isPhotoEmpty ||
              authProvider.user.getPhoto == "" ||
              authProvider.user.getPhoto == "null")
          ? Padding(
              padding: const EdgeInsets.only(),
              child: CircleAvatar(
                maxRadius: 40,
                child: Text(
                  authProvider.user.getEmail.toString()[0].toUpperCase(),
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
                ),
              ),
            )
          : GestureDetector(
              onTap: () => showAFullPhoto(ctx, authProvider.user.getPhoto!),
              child: Padding(
                padding: const EdgeInsets.only(),
                child: CircleAvatar(
                  maxRadius: 40,
                  backgroundImage: NetworkImage(authProvider.user.getPhoto!),
                ),
              ),
            ),
      title: Padding(
        padding: EdgeInsets.only(
          bottom: 7,
        ),
        child: GestureDetector(
          onTap: () {
            pushNewScreen(context,
                screen: ProfilePage(
                  isVerified: authProvider.user.getIsVerified!,
                ),
                withNavBar: false);
          },
          child: Text(
            (authProvider.user.isNameEmpty == true ||
                    authProvider.user.getName == "null" ||
                    authProvider.user.isNameEmpty)
                ? S.of(context).unnamed
                : authProvider.user.getName.toString(),
            textAlign: TextAlign.center,
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[850]),
          ),
        ),
      ),
      subtitle: GestureDetector(
        child: customSubtitle(authProvider: authProvider),
        onTap: () {
          pushNewScreen(context,
              screen: ProfilePage(
                isVerified: authProvider.user.getIsVerified!,
              ),
              withNavBar: false);
        },
      ),
      trailing: IconButton(
        onPressed: () {
          pushNewScreen(context,
              screen: ProfilePage(
                isVerified: authProvider.user.getIsVerified!,
              ),
              withNavBar: false);
        },
        icon: Icon(Icons.arrow_forward_ios),
      ),
    );
  }

  Widget newUserTile(
      {required AuthProvider authProvider, required BuildContext cont}) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 20),
      child: Row(
        children: [
          userPhotoBlock(authProvider: authProvider, cont: cont),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  pushNewScreen(context,
                      screen: ProfilePage(
                        isVerified: authProvider.user.getIsVerified!,
                      ),
                      withNavBar: false);
                },
                child: Text(
                  (authProvider.user.isNameEmpty == true ||
                          authProvider.user.getName == "null" ||
                          authProvider.user.isNameEmpty)
                      ? S.of(context).unnamed
                      : authProvider.user.getName.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              GestureDetector(
                child: customSubtitle(authProvider: authProvider),
                onTap: () {
                  pushNewScreen(context,
                      screen: ProfilePage(
                        isVerified: authProvider.user.getIsVerified!,
                      ),
                      withNavBar: false);
                },
              )
            ],
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              pushNewScreen(context,
                  screen: ProfilePage(
                    isVerified: authProvider.user.getIsVerified!,
                  ),
                  withNavBar: false);
            },
            icon: Icon(
              Icons.arrow_forward_ios_rounded,
              color: GREEN_GRAY,
              size: 20,
            ),
          )
        ],
      ),
    );
  }

  Widget userPhotoBlock(
      {required AuthProvider authProvider, required BuildContext cont}) {
    if (authProvider.user.isPhotoEmpty ||
        authProvider.user.getPhoto == "" ||
        authProvider.user.getPhoto == "null") {
      return CircleAvatar(
        maxRadius: 40,
        backgroundColor: PRIMARY,
        child: Text(
          authProvider.user.getEmail.toString()[0].toUpperCase(),
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => showAFullPhoto(cont, authProvider.user.getPhoto!),
        child: Padding(
          padding: const EdgeInsets.only(),
          child: CircleAvatar(
            maxRadius: 40,
            backgroundImage: NetworkImage(authProvider.user.getPhoto!),
          ),
        ),
      );
    }
  }

  Widget scanQrCodeBlock({required AuthProvider authProvider}) {
    if (authProvider.isAuth) {
      if (authProvider.user.isTourist) {
        return Container();
      } else {
        if (authProvider.user.isVerified!) {
          return GestureDetector(
            onTap: () async {
              pushNewScreen(context,
                  screen: QrCodeScannerScreen(), withNavBar: false);
            },
            child: Column(
              children: [
                staticTile(""),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Icon(
                        Icons.qr_code,
                        color: PRIMARY,
                        size: 50,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Column(
                        children: [
                          Text(
                            "QR",
                            style: TextStyle(
                                fontSize: 17,
                                color: GREEN_BLACK,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            S.of(context).scanTicket,
                            style: TextStyle(
                                fontSize: 17,
                                color: GREEN_GRAY,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      }
    } else {
      return Container();
    }
  }

  Widget myToursTile(AuthProvider authProvider) {
    if (authProvider.isAuth) {
      if (authProvider.user.isTourist) {
        return Container();
      } else {
        if (authProvider.user.isVerified!) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dynamicActionButton(
                S.of(context).myTours,
                "",
                () {
                  if (authProvider.user.haveDocuments &&
                      authProvider.user.isVerified! &&
                      !authProvider.user.isTourist) {
                    pushNewScreen(context,
                        screen: OffersListScreen(), withNavBar: true);
                  } else {
                    EasyLoading.showError(
                      S.of(context).youHaveToVerify,
                      duration: Duration(seconds: 3),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 6,
              )
            ],
          );
        } else {
          return Container();
        }
      }
    } else {
      return Container();
    }
  }

  Widget languageSelect(AuthProvider authData
      //, SimpleFontelicoProgressDialog dialog
      ) {
    return GestureDetector(
      onTap: () async {
        try {
          String res = await showConfirmationDialog(
            context: context,
            title: S.of(context).choseLang,
            barrierDismissible: false,
            shrinkWrap: true,
            actions: <AlertDialogAction>[
              AlertDialogAction(
                  key: 'en', label: "English", isDefaultAction: true),
              AlertDialogAction(
                key: 'ru',
                label: "Русский",
              ),
              AlertDialogAction(key: 'de', label: "Deutsch"),
              AlertDialogAction(key: 'th', label: "ไทย"),
              AlertDialogAction(key: 'tr', label: "Türk"),
              AlertDialogAction(key: 'fr', label: "Français"),
              AlertDialogAction(key: 'ar', label: "عربي"),
              AlertDialogAction(key: 'es', label: "Español"),
              AlertDialogAction(key: 'it', label: "italiano"),
            ],
          );
          String? id = authData.user.getIdd;

          //dialog.show(message: "Loading...");
          await context.read<LocalizationProvider>().setLanguageLocaly(res);
          setFlag(res);
          await context
              .read<LocalizationProvider>()
              .setLanguageStrapi(localeCode: res, id: id);
          //dialog.hide();
        } catch (e) {}
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).language,
              style: TextStyle(
                  fontSize: 17, color: GREEN_GRAY, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                OctoImage(
                  image: AssetImage("assets/$flag.png"),
                  height: 20,
                  width: 35,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget currencySelect(AuthProvider authData
      //, SimpleFontelicoProgressDialog dialog
      ) {
    return GestureDetector(
      onTap: () async {
        String? res = await showConfirmationDialog(
          context: context,
          title: S.of(context).chooseCurrency,
          actions: [
            AlertDialogAction<String>(
                key: "USD", label: "USD - American Dollar"),
            AlertDialogAction<String>(key: "EUR", label: "EUR - Euro"),
            AlertDialogAction<String>(key: "AED", label: "AED - UAE Dirham"),
            // AlertDialogAction<String>(
            //     key: "RUB", label: "RUB - Russian Rouble"),
            AlertDialogAction<String>(key: "THB", label: "THB - Thai Baht"),
            AlertDialogAction<String>(key: "TRY", label: "TRY - Turkish Lira"),
            AlertDialogAction<String>(
                key: "GBP", label: "GBP - Great Britain Pound")
          ],
        );
        if (res != null) {
          context.read<CurrencyProvider>().setCurrencyLocaly(res);
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).selectCurrency,
              style: TextStyle(
                  fontSize: 17, color: GREEN_GRAY, fontWeight: FontWeight.w500),
            ),
            Row(
              children: [
                Text(
                  context.watch<CurrencyProvider>().currency ?? "USD",
                  style: TextStyle(
                      fontSize: 17,
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget becomeGuideButton({required AuthProvider authData}) {
    if (authData.isAuth) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          becomeGuideActionButton(S.of(context).becomeGuide, "", () {
            pushNewScreen(
              context,
              screen: UploadDocumentScreen(),
              withNavBar: false,
            );
          }, authData),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15),
            child: Divider(
              color: LIGHT_GRAY,
              thickness: 0.5,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget dynamicActionButton(String title, String value, Function d) {
    return GestureDetector(
      onTap: () => d(),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 17, color: GREEN_GRAY, fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 17, color: GREEN_GRAY, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget becomeGuideActionButton(
      String title, String value, Function d, AuthProvider authProvider) {
    late bool statement;
    if (authProvider.user.isTourist) {
      statement = false;
    } else {
      if (!authProvider.user.haveDocuments && !authProvider.user.isVerified!) {
        statement = true;
      } else {
        statement = false;
      }
    }

    return GestureDetector(
      onTap: () => d(),
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
                  color: statement ? RED : GREEN_GRAY,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: TextStyle(
                  fontSize: 17, color: GREEN_GRAY, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget staticTile2(String title) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 17, color: GREEN_BLACK, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget accountCreditInfo({required AuthProvider authData}) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              S.of(context).accountBalance,
              style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: [
                Text(
                  authData.user.balance + "\$",
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget logOut(BuildContext context) {
    return Column(
      children: [
        staticTile(''),
        GestureDetector(
          onTap: () => context.read<AuthProvider>().signOut(),
          child: Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  S.of(context).logout,
                  style: TextStyle(
                      fontSize: 17,
                      color: Colors.red,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget logInOrSignUp() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      child: Center(
        child: ElevatedButton(
          onPressed: () => pushNewScreen(context,
              screen: LogInOptionScreen(), withNavBar: false),
          child: Text(
            S.of(context).logOrSignUp,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void update() {
    setState(() {});
  }

  void whatsAppOpen() async {
    final result = await showModalActionSheet<String>(
      context: context,
      actions: [SheetAction(label: "Email", key: "email")],
    );
    if (result == "email") {
      final Uri params = Uri(
        scheme: 'mailto',
        path: 'support@viptourist.club',
        query: '',
      );

      var url = params.toString();

      await launch(url);
    } else {}
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

  void rateApp() async {
    final InAppReview inAppReview = InAppReview.instance;

    if (await inAppReview.isAvailable()) {
      try {
        inAppReview.requestReview();
      } catch (e) {
        EasyLoading.showError(S.of(context).uHaveAlreadyRated);
      }
    } else {
      EasyLoading.showError(S.of(context).uHaveAlreadyRated);
    }
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

  Future<void> leaveFeedback() async {
    await launch(
        'mailto:support@viptourist.club?subject=&body=${S.of(context).wantToLeaveFeedback}');
  }

  Widget customSubtitle({required AuthProvider authProvider}) {
    if (authProvider.user.isTourist) {
      return Text(
        authProvider.user.getEmail.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.w500, color: Colors.grey[850], fontSize: 16),
      );
    } else {
      if (authProvider.user.haveDocuments &&
          authProvider.user.isVerified! &&
          !authProvider.user.isTourist) {
        return Text(
          S.of(context).verified,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: PRIMARY, fontSize: 16),
        );
      } else if (authProvider.user.haveDocuments &&
          !authProvider.user.isVerified! &&
          !authProvider.user.isTourist) {
        return Text(
          S.of(context).onConsider,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
              fontSize: 16),
        );
      } else if (!authProvider.user.haveDocuments &&
          !authProvider.user.isVerified!) {
        return Text(
          S.of(context).unverified,
          textAlign: TextAlign.center,
          style:
              TextStyle(fontWeight: FontWeight.w500, color: RED, fontSize: 16),
        );
      } else {
        return Text(
          authProvider.user.getEmail.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: GREEN_GRAY, fontSize: 16),
        );
      }
    }
  }
}
