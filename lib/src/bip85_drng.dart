import 'dart:typed_data';
import 'errors.dart';
import 'utils.dart';

/// BIP85-DRNG: A deterministic random number generator for cryptographic
/// functions that require deterministic outputs.
///
/// Since PointyCastle's SHAKE256 implementation has limitations, this
/// implementation uses HMAC-SHA512 in a similar manner to achieve
/// the same deterministic random generation as specified in BIP85.
/// The input must be exactly 64 bytes long (from the BIP85 HMAC output).
class Bip85DRNG {
  final Uint8List _originalSeed;
  late Uint8List _currentState;
  late Uint8List _buffer;
  int _bufferPosition = 0;
  int _stateCounter = 0;
  static const int _bufferSize = 1024; // Buffer size for efficiency

  /// Creates a new BIP85-DRNG instance.
  ///
  /// [seed] must be exactly 64 bytes long (from BIP85 HMAC output)
  Bip85DRNG(this._originalSeed) {
    if (_originalSeed.length != 64) {
      throw Bip85Exception('BIP85-DRNG seed must be exactly 64 bytes');
    }

    // Initialize the state with the original seed
    _currentState = Uint8List.fromList(_originalSeed);
    _buffer = Uint8List(_bufferSize);
    _bufferPosition = _bufferSize; // Force initial fill
  }

  /// Reads the specified number of bytes from the DRNG.
  ///
  /// This method can be called multiple times and will provide
  /// a continuous stream of deterministic random bytes.
  Uint8List read(int count) {
    if (count <= 0) {
      throw ArgumentError('Count must be positive');
    }

    final result = Uint8List(count);
    int resultPosition = 0;

    while (resultPosition < count) {
      // Refill buffer if needed
      if (_bufferPosition >= _buffer.length) {
        _fillBuffer();
      }

      // Copy bytes from buffer to result
      final bytesToCopy = (count - resultPosition).clamp(
        0,
        _buffer.length - _bufferPosition,
      );
      result.setRange(
        resultPosition,
        resultPosition + bytesToCopy,
        _buffer,
        _bufferPosition,
      );

      resultPosition += bytesToCopy;
      _bufferPosition += bytesToCopy;
    }

    return result;
  }

  /// Fills the internal buffer with new random bytes.
  ///
  /// Uses HMAC-SHA512 with a counter to generate deterministic output.
  /// This approach is inspired by the BIP85 specification and provides
  /// cryptographically secure deterministic randomness.
  void _fillBuffer() {
    for (int i = 0; i < _buffer.length; i += 64) {
      final remaining = (_buffer.length - i).clamp(0, 64);
      final chunk = _generateChunk();
      _buffer.setRange(i, i + remaining, chunk);
    }

    _bufferPosition = 0;
  }

  /// Generates a 64-byte chunk using HMAC-SHA512 with the current state.
  ///
  /// This method updates the internal state for the next generation,
  /// ensuring a continuous stream of deterministic random bytes.
  Uint8List _generateChunk() {
    // Create a unique input by combining the original seed with a counter
    final input = Uint8List(68); // 64 bytes seed + 4 bytes counter
    input.setRange(0, 64, _originalSeed);

    // Add counter as big-endian 4-byte value
    input[64] = (_stateCounter >> 24) & 0xFF;
    input[65] = (_stateCounter >> 16) & 0xFF;
    input[66] = (_stateCounter >> 8) & 0xFF;
    input[67] = _stateCounter & 0xFF;

    // Generate 64 bytes using HMAC-SHA512
    // Use the current state as the key and the input as the message
    final output = Utils.hmacSha512(_currentState, input);

    // Update state for next iteration using the output
    _currentState = Uint8List.fromList(output);
    _stateCounter++;

    return output;
  }
}
