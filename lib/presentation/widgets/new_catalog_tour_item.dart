import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:provider/provider.dart';

class NewCatalogTourItem extends StatefulWidget {
  final Locale locale;
  final String id;
  final String image;

  final String name;
  final int rating;
  final int reviews; //quantity
  final double price;
  const NewCatalogTourItem(
      {Key? key,
      required this.image,
      required this.id,
      required this.locale,
      required this.name,
      required this.rating,
      required this.reviews,
      required this.price})
      : super(key: key);

  @override
  State<NewCatalogTourItem> createState() => _NewCatalogTourItemState();
}

class _NewCatalogTourItemState extends State<NewCatalogTourItem> {
  @override
  Widget build(BuildContext context) {
    final curData = Provider.of<CurrencyProvider>(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(context, screen: TourDetailScreen(), withNavBar: false);
        context.read<DetailTourProvider>().getTourDetails(
              widget.id,
            );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              spreadRadius: -2.8,
              color: Colors.black,
              offset: Offset(2, 2),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: OctoImage(
                    image: NetworkImage(widget.image),
                    height: 150,
                    width: double.maxFinite,
                    fit: BoxFit.fitWidth,
                    placeholderBuilder: (context) => Container(
                      height: 250,
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (context
                        .read<WishlistProvider>()
                        .isFavorite(widget.id)) {
                      context
                          .read<WishlistProvider>()
                          .removeFromFavorites(widget.id);
                    } else {
                      context
                          .read<WishlistProvider>()
                          .addToFavorites(widget.id);
                    }
                  },
                  icon: Icon(Icons.favorite,
                      color: context
                              .watch<WishlistProvider>()
                              .isFavorite(widget.id)
                          ? Colors.red
                          : Colors.grey),
                ),
                Positioned(
                    bottom: 7,
                    left: 7,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Text(
                        S.of(context).top + " " + S.of(context).tour,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.blue[600],
                          borderRadius: BorderRadius.circular(10)),
                    ))
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18.5,
                  color: Colors.grey[850],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RatingBar.builder(
                    ignoreGestures: true,
                    itemSize: 20,
                    glowColor: Color.fromRGBO(255, 206, 100, 1),
                    initialRating: widget.rating.toDouble(),
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
                  Text(
                    S.of(context).from,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    (widget.reviews < 1)
                        ? S.of(context).noReviews
                        : '${widget.reviews} ' + S.of(context).reviews,
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    getPrice(curData, widget.price),
                    style: TextStyle(
                      fontSize: 18.5,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget tourDetails(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.grey[850],
        ),
        SizedBox(
          width: 5,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.grey[850], fontSize: 15),
        )
      ],
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
