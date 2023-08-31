import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';

import '../../generated/l10n.dart';
import '../../logic/providers/detail_tour_provider.dart';
import '../../logic/providers/wishlist_provider.dart';
import '../screens/tour_details_screens/tour_detail_screen.dart';

class PopularTourItem extends StatelessWidget {
  final String id;
  final String image;

  final String name;
  final int rating;

  final double price;

  const PopularTourItem(
      {Key? key,
      required this.image,
      required this.id,
      required this.name,
      required this.rating,
      required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final currencyProvider = Provider.of<CurrencyProvider>(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: TourDetailScreen(), withNavBar: false);
        context.read<DetailTourProvider>().getTourDetails(
              id,
            );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: OctoImage(
                  image: NetworkImage(image),
                  placeholderBuilder:
                      OctoPlaceholder.circularProgressIndicator(),
                  height: 130,
                  width: 130,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[850]),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    RatingBar.builder(
                      ignoreGestures: true,
                      itemSize: 16,
                      glowColor: Color.fromRGBO(255, 206, 100, 1),
                      initialRating: rating.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Color.fromRGBO(255, 188, 44, 1),
                      ),
                      onRatingUpdate: (double value) {},
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      S.of(context).from +
                          " " +
                          getPrice(currencyProvider, price),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[850],
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  if (context.read<WishlistProvider>().isFavorite(id)) {
                    context.read<WishlistProvider>().removeFromFavorites(id);
                  } else {
                    context.read<WishlistProvider>().addToFavorites(id);
                  }
                },
                icon: Icon(Icons.favorite,
                    color: context.watch<WishlistProvider>().isFavorite(id)
                        ? Colors.red
                        : Colors.grey),
              )
            ],
          ),
        ),
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
