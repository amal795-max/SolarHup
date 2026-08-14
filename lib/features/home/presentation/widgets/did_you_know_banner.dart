import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/home/data/models/tip_model.dart';

class DidYouKnowBanner extends StatefulWidget {
  final List<TipModel> tips;

  const DidYouKnowBanner({
    super.key,
    required this.tips,
  });

  @override
  State<DidYouKnowBanner> createState() => _DidYouKnowBannerState();
}

class _DidYouKnowBannerState extends State<DidYouKnowBanner> {
  static const _rotationInterval = Duration(seconds: 5);

  final PageController _controller = PageController(viewportFraction: 0.88);
  Timer? _timer;
  int _currentIndex = 0;

  bool get _canRotate => widget.tips.length >= 2;

  @override
  void initState() {
    super.initState();
    _startRotationTimer();
  }

  @override
  void didUpdateWidget(covariant DidYouKnowBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tips.length != widget.tips.length) {
      _currentIndex = 0;
      if (_controller.hasClients) {
        _controller.jumpToPage(0);
      }
      _startRotationTimer();
    }
  }

  void _startRotationTimer() {
    _timer?.cancel();
    if (!_canRotate) return;

    _timer = Timer.periodic(_rotationInterval, (_) {
      if (!_controller.hasClients || !_canRotate) return;

      final current = _controller.page?.round() ?? _currentIndex;
      final nextPage = (current + 1) % widget.tips.length;

      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) => AspectRatio(
            aspectRatio: constraints.maxWidth > 600 ? 4 : 2.5,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.tips.length,
              physics: _canRotate
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemBuilder: (context, index) {
                final tip = widget.tips[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 10.w),
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: const [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              tip.title,
                              style: AppStyle.bodySmall.copyWith(
                                color: AppColors.lightGrey,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.tips_and_updates,
                            color: AppColors.secondaryColor,
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        tip.description,
                        style: AppStyle.bodyXSmall.copyWith(
                          color: AppColors.blue,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        if (_canRotate) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.tips.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                width: _currentIndex == index ? 20.w : 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  color: _currentIndex == index
                      ? AppColors.tertiaryColor
                      : AppColors.tertiaryColor.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
