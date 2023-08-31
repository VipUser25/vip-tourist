import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../generated/l10n.dart';
import '../../logic/utility/constants.dart';

class ActiveTourItem extends StatelessWidget {
  final String image;
  final String price;
  final String tourName;
  final String tourDescription;

  const ActiveTourItem(
      {Key? key,
      required this.image,
      required this.price,
      required this.tourName,
      required this.tourDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Container(
        height: 145,
        padding: EdgeInsets.all(11),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: LIGHT_GRAY)),
        child: Row(
          // mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
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
                        color: YELLOW, borderRadius: BorderRadius.circular(6)),
                  ),
                )
              ],
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: 190,
              child: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
