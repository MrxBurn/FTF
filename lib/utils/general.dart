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
    'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3f/Placeholder_view_vector.svg/310px-Placeholder_view_vector.svg.png';
