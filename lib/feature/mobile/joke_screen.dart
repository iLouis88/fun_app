import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/Joke_model.dart';
import 'joke_card.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference jokesCollection;
  late QuerySnapshot jokesSnapshot;
  int currentJokeIndex = 0;
  bool isLoading = true;
  bool hasMoreJokes = true;
  int totalJokesCount = 0;

  @override
  void initState() {
    super.initState();
    jokesCollection = firestore.collection('jokes');
    fetchJokes();
  }

  Future<void> fetchJokes() async {
    try {
      jokesSnapshot = await jokesCollection.get();
      setState(() {
        currentJokeIndex = 0;
        isLoading = false;
        hasMoreJokes = jokesSnapshot.docs.isNotEmpty;
        totalJokesCount = jokesSnapshot.docs.length;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        hasMoreJokes = false;
      });
      print('Failed to fetch jokes: $e');
    }
  }

  Future<void> addJoke(String jokeText) async {
    try {
      await jokesCollection.add({
        'text': jokeText,
        'likes': 0,
        'dislikes': 0,
      });
      print('Joke added successfully!');
    } catch (e) {
      print('Failed to add joke: $e');
    }
  }

  Future<void> vote(bool liked) async {
    if (liked) {
      await jokesCollection
          .doc(jokesSnapshot.docs[currentJokeIndex].id)
          .update({'likes': FieldValue.increment(1)});
    } else {
      await jokesCollection
          .doc(jokesSnapshot.docs[currentJokeIndex].id)
          .update({'dislikes': FieldValue.increment(1)});
    }
    showNextJoke();
  }

  void showNextJoke() {
    setState(() {
      currentJokeIndex++;
      if (currentJokeIndex >= jokesSnapshot.docs.length) {
        hasMoreJokes = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Joke App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
            Text(
              'Total Jokes: $totalJokesCount',
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: 100,
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'A joke a day keeps the doctor away',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'If you joke wrong way, you teeth have to pay.(Serious)',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
            isLoading
                ? const CircularProgressIndicator()
                : hasMoreJokes
                    ? JokeCard(
                        joke: Joke.fromSnapshot(
                            jokesSnapshot.docs[currentJokeIndex]),
                        onLiked: () => vote(true),
                        onDisliked: () => vote(false),
                      )
                    : Container(
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "That's all the jokes for today! Come back another day!"),
                          ],
                        ),
                      ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(top: 30),
              child: const Text('Copyright 2023 NVT'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddJokeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController jokeTextController = TextEditingController();

        return AlertDialog(
          title: const Text('Add Joke'),
          content: TextField(
            controller: jokeTextController,
            maxLines: 5,
            minLines: 1,
            decoration: const InputDecoration(
              hintText: 'Enter your joke',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                String jokeText = jokeTextController.text;
                if (jokeText.isNotEmpty) {
                  addJoke(jokeText);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Add successfully'),
                      action: SnackBarAction(
                        label: 'Dismiss',
                        onPressed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        },
                      ),
                    ),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.add_card_sharp),
                title: const Text('Add Joke'),
                onTap: () {
                  _showAddJokeDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
