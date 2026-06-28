import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/features/stores/presentation/bloc/store_kit_bloc/store_kit_bloc.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_header_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_products_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_search_section.dart';
import 'package:untitled1/features/stores/presentation/widgets/store_kit_special_offer_section.dart';

class StoreKitProductData {
  final String id;
  final String categoryKey;
  final String name;
  final double price;
  final double rating;
  final int reviews;
  final int imageColorValue;
  final String? imageUrl;

  const StoreKitProductData({
    required this.id,
    required this.categoryKey,
    required this.name,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.imageColorValue,
    this.imageUrl,
  });
}

class StoreKitScreen extends StatelessWidget {
  const StoreKitScreen({super.key});

  static const String _storeName = 'SunPeak Energy Systems';

  static const List<StoreKitProductData> _products = [
    StoreKitProductData(
      id: 'helios-450w',
      categoryKey: 'panels',
      name: 'Helios Mono-Crystalline 450W',
      price: 299.00,
      rating: 4.9,
      reviews: 124,
      imageColorValue: 0xFF2D5C86,
    ),
    StoreKitProductData(
      id: 'ionstack-10kwh',
      categoryKey: 'batteries',
      name: 'IonStack Home Battery 10kWh',
      price: 4850,
      rating: 4.8,
      reviews: 89,
      imageColorValue: 0xFF8798A6,
    ),
    StoreKitProductData(
      id: 'smartflow-5kw',
      categoryKey: 'inverters',
      name: 'SmartFlow Hybrid Inverter 5kW',
      price: 1240,
      rating: 4.7,
      reviews: 56,
      imageColorValue: 0xFFD9DEE3,
    ),
    StoreKitProductData(
      id: 'promount-z-bracket-set',
      categoryKey: 'panels',
      name: 'ProMount Z-Bracket Set (4)',
      price: 45.00,
      rating: 4.9,
      reviews: 210,
      imageColorValue: 0xFFC4D0DA,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreKitBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StoreKitHeaderSection(storeName: _storeName),
                  SizedBox(height: 16.h),
                  const StoreKitSearchSection(),
                  SizedBox(height: 14.h),
                  const StoreKitProductsSection(products: _products),
                  SizedBox(height: 16.h),
                  const StoreKitSpecialOfferSection(),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
