abstract class AuthRepository {
  Future<String?> signInWithEmailPassword(String email, String password);
  Future<String?> registerWithEmailPassword(String email, String password);
  Future<void> logOut();
  Future<String?> signInWithGoogle();
  Stream<dynamic> onAuthChanged();
}
