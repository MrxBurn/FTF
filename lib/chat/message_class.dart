class Message {
  String? senderName;
  String? message;
  String? senderId;
  DateTime? sentTime;

  Message({this.senderName, this.message, this.senderId});

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'message': message,
      'senderId': senderId,
      'sentTime': sentTime
    };
  }
}
