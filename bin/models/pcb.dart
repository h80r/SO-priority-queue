import 'dart:math';

class PCB {
  PCB({
    required this.pid,
    required this.priority,
    required this.startingAddress,
  }) {
    final rand = Random();

    creation = DateTime.now();
    name = firstName[rand.nextInt(5)] + lastName[rand.nextInt(7)];
    executionTime = rand.nextInt(10) + 1;
    endingAddress = startingAddress + executionTime;
    pendingExecutionTime = executionTime;
  }

  final int pid;
  final int priority;
  final int startingAddress;
  late final String name;
  late final DateTime creation;
  late final int executionTime;
  late final int endingAddress;

  int pendingExecutionTime = 0;

  bool get isFinished => pendingExecutionTime == 0;

  void run(int delta) {
    while (delta != 0 && pendingExecutionTime != 0) {
      Future.delayed(Duration(seconds: 1)).then((_) {
        pendingExecutionTime--;
        delta--;
      });
    }
  }
}

const firstName = [
  'Facebook',
  'Amazon',
  'Apple',
  'Netflix',
  'Google',
];

const lastName = [
  ' Browser',
  ' File Manager',
  ' Music Player',
  ' Video Player',
  ' Messenger',
  ' Game Engine',
  ' Code Editor',
];
