import 'dart:io';

import 'package:flutter_launcher_name/constants.dart' as constants;

/// Updates the line which specifies the CFBundleName within the Info.plist
/// with the new name (only if it has changed)
Future<void> overwriteInfoPlist(String name) async {
  final File iOSInfoPlistFile = File(constants.iOSInfoPlistFile);
  final List<String> lines = await iOSInfoPlistFile.readAsLines();

  // there is no plist parser...
  // this is not good way
  bool requireChange = false;
  for (int x = 0; x < lines.length; x++) {
    String line = lines[x];
    if (line.contains('CFBundleName')) {
      requireChange = true;
      continue;
    }

    if (requireChange) {
      lines[x] = '	<string>$name</string>';
      requireChange = false;
    }
  }
  iOSInfoPlistFile.writeAsString(lines.join('\n'));
}

// Replace bundleId with new bundleId in project.pbxproj
Future<void> changeBundleIdInPbxproj(String bundleId) async {
  final File pbxprojFile = File(constants.iOSProjectPbxprojFile);
  final List<String> lines = await pbxprojFile.readAsLines();

  bool requireChange = false;
  for (int x = 0; x < lines.length; x++) {
    String line = lines[x];
    if (line.contains('PRODUCT_BUNDLE_IDENTIFIER')) {
      requireChange = true;
      continue;
    }

    if (requireChange) {
      lines[x] = '				PRODUCT_BUNDLE_IDENTIFIER = $bundleId;';
      requireChange = false;
    }
    pbxprojFile.writeAsString(lines.join('\n'));
  }
}
