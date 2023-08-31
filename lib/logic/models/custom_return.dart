class CustomReturn {
  final String? error;
  final String? uid;
  final String? email;
  final String? name;
  final String? number;
  final String? photo;

  CustomReturn(
      {required this.uid,
      required this.email,
      required this.name,
      required this.number,
      required this.error,
      required this.photo});
}
