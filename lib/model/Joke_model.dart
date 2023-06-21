import 'package:cloud_firestore/cloud_firestore.dart';

class Joke {
  final String text;
  final int likes;
  final int dislikes;

  Joke({
    required this.text,
    required this.likes,
    required this.dislikes,
  });

  factory Joke.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Joke(
      text: data['text'] ?? '',
      likes: data['likes'] ?? 0,
      dislikes: data['dislikes'] ?? 0,
    );
  }
}
