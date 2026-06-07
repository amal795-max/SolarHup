import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/features/home/presentation/pages/home_screen.dart';
import 'package:untitled1/features/orders/presentation/pages/activity_screen.dart';
import 'package:untitled1/features/stores/presentation/pages/stores_screen.dart';

import '../../../../core/theme/app_colors.dart';

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
    ActivityScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        extendBody: true,
        body: pages[selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // color:context.brightness AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: StylishBottomBar(

            option: DotBarOptions(
              dotStyle: DotStyle.tile,
              gradient: const LinearGradient(
                colors: [
                  AppColors.tertiaryColor,
                  AppColors.secondaryColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            items: [
              BottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                selectedColor: AppColors.primaryColor,
                unSelectedColor: AppColors.greyTitle,
                selectedIcon: const Icon(Icons.home),
              ),
              BottomBarItem(
                icon: const Icon(Icons.storefront_outlined),
                title: const Text('Stores'),
                selectedColor: AppColors.primaryColor,
                unSelectedColor: AppColors.greyTitle,
              ),
              BottomBarItem(
                icon: const Icon(Icons.build_outlined),
                title: const Text('Services'),
                selectedColor: AppColors.primaryColor,
                unSelectedColor: AppColors.greyTitle,
              ),
              BottomBarItem(
                icon: const Icon(Icons.receipt_long_outlined),
                title: const Text('Orders'),
                selectedColor: AppColors.primaryColor,
                unSelectedColor: AppColors.greyTitle,
              ),
            ],

            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
                pages.elementAt(index);
              });
            },
          ),
        ),
      ),
    );
  }
}
