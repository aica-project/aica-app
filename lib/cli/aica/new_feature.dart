import 'dart:io';
import 'package:args/args.dart';
import 'base_command.dart';

class NewFeatureCommand extends Command {
  @override
  String get name => 'nf';

  @override
  String get description => 'Créer une nouvelle feature.';

  @override
  ArgParser get parser => ArgParser()
    ..addOption('name',
        abbr: 'n', help: 'Nom de la feature à créer.', mandatory: true);

  @override
  void execute(ArgResults args) {
    final featureName = args['name'] as String;
    _generateFeature(featureName);
  }

  void _generateFeature(String featureName) {
    final rootPath = 'lib/features/$featureName';
    final directories = [
      '$rootPath/domain/entities',
      '$rootPath/domain/enums',
      '$rootPath/domain/providers',
      '$rootPath/domain/state',
      '$rootPath/presentation/screen',
      '$rootPath/presentation/widget',
      '$rootPath/services',
    ];

    for (final dir in directories) {
      final directory = Directory(dir);
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
        print('Création du dossier : $dir');
      } else {
        print('Le dossier existe déjà : $dir');
      }
    }

    print('Feature "$featureName" générée avec succès.');
  }
}
