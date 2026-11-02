import 'pagination_model.dart';

/// Reads a paginated envelope: `data` is the list, `meta` the pagination figures.
class ApiPage {
  ApiPage._();

  static ({List<T> items, PaginationMeta? meta}) parse<T>(dynamic body, T Function(Map<String, dynamic> json) fromJson) {
    final map = body as Map<String, dynamic>;
    final items = (map['data'] as List<dynamic>).map((item) => fromJson(item as Map<String, dynamic>)).toList();
    final meta = map['meta'] is Map<String, dynamic> ? PaginationMeta.fromJson(map['meta'] as Map<String, dynamic>) : null;

    return (items: items, meta: meta);
  }
}
