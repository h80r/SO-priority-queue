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

  bool get isEmpty => _pcbs.isEmpty;

  Future<void> run() async {
    await _pcbs[currentPID].run(delta);

    if (_pcbs[currentPID].isFinished) {
      _pcbs.removeAt(currentPID);
      currentPID = _pcbs.isEmpty ? 0 : currentPID % _pcbs.length;
      return;
    }

    currentPID = (currentPID + 1) % _pcbs.length;
  }

  void printQueue() {
    print(this);
    for (final pcb in _pcbs) {
      print(pcb.toString());
    }
  }

  @override
  String toString() {
    return 'Queue $qid (Priority: $priority, Delta: $delta)';
  }
}
