import 'package:flutter/cupertino.dart';

class Categories with ChangeNotifier {
  bool guideTour = false;
  bool privateTour = false;
  bool oneDayTrip = false;
  bool nature = false;
  bool ticketMustHave = false;
  bool onWater = false;
  bool packageTour = false;
  bool smallGroup = false;
  bool invalidFriendly = false;
  bool history = false;
  bool worldWar = false;
  bool openAir = false;
  bool streetArt = false;
  bool adrenaline = false;
  bool architecture = false;
  bool food = false;
  bool music = false;
  bool forCouples = false;
  bool forKids = false;
  bool museum = false;
  bool memorial = false;
  bool park = false;
  bool gallery = false;
  bool square = false;
  bool theater = false;
  bool castle = false;
  bool towers = false;
  bool airports = false;
  bool bicycle = false;
  bool minivan = false;
  bool publicTransport = false;
  bool limousine = false;
  bool taxi = false;
  bool car = false;
  bool cruise = false;
  bool hunting = false;
  bool adventure = false;
  bool fishing = false;
  bool night = false;
  bool game = false;
  bool onlyTransfer = false;
  bool fewDaysTrip = false;

  Categories(
      {required this.guideTour,
      required this.privateTour,
      required this.oneDayTrip,
      required this.nature,
      required this.ticketMustHave,
      required this.onWater,
      required this.packageTour,
      required this.smallGroup,
      required this.invalidFriendly,
      required this.history,
      required this.worldWar,
      required this.openAir,
      required this.streetArt,
      required this.adrenaline,
      required this.architecture,
      required this.food,
      required this.music,
      required this.forCouples,
      required this.forKids,
      required this.museum,
      required this.memorial,
      required this.park,
      required this.gallery,
      required this.square,
      required this.theater,
      required this.castle,
      required this.towers,
      required this.airports,
      required this.bicycle,
      required this.minivan,
      required this.publicTransport,
      required this.limousine,
      required this.taxi,
      required this.car,
      required this.cruise,
      required this.adventure,
      required this.fewDaysTrip,
      required this.fishing,
      required this.game,
      required this.hunting,
      required this.night,
      required this.onlyTransfer});

  bool operator [](String prop) {
    if (prop == 'guideTour') {
      return guideTour;
    } else if (prop == "privateTour") {
      return privateTour;
    } else if (prop == 'oneDayTrip') {
      return oneDayTrip;
    } else if (prop == 'nature') {
      return nature;
    } else if (prop == 'ticketMustHave') {
      return ticketMustHave;
    } else if (prop == 'onWater') {
      return onWater;
    } else if (prop == 'packageTour') {
      return packageTour;
    } else if (prop == 'smallGroup') {
      return smallGroup;
    } else if (prop == 'invalidFriendly') {
      return invalidFriendly;
    } else if (prop == 'history') {
      return history;
    } else if (prop == 'worldWar') {
      return worldWar;
    } else if (prop == 'openAir') {
      return openAir;
    } else if (prop == 'streetArt') {
      return streetArt;
    } else if (prop == 'adrenaline') {
      return adrenaline;
    } else if (prop == 'architecture') {
      return architecture;
    } else if (prop == 'food') {
      return food;
    } else if (prop == 'music') {
      return music;
    } else if (prop == 'forCouples') {
      return forCouples;
    } else if (prop == 'forKids') {
      return forKids;
    } else if (prop == 'museum') {
      return museum;
    } else if (prop == 'memorial') {
      return memorial;
    } else if (prop == 'park') {
      return park;
    } else if (prop == 'gallery') {
      return gallery;
    } else if (prop == 'square') {
      return square;
    } else if (prop == 'theater') {
      return theater;
    } else if (prop == 'castle') {
      return castle;
    } else if (prop == 'towers') {
      return towers;
    } else if (prop == 'airports') {
      return airports;
    } else if (prop == 'bicycle') {
      return bicycle;
    } else if (prop == 'minivan') {
      return minivan;
    } else if (prop == 'publicTransport') {
      return publicTransport;
    } else if (prop == 'limousine') {
      return limousine;
    } else if (prop == 'taxi') {
      return taxi;
    } else if (prop == 'car') {
      return car;
    } else if (prop == 'cruise') {
      return cruise;
    } else if (prop == 'hunting') {
      return hunting;
    } else if (prop == 'adventure') {
      return adventure;
    } else if (prop == 'fishing') {
      return fishing;
    } else if (prop == 'night') {
      return night;
    } else if (prop == 'game') {
      return game;
    } else if (prop == 'onlyTransfer') {
      return onlyTransfer;
    } else if (prop == 'fewDaysTrip') {
      return fewDaysTrip;
    } else
      return false;
  }
}
