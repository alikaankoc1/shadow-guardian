import 'audio_engine_stub.dart'
    if (dart.library.js_interop) 'audio_engine_web.dart'
    if (dart.library.io) 'audio_engine_io.dart';

abstract class AudioEngine {
  Future<void> playBgm(String assetPath, {double volume = 0.4});
  Future<void> pauseBgm();
  Future<void> playSfx(String assetPath, {double volume = 0.85});
}

AudioEngine createAudioEngine() => createAudioEngineImpl();
