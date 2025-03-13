import 'dart:io';

import 'package:flutter_launcher_name/android.dart';
import 'package:flutter_launcher_name/constants.dart' as constants;
import 'package:flutter_launcher_name/ios.dart';
import 'package:yaml/yaml.dart';

void exec() {
  print('════════════════════════════════════════════');
  print("            FLUTTER LAUNCHER NAME           ");
  print('════════════════════════════════════════════');

  final config = loadConfigFile();

  final newName = config['name'];

  print('- Overwriting app name Android');
  overwriteAndroidManifest(newName);
  print('- Overwriting app name iOS');
  overwriteInfoPlist(newName);

  print('Successfully generated app name');
}

Map<String, dynamic> loadConfigFile() {
  try {
    final File file = File('pubspec.yaml');
    final String yamlString = file.readAsStringSync();
    final Map yamlMap = loadYaml(yamlString);

    if (!(yamlMap[constants.yamlKey] is Map)) {
      throw Exception('flutter_launcher_name was not found');
    }

    final Map<String, dynamic> config = <String, dynamic>{};
    for (MapEntry<dynamic, dynamic> entry in yamlMap[constants.yamlKey].entries) {
      config[entry.key] = entry.value;
    }

    return config;
  } catch (e) {
    print('Error loading config file: $e');
    return {};
  }
}
