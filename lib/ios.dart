import 'dart:io';

import 'package:flutter_launcher_name/constants.dart' as constants;

/// Updates the line which specifies the CFBundleName within the Info.plist
/// with the new name (only if it has changed)
Future<void> overwriteInfoPlist(String name) async {
  final File iOSInfoPlistFile = File(constants.iOSInfoPlistFile);
  final List<String> lines = await iOSInfoPlistFile.readAsLines();

  bool requireChange = false;
  for (int x = 0; x < lines.length; x++) {
    String line = lines[x];
    // Check for the exact key line
    if (line.trim() == '<key>CFBundleDisplayName</key>') {
      // Check the next line is the string value line
      if (lines[x + 1].trim().startsWith('<string>') &&
          lines[x + 1].trim().endsWith('</string>')) {
        lines[x + 1] = '\t\t<string>$name</string>'; // Replace the value line
        requireChange = true;
        break;
      }
    }
  }

  if (requireChange) {
    await iOSInfoPlistFile.writeAsString(lines.join('\n'), flush: true);
  }
}
