import 'package:flutter/material.dart';
import 'package:vip_tourist/logic/models/categories.dart';
import 'package:vip_tourist/logic/providers/home_tour_provider.dart';

class MiniTour with ChangeNotifier {
  late final String tourID; //required
  late final String name; //required
  late final String photoURL; //required
  final int rating;
  late int? reviews;
  late double price;
  late Categories category;
  final List<MiniLocal>? localizations;
  final int duration;
  MiniTour(
      {required this.tourID,
      required this.name,
      required this.photoURL,
      required this.rating,
      required this.price,
      required this.category,
      this.localizations,
      this.reviews,
      required this.duration});

  void setReviews(int value) {
    reviews = value;
    notifyListeners();
  }

  void updateUI() => notifyListeners();
}
