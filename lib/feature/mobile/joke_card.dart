import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../model/Joke_model.dart';

class JokeCard extends StatelessWidget {
  final Joke joke;
  final VoidCallback onLiked;
  final VoidCallback onDisliked;

  const JokeCard({
    super.key,
    required this.joke,
    required this.onLiked,
    required this.onDisliked,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
                    bottom: 128,
                    right: 40,
                    left: 40,
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    height: 278,

                      child: Text(
                        joke.text,
                        style: const TextStyle(fontSize: 15,
                        color: textC1,
                        ),
                        textAlign: TextAlign.justify,
                      ),

                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(145, 36)),
                  ),
                  onPressed: () {
                    onLiked();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('This is funny!'),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('This is funny!'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    onDisliked();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('This is not funny.'),
                        action: SnackBarAction(
                          label: 'Dismiss',
                          onPressed: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          },
                        ),
                      ),
                    );
                  },
                  child: const Text('This is not funny.'),
                ),
              ],
            ),
            const SizedBox(height: 55),
          ],
        ),

    );
  }
}
