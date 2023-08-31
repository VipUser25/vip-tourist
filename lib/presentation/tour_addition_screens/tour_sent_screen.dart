import 'package:flutter/material.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/offers_edit_screens/offers_list_screen.dart';
import 'package:vip_tourist/presentation/widgets/mini_tour_item.dart';
import 'package:vip_tourist/presentation/widgets/tour_sent_item.dart';

import '../../generated/l10n.dart';

class TourSentScreen extends StatelessWidget {
  final String price;
  final String tourName;
  final double adultPrice;
  final int seats;
  final String description;
  final String photoUrl;
  const TourSentScreen(
      {Key? key,
      required this.tourName,
      required this.adultPrice,
      required this.seats,
      required this.photoUrl,
      required this.price,
      required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CurrencyProvider>(context);
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 250,
            decoration:
                BoxDecoration(color: Color(0xFFF1F3EC), shape: BoxShape.circle),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 11.5),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: TourSentItem(name: tourName, photo: photoUrl),
                  ),
                ),
                Positioned(
                  bottom: 170,
                  child: Container(
                    height: 40,
                    width: 50,
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, color: YELLOW),
                    child: Icon(Icons.timer_sharp),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Text(
            S.of(context).tourSendTag1,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20.5,
                fontWeight: FontWeight.bold,
                color: GREEN_BLACK),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(S.of(context).tourSendTag2,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: GREEN_GRAY)),
          const SizedBox(
            height: 35,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size.fromHeight(double.infinity),
            ),
            onPressed: () async {
              pushNewScreen(context, screen: OffersListScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20),
              child: Text(
                S.of(context).goToOffers,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ),
          )
        ],
      ),
    );
  }

  String getPrice(CurrencyProvider data, double price) {
    if (data.currency == "USD" || data.currency == null) {
      return "\$" + price.toStringAsFixed(2);
    } else if (data.currency == "EUR") {
      return "€" + (price * data.euro!).toStringAsFixed(2);
    } else if (data.currency == "AED") {
      return ".د.إ" + (price * data.dirham!).toStringAsFixed(2);
    } else if (data.currency == "RUB") {
      return "₽" + (price * data.rouble!).toStringAsFixed(2);
    } else if (data.currency == "THB") {
      return "฿" + (price * data.baht!).toStringAsFixed(2);
    } else if (data.currency == "TRY") {
      return "₤" + (price * data.lira!).toStringAsFixed(2);
    } else if (data.currency == "GBP") {
      return "£" + (price * data.gbp!).toStringAsFixed(2);
    }
    return "\$" + price.toStringAsFixed(2);
  }
}
