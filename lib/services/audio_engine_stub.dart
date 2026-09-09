import 'audio_engine.dart';

class _StubAudioEngine implements AudioEngine {
  @override
  Future<void> playBgm(String assetPath, {double volume = 0.4}) async {}

  @override
  Future<void> pauseBgm() async {}

  @override
  Future<void> playSfx(String assetPath, {double volume = 0.85}) async {}
}

AudioEngine createAudioEngineImpl() => _StubAudioEngine();
