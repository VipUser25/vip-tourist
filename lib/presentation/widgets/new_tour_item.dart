import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:octo_image/octo_image.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:vip_tourist/generated/l10n.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/detail_tour_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:vip_tourist/logic/utility/constants.dart';
import 'package:vip_tourist/presentation/screens/tour_details_screens/tour_detail_screen.dart';
import 'package:provider/provider.dart';

class NewTourItem extends StatefulWidget {
  final Locale locale;
  final String id;

  final String image;

  final String name;
  final int rating;
  final int reviews; //quantity
  final double price;

  final int? seats;
  final int duration;
  const NewTourItem(
      {Key? key,
      required this.image,
      required this.id,
      required this.locale,
      required this.name,
      required this.rating,
      required this.reviews,
      required this.price,
      required this.seats,
      required this.duration})
      : super(key: key);

  @override
  State<NewTourItem> createState() => _NewTourItemState();
}

class _NewTourItemState extends State<NewTourItem> {
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
              offset: Offset(0.1, 0.1),
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
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(9),
                      topRight: Radius.circular(9)),
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
                Positioned(
                  right: 10,
                  child: Container(
                    width: 30,
                    child: ElevatedButton(
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
                      child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: context
                                .watch<WishlistProvider>()
                                .isFavorite(widget.id)
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
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18.5,
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
                getDuration(),
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
                    initialRating: widget.rating.toDouble(),
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
                    (widget.reviews < 1)
                        ? "(" + S.of(context).noReviews + ")"
                        : '(${widget.reviews} ' + S.of(context).reviews + ")",
                    style: TextStyle(
                      fontSize: 14,
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  Widget oldOne() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
          context.watch<WishlistProvider>().isFavorite(widget.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: Colors.red),
    );
  }

  String getDuration() {
    if (widget.duration % 24 == 0) {
      if (widget.duration == 24) {
        return "1 " + S.of(context).day.toLowerCase();
      } else {
        double days = widget.duration / 24;
        return days.toInt().toString() + " " + S.of(context).days.toLowerCase();
      }
    } else {
      return widget.duration.toString() +
          " " +
          S.of(context).hours.toLowerCase();
    }
  }

  Widget getPriceBlock(CurrencyProvider data) {
    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 12, left: 12),
      child: Text(
        getPrice(data, widget.price),
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
      ),
      decoration:
          BoxDecoration(color: YELLOW, borderRadius: BorderRadius.circular(6)),
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
