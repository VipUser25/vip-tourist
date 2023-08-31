
class AddTour {
  final String name;
  final String description;
  final String duration;
  final String mainPhotoUrl;
  final String adultPrice;
  final bool transfer;

  final String? childPrice;
  final String languages;
  final String? prerequisites;
  final String? prohibitions;
  final String? included;
  final String? notIncluded;

  final String? note;
  final String? urls;
  final bool withTransfer;
  final String? meetingPoint;
  final String? dateTime;
  final String? time;
  final bool alwaysAvailable;
  final String seats;
  final String? transferPhotoUrl;
  final String? days;
  final String? freeTicketNote;

  AddTour(
      {required this.name,
      required this.description,
      required this.duration,
      this.dateTime,
      required this.adultPrice,
      required this.withTransfer,
      this.childPrice,
      required this.languages,
      this.prerequisites,
      this.prohibitions,
      this.included,
      this.notIncluded,
      this.meetingPoint,
      required this.alwaysAvailable,
      required this.transfer,
      this.note,
      this.urls,
      required this.mainPhotoUrl,
      required this.seats,
      this.transferPhotoUrl,
      this.time,
      this.days,
      this.freeTicketNote});
  static AddTour empty = AddTour(
      name: "",
      description: "",
      languages: "",
      duration: '',
      dateTime: '',
      adultPrice: '',
      meetingPoint: '',
      alwaysAvailable: false,
      transfer: false,
      withTransfer: false,
      seats: "",
      mainPhotoUrl: "");
}
