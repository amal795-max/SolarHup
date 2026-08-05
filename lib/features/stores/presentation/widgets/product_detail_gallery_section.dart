import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/stores/data/models/product_detail_model.dart';
import 'package:untitled1/features/stores/presentation/bloc/product_detail_bloc/product_detail_bloc.dart';
import 'package:untitled1/widgets/image_widget.dart';

class ProductDetailGallerySection extends StatefulWidget {
  final ProductDetailModel product;
  final int selectedIndex;

  const ProductDetailGallerySection({
    super.key,
    required this.product,
    required this.selectedIndex,
  });

  @override
  State<ProductDetailGallerySection> createState() =>
      _ProductDetailGallerySectionState();
}

class _ProductDetailGallerySectionState extends State<ProductDetailGallerySection> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.selectedIndex);
  }

  @override
  void didUpdateWidget(covariant ProductDetailGallerySection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex &&
        _pageController.hasClients &&
        _pageController.page?.round() != widget.selectedIndex) {
      _pageController.animateToPage(
        widget.selectedIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = widget.product.galleryItemCount;
    final hasImages = widget.product.imageUrls.isNotEmpty;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: 220.h,
            width: double.infinity,
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: itemCount,
                  onPageChanged: (index) {
                    context.read<ProductDetailBloc>().add(
                          SelectGalleryImageEvent(index: index),
                        );
                  },
                  itemBuilder: (context, index) {
                    if (hasImages) {
                      return ImageWidget(
                        image: widget.product.imageUrls[index],
                        height: 220.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        borderRadius: 0,
                      );
                    }
                    return _buildPlaceholder(theme);
                  },
                ),
                if (itemCount > 1)
                  Positioned(
                    bottom: 12.h,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(itemCount, (index) {
                        final isSelected = index == widget.selectedIndex;
                        return GestureDetector(
                          onTap: () {
                            context.read<ProductDetailBloc>().add(
                                  SelectGalleryImageEvent(index: index),
                                );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: isSelected ? 8.w : 6.w,
                              height: isSelected ? 8.w : 6.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? AppColors.secondaryColor
                                    : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.35),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (itemCount > 1) ...[
          SizedBox(height: 12.h),
          SizedBox(
            height: 56.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              separatorBuilder: (_, __) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final isSelected = index == widget.selectedIndex;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.read<ProductDetailBloc>().add(
                            SelectGalleryImageEvent(index: index),
                          );
                    },
                    borderRadius: BorderRadius.circular(10.r),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 56.w,
                      height: 56.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.secondaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: hasImages
                          ? ImageWidget(
                              image: widget.product.imageUrls[index],
                              width: 56.w,
                              height: 56.w,
                              fit: BoxFit.cover,
                              borderRadius: 0,
                            )
                          : _buildPlaceholder(theme),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    final mainColor = Color(widget.product.imagePlaceholderColorValue);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(
                  255,
                  (mainColor.r * 0.55).round(),
                  (mainColor.g * 0.55).round(),
                  (mainColor.b * 0.55).round(),
                ),
                mainColor,
              ],
            ),
          ),
        ),
        Positioned(
          right: -20.w,
          bottom: -20.h,
          child: Icon(
            Icons.solar_power_rounded,
            size: 140.sp,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}
