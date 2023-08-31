import 'package:flutter/cupertino.dart';

class Review with ChangeNotifier {
  final String reviewID;
  final String username;
  final String userPhoto;
  final int userRating;
  final String messageBody;
  final DateTime commentDate;

  Review(
      {required this.reviewID,
      required this.username,
      required this.userRating,
      required this.messageBody,
      required this.commentDate,
      required this.userPhoto});
}
