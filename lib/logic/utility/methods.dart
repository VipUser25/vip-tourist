bool isAbsoluteNull(String? value) {
  if (value == null) {
    return true;
  } else {
    if (value.isEmpty ||
        value.length == 0 ||
        value == "null" ||
        value == "" ||
        value == " " ||
        value == "  ") {
      return true;
    } else {
      return false;
    }
  }
}
