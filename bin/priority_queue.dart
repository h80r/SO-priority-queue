import 'dart:io';
import 'dart:math';

import 'package:interact/interact.dart';

import 'models/pcb.dart';
import 'models/queue.dart';

void main(List<String> arguments) async {
  /// Número de filas que o usuário deseja simular
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

  /// Lista contendo todas as filas geradas.
  ///
  /// Depois que todas as filas são geradas, a lista é ordenada de forma que
  /// a fila com maior prioridade fique no início da lista.
  final queues = List.generate(queueCount, (i) => Queue(i))
    ..sort((prev, next) => next.priority.compareTo(prev.priority));

  /// Número de processos que o usuário deseja simular
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

  /// Contador que indica quantos processos ainda precisam ser inicializados
  var processesToInitialize = processCount;

  /// Variável auxiliar, indica qual o último endereço válido para um processo
  var lastValidAddress = 0;

  /// Gerador de números pseudo-aleatórios.
  final _rand = Random();

  while (true) {
    /// Condicional que verifica se todos os processos já foram inicializados
    if (processesToInitialize != 0) {
      /// Seleciona uma fila aleatória para inicializar um processo.
      ///
      /// Simula que cada processo tem uma prioridade diferente.
      final selectedQueue = queues[_rand.nextInt(queueCount)];

      /// Inicializa um novo processo
      final newProcess = PCB(
        pid: processCount - processesToInitialize,
        priority: selectedQueue.priority,
        startingAddress: lastValidAddress,
      );

      /// Atualiza o último endereço válido
      lastValidAddress = newProcess.endingAddress;

      /// Adiciona o novo PCB à fila selecionada
      selectedQueue.addPCB(newProcess);

      /// Decrementa o contador de processos a serem inicializados
      processesToInitialize--;
    }

    /// Verifica se todas as filas estão vazias
    ///
    /// Se todas as filas estiverem vazias, significa que todos os PCBs foram
    /// concluídos e o programa pode ser encerrado.
    if (queues.every((q) => q.isEmpty)) break;

    /// Seleciona a fila com maior prioridade para executar o processo.
    ///
    /// Irá ignorar filas de alta prioridade que não possuem processos.
    final currentQueue = queues.firstWhere((q) => !q.isEmpty);

    /// Código auxiliar para exibição de informações na tela
    print(Process.runSync("clear", [], runInShell: true).stdout);
    for (final q in queues) {
      q.printQueue(isCurrent: q == currentQueue);
    }

    /// Executa o processo da fila com maior prioridade
    await currentQueue.run();
  }

  /// Código auxiliar para exibição de informações na tela
  print(Process.runSync("clear", [], runInShell: true).stdout);
}
