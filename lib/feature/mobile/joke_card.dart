import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../model/Joke_model.dart';

class JokeCard extends StatelessWidget {
  final Joke joke;
  final VoidCallback onLiked;
  final VoidCallback onDisliked;

  const JokeCard({super.key,
    required this.joke,
    required this.onLiked,
    required this.onDisliked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(

      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              color: color1,
              elevation: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 350,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        joke.text,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(150, 37)),
            ),
                  onPressed: () {
                    onLiked();
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: const Text('This is funny!'),
                       action: SnackBarAction(
                         label: 'Dismiss',
                         onPressed: () {
                           ScaffoldMessenger.of(context).hideCurrentSnackBar();
                         },
                       ),
                     ),
                  );},
                  child: const Text('This is funny!'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    onDisliked();
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(content: const Text('This is not funny.'),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),

                  );},
                  child: const Text('This is not funny.'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}