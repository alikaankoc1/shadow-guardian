import 'package:audioplayers/audioplayers.dart';

import 'audio_engine.dart';

/// Android / iOS / desktop audio via audioplayers.
class _IoAudioEngine implements AudioEngine {
  _IoAudioEngine() {
    // Prefer media/game stream so volume keys and silent-switch behave correctly.
    AudioPlayer.global.setAudioContext(
      AudioContext(
        android: const AudioContextAndroid(
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.game,
          audioFocus: AndroidAudioFocus.gain,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: const {AVAudioSessionOptions.mixWithOthers},
        ),
      ),
    );
  }

  final AudioPlayer _bgm = AudioPlayer();
  final AudioPlayer _sfx = AudioPlayer();
  String? _bgmAsset;
  bool _bgmReady = false;

  String _sourcePath(String assetPath) {
    // AssetSource paths are relative to the assets/ folder.
    const prefix = 'assets/';
    if (assetPath.startsWith(prefix)) {
      return assetPath.substring(prefix.length);
    }
    return assetPath;
  }

  @override
  Future<void> playBgm(String assetPath, {double volume = 0.4}) async {
    final path = _sourcePath(assetPath);
    await _bgm.setReleaseMode(ReleaseMode.loop);
    await _bgm.setVolume(volume);
    if (_bgmReady && _bgmAsset == path) {
      final state = _bgm.state;
      if (state == PlayerState.paused || state == PlayerState.completed) {
        await _bgm.resume();
      }
      return;
    }
    _bgmAsset = path;
    _bgmReady = true;
    await _bgm.play(AssetSource(path));
  }

  @override
  Future<void> pauseBgm() async {
    if (_bgm.state == PlayerState.playing) {
      await _bgm.pause();
    }
  }

  @override
  Future<void> playSfx(String assetPath, {double volume = 0.85}) async {
    final path = _sourcePath(assetPath);
    await _sfx.stop();
    await _sfx.setVolume(volume);
    await _sfx.play(AssetSource(path));
  }
}

AudioEngine createAudioEngineImpl() => _IoAudioEngine();
