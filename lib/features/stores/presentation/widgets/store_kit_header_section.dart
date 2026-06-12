import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';

class StoreKitHeaderSection extends StatelessWidget {
  final String storeName;

  const StoreKitHeaderSection({
    super.key,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(
            Icons.electric_bolt_rounded,
            color: Theme.of(context).colorScheme.onSurface,
            size: 18.sp,
          ),
        ),
        Expanded(
          child: Text(
            storeName,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.cartScreen),
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: Theme.of(context).colorScheme.onSurface,
            size: 20.sp,
          ),
        ),
      ],
    );
  }
}
