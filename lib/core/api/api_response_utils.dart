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

Map<String, dynamic> unwrapStorePayload(Map<String, dynamic> json) {
  final payload = unwrapApiPayload(json);
  final store = payload['store'];
  if (store is Map<String, dynamic>) return store;
  return payload;
}

Map<String, dynamic> unwrapWorkshopPayload(Map<String, dynamic> json) {
  final payload = unwrapApiPayload(json);
  final workshop = payload['workshop'];
  if (workshop is Map<String, dynamic>) return workshop;
  return payload;
}

Map<String, dynamic> unwrapOrderPayload(Map<String, dynamic> json) {
  final payload = unwrapApiPayload(json);
  final order = payload['order'];
  if (order is Map<String, dynamic>) return order;
  return payload;
}
