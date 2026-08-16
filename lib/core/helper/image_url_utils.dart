import 'package:untitled1/core/constants/environment_config.dart';

String _mediaOrigin() {
  final uri = Uri.parse(EnvironmentConfig.apiEndpoint);
  final defaultPort = uri.scheme == 'https' ? 443 : 80;
  final portSuffix =
      uri.hasPort && uri.port != defaultPort ? ':${uri.port}' : '';
  return '${uri.scheme}://${uri.host}$portSuffix';
}

/// Turns API image paths into full URLs.
/// Supports absolute URLs, protocol-relative URLs, and `/uploads/...` paths.
String resolveImageUrl(String? image) {
  if (image == null) return '';

  final trimmed = image.trim();
  if (trimmed.isEmpty) return '';

  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.hasScheme && uri.isAbsolute) {
    return trimmed;
  }

  if (trimmed.startsWith('//')) {
    return 'https:$trimmed';
  }

  final path = trimmed.startsWith('/') ? trimmed : '/$trimmed';
  return '${_mediaOrigin()}$path';
}

bool isDisplayableImageUrl(String? image) {
  if (image == null || image.trim().isEmpty) return false;

  final resolved = resolveImageUrl(image);
  final uri = Uri.tryParse(resolved);
  return uri != null && uri.hasScheme && uri.host.isNotEmpty;
}
