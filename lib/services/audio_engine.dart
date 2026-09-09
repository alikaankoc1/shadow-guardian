import 'audio_engine_stub.dart'
    if (dart.library.js_interop) 'audio_engine_web.dart';

abstract class AudioEngine {
  Future<void> playBgm(String assetPath, {double volume = 0.4});
  Future<void> pauseBgm();
  Future<void> playSfx(String assetPath, {double volume = 0.85});
}

AudioEngine createAudioEngine() => createAudioEngineImpl();
