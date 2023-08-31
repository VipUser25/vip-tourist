import 'package:form_field_validator/form_field_validator.dart';
import 'package:vip_tourist/generated/l10n.dart';

class Validator {
  static MultiValidator emailvalidator(S data) {
    return MultiValidator([
      EmailValidator(errorText: data.invalidEmailForm),
      RequiredValidator(errorText: data.required)
    ]);
  }

  static MultiValidator passwordValidator(S data) {
    return MultiValidator([
      RequiredValidator(errorText: data.passwordIsRequired),
      MinLengthValidator(8, errorText: data.password8symbolsLong),
    ]);
  }
}
