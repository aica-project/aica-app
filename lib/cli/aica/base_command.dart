import 'package:args/args.dart';

abstract class Command {
  String get name; // Nom de la commande
  String get description; // Description de la commande
  ArgParser get parser; // Parser spécifique à la commande

  void execute(ArgResults args); // Logique d'exécution
}
