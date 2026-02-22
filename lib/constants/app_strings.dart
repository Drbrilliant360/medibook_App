class AppStrings {
  AppStrings._();

  // --- App ---
  static const String appName = 'MediBook';
  static const String tagline = 'Your Health, Our Priority';

  // --- Auth ---
  static const String login = 'Login';
  static const String register = 'Register';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String confirmPassword = 'Confirm Password';
  static const String forgotPassword = 'Forgot Password?';
  static const String dontHaveAccount = "Don't have an account? ";
  static const String alreadyHaveAccount = 'Already have an account? ';
  static const String signUp = 'Sign Up';
  static const String signIn = 'Sign In';
  static const String logout = 'Logout';

  // --- Booking ---
  static const String bookAppointment = 'Book Appointment';
  static const String patientName = 'Patient Name';
  static const String selectDoctor = 'Select Doctor';
  static const String selectDate = 'Select Date';
  static const String bookNow = 'Book Now';

  // --- Confirmation ---
  static const String bookingConfirmed = 'Booking Confirmed!';
  static const String bookingSuccess = 'Your appointment has been successfully booked.';
  static const String goToDashboard = 'Go to Dashboard';
  static const String bookAnother = 'Book Another';

  // --- Dashboard ---
  static const String myAppointments = 'My Appointments';
  static const String noAppointments = 'No appointments yet.';
  static const String bookFirst = 'Book your first appointment!';

  // --- Status ---
  static const String pending = 'Pending';
  static const String confirmed = 'Confirmed';
  static const String cancelled = 'Cancelled';

  // --- Validation ---
  static const String fieldRequired = 'This field is required';
  static const String invalidEmail = 'Enter a valid email address';
  static const String passwordTooShort = 'Password must be at least 6 characters';
  static const String passwordsMustMatch = 'Passwords do not match';
  static const String pastDateError = 'Please select a future date';

  // --- Errors ---
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'Network error. Check your connection.';
}
