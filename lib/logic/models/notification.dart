
class MyNotification {
  final String title;
  final String body;
  final String notificationID;
  final String uid;
  final bool isPersonal;
  final DateTime dateTime;

  MyNotification(
      {required this.title,
      required this.body,
      required this.notificationID,
      required this.uid,
      required this.isPersonal,
      required this.dateTime});
}
