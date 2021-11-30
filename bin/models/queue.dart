import 'dart:math';

import 'pcb.dart';

class Queue {
  Queue(this.qid) {
    final rand = Random();

    priority = rand.nextInt(10);
    delta = rand.nextInt(5) + 1;
  }

  final int qid;
  final List<PCB> _pcbs = [];
  late final int priority;
  late final int delta;

  int currentPID = 0;

  void addPCB(PCB newPCB) {
    _pcbs.add(newPCB);
  }

  PCB? removePCB() {
    if (_pcbs.isEmpty) return null;
    return _pcbs.removeAt(0);
  }

  void run() {
    if (_pcbs.isEmpty) return;
    _pcbs[currentPID].run(delta);
    currentPID = (currentPID + 1) % _pcbs.length;
  }

  @override
  String toString() {
    return 'Queue $qid (Priority: $priority, Delta: $delta)';
  }
}
