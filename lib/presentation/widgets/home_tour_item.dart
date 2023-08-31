import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:octo_image/octo_image.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';

import '../../logic/utility/constants.dart';

class TourHomeItem extends StatelessWidget {
  final String id;
  final String name;
  final int rate;
  final int reviewCount;
  final String currency;
  final double price;
  final String image;
  final int duration;
  final int reviews;

  const TourHomeItem(
      {Key? key,
      required this.id,
      required this.name,
      required this.rate,
      required this.reviewCount,
      required this.currency,
      required this.price,
      required this.image,
      required this.duration,
      required this.reviews})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final curData = Provider.of<CurrencyProvider>(context);
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width / 1.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        // boxShadow: [
        //   BoxShadow(
        //     spreadRadius: -2.8,
        //     color: Colors.black,
        //     offset: Offset(0.1, 0.1),
        //     blurRadius: 5,
        //   ),
        // ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: Alignment.topRight,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(9), topRight: Radius.circular(9)),
                child: OctoImage(
                  image: NetworkImage(image),
                  height: 140,
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                  placeholderBuilder: (context) => Container(
                    height: 270,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 10,
                child: Container(
                  width: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      if (context.read<WishlistProvider>().isFavorite(id)) {
                        context
                            .read<WishlistProvider>()
                            .removeFromFavorites(id);
                      } else {
                        context.read<WishlistProvider>().addToFavorites(id);
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 20,
                      color: context.watch<WishlistProvider>().isFavorite(id)
                          ? RED
                          : GRAY,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: CircleBorder(),
                        padding: const EdgeInsets.all(0),
                        elevation: 0),
                  ),
                ),
              ),
              Positioned(top: 10, left: 10, child: getPriceBlock(curData))
            ],
          ),
          Container(
            width: width / 1.7,
            decoration: BoxDecoration(
              border: Border.all(color: LIGHT_GRAY, width: 1),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(9),
                bottomRight: Radius.circular(9),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    getDuration(context),
                    style: TextStyle(
                      fontSize: 14,
                      color: GRAY,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      RatingBar.builder(
                        ignoreGestures: true,
                        itemSize: 20,
                        glowColor: YELLOW,
                        unratedColor: GRAY,
                        initialRating: rate.toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: YELLOW,
                        ),
                        onRatingUpdate: (double value) {},
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        (reviews < 1)
                            ? "(" + S.of(context).noReviews + ")"
                            : '($reviews ' + S.of(context).reviews + ")",
                        style: TextStyle(
                          fontSize: 12,
                          color: GREEN_BLACK,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String getDuration(BuildContext context) {
    if (duration % 24 == 0) {
      if (duration == 24) {
        return "1 " + S.of(context).day.toLowerCase();
      } else {
        double days = duration / 24;
        return days.toInt().toString() + " " + S.of(context).days.toLowerCase();
      }
    } else {
      return duration.toString() + " " + S.of(context).hours.toLowerCase();
    }
  }

  Widget getPriceBlock(CurrencyProvider data) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 12, left: 12),
      child: Text(
        getPrice(data, price),
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
      ),
      decoration:
          BoxDecoration(color: YELLOW, borderRadius: BorderRadius.circular(6)),
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
