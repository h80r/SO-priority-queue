import 'dart:math';

/// Classe que representa um PCB
class PCB {
  PCB({
    required this.pid,
    required this.priority,
    required this.startingAddress,
  }) {
    /// Gerador de números pseudo-aleatórios.
    final rand = Random();

    /// Define a data de criação do PCB
    creation = DateTime.now();

    /// Gera aleatoriamente um nome para o processo
    name = firstName[rand.nextInt(5)] + lastName[rand.nextInt(7)];

    /// Gera aleatoriamente um tempo de execução para o processo
    executionTime = rand.nextInt(10) + 1;

    /// Calcula o endereço de término do PCB
    endingAddress = startingAddress + executionTime;

    /// Inicializa o tempo de execução pendente com o tempo de execução
    pendingExecutionTime = executionTime;
  }

  /// ID único do processo
  final int pid;

  /// Nível de prioridade do processo
  final int priority;

  /// Endereço de início do processo
  final int startingAddress;

  /// Nome do processo
  late final String name;

  /// Horário de criação do processo
  late final DateTime creation;

  /// Tempo de execução do processo
  late final int executionTime;

  /// Endereço de término do processo
  late final int endingAddress;

  /// Tempo de execução pendente do processo
  int pendingExecutionTime = 0;

  /// Informa se o processo já foi concluído
  bool get isFinished => pendingExecutionTime == 0;

  /// Executa o processo pelo [delta] especificado
  Future<void> run(int delta) async {
    while (delta != 0 && pendingExecutionTime != 0) {
      /// Simula a execução do processo por 1 segundo
      await Future.delayed(Duration(seconds: 1));

      pendingExecutionTime--;
      delta--;
    }
  }

  @override
  String toString() {
    return '\t[$pid] $name (${pendingExecutionTime}s)'
        '\n\t\tPointers: [$startingAddress - $endingAddress]'
        '\n\t\tCreated at: $creation';
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
