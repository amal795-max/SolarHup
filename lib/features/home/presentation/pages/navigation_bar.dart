import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/features/home/presentation/pages/home_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/activity_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/stores_screen.dart';
import '../../../settings/presentation/pages/settings_screen.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    StoresScreen(),
    ActivityScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;

    return Scaffold(
      extendBody: true,
      body: pages[selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: scheme.surface,
          elevation: 0,
          selectedItemColor: scheme.primary,
          unselectedItemColor: scheme.onSurface.withOpacity(0.6),


          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),

          items:  [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'Home'.tr(),
            ),
             BottomNavigationBarItem(
              icon: const Icon(Icons.storefront_outlined),
              activeIcon: const Icon(Icons.storefront_rounded),
              label: 'Stores'.tr(),
            ),
             BottomNavigationBarItem(
              icon:  const Icon(Icons.build_outlined),
              activeIcon: const Icon(Icons.build),
              label: 'Services'.tr(),
            ),
             BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long),
              label: 'Orders'.tr(),
            ),
          ],
        ),

    );
  }
}
