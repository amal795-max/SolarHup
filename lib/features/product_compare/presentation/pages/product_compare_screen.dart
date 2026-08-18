import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_colors.dart';
import 'package:untitled1/features/product_compare/presentation/cubit/compare_session_cubit.dart';
import 'package:untitled1/features/product_compare/presentation/mappers/compare_spec_mapper.dart';
import 'package:untitled1/features/product_compare/presentation/widgets/compare_product_picker_sheet.dart';
import 'package:untitled1/features/product_compare/presentation/widgets/compare_sections.dart';
import 'package:untitled1/features/product_compare/presentation/widgets/compare_vs_celebration.dart';
import 'package:untitled1/widgets/back_button_widget.dart';
import 'package:untitled1/widgets/empty_widget.dart';
import 'package:untitled1/widgets/loader.dart';
import 'package:untitled1/widgets/primary_button.dart';

class ProductCompareScreen extends StatefulWidget {
  const ProductCompareScreen({super.key});

  @override
  State<ProductCompareScreen> createState() => _ProductCompareScreenState();
}

class _ProductCompareScreenState extends State<ProductCompareScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CompareSessionCubit>().refreshSelectedProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _ProductCompareView();
  }
}

class _ProductCompareView extends StatefulWidget {
  const _ProductCompareView();

  @override
  State<_ProductCompareView> createState() => _ProductCompareViewState();
}

class _ProductCompareViewState extends State<_ProductCompareView> {
  bool _showVsCelebration = false;
  bool _vsShownForCurrentPair = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final state = context.read<CompareSessionCubit>().state;
      if (state.isReadyForComparison && !_vsShownForCurrentPair) {
        _vsShownForCurrentPair = true;
        setState(() => _showVsCelebration = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocListener<CompareSessionCubit, CompareSessionState>(
          listenWhen: (previous, current) =>
              !previous.isReadyForComparison && current.isReadyForComparison,
          listener: (context, state) {
            if (!_vsShownForCurrentPair) {
              _vsShownForCurrentPair = true;
              setState(() => _showVsCelebration = true);
            }
          },
          child: BlocBuilder<CompareSessionCubit, CompareSessionState>(
            builder: (context, state) {
              if (!state.isReadyForComparison) {
                _vsShownForCurrentPair = false;
              }
            if (state.isLoading && state.selectedCount == 0) {
              return const LoadingIndicator();
            }

            if (state.selectedCount == 0) {
              return _CompareEmptyState(
                onBack: () => Navigator.of(context).maybePop(),
              );
            }

            final specRows = buildCompareSpecRows(
              first: state.firstProduct,
              second: state.secondProduct,
            );

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(8.w, 4.h, 16.w, 0),
                  child: Row(
                    children: [
                      const BackButtonWidget(),
                      Expanded(
                        child: Text(
                          'package_comparison_title'.tr(),
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed: state.selectedCount == 0
                            ? null
                            : () =>
                                context.read<CompareSessionCubit>().clear(),
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.grey,
                          size: 22.sp,
                        ),
                        tooltip: 'compare_clear'.tr(),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CompareHeaderSection(category: state.lockedCategory),
                            SizedBox(height: 16.h),
                            CompareProductCardsSection(
                              firstProduct: state.firstProduct,
                              secondProduct: state.secondProduct,
                              onTapFirst: () => showCompareProductPicker(
                                context: context,
                                slot: CompareSlot.first,
                              ),
                              onTapSecond: () => showCompareProductPicker(
                                context: context,
                                slot: CompareSlot.second,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            ComparePricingSection(
                              firstProduct: state.firstProduct,
                              secondProduct: state.secondProduct,
                            ),
                            if (specRows.isNotEmpty) ...[
                              SizedBox(height: 12.h),
                              CompareSpecsSection(rows: specRows),
                            ],
                            if (!state.isReadyForComparison) ...[
                              SizedBox(height: 16.h),
                              Text(
                                'compare_pick_second_hint'.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.grey),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (state.isLoading)
                        const ColoredBox(
                          color: Color(0x44FFFFFF),
                          child: Center(child: LoadingIndicator()),
                        ),
                      if (_showVsCelebration)
                        CompareVsCelebration(
                          onFinished: () {
                            if (mounted) {
                              setState(() => _showVsCelebration = false);
                            }
                          },
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: CompareActionsSection(
                    firstProduct: state.firstProduct,
                    secondProduct: state.secondProduct,
                    isSessionLoading: state.isLoading,
                  ),
                ),
              ],
            );
          },
        ),
        ),
      ),
    );
  }
}

class _CompareEmptyState extends StatelessWidget {
  final VoidCallback onBack;

  const _CompareEmptyState({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.w, top: 4.h),
            child: const BackButtonWidget(),
          ),
        ),
        Expanded(
          child: EmptyWidget(
            icon: Icons.compare_arrows_rounded,
            iconSize: 56,
            iconColor: AppColors.secondaryColor,
            title: 'compare_empty_title'.tr(),
            subtitle: 'compare_empty_subtitle'.tr(),
            action: CustomButton(
              text: 'compare_choose_first'.tr(),
              onPressed: () => showCompareProductPicker(
                context: context,
                slot: CompareSlot.first,
              ),
              width: 220.w,
            ),
          ),
        ),
      ],
    );
  }
}
