import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:untitled1/core/routing/app_routes.dart';

/// Opens the reviews list. Rating is only allowed after order/service completion.
void openReviewsScreen(
  BuildContext context, {
  required String itemType,
  required int itemId,
  required String itemName,
  bool showReviewForm = false,
}) {
  if (itemId <= 0) return;

  context.push(
    AppRoutes.reviewsScreen,
    extra: {
      'itemType': itemType,
      'itemId': itemId.toString(),
      'itemName': itemName,
      'showReviewForm': showReviewForm,
    },
  );
}
