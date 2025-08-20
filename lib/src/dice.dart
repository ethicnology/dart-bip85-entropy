import 'dart:math';
import 'dart:typed_data';

import 'package:bip85/bip85.dart';
import 'package:bip85/src/utils.dart';

List<int> deriveDiceRolls(String xprvBase58, int sides, int rolls, int index) {
  if (sides < 2 || sides > 0xFFFFFFFF) {
    throw Bip85Exception('Sides must be between 2 and 2^32-1');
  }
  if (rolls < 1 || rolls > 0xFFFFFFFF) {
    throw Bip85Exception('Rolls must be between 1 and 2^32-1');
  }

  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      DiceApplication(),
      "$sides'/$rolls'/$index'",
    );

    final drng = _Bip85DRNG(entropy);

    final bitsPerRoll = (log(sides) / log(2)).ceil();
    final bytesPerRoll = (bitsPerRoll / 8).ceil();

    final results = <int>[];

    while (results.length < rolls) {
      final bytes = drng.getBytes(bytesPerRoll);
      int value = 0;

      // Convert bytes to integer (big endian)
      for (int i = 0; i < bytes.length; i++) {
        value = (value << 8) | bytes[i];
      }

      // Trim excess bits
      if (bitsPerRoll < bytesPerRoll * 8) {
        final excessBits = (bytesPerRoll * 8) - bitsPerRoll;
        value = value >> excessBits;
      }

      // Check if value is within range
      if (value < sides) {
        results.add(value);
      }
    }

    return results;
  } catch (e) {
    throw Bip85Exception('Failed to derive dice rolls: $e');
  }
}

// Simple DRNG implementation for dice rolls
class _Bip85DRNG {
  late Uint8List _state;
  int _position = 0;

  _Bip85DRNG(Uint8List seed) {
    if (seed.length != 64) {
      throw ArgumentError('Seed must be exactly 64 bytes');
    }
    _state = Uint8List.fromList(seed);
  }

  Uint8List getBytes(int count) {
    final result = Uint8List(count);

    for (int i = 0; i < count; i++) {
      if (_position >= _state.length) {
        _expand();
      }
      result[i] = _state[_position++];
    }

    return result;
  }

  void _expand() {
    _state = Utils.hmacSha512(_state, _state);
    _position = 0;
  }
}
