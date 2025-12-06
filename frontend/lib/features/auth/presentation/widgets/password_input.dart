import 'package:formz/formz.dart';

enum PasswordValidationError {
  empty,
  tooShort,
  missingUppercase,
  missingLowercase,
  missingNumber,
  missingSpecial,
}

class Password extends FormzInput<String, PasswordValidationError> {
  const Password.pure() : super.pure('');
  const Password.dirty([super.value = '']) : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) {
      return PasswordValidationError.empty;
    }
    if (value.length < 8) {
      return PasswordValidationError.tooShort;
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return PasswordValidationError.missingUppercase;
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return PasswordValidationError.missingLowercase;
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return PasswordValidationError.missingNumber;
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return PasswordValidationError.missingSpecial;
    }
    return null;
  }

  String? get errorMessage {
    if (isPure || isValid) return null;

    switch (error) {
      case PasswordValidationError.empty:
        return 'Password is required';
      case PasswordValidationError.tooShort:
        return 'Password must be at least 8 characters';
      case PasswordValidationError.missingUppercase:
        return 'Password must contain at least one uppercase letter';
      case PasswordValidationError.missingLowercase:
        return 'Password must contain at least one lowercase letter';
      case PasswordValidationError.missingNumber:
        return 'Password must contain at least one number';
      case PasswordValidationError.missingSpecial:
        return 'Password must contain at least one special character';
      default:
        return null;
    }
  }
}
