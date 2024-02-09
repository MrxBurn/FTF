import 'package:ftf/utils/regex.dart';

String? emailValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (!emailRgx.hasMatch(value)) {
    return 'Invalid email';
  }
  return null;
}

String? fieldRequired(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  }
  return null;
}

String? userNameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value.length < 5) {
    return 'Username should have more than 5 characters';
  }
  return null;
}

String? confirmPasswordValidator(String? value, String? password) {
  if (value == null || value.isEmpty) {
    return 'This field is required';
  } else if (value != password) {
    return "Passwords don't match";
  }
  return null;
}

String imgPlaceholder =
    'https://firebasestorage.googleapis.com/v0/b/ftfdb-83750.appspot.com/o/imagePlaceholder%2Fimage_placeholder.png?alt=media&token=dad6825d-cf9b-4d35-b30d-c5585d3f5294';
