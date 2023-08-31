import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/tour.dart';

import 'package:vip_tourist/logic/providers/auth_provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';

class BillingScreen extends StatefulWidget {
  final Tour tour;
  final int adults;
  final int children;
  final CurrencyProvider curData;
  const BillingScreen(
      {Key? key,
      required this.tour,
      required this.adults,
      required this.curData,
      required this.children})
      : super(key: key);

  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  @override
  void initState() {
    // TODO: implement initState
    nameController =
        TextEditingController(text: context.read<AuthProvider>().user.getName);
    emailController =
        TextEditingController(text: context.read<AuthProvider>().user.getEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SimpleFontelicoProgressDialog dialog = SimpleFontelicoProgressDialog(
        context: context, barrierDimisable: false);
    final data = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[600],
        title: Text(
          S.of(context).billing,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          children: [
            Text(
              S.of(context).orderDetails,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900]),
            ),
            SizedBox(
              height: 13,
            ),
            tourAndGuide(),
            SizedBox(
              height: 15,
            ),
            peopleNumberTile(),
            SizedBox(
              height: 15,
            ),
            dateAndTime(),
            SizedBox(
              height: 15,
            ),
            totalAmount(),
            SizedBox(
              height: 15,
            ),
            firstNameField(context),
            SizedBox(
              height: 10,
            ),
            emailField(context),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 6.5,
            ),
            privacyPolicy(context),
            SizedBox(
              height: 20,
            ),
            continueButton(data, widget.curData, dialog),
            SizedBox(
              height: 15,
            )
          ],
        ),
      )),
    );
  }

  Widget firstNameField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        autofocus: false,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        controller: nameController,
        decoration: InputDecoration(
          labelText: S.of(context).name,
          prefixIcon: Icon(Icons.account_circle),
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        keyboardType: TextInputType.name,
        obscureText: false,
      ),
    );
  }

  Widget emailField(BuildContext ctx) {
    return Theme(
      data: Theme.of(ctx).copyWith(
        primaryColor: Colors.black,
      ),
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        decoration: InputDecoration(
          labelText: S.of(context).email,
          prefixIcon: Icon(Icons.markunread_outlined),
          labelStyle:
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
          ),
        ),
        keyboardType: TextInputType.name,
        obscureText: false,
      ),
    );
  }

  Widget privacyPolicy(BuildContext ctx) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: S.of(context).billingTag + ". ",
            style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
                fontSize: 15),
          ),
          TextSpan(
              text: S.of(context).privacyPolicy,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  pushNewScreen(context,
                      screen: PolicyPrivacyScreen(), withNavBar: false);
                },
              style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 15,
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  double getTotalPrice() {
    try {
      if (widget.tour.childPrice != null || widget.tour.childPrice != 0) {
        return ((widget.adults * widget.tour.price) +
            (widget.children * widget.tour.childPrice!));
      } else {
        return (widget.adults * widget.tour.price);
      }
    } catch (e) {
      return (widget.adults * widget.tour.price);
    }
  }

////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget continueButton(AuthProvider data, CurrencyProvider curData,
      SimpleFontelicoProgressDialog dialog) {
    return MaterialButton(
      onPressed: () async {
        //showPaymentDoesntWork();
      },
      child: Text(
        S.of(context).next,
        style: TextStyle(
            color: Colors.white, fontSize: 19, fontWeight: FontWeight.w500),
      ),
      color: Colors.blue[600],
      minWidth: MediaQuery.of(context).size.width / 1.075,
      padding: EdgeInsets.only(top: 14, bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }

  Widget peopleNumberTile() {
    return ListTile(
      leading: Icon(
        Icons.people_alt,
        color: Colors.green[800],
        size: 30,
      ),
      title: Text(
        S.of(context).numberOfPpl,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        numberOfPeople(widget.adults, widget.children),
        style: TextStyle(color: Colors.grey[700], fontSize: 18),
      ),
    );
  }

  Widget dateAndTime() {
    return ListTile(
      leading: Icon(
        Icons.date_range,
        color: Colors.green[800],
        size: 30,
      ),
      title: Text(
        S.of(context).dateAndTime,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        widget.tour.date == null
            ? S.of(context).alwaysAvailable
            : DateFormat("dd MMMM, yyyy, HH:mm").format(widget.tour.date!),
        style: TextStyle(color: Colors.grey[700], fontSize: 18),
      ),
    );
  }

  Widget totalAmount() {
    return ListTile(
      leading: Icon(
        Icons.price_change_outlined,
        color: Colors.blue[600],
        size: 30,
      ),
      title: Text(
        getPrice(widget.curData, getTotalPrice()),
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget tourAndGuide() {
    return ListTile(
      leading: Icon(
        Icons.tour,
        color: Colors.green[800],
        size: 30,
      ),
      title: Text(
        widget.tour.name,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        S.of(context).guide + ": " + widget.tour.userName,
        style: TextStyle(color: Colors.grey[700], fontSize: 18),
      ),
    );
  }

  String numberOfPeople(int adults, int children) {
    if (adults == 0 && children == 0) {
      return S.of(context).noPeople;
    } else if (adults == 0 && children == 1) {
      return "x1" + " " + S.of(context).child;
    } else if (adults == 1 && children == 0) {
      return "x1" + " " + S.of(context).adult;
    } else if (adults == 1 && children == 1) {
      return "x1" +
          " " +
          S.of(context).adult +
          ", x1" +
          " " +
          S.of(context).child;
    } else {
      return "x$adults" +
          " " +
          S.of(context).adult +
          ", x$children" +
          " " +
          S.of(context).child;
    }
  }

  String getPrice(CurrencyProvider data, double price) {
    if (data.currency == "USD" || data.currency == null) {
      return "\$" + price.toStringAsFixed(2) + " " + S.of(context).overall;
    } else if (data.currency == "EUR") {
      return "€" +
          (price * data.euro!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    } else if (data.currency == "AED") {
      return ".د.إ" +
          (price * data.dirham!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    } else if (data.currency == "RUB") {
      return "₽" +
          (price * data.rouble!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    } else if (data.currency == "THB") {
      return "฿" +
          (price * data.baht!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    } else if (data.currency == "TRY") {
      return "₤" +
          (price * data.lira!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    } else if (data.currency == "GBP") {
      return "£" +
          (price * data.gbp!).toStringAsFixed(2) +
          " " +
          S.of(context).overall;
    }
    return "\$" + price.toStringAsFixed(2);
  }
}
