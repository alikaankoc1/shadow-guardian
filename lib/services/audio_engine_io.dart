import 'package:flutter/services.dart';

import 'audio_engine.dart';

/// Android / iOS / desktop audio via a tiny platform channel (no audioplayers).
///
/// Avoids native-assets / objective_c build breaks on Windows paths with spaces,
/// so Chrome preview and Android builds both work.
class _IoAudioEngine implements AudioEngine {
  static const _channel = MethodChannel('sevimli_golgeler/audio');

  String? _bgmAsset;

  @override
  Future<void> playBgm(String assetPath, {double volume = 0.4}) async {
    try {
      await _channel.invokeMethod<void>('playBgm', {
        'asset': assetPath,
        'volume': volume,
        'loop': true,
        'reuse': _bgmAsset == assetPath,
      });
      _bgmAsset = assetPath;
    } on MissingPluginException {
      // Desktop / platforms without the channel — silent no-op.
    }
  }

  @override
  Future<void> pauseBgm() async {
    try {
      await _channel.invokeMethod<void>('pauseBgm');
    } on MissingPluginException {
      // ignore
    }
  }

  @override
  Future<void> playSfx(String assetPath, {double volume = 0.85}) async {
    try {
      await _channel.invokeMethod<void>('playSfx', {
        'asset': assetPath,
        'volume': volume,
      });
    } on MissingPluginException {
      // ignore
    }
  }
}

AudioEngine createAudioEngineImpl() => _IoAudioEngine();
