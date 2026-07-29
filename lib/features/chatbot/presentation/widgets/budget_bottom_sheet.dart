import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:untitled1/features/chatbot/presentation/bloc/chat_bot_cubit.dart';
import 'package:untitled1/widgets/custom_text_field.dart';
import 'package:untitled1/widgets/primary_button.dart';

class BudgetBottomSheet extends StatelessWidget {
  final ChatBotCubit cubit;

  const BudgetBottomSheet({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 40.h,
        left: 20.w,
        right: 20.w,
        top: 20.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Text(
            'set_budget_title'.tr(),
            style: AppStyle.bodyLarge,
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            controller: cubit.budgetController,
            hint: 'enter_budget_hint'.tr(),
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            title: '',
            hasTitle: false,
          ),
          SizedBox(height: 16.h),
          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'confirm'.tr(),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Expanded(
                child: CustomButton(
                  text: 'clear'.tr(),
                  type: ButtonType.outlined,
                  onPressed: () {
                    cubit.budgetController.clear();
                    Navigator.pop(context);
                  },
                ),
              ),

            ],
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }
}
