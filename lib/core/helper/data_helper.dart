import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/core/theme/app_style.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_url.dart';
import '../theme/app_colors.dart';
import 'local_storage.dart';

class DataHelper {
  static bool get isIos => Platform.isIOS;

  static void showSnackBar(
 {
   Color ? color ,
   required String message,
    required BuildContext context,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        behavior: SnackBarBehavior.floating,
        backgroundColor:color,
        content: Text(message.tr(),style:AppStyle.bodySmall),
      ),
    );
  }
  void showConfirmationDialog(BuildContext context,String title,String subtitle,VoidCallback? onPressed,{String? confirm}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title.tr()),
        content: Text(subtitle.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: onPressed,
            style: TextButton.styleFrom(foregroundColor: AppColors.red),
            child: Text(confirm?.tr()??'delete'.tr()),
          ),
        ],
      ),
    );
  }


  static String formatePhoneNumber(String phoneNumber) {
    String? phone = LocalStorage().getDataString(key: ApiKeys.phoneNumber);
    if (phoneNumber == '' && phone != null) {
      return phone;
    }
    String raw = phoneNumber.trim();
    if (raw.startsWith('0')) {
      raw = raw.substring(1);
    }
    return  '+963$raw';
  }
  static String dateFormat(String newPattern, DateTime date, {Locale? locale}) {
    final updatedDate = date.add(const Duration(hours: 3));
    return DateFormat(newPattern, locale?.languageCode).format(updatedDate);
  }


  Future<void> makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> openTelegram(String username) async {
    final telegramApp = Uri.parse('tg://resolve?domain=$username');
    final telegramWeb = Uri.parse('https://t.me/$username');

    if (await canLaunchUrl(telegramApp)) {
      await launchUrl(telegramApp, mode: LaunchMode.externalApplication);
    } else {
      await launchUrl(telegramWeb, mode: LaunchMode.externalApplication);
    }
  }
  String timeAgo(DateTime date, BuildContext context) {
    final diff = DateTime.now().difference(date);

    if (diff.inSeconds < 60) return 'just_now'.tr();
    if (diff.inMinutes < 60) return '${diff.inMinutes} ${'minutes_ago'.tr()}';
    if (diff.inHours < 24) return '${diff.inHours} ${'hours_ago'.tr()}';
    if (diff.inDays < 7) return '${diff.inDays} ${'days_ago'.tr()}';

    return dateFormat('dd MMM yyyy',date, locale:context.locale);
  }

}
