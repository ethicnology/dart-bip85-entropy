import 'package:bip85_entropy/bip85_entropy.dart';

class Bip85HardenedPath {
  late String _path;

  @override
  String toString() => _path;

  Bip85HardenedPath(String path) {
    if (path.isEmpty) {
      throw Bip85Exception('Path cannot be empty');
    }
    _validateHardenedPath(path);
    _path = path;
  }

  void _validateHardenedPath(String path) {
    // Remove the BIP85 prefix if present
    String cleanPath = path;
    const bip85Prefix = "m/83696968'";
    if (cleanPath.startsWith(bip85Prefix)) {
      cleanPath = cleanPath.substring(bip85Prefix.length);
    }

    // Split path into components
    final components = cleanPath.split('/').where((c) => c.isNotEmpty).toList();

    if (components.isEmpty) {
      throw Bip85Exception(
        'Path must contain at least one derivation component',
      );
    }

    // Check each component is hardened (ends with single quote)
    for (int i = 0; i < components.length; i++) {
      final component = components[i];

      if (!component.endsWith("'")) {
        throw Bip85Exception(
          'All BIP85 derivation path components must be hardened (end with single quote). '
          'Component "$component" at position $i is not hardened.',
        );
      }

      // Verify the part before the quote is a valid number
      final numberPart = component.substring(0, component.length - 1);
      if (numberPart.isEmpty || int.tryParse(numberPart) == null) {
        throw Bip85Exception(
          'Invalid path component "$component". Must be a number followed by a single quote.',
        );
      }
    }
  }
}
