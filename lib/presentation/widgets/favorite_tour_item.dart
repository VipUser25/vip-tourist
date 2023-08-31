import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:octo_image/octo_image.dart';
import 'package:vip_tourist/logic/providers/currency_provider.dart';
import 'package:vip_tourist/logic/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class FavoriteTourItem extends StatefulWidget {
  final String tourVID;
  final String tourName;
  final double rating;
  final String image;
  final double price;
  const FavoriteTourItem(
      {Key? key,
      required this.image,
      required this.tourVID,
      required this.tourName,
      required this.rating,
      required this.price})
      : super(key: key);

  @override
  _FavoriteTourItemState createState() => _FavoriteTourItemState();
}

class _FavoriteTourItemState extends State<FavoriteTourItem> {
  @override
  Widget build(BuildContext context) {
    final curData = Provider.of<CurrencyProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: EdgeInsets.only(right: 5),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(color: Colors.white),
              child: OctoImage(
                image: NetworkImage(widget.image),
                placeholderBuilder: OctoPlaceholder.circularProgressIndicator(),
                height: 130,
                width: 130,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.tourName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                    initialRating: widget.rating,
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
                  Flexible(
                    child: Text(
                      getPrice(curData, widget.price),
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[850],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            IconButton(
                padding: EdgeInsets.symmetric(vertical: 1),
                onPressed: () {
                  context
                      .read<WishlistProvider>()
                      .removeFromFavorites(widget.tourVID);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ))
          ],
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
