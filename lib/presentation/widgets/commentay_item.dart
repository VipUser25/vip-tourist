import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:vip_tourist/logic/utility/constants.dart';

class CommentaryItem extends StatelessWidget {
  const CommentaryItem(
      {Key? key,
      required this.messageBody,
      required this.userName,
      required this.userPhoto,
      required this.date,
      required this.rating})
      : super(key: key);

  final String messageBody;
  final String userName;
  final String userPhoto;
  final DateTime date;
  final int rating;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            contentPadding: EdgeInsets.only(left: 0),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                DateFormat("dd.MM.yyyy").format(date),
                style: TextStyle(color: GRAY, fontSize: 14),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName,
                  style: TextStyle(
                      color: GREEN_BLACK,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                RatingBar.builder(
                  ignoreGestures: true,
                  unratedColor: GRAY,
                  itemSize: 18,
                  glowColor: YELLOW,
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
                )
              ],
            ),
            leading: userPhoto.isEmpty
                ? CircleAvatar(
                    child: Text(userName[0].toUpperCase()),
                    maxRadius: 20,
                  )
                : CircleAvatar(
                    backgroundImage: NetworkImage(userPhoto),
                    maxRadius: 20,
                  )),
        Padding(
          padding: const EdgeInsets.only(left: 55.0),
          child: Text(
            messageBody,
            style: TextStyle(
              color: GREEN_GRAY,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Divider(
          thickness: 0.5,
          color: Colors.grey,
        ),
      ],
    );
  }
}
