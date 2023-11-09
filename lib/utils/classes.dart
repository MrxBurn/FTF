class UserClass {
  String uid;
  String weightClass;
  String firstName;
  String lastName;
  String fighterStatus;
  String route;
  String nationality;
  String gender;
  String description;
  String fighterType;
  String? profileImageURL;

  UserClass(
      {this.uid = '',
      this.weightClass = '',
      this.firstName = '',
      this.lastName = '',
      this.fighterStatus = '',
      this.route = '',
      this.nationality = '',
      this.gender = '',
      this.description = '',
      this.fighterType = '',
      this.profileImageURL});
}

class NegotiationValuesClass {
  DateTime? createdAt;
  int creatorValue;
  String fightDate;
  int opponentValue;
  String weightClass;

  NegotiationValuesClass({
    this.createdAt,
    this.creatorValue = 0,
    this.fightDate = '',
    this.opponentValue = 0,
    this.weightClass = '',
  });
}
