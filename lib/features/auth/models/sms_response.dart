class SmsResponse {
  final String verificationId;
  final String? errorText;

  SmsResponse({required this.verificationId, this.errorText});
}
