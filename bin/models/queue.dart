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

  void printQueue({bool isCurrent = false}) {
    print(isCurrent ? '\x1B[33m${this}\x1B[0m' : this);
    for (var i = 0; i < _pcbs.length; i++) {
      print(isCurrent
          ? i == currentPID
              ? '\x1B[36m${_pcbs[i]}\x1B[0m'
              : '\x1B[33m${_pcbs[i]}\x1B[0m'
          : _pcbs[i]);
    }
  }

  @override
  String toString() {
    return 'Queue $qid (Priority: $priority, Delta: $delta)';
  }
}
