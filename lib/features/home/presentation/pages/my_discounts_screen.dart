import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class MyDiscountsScreen extends StatelessWidget {
  const MyDiscountsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('my_discounts_title'.tr()), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
                children: [
                  _discountCard(
                    context,
                    code: 'SKD83G',
                    amount: '25\$',
                    expired: false,
                  ),
                  _discountCard(
                    context,
                    code: '4kfh3A',
                    amount: '34\$',
                    expired: true,
                  ),
                ],
              ),
            ),

    );
  }

  Widget _discountCard(
    BuildContext context, {
    required String code,
    required String amount,
    required bool expired,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: expired
            ? theme.colorScheme.error.withOpacity(0.08)
            : theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: expired
              ? theme.colorScheme.error.withOpacity(0.3)
              : theme.dividerColor,
        ),
      ),
      child: ListTile(
        leading: Icon(
          Icons.discount_outlined,
          color: expired ? theme.colorScheme.error : theme.colorScheme.primary,
          size: 28,
        ),
        title: Row(
          spacing: 4,
          children: [
            Text(
              code,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(Icons.copy,size: 16,)
          ],
        ),
        subtitle: Text(
          expired ? 'discount_expired'.tr() : 'discount_active'.tr(),
          style: TextStyle(
            color: expired
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
            fontSize: 13,
          ),
        ),
        trailing: Text(
          amount,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: expired
                ? theme.colorScheme.error
                : theme.colorScheme.primary,
          ),
        ),
      ),
      //
    );
  }
}
