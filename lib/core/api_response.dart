class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T? data;

  ApiResponse({
    required this.statusCode,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromData,
  ) {
    return ApiResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: json['data'] != null ? fromData(json['data']) : null,
    );
  }

  factory ApiResponse.fromJsonList(
    List<dynamic> json,
    T Function(dynamic) fromData,
    int statusCode,
  ) {
    return ApiResponse(
      statusCode: statusCode,
      message: 'Success',
      data: fromData(json),
    );
  }
}
