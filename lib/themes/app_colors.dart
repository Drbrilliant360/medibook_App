import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Brand Colors ---
  static const Color primary = Color(0xFF1565C0);       // Deep Blue
  static const Color primaryLight = Color(0xFF5E92F3);
  static const Color primaryDark = Color(0xFF003C8F);
  static const Color secondary = Color(0xFF00ACC1);     // Teal accent

  // --- Status Colors ---
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFC62828);
  static const Color info = Color(0xFF0277BD);

  // --- Appointment Status Colors ---
  static const Color statusPending = Color(0xFFF57C00);
  static const Color statusConfirmed = Color(0xFF2E7D32);
  static const Color statusCancelled = Color(0xFFC62828);

  // --- Backgrounds ---
  static const Color backgroundLight = Color(0xFFF5F7FA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // --- Text (Light) ---
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);
  static const Color textOnPrimary = Colors.white;

  // --- Text (Dark) ---
  static const Color textPrimaryDark = Color(0xFFE8EAED);
  static const Color textSecondaryDark = Color(0xFF9AA0A6);

  // --- Input Fields ---
  static const Color inputFill = Color(0xFFF0F4FF);
  static const Color inputBorder = Color(0xFFDDE1E7);

  // --- Misc ---
  static const Color divider = Color(0xFFE5E7EB);
  static const Color shimmer = Color(0xFFE0E0E0);
}
