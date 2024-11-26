class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;

  //该类是返回消息的样子,
  ApiResponse({required this.success, required this.message, this.data});

      //接受俩参数
  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(Object? json)? fromJsonT,
      ) =>
      //然后转变成ApiResponse
      ApiResponse(
        //当add,delete等body不会携带data也就不需要解析,第二个参数为null
        //当get就需要函数来解析，例如
        //ApiResponse<List<Category>> apiResponse = ApiResponse<List<Category>>.fromJson(
        //   response.body,
        //   (json) => (json as List).map((item) => Category.fromJson(item)).toList(),
        // );
        success: json['success'] as bool,
        message: json['message'] as String,
        data: json['data'] != null ? fromJsonT!(json['data']) : null,
      );
}
