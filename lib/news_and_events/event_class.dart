class Event {
  String? sporTitle;
  String? commenceTime;
  String? homeTeam;
  String? awayTeam;

  Event({this.sporTitle, this.commenceTime, this.awayTeam, this.homeTeam});

  factory Event.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'sporTitle': String sporTitle,
        'commenceTime': String commenceTime,
        'homeTeam': String homeTeam,
        "awayTeam": String awayTeam
      } =>
        Event(
            sporTitle: sporTitle,
            commenceTime: commenceTime,
            homeTeam: homeTeam,
            awayTeam: awayTeam),
      _ => throw const FormatException('Failed to load event.'),
    };
  }
}
