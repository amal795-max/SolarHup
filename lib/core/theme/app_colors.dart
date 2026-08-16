import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryColor = Color(0xFF0A2A43);
  static const Color deepPrimaryColor = Color(0xFF001527);
  static const Color secondaryColor = Color(0xFFFDCC16);
  static const Color tertiaryColor = Color(0xFF3E2102);
  static const Color brown = Color(0xFF745B00);
  static const Color lightYellow = Color(0xffffefcc);
  static const Color lightOrange = Color(0xFFFFEEE1);

  static const Color black = Color(0xFF000000);
  static const Color white = Colors.white;
  static const Color grey = Color(0xFF73777E);
  static const Color deepGrey = Color(0xFF43474D);
  static const Color lightGrey = Color(0xFFF1F0F3);
  static const Color backGroundGrey = Color(0xFFFAF9FB);
  static final Color borderColor = Colors.grey.shade300;
  static final Color shadowColor = Colors.black.withOpacity(0.03);

  static const Color darkContainer = Color(0xFF1E293B);
  static const Color darkMode = Color(0xFF0F172A);
  static const Color darkBottomNav = Color(0xFF1E293B);
  static const Color darkGray = Color(0xFF334155);
  static const Color blue = Color(0xFF7692B0);

  static const Color red = Color(0xFFBA1A1A);
  static const Color green = Color(0xFF2E7D32);


  // -------------------------------
  // Delivery Status Colors (New)
  // -------------------------------

  // Pending
  static const Color pendingBg = lightGrey;
  static const Color pendingBorder = deepGrey;

  // Accepted
  static const Color acceptedBg = lightYellow;
  static const Color acceptedBorder = brown;

  // In Transit
  static const Color inTransitBg = Color(0xFFE3F2FD);
  static const Color inTransitBorder = blue;

  // Rejected
  static const Color rejectedBg = Color(0xFFFFEBEE);
  static const Color rejectedBorder = red;

  // Delivered
  static const Color deliveredBg = Color(0xFFE8F5E9);
  static const Color deliveredBorder = green;

  // Completed
  static const Color completedBg = Color(0xFFC8E6C9);
  static const Color completedBorder = Color(0xFF1B5E20);
}
