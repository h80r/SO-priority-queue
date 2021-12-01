import 'dart:math';

import 'pcb.dart';

/// Classe que representa uma fila
class Queue {
  Queue(this.qid) {
    /// Gerador de números pseudo-aleatórios
    final rand = Random();

    /// Gera uma prioridade aleatória para a fila
    priority = rand.nextInt(10);

    /// Gera um tempo delta aleatório para a fila
    delta = rand.nextInt(5) + 1;
  }

  /// Identificador único da fila
  final int qid;

  /// Lista de processos na fila
  final List<PCB> _pcbs = [];

  /// Prioridade da fila
  late final int priority;

  /// Delta de execução da fila
  late final int delta;

  /// ID (relativo à fila) do processo atualmente em execução
  int currentPID = 0;

  /// Função para adicionar um novo PCB à fila
  void addPCB(PCB newPCB) {
    _pcbs.add(newPCB);
  }

  /// Informa se a fila está vazia
  bool get isEmpty => _pcbs.isEmpty;

  /// Função para executar um processo na fila, aplicando Round Robin
  Future<void> run() async {
    await _pcbs[currentPID].run(delta);

    if (_pcbs[currentPID].isFinished) {
      _pcbs.removeAt(currentPID);
      currentPID = _pcbs.isEmpty ? 0 : currentPID % _pcbs.length;
      return;
    }

    currentPID = (currentPID + 1) % _pcbs.length;
  }

  /// Função auxiliar para imprimir a fila
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
