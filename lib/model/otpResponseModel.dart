class OtpResponse {
  final String token;
  final int status;
  final String message;

  OtpResponse(
      {required this.token, required this.status, required this.message});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      token: json['token'] ?? '',
      status: json['status'],
      message: json['message'],
    );
  }
}
