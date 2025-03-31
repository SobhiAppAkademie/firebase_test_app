class DatabaseUser {
  final String email;
  final bool isBlocked;
  final String name;
  final int rank;
  final DateTime lastLogin;

  DatabaseUser(
      {required this.email,
      required this.isBlocked,
      required this.name,
      required this.rank,
      required this.lastLogin});

  factory DatabaseUser.fromMap(Map<String, dynamic> map) {
    return DatabaseUser(
        email: map["email"],
        isBlocked: map["isBlocked"],
        name: map["name"],
        lastLogin: map["lastLogin"].toDate(),
        rank: map["rank"]);
  }
}
