import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../generated/l10n.dart';
import '../../logic/utility/constants.dart';

class MapTourItemWidget extends StatelessWidget {
  final String image;
  final String price;
  final String tourName;
  final String tourDescription;
  final int rating;
  final int reviews;
  final void Function() moveCamera;
  final void Function() openTour;
  const MapTourItemWidget(
      {Key? key,
      required this.image,
      required this.price,
      required this.tourName,
      required this.moveCamera,
      required this.openTour,
      required this.rating,
      required this.reviews,
      required this.tourDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 60, bottom: 15),
      child: Container(
        height: 115,
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: moveCamera,
              child: Stack(
                alignment: Alignment.topLeft,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      image,
                      height: 90,
                      width: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    left: 5,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        price,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      decoration: BoxDecoration(
                          color: YELLOW,
                          borderRadius: BorderRadius.circular(6)),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 190,
              child: GestureDetector(
                onTap: openTour,
                child: Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tourName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: tourDescription.length > 25 ? 1 : 2,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GREEN_BLACK),
                      ),
                      Spacer(),
                      Text(
                        tourDescription,
                        maxLines: tourDescription.length > 25 ? 2 : 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5, color: GRAY),
                      ),
                      Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          RatingBar.builder(
                            ignoreGestures: true,
                            itemSize: 17,
                            glowColor: YELLOW,
                            unratedColor: GRAY,
                            initialRating: rating.toDouble(),
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
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
