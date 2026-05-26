import 'dart:io';

abstract class NetworkInfo{
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo{
  NetworkInfoImpl();
  @override
  Future<bool> get isConnected async {
    try {
      final List<InternetAddress> result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e){
      return false;
    }
  }
}

