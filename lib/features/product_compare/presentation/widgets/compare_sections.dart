import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/helper/data_helper.dart';
import 'package:untitled1/core/helper/extensions.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_cubit.dart';
import 'package:untitled1/features/orders/presentation/bloc/cart_state.dart';
import 'package:untitled1/features/product_compare/data/models/compare_product_model.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_mapper.dart';
import 'package:untitled1/widgets/container_style_widget.dart';
import 'package:untitled1/widgets/image_widget.dart';
import 'package:untitled1/widgets/primary_button.dart';

class CompareProductCardsSection extends StatelessWidget {
  final CompareProduct? firstProduct;
  final CompareProduct? secondProduct;
  final VoidCallback? onTapFirst;
  final VoidCallback? onTapSecond;

  const CompareProductCardsSection({
    super.key,
    required this.firstProduct,
    required this.secondProduct,
    this.onTapFirst,
    this.onTapSecond,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _CompareProductCard(
            product: firstProduct,
            badgeKey: 'compare_product_a',
            onTap: onTapFirst,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _CompareProductCard(
            product: secondProduct,
            badgeKey: 'compare_product_b',
            isHighlighted: true,
            onTap: onTapSecond,
          ),
        ),
      ],
    );
  }
}

class _CompareProductCard extends StatelessWidget {
  final CompareProduct? product;
  final String badgeKey;
  final bool isHighlighted;
  final VoidCallback? onTap;

  const _CompareProductCard({
    required this.product,
    required this.badgeKey,
    this.isHighlighted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isHighlighted
                  ? AppColors.secondaryColor
                  : theme.colorScheme.outline.withValues(alpha: 0.25),
              width: isHighlighted ? 1.5 : 1,
            ),
            boxShadow: [
              if (!context.brightness)
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1.15,
                child: product == null
                    ? _EmptyProductPlaceholder(onTap: onTap)
                    : _ProductImage(product: product!),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 3.h,
                      ),
                      decoration: BoxDecoration(
                        color: isHighlighted
                            ? titleColor
                            : (isDark ? AppColors.darkGray : AppColors.lightGrey),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        badgeKey.tr(),
                        style: AppStyle.labelSmall.copyWith(
                          color: isHighlighted ? AppColors.white : AppColors.grey,
                          fontWeight: FontWeight.w800,
                          fontSize: 10.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      product?.detail.title ?? 'compare_tap_to_choose'.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyle.bodyLarge.copyWith(
                        fontWeight: FontWeight.w800,
                        color: product == null ? AppColors.grey : titleColor,
                        height: 1.25,
                      ),
                    ),
                    if (product != null) ...[
                      SizedBox(height: 6.h),
                      Text(
                        product!.storeName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppStyle.bodySmall.copyWith(
                          color: AppColors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final CompareProduct product;

  const _ProductImage({required this.product});

  @override
  Widget build(BuildContext context) {
    final detail = product.detail;
    if (detail.imageUrls.isNotEmpty) {
      return ImageWidget(image: detail.imageUrls.first);
    }

    return ColoredBox(
      color: Color(detail.imagePlaceholderColorValue),
      child: Icon(
        Icons.inventory_2_outlined,
        color: AppColors.white.withValues(alpha: 0.7),
        size: 40.sp,
      ),
    );
  }
}

class _EmptyProductPlaceholder extends StatelessWidget {
  final VoidCallback? onTap;

  const _EmptyProductPlaceholder({this.onTap});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.lightGrey.withValues(alpha: 0.35),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_circle_outline_rounded,
            color: AppColors.secondaryColor,
            size: 36.sp,
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'compare_tap_to_choose'.tr(),
              textAlign: TextAlign.center,
              style: AppStyle.bodyMedium.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ComparePricingSection extends StatelessWidget {
  final CompareProduct? firstProduct;
  final CompareProduct? secondProduct;

  const ComparePricingSection({
    super.key,
    required this.firstProduct,
    required this.secondProduct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final valueColor = isDark ? AppColors.blue : AppColors.primaryColor;

    return container(
      context: context,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.payments_outlined, size: 20.sp, color: AppColors.grey),
              SizedBox(width: 8.w),
              Text(
                'label_system_pricing'.tr(),
                style: AppStyle.labelMedium.copyWith(
                  color: AppColors.grey,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PriceColumn(
                  product: firstProduct,
                  valueColor: valueColor,
                ),
              ),
              Expanded(
                child: _PriceColumn(
                  product: secondProduct,
                  valueColor: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final CompareProduct? product;
  final Color valueColor;

  const _PriceColumn({
    required this.product,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Text(
        '—',
        textAlign: TextAlign.center,
        style: AppStyle.h4.copyWith(
          fontWeight: FontWeight.w800,
          color: AppColors.grey,
        ),
      );
    }

    final detail = product!.detail;

    if (detail.hasDiscount) {
      return Column(
        children: [
          Text(
            _formatPrice(detail.originalPrice!),
            textAlign: TextAlign.center,
            style: AppStyle.bodyMedium.copyWith(
              color: AppColors.grey,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.grey,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            _formatPrice(detail.currentPrice),
            textAlign: TextAlign.center,
            style: AppStyle.h4.copyWith(
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      );
    }

    return Text(
      _formatPrice(detail.currentPrice),
      textAlign: TextAlign.center,
      style: AppStyle.h4.copyWith(
        fontWeight: FontWeight.w800,
        color: valueColor,
      ),
    );
  }

  String _formatPrice(double price) =>
      '\$${price.toStringAsFixed(2)}';
}

class CompareSpecsSection extends StatelessWidget {
  final List<CompareSpecRow> rows;

  const CompareSpecsSection({super.key, required this.rows});

  static const double _cardHeight = 118;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: 10.h),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ProductSpecCard(
                    labelKey: rows[i].labelKey,
                    value: rows[i].leftValue,
                    icon: rows[i].icon,
                    height: _cardHeight,
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _ProductSpecCard(
                    labelKey: rows[i].labelKey,
                    value: rows[i].rightValue,
                    icon: rows[i].icon,
                    height: _cardHeight,
                    emphasizeValue: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _ProductSpecCard extends StatelessWidget {
  final String labelKey;
  final String? value;
  final IconData? icon;
  final double height;
  final bool emphasizeValue;

  const _ProductSpecCard({
    required this.labelKey,
    required this.value,
    required this.height,
    this.icon,
    this.emphasizeValue = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final valueColor = emphasizeValue
        ? (isDark ? AppColors.blue : AppColors.primaryColor)
        : AppColors.grey;
    final iconColor = _iconColorForKey(labelKey);
    final resolvedIcon = icon ?? _iconForKey(labelKey);

    return SizedBox(
      height: height.h,
      child: container(
        context: context,
        child: Scrollbar(
          thumbVisibility: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDark ? 0.2 : 0.15),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(resolvedIcon, size: 20.sp, color: iconColor),
                ),
                SizedBox(height: 10.h),
                Text(
                  labelKey.tr(),
                  style: AppStyle.labelSmall.copyWith(
                    color: AppColors.grey,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  value ?? '—',
                  style: AppStyle.h6.copyWith(
                    fontWeight:
                        emphasizeValue ? FontWeight.w800 : FontWeight.w700,
                    color: valueColor,
                    fontSize: 16.sp,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _iconColorForKey(String labelKey) {
    final key = labelKey.toLowerCase();
    if (key.contains('warranty')) return AppColors.brown;
    if (key.contains('efficiency') ||
        key.contains('power') ||
        key.contains('output')) {
      return AppColors.secondaryColor;
    }
    if (key.contains('capacity') ||
        key.contains('battery') ||
        key.contains('storage')) {
      return AppColors.blue;
    }
    if (key.contains('panel') || key.contains('cell')) {
      return AppColors.grey;
    }
    return AppColors.grey;
  }

  IconData _iconForKey(String labelKey) {
    final key = labelKey.toLowerCase();
    if (key.contains('warranty')) return Icons.verified_user_outlined;
    if (key.contains('efficiency') ||
        key.contains('power') ||
        key.contains('output')) {
      return Icons.bolt_rounded;
    }
    if (key.contains('capacity') ||
        key.contains('battery') ||
        key.contains('storage')) {
      return Icons.battery_charging_full_rounded;
    }
    if (key.contains('panel') || key.contains('cell')) {
      return Icons.grid_view_rounded;
    }
    if (key.contains('weight')) return Icons.scale_rounded;
    if (key.contains('voltage')) return Icons.electrical_services_rounded;
    return Icons.info_outline_rounded;
  }
}

class CompareActionsSection extends StatefulWidget {
  final CompareProduct? firstProduct;
  final CompareProduct? secondProduct;
  final bool isSessionLoading;

  const CompareActionsSection({
    super.key,
    required this.firstProduct,
    required this.secondProduct,
    this.isSessionLoading = false,
  });

  @override
  State<CompareActionsSection> createState() => _CompareActionsSectionState();
}

class _CompareActionsSectionState extends State<CompareActionsSection> {
  int? _addingProductId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        if (state is CartActionSuccess) {
          DataHelper.showSnackBar(message: state.message, context: context);
          setState(() => _addingProductId = null);
        } else if (state is CartError) {
          DataHelper.showSnackBar(
            message: state.message,
            context: context,
            color: AppColors.red,
          );
          setState(() => _addingProductId = null);
        }
      },
      child: Row(
        children: [
          Expanded(
            child: _AddToCartButton(
              product: widget.firstProduct,
              outlined: true,
              isLoading: _addingProductId == widget.firstProduct?.detail.id,
              disabled: widget.isSessionLoading,
              onPressed: () => _addProduct(widget.firstProduct),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _AddToCartButton(
              product: widget.secondProduct,
              isLoading: _addingProductId == widget.secondProduct?.detail.id,
              disabled: widget.isSessionLoading,
              onPressed: () => _addProduct(widget.secondProduct),
            ),
          ),
        ],
      ),
    );
  }

  void _addProduct(CompareProduct? product) {
    if (product == null || !product.detail.isAvailable) return;

    setState(() => _addingProductId = product.detail.id);
    context.read<CartCubit>().addToCart(product.detail.id, 1);
  }
}

class _AddToCartButton extends StatelessWidget {
  final CompareProduct? product;
  final bool outlined;
  final bool isLoading;
  final bool disabled;
  final VoidCallback? onPressed;

  const _AddToCartButton({
    required this.product,
    this.outlined = false,
    this.isLoading = false,
    this.disabled = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final canAdd = product != null && product!.detail.isAvailable && !disabled;

    return CustomButton(
      text: 'product_detail_add_to_cart'.tr(),
      type: outlined ? ButtonType.outlined : ButtonType.filled,
      icon: Icons.add_shopping_cart_rounded,
      iconLeft: true,
      isLoading: isLoading,
      onPressed: canAdd ? onPressed : null,
    );
  }
}

class CompareHeaderSection extends StatelessWidget {
  final String? category;

  const CompareHeaderSection({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final subtitle = category == null || category!.isEmpty
        ? 'comparison_subtitle'.tr()
        : 'compare_category_locked'.tr(
            namedArgs: {
              'category': formatCompareCategoryLabel(category!),
            },
          );

    return Text(
      subtitle,
      style: AppStyle.bodyLarge.copyWith(
        color: AppColors.grey,
        height: 1.45,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
