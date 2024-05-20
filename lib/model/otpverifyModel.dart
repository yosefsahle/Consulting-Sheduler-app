class OtpVerificationResponse {
  final String token;
  final int status;
  final String message;

  OtpVerificationResponse(
      {required this.token, required this.status, required this.message});

  factory OtpVerificationResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerificationResponse(
      token: json['token'],
      status: json['status'],
      message: json['message'],
    );
  }
}
