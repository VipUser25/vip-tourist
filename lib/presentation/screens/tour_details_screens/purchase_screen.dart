import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/purchase_order_provider.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/people_number_change_screen.dart';
import 'package:vip_tourist/presentation/widgets/seller_tour_item.dart';

import '../../../logic/utility/constants.dart';

class PurchaseOneScreen extends StatefulWidget {
  const PurchaseOneScreen({Key? key}) : super(key: key);

  @override
  _PurchaseOneScreenState createState() => _PurchaseOneScreenState();
}

class _PurchaseOneScreenState extends State<PurchaseOneScreen> {
  int adults = 1;
  int children = 0;
  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<DetailTourProvider>(context);
    final curData = Provider.of<CurrencyProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: GREEN_BLACK, fontWeight: FontWeight.w500, fontSize: 21),
        title: Text(
          S.of(context).purchase,
        ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              listTileTemplate(
                  icon: CupertinoIcons.globe,
                  title: data.tour.name,
                  subtitle: S.of(context).name),
              const SizedBox(
                height: 15,
              ),
              listTileTemplate(
                  icon: Icons.emoji_people,
                  title: data.tour.userName,
                  subtitle: S.of(context).guide),
              const SizedBox(
                height: 15,
              ),
              getAlwaysAvailableBlock(data),
              const SizedBox(
                height: 15,
              ),
              listTileTemplate2(
                  icon: Icons.people,
                  title: S.of(context).adults +
                      " x" +
                      context.watch<DetailTourProvider>().adults.toString() +
                      ", " +
                      S.of(context).children +
                      " x" +
                      context.watch<DetailTourProvider>().children.toString(),
                  subtitle: S.of(context).numberOfPpl,
                  doPressed: () => peopleNumberBottomSheet()),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    S.of(context).overall2,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: GREEN_BLACK),
                  ),
                  Text(
                    getPrice(curData, data.getTotalAmount()),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: GREEN_BLACK),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).overllWillBeConverted,
                style: TextStyle(fontSize: 12, color: GREEN_GRAY),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    makePayment(data);
                  },
                  child: Text(S.of(context).next)),
              const SizedBox(
                height: 15,
              ),
              privacyPolicy(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget privacyPolicy(BuildContext ctx) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: S.of(context).billingTagNew + ". ",
            style: TextStyle(color: GREEN_GRAY, fontSize: 12),
          ),
          TextSpan(
              text: S.of(context).privacyPolicy,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  pushNewScreen(context,
                      screen: PolicyPrivacyScreen(), withNavBar: false);
                },
              style: TextStyle(
                  color: GREEN_BLACK,
                  fontSize: 12,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget getAlwaysAvailableBlock(DetailTourProvider data) {
    if (data.tour.alwaysAvailable) {
      return listTileTemplate(
          icon: Icons.calendar_month,
          title: getWeekdays(data.tour.weekDays!),
          subtitle: S.of(context).alwaysAvailable);
    } else {
      return listTileTemplate(
          icon: Icons.calendar_month,
          title: DateFormat("dd MMMM yyyy").format(data.tour.date!) +
              ", " +
              data.tour.time!,
          subtitle: S.of(context).dateAndTime);
    }
  }

  Future<void> peopleNumberBottomSheet() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      barrierColor: Colors.black26,
      context: context,
      builder: (ctx) {
        return PeopleNumberChangeScreen();
      },
    );
  }

  String getWeekdays(String val) {
    String cc = "";
    List<String> days = val.split(",");
    days.forEach((element) {
      if (element == "mn") {
        cc = cc + S.of(context).monday + ", ";
      } else if (element == "tu") {
        cc = cc + S.of(context).tuesday + ", ";
      } else if (element == "wd") {
        cc = cc + S.of(context).wednesday + ", ";
      } else if (element == "th") {
        cc = cc + S.of(context).thursday + ", ";
      } else if (element == "fr") {
        cc = cc + S.of(context).friday + ", ";
      } else if (element == "st") {
        cc = cc + S.of(context).saturday + ", ";
      } else if (element == "sn") {
        cc = cc + S.of(context).sunday + ", ";
      }
    });
    return cc.substring(0, cc.length - 2);
  }

  Future<void> showFilter(BuildContext cont) async {
    showDialog<void>(
      barrierDismissible: true,
      context: cont,
      builder: (context) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                S.of(context).adult,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().decrementAdult();
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(context.read<DetailTourProvider>().adults.toString()),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().incrementAdult();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
              Text(
                S.of(context).child,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().decrementChild();
                      });
                    },
                    icon: Icon(Icons.remove),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(context.read<DetailTourProvider>().children.toString()),
                  SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        context.read<DetailTourProvider>().incrementChild();
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        Flexible(
          child: Column(
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
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget listTileTemplate2(
      {required IconData icon,
      required String title,
      required String subtitle,
      required void Function()? doPressed}) {
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
        ),
        Spacer(),
        IconButton(
          onPressed: doPressed,
          icon: Icon(
            Icons.arrow_forward_ios,
            color: GREEN_BLACK,
            size: 18,
          ),
          padding: EdgeInsets.all(0),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  Widget activityDetails1() {
    return Container(
      padding: EdgeInsets.only(top: 5, right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey, width: 0.5),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.people,
                        color: Colors.grey[850],
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Flexible(
                        child: Text(
                          S.of(context).participants,
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.7,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          S.of(context).adults +
                              " x" +
                              context
                                  .watch<DetailTourProvider>()
                                  .adults
                                  .toString() +
                              ", " +
                              S.of(context).children +
                              " x" +
                              context
                                  .watch<DetailTourProvider>()
                                  .children
                                  .toString(),
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      GestureDetector(
                        onTap: () => showFilter(context),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[850],
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  void showPaymentDoesntWork() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Icon(
                  CupertinoIcons.exclamationmark_triangle,
                  color: Colors.red[600],
                  size: 53,
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  S.of(context).lastfirst,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> makePayment(DetailTourProvider data) async {
    int adds = data.adults;
    int childs = data.children;

    double adPrice = data.tour.price;
    double? chilPrice = data.tour.childPrice;

    double ovrall = 0;

    for (var i = 0; i < adds; i++) {
      ovrall = ovrall + adPrice;
    }

    if (children > 0) {
      if (chilPrice != null) {
        for (var i = 0; i < childs; i++) {
          ovrall = ovrall + chilPrice;
        }
      }
    }

    try {
      paymentIntent =
          await createPaymentIntent(ovrall.toInt().toString(), 'USD');
      print("PAYMENT INTENT RESULT");
      print(paymentIntent);
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  // applePay: const PaymentSheetApplePay(merchantCountryCode: '+92',),
                  // googlePay: const PaymentSheetGooglePay(testEnv: true, currencyCode: "US", merchantCountryCode: "+92"),
                  style: ThemeMode.dark,
                  merchantDisplayName: 'VIP Tourist'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(data);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  double getComission(double val) {
    if (val < 10 && val >= 0) {
      return 2;
    } else if (val >= 10 && val < 31) {
      double perc = (val * 20) / 100;
      return perc;
    } else if (val >= 31 && val < 40) {
      return 7;
    } else if (val >= 40 && val < 131) {
      double perc = (val * 18) / 100;
      return perc;
    } else if (val >= 131 && val < 231) {
      return 30;
    } else if (val >= 231 && val < 501) {
      double perc = (val * 13) / 100;
      return perc;
    } else if (val >= 501) {
      double perc = (val * 10) / 100;
      return perc;
    }

    return 1;
  }

  displayPaymentSheet(DetailTourProvider data) async {
    String? myID = context.read<AuthProvider>().user.id;
    if (myID == null) {
      EasyLoading.show(status: S.of(context).signInOrRegister);
      return;
    }
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        EasyLoading.show();

        await context.read<PurchaseOrderProvider>().createOrder(
            adultPrice: data.tour.price.toString(),
            adults: data.adults,
            childPRice: data.tour.childPrice.toString(),
            children: data.children,
            dateTime: data.tour.date ?? DateTime.now(),
            tourName: data.tour.name,
            sellerID: data.tour.userID,
            ownerID: myID);
        EasyLoading.dismiss();
        Navigator.pop(context);
        Navigator.pop(context);
        context.read<AuthProvider>().controller.jumpToTab(2);
        // showDialog(
        //     context: context,
        //     builder: (_) => AlertDialog(
        //           content: Column(
        //             mainAxisSize: MainAxisSize.min,
        //             children: [
        //               Row(
        //                 children: const [
        //                   Icon(
        //                     Icons.check_circle,
        //                     color: Colors.green,
        //                   ),
        //                   const SizedBox(
        //                     width: 10,
        //                   ),
        //                   Text("Payment Successfull"),
        //                 ],
        //               ),
        //             ],
        //           ),
        //         ));
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        EasyLoading.showError(S.of(context).errorOccuredTryAgain);
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text(S.of(context).canceled),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': convertToCent(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer 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',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  String convertToCent(String amount) {
    int am = int.parse(amount);
    int qrr = am * 100;
    return qrr.toString();
  }
}
