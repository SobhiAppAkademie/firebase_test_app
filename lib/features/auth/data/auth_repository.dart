import 'package:testvlapp/features/auth/models/sms_response.dart';

abstract class AuthRepository {
  Future<String?> signInWithEmailPassword(String email, String password);
  Future<String?> registerWithEmailPassword(String email, String password);
  Future<void> logOut();
  Future<String?> signInWithGoogle();
  Stream<dynamic> onAuthChanged();
  Future<String?> resetPassword(String email);
  Future<SmsResponse> sendSMSCode(String phone);
  Future<String?> signInWithPhoneNumber(String verificationId, String smsCode);
}
