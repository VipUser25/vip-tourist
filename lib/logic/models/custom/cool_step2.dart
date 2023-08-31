import 'package:flutter/widgets.dart';

class CoolStep2 {
  final String title;
  final String subtitle;
  final Widget content;
  final String? Function()? validation;
  final bool isHeaderEnabled;

  CoolStep2(
      {required this.title,
      required this.subtitle,
      required this.content,
      required this.validation,
      this.isHeaderEnabled = true});
}
