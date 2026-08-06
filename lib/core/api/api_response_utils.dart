Map<String, dynamic> unwrapApiPayload(Map<String, dynamic> json) {
  final data = json['data'];
  if (data is Map<String, dynamic>) return data;
  return json;
}

Map<String, dynamic> unwrapProductPayload(Map<String, dynamic> json) {
  final payload = unwrapApiPayload(json);
  final product = payload['product'];
  if (product is Map<String, dynamic>) return product;
  return payload;
}
