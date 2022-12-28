class UserData {
  final String? name;
  final String? email;
  final String? id;
  final String? photoUrl;
  final bool isLoggedIn;

  const UserData(
      {this.name,
      this.email,
      this.id,
      this.photoUrl,
      required this.isLoggedIn});
}
