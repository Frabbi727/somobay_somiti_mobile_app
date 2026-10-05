import 'package:json_annotation/json_annotation.dart';
import 'pagination_model.dart';

part 'api_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final int statusCode;
  final String message;
  final T? data;
  final Map<String, List<String>>? errors;
  final PaginationMeta? meta;

  const ApiResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.data,
    this.errors,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T? value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
