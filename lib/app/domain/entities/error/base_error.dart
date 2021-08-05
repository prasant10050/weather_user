import 'dart:convert';

BaseErrorModel baseErrorModelFromJson(String str) =>
    BaseErrorModel.fromJson(json.decode(str));

String baseErrorModelToJson(BaseErrorModel data) => json.encode(data.toJson());

class BaseErrorModel {
  BaseErrorModel({
    required this.responseCode,
    required this.message,
  });

  final int responseCode;
  final String message;

  BaseErrorModel copyWith({
    int? responseCode,
    String? message,
  }) =>
      BaseErrorModel(
        responseCode: responseCode ?? this.responseCode,
        message: message ?? this.message,
      );

  factory BaseErrorModel.fromJson(Map<String, dynamic> json) => BaseErrorModel(
        responseCode:
            json['response_code'] == null ? null : json['response_code'],
        message: json['message'] == null ? null : json['message'],
      );

  Map<String, dynamic> toJson() => {
        'response_code': responseCode == null ? null : responseCode,
        'message': message == null ? null : message,
      };
}
