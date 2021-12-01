import 'dart:io';
import 'dart:math';

import 'package:interact/interact.dart';

import 'models/pcb.dart';
import 'models/queue.dart';

void main(List<String> arguments) async {
  final queueCount = int.parse(Input(
    prompt: 'Quantas filas você deseja?',
    defaultValue: '5',
    validator: (value) {
      final inputInt = int.tryParse(value);
      if (inputInt != null && inputInt >= 1 && inputInt <= 10) return true;
      if (inputInt == null) throw ValidationError('Valor inválido');
      if (inputInt < 1) throw ValidationError('Deve haver ao menos uma fila.');
      throw ValidationError('Deve haver no máximo 10 filas.');
    },
  ).interact());

  final queues = List.generate(queueCount, (i) => Queue(i))
    ..sort((prev, next) => next.priority.compareTo(prev.priority))
    ..forEach((q) => print(q));

  final processCount = int.parse(Input(
    prompt: 'Quantos processos você deseja simular?',
    defaultValue: '20',
    validator: (value) {
      final inputInt = int.tryParse(value);
      if (inputInt != null && inputInt >= 5 && inputInt <= 30) return true;
      if (inputInt == null) throw ValidationError('Valor inválido');
      if (inputInt < 5) throw ValidationError('Simule ao menos 5 processos.');
      throw ValidationError('Não é recomendável simular mais de 30 processos.');
    },
  ).interact());

  var processesToInitialize = processCount;

  var lastValidAddress = 0;

  final _rand = Random();

  while (true) {
    if (processesToInitialize != 0) {
      final selectedQueue = queues[_rand.nextInt(queueCount)];
      final newProcess = PCB(
        pid: processCount - processesToInitialize,
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

    print(Process.runSync("clear", [], runInShell: true).stdout);
    for (final q in queues) {
      q.printQueue(isCurrent: q == currentQueue);
    }

    await currentQueue.run();
  }

  print(Process.runSync("clear", [], runInShell: true).stdout);
}
