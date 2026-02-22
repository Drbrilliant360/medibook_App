import '../constants/app_strings.dart';

class Validators {
  Validators._();

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) return AppStrings.invalidEmail;
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return AppStrings.fieldRequired;
    if (value.length < 6) return AppStrings.passwordTooShort;
    return null;
  }

  static String? confirmPassword(String? value, String original) {
    final passError = password(value);
    if (passError != null) return passError;
    if (value != original) return AppStrings.passwordsMustMatch;
    return null;
  }

  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    return null;
  }

  static String? appointmentDate(DateTime? date) {
    if (date == null) return AppStrings.fieldRequired;
    final today = DateTime.now();
    final todayMidnight = DateTime(today.year, today.month, today.day);
    if (date.isBefore(todayMidnight)) return AppStrings.pastDateError;
    return null;
  }
}
