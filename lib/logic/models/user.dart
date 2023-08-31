import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  final String uid;
  late final String email;
  late String? idd;
  late String? name; //editable
  late String? photo; //editable
  late String? phoneNumber; //editable
  bool isTourist; //editable once
  late final String? registrationDate;
  final bool haveDocuments;
  final String balance;
  bool? isVerified; //editable once
  bool? getPromo; //editable
  final bool hasWhatsapp;
  final bool hasViber;
  final bool hasTelegram;

  UserModel(
      {required this.uid,
      required this.email,
      required this.haveDocuments,
      this.name,
      this.photo,
      this.phoneNumber,
      this.idd,
      this.isTourist = true,
      this.isVerified = false,
      required this.balance,
      this.registrationDate,
      this.getPromo = false,
      required this.hasTelegram,
      required this.hasViber,
      required this.hasWhatsapp});

  String get getUid {
    return uid;
  }

  String? get getEmail {
    return email;
  }

  String? get getName {
    return name;
  }

  String? get getPhoto {
    return photo;
  }

  String? get id {
    return idd;
  }

  String? get getPhoneNumber {
    return phoneNumber;
  }

  bool? get getIsTourist {
    return isTourist;
  }

  String? get getRegistrationDate {
    return registrationDate;
  }

  bool? get getIsVerified {
    return isVerified;
  }

  String? get getIdd => idd;

  void setName(String value) {
    name = value;
    notifyListeners();
  }

  void setphoto(String value) {
    photo = value;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    phoneNumber = value;
    notifyListeners();
  }

  void setTouristOrGuide(bool value) {
    isTourist = value;
    notifyListeners();
  }

  void setVerificationStatus(bool value) {
    isVerified = value;
    notifyListeners();
  }

  void setRegistrationDate(String value) {
    registrationDate = value;
    notifyListeners();
  }

  bool get isNameEmpty {
    return name == null;
  }

  bool get isNumberEmpty {
    return phoneNumber == null;
  }

  bool get isPhotoEmpty {
    return photo == null;
  }

  static UserModel empty = UserModel(
      uid: "",
      email: "",
      isVerified: false,
      hasTelegram: false,
      hasViber: false,
      hasWhatsapp: false,
      balance: "0.0",
      haveDocuments: false);

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;
  @override
  List<Object?> get props => [
        email,
        uid,
        name,
        photo,
        phoneNumber,
        isTourist,
        isVerified,
        registrationDate
      ];
}
