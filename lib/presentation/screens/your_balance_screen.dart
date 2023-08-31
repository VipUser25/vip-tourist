import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/src/provider.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/payment_cards_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/card_save_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

class YourBalanceScreen extends StatefulWidget {
  const YourBalanceScreen({Key? key}) : super(key: key);

  @override
  _YourBalanceScreenState createState() => _YourBalanceScreenState();
}

class _YourBalanceScreenState extends State<YourBalanceScreen> {
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
          S.of(context).accountBalance,
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
        padding: EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              context.watch<PaymentCardsProvider>().balance + " \$",
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.bold, color: PRIMARY),
            ),
            SizedBox(
              height: 25,
            ),
            templateTile(
              icon: Icons.wallet,
              text: context.watch<PaymentCardsProvider>().cardNumber ??
                  S.of(context).noCard,
              onPressed: () => pushNewScreen(context,
                  screen: CardSaveScreen(), withNavBar: false),
            ),
            const SizedBox(
              height: 15,
            ),
            templateTile(
                icon: Icons.attach_money_rounded,
                text: S.of(context).getBalance,
                onPressed: () async {
                  if (context.read<PaymentCardsProvider>().cardID == null ||
                      context.read<PaymentCardsProvider>().cardNumber == null) {
                    EasyLoading.showError(
                      S.of(context).cardAttachAlarm,
                      duration: Duration(seconds: 2),
                    );
                  } else {
                    EasyLoading.show(status: S.of(context).loading);
                    bool res = await context
                        .read<PaymentCardsProvider>()
                        .makeWithdrawal();
                    if (res) {
                      await launch(
                          'mailto:support@viptourist.club?subject=&body=${S.of(context).getBalanceNew}');
                    } else {
                      EasyLoading.showError(S.of(context).errorOccured);
                    }
                  }
                }),
          ],
        ),
      ),
    );
  }

  Widget templateTile(
      {required IconData icon,
      required String text,
      required void Function() onPressed}) {
    return Container(
      padding: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: LIGHT_GRAY),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: GRAY,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: GREEN_BLACK),
          ),
          Spacer(),
          IconButton(
            onPressed: onPressed,
            icon: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
            ),
            padding: EdgeInsets.all(0),
          )
        ],
      ),
    );
  }
}
