import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../model/Joke_model.dart';
import 'joke_card.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference jokesCollection;
  late QuerySnapshot jokesSnapshot;
  int currentJokeIndex = 0;
  bool isLoading = true;
  bool hasMoreJokes = true;
  int totalJokesCount = 0;
  late TabController tabBarController;

  @override
  void initState() {
    super.initState();
    jokesCollection = firestore.collection('jokes');
    fetchJokes();
    tabBarController = TabController(
      length: 1,
      vsync: this,
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(65),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Image.asset(
                'assets/logo_1.jpg',
              )),
          actions: [Image.asset('assets/logo_2.jpg')],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 5,
          right: 5,
        ),
        child: SizedBox(
            height: 115,
            child: Center(
              child: Column(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(
                      right: 10,
                      left: 10,
                    ),
                    child: Text(
                      'This appis created as part of Hlsolution program. The material con-tained on this website are provided for general information only and do not constitute any from of advice. HLS assumes no responsibility for the accuracy of any particular statement and accepts no liability for any loss or damage which may arise from reliance on the infor-mation contained on this site.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Copyright 2021 HLS',
                    style: TextStyle(color: textC1, fontSize: 18),
                  )
                ],
              ),
            )),
      )),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 126,
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
                      : SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                  "That's all the jokes for today! Come back another day!"),
                            ],
                          ),
                        ),
            ],
          ),
        ),
      ),
      /*  floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          _showBottomSheet(context);
        },
        child: const Icon(Icons.add),
      ),*/
    );
  }

/*  void _showAddJokeDialog() {
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
  }*/

/*  void _showBottomSheet(BuildContext context) {
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
  }*/
}
