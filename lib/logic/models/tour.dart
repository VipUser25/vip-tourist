import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:vip_tourist/logic/models/categories.dart';

class Tour with ChangeNotifier {
  final DateTime? date;
  final String tourID;
  final String name;
  final String description;
  final int seats;
  final Categories? categories;
  final double price;
  final String? country;
  final int rating;
  final bool alwaysAvailable;
  final LatLng? meetingPoint;
  final List<String> photos;
  final int? duration;
  final String userID;
  final String userName;
  final String? userPhoto;
  final List<String> languages;
  final bool withTransfer;
  final double? childPrice;
  final bool top;
  final String? prerequisites;
  final String? prohibitions;
  final String? included;
  final String? notIncluded;
  final String? note;
  final String? cityId;
  final String? cityName;

  final String? transferPhotoUrl;

  final String? freeTicketNotice;
  final String? weekDays;

  final String? time;

  Tour(
      {required this.languages,
      this.childPrice,
      this.prerequisites,
      this.prohibitions,
      this.included,
      this.notIncluded,
      this.note,
      this.date,
      this.time,
      required this.withTransfer,
      required this.tourID,
      required this.name,
      required this.description,
      required this.categories,
      required this.photos,
      required this.price,
      required this.rating,
      required this.alwaysAvailable,
      this.meetingPoint,
      required this.top,
      required this.userID,
      required this.userName,
      this.userPhoto,
      this.country,
      this.duration,
      this.cityId,
      this.cityName,
      this.transferPhotoUrl,
      this.freeTicketNotice,
      this.weekDays,
      required this.seats});

  static Tour empty = Tour(
      top: false,
      languages: [],
      date: DateTime.now(),
      tourID: '',
      name: '',
      description: '',
      withTransfer: false,
      price: 0,
      photos: [],
      categories: null,
      alwaysAvailable: false,
      rating: 0,
      userID: '',
      userName: '',
      seats: 0);
}
