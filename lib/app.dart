import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/main_navigation.dart';
import 'screens/doctors/doctors_screen.dart';
import 'screens/doctors/doctor_profile_screen.dart';
import 'screens/booking/booking_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/confirmation/confirmation_screen.dart';
import 'screens/appointments/appointments_screen.dart';
import 'screens/appointments/appointment_detail_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/doctor/doctor_navigation.dart';
import 'screens/admin/admin_navigation.dart';
import 'constants/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediBook',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
      routes: {
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        // Patient
        AppRoutes.dashboard: (_) => const MainNavigation(),
        AppRoutes.doctors: (_) => const DoctorsScreen(),
        AppRoutes.doctorProfile: (_) => const DoctorProfileScreen(),
        AppRoutes.booking: (_) => const BookingScreen(),
        AppRoutes.payment: (_) => const PaymentScreen(),
        AppRoutes.confirmation: (_) => const ConfirmationScreen(),
        AppRoutes.appointments: (_) => const AppointmentsScreen(),
        AppRoutes.appointmentDetail: (_) => const AppointmentDetailScreen(),
        AppRoutes.editProfile: (_) => const EditProfileScreen(),
        // Doctor
        AppRoutes.doctorDashboard: (_) => const DoctorNavigation(),
        // Admin
        AppRoutes.adminDashboard: (_) => const AdminNavigation(),
      },
    );
  }
}
