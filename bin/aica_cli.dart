import 'dart:io';

import 'package:aica_app/cli/aica/base_command.dart';
import 'package:aica_app/cli/aica/new_feature.dart';
import 'package:args/args.dart';

void main(List<String> arguments) {
  final commands = <Command>[
    NewFeatureCommand(),
  ];

  final parser = ArgParser();
  for (final command in commands) {
    parser.addCommand(command.name, command.parser);
  }

  if (arguments.isEmpty) {
    print('Usage : aica <commande> [options]');
    print('Commandes disponibles :');
    for (final command in commands) {
      print('  ${command.name} - ${command.description}');
    }
    return;
  }

  final result = parser.parse(arguments);
  final command = commands.firstWhere(
    (c) => c.name == result.command?.name,
    orElse: () {
      print('Commande inconnue : ${result.command?.name}');
      print('Commandes disponibles :');
      for (final cmd in commands) {
        print('  ${cmd.name} - ${cmd.description}');
      }
      exit(1); // Quitte le programme avec une erreur.
    },
  );

  command.execute(result.command!);
}
