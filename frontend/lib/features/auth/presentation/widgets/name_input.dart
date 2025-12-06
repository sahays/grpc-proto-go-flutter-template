import 'package:formz/formz.dart';

enum NameValidationError { empty, tooShort, invalid }

class Name extends FormzInput<String, NameValidationError> {
  const Name.pure() : super.pure('');
  const Name.dirty([super.value = '']) : super.dirty();

  static final _nameRegex = RegExp(r"^[a-zA-Z\s\-']+$");

  @override
  NameValidationError? validator(String value) {
    if (value.trim().isEmpty) {
      return NameValidationError.empty;
    } else if (value.trim().length < 2) {
      return NameValidationError.tooShort;
    } else if (!_nameRegex.hasMatch(value)) {
      return NameValidationError.invalid;
    }
    return null;
  }
}
