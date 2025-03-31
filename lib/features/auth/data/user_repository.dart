import 'package:testvlapp/features/auth/models/database_user.dart';

abstract class UserRepository {
  // UID erhalten wir von unseren Firebase Auth Instanz
  // bzw. eingeloggter User
  Future<DatabaseUser?> getUser(String uid);

  Future<List<DatabaseUser>> getAllUsers();
}
