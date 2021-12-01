import 'dart:io';
import 'dart:math';

import 'models/pcb.dart';
import 'models/queue.dart';

void main(List<String> arguments) async {
  final queues = List.generate(5, (i) => Queue(i))
    ..sort((prev, next) => next.priority.compareTo(prev.priority))
    ..forEach((q) => print(q));

  var processesToInitialize = 20;
  var lastValidAddress = 0;

  final _rand = Random();

  while (true) {
    if (processesToInitialize != 0) {
      final selectedQueue = queues[_rand.nextInt(5)];
      final newProcess = PCB(
        pid: 20 - processesToInitialize,
        priority: selectedQueue.priority,
        startingAddress: lastValidAddress,
      );

      print(newProcess);

      lastValidAddress = newProcess.endingAddress;

      selectedQueue.addPCB(newProcess);
      processesToInitialize--;
    }

    if (queues.every((q) => q.isEmpty)) break;

    final currentQueue = queues.firstWhere((q) => !q.isEmpty);
    await currentQueue.run();

    print(Process.runSync("clear", [], runInShell: true).stdout);
    for (final q in queues) {
      q.printQueue();
    }
  }
}
