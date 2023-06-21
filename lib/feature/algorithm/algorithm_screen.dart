import 'package:flutter/material.dart';

class AlgorithmScreen extends StatefulWidget {
  const AlgorithmScreen({
    Key? key,
  }) : super(key: key);

  final String title = 'Solve the algorithm';

  @override
  State<AlgorithmScreen> createState() => _AlgorithmScreenState();
}

class _AlgorithmScreenState extends State<AlgorithmScreen> {
  List<int> arr = [];
  final TextEditingController controller = TextEditingController();

  void _calculateMinMaxSum() {
    arr.sort();
    int minSum = 0;
    int maxSum = 0;
    for (int i = 0; i < arr.length - 1; i++) {
      minSum += arr[i];
      maxSum += arr[i + 1];
    }

    setState(() {
      _minSum = minSum;
      _maxSum = maxSum;
    });
  }

  int _minSum = 0;
  int _maxSum = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Card(
                elevation: 20,
                shadowColor: Colors.green,
                child: Container(
                  width: 200,
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Min sum: $_minSum'),
                      Text('Max sum: $_maxSum'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 100),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Enter five space-separated integers',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        arr.clear();
                        _minSum = 0;
                        _maxSum = 0;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onChanged: (value) {
                  List<String> inputList = value.split(' ');
                  arr = inputList.map((e) => int.parse(e)).toList();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                onPressed: () {
                  _calculateMinMaxSum();
                },
                child: const Text('Calculate'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 260),
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: const Text(
                      "Copyright 2023 NVT",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
