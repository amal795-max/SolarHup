import "package:flutter/material.dart";

import "full_screen_loader.dart";

GlobalKey<State> loaderKey = GlobalKey<State>();

void showLoader(BuildContext context) {
  showDialog<dynamic>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const FullScreenLoader();
    },
    // ignore: invalid_use_of_protected_member
  ).then((_) => loaderKey.currentState?.dispose());
}
