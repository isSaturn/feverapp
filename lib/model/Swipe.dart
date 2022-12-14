import 'package:cloud_firestore/cloud_firestore.dart';

class Swipe {
  String id = '';
  String user1 = '';
  String user2 = '';
  bool hasBeenSeen = false;
  String type = 'dislike';
  Timestamp createdAt = Timestamp.now();

  Swipe(
      {this.id,
      this.user1,
      this.user2,
      this.createdAt,
      this.hasBeenSeen,
      this.type});

  factory Swipe.fromJson(Map<String, dynamic> parsedJson) {
    return new Swipe(
        id: parsedJson['id'] ?? "",
        user1: parsedJson['user1'] ?? "",
        user2: parsedJson['user2'] ?? '',
        createdAt: parsedJson['createdAt'] ?? Timestamp.now(),
        hasBeenSeen: parsedJson['hasBeenSeen'] ?? false,
        type: parsedJson['type'] ?? 'dislike');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      "user1": this.user1,
      "user2": this.user2,
      "createdAt": this.createdAt,
      'hasBeenSeen': this.hasBeenSeen,
      'type': this.type
    };
  }
}
