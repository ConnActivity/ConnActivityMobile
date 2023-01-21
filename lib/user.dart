/// The User Data class, used to store the current user data.
/// Note that many of the fields are nullable, because a user that is not logged
/// in has no data.
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
