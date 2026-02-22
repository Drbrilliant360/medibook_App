class AppConstants {
  AppConstants._();

  // --- Spacing ---
  static const double paddingXS = 4.0;
  static const double paddingSM = 8.0;
  static const double paddingMD = 16.0;
  static const double paddingLG = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;

  // --- Border Radius ---
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusRound = 100.0;

  // --- Button Height ---
  static const double buttonHeight = 52.0;

  // --- Input ---
  static const double inputHeight = 56.0;

  // --- Doctors List (can be replaced with Firestore fetch later) ---
  static const List<String> availableDoctors = [
    'Dr. Amina Hassan',
    'Dr. John Kamau',
    'Dr. Fatuma Ali',
    'Dr. Peter Mwangi',
    'Dr. Sarah Ochieng',
    'Dr. James Ndungu',
    'Dr. Zainab Omar',
  ];

  // --- Firestore ---
  static const String appointmentsCollection = 'appointments';
  static const String usersCollection = 'users';
}
