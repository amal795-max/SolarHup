import "dart:io";

class CheckInternet {
  static Future<bool> checkConnect() async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup(
        "google.com",
      );
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}
