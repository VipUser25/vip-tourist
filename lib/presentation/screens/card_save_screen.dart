import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/payment_cards_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/policy_privacy_screen.dart';

class CardSaveScreen extends StatefulWidget {
  const CardSaveScreen({Key? key}) : super(key: key);

  @override
  _CardSaveScreenState createState() => _CardSaveScreenState();
}

class _CardSaveScreenState extends State<CardSaveScreen> {
  late TextEditingController cardNameController;
  late TextEditingController cardNumberController;
  //late TextEditingController ibanController;
  late RoundedLoadingButtonController controller;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? id;
  @override
  void initState() {
    // TODO: implement initState
    cardNameController = TextEditingController(
        text: context.read<PaymentCardsProvider>().cardName ?? "");
    cardNumberController = TextEditingController(
        text: context.read<PaymentCardsProvider>().cardNumber ?? "");
    // ibanController = TextEditingController(
    //     text: context.read<PaymentCardsProvider>().iban ?? "");
    controller = RoundedLoadingButtonController();
    id = context.read<PaymentCardsProvider>().cardID;
    super.initState();
  }

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
          S.of(context).account,
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
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  cardNameField(context),
                  SizedBox(
                    height: 25,
                  ),
                  cardNumberField(context),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            infoText(context),
            SizedBox(height: 20),
            saveButton(context)
          ],
        ),
      ),
    );
  }

  Widget cardNameField(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.account_circle_rounded,
              color: GRAY,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).cardName,
              style: TextStyle(
                  fontSize: 16, color: GREEN_GRAY, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          autofocus: false,
          validator: (value) {
            if (value!.isEmpty || value == "") {
              return S.of(context).required;
            }
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.w500),
          controller: cardNameController,
          decoration: InputDecoration(
            hintText: "JOHNNY DEPP",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
            contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
          ),
          keyboardType: TextInputType.name,
          obscureText: false,
        ),
      ],
    );
  }

  Widget cardNumberField(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.credit_card,
              color: GRAY,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              S.of(context).cardNumber,
              style: TextStyle(
                  fontSize: 16, color: GREEN_GRAY, fontWeight: FontWeight.bold),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          autofocus: false,
          validator: (value) {
            if (value!.isEmpty || value == "") {
              return S.of(context).required;
            }
            return null;
          },
          style: TextStyle(fontWeight: FontWeight.w500),
          controller: cardNumberController,
          decoration: InputDecoration(
            hintText: "XXXXXXXXXXXX4444",
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
            contentPadding: EdgeInsets.fromLTRB(18, 24, 18, 16),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: GRAY),
            ),
          ),
          keyboardType: TextInputType.name,
          obscureText: false,
        ),
      ],
    );
  }

  // Widget ibanField(BuildContext ctx) {
  //   return Theme(
  //     data: Theme.of(ctx).copyWith(
  //       primaryColor: Colors.black,
  //     ),
  //     child: TextFormField(
  //       autofocus: false,
  //       validator: (value) {
  //         if (value!.isEmpty || value == null || value == "") {
  //           return S.of(context).required;
  //         }
  //       },
  //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
  //       controller: ibanController,
  //       decoration: InputDecoration(
  //         labelText: S.of(context).ibanAccount,
  //         prefixIcon: Icon(Icons.account_balance_rounded),
  //         labelStyle:
  //             TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
  //         enabledBorder: UnderlineInputBorder(
  //           borderSide:
  //               BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
  //         ),
  //         focusedBorder: UnderlineInputBorder(
  //           borderSide:
  //               BorderSide(width: 1, color: Color.fromRGBO(124, 124, 124, 1)),
  //         ),
  //       ),
  //       keyboardType: TextInputType.name,
  //       obscureText: false,
  //     ),
  //   );
  // }

  Widget infoText(BuildContext ctx) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: S.of(context).bankTag,
            style: TextStyle(color: GREEN_GRAY, fontSize: 13),
          ),
          TextSpan(
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                pushNewScreen(context,
                    screen: PolicyPrivacyScreen(), withNavBar: false);
              },
            text: " " + S.of(context).privacyPolicy,
            style: TextStyle(
                color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget saveButton(BuildContext ctx) {
    String val;
    return RoundedLoadingButton(
      width: double.maxFinite,
      borderRadius: 10,
      color: PRIMARY,
      height: 60,
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          controller.start();
          bool res = await context.read<PaymentCardsProvider>().saveCard(
                cardID: context.read<PaymentCardsProvider>().cardID,
                cardName: cardNameController.text,
                cardNumber: cardNumberController.text,
              );
          if (res) {
            controller.success();
            showOkAlertDialog(
                context: context,
                message: S.of(context).cardSaved,
                okLabel: S.of(context).ok);
          } else {
            controller.error();
            showOkAlertDialog(
                context: context,
                message: S.of(context).errorOccured,
                okLabel: S.of(context).ok);
          }
        }
      },
      controller: controller,
      child: Text(
        S.of(context).save,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }
}
