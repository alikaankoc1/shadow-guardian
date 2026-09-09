import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'audio_engine.dart';

/// Soft UI sounds + looping menu BGM. Persists mute across launches.
class SoundSettings {
  SoundSettings._();
  static final SoundSettings instance = SoundSettings._();

  static const _key = 'sound_enabled';
  static const bgmAsset = 'assets/audio/bgm.mp3';
  static const correctAsset = 'assets/audio/sfx_correct.mp3';
  static const wrongAsset = 'assets/audio/sfx_wrong.mp3';

  bool enabled = true;

  /// False while placing shadows in a stage (HUD active).
  bool menusAllowMusic = true;

  /// True after audio is allowed to play (always on Android; web may need 1 gesture).
  bool _audioReady = !kIsWeb;

  final List<VoidCallback> _listeners = [];
  final AudioEngine _engine = createAudioEngine();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_key) ?? true;
    menusAllowMusic = true;
    // Try immediately — works on phone/tablet; Chrome may block until a gesture.
    await syncMusic(forceAttempt: true);
    _notify();
  }

  /// Call from the first tap / button press (required on some browsers).
  Future<void> unlockAudio() async {
    _audioReady = true;
    await syncMusic(forceAttempt: true);
  }

  Future<void> setEnabled(bool value) async {
    if (enabled == value) {
      return;
    }
    enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    _notify();
    await unlockAudio();
    if (value) {
      playTap();
    }
    await syncMusic(forceAttempt: true);
  }

  Future<void> toggle() => setEnabled(!enabled);

  Future<void> enterMenus() async {
    menusAllowMusic = true;
    await syncMusic(forceAttempt: true);
  }

  Future<void> enterGameplay() async {
    menusAllowMusic = false;
    await syncMusic(forceAttempt: true);
  }

  Future<void> syncMusic({bool forceAttempt = false}) async {
    if (!_audioReady && !forceAttempt) {
      return;
    }
    final shouldPlay = enabled && menusAllowMusic;
    try {
      if (shouldPlay) {
        await _engine.playBgm(bgmAsset, volume: 0.42);
        _audioReady = true;
      } else {
        await _engine.pauseBgm();
      }
    } catch (error, stack) {
      debugPrint('BGM failed: $error\n$stack');
      // Browser autoplay block — next user gesture will unlock.
      if (kIsWeb) {
        _audioReady = false;
      }
    }
  }

  void playTap() {
    if (!enabled) {
      return;
    }
    SystemSound.play(SystemSoundType.click);
  }

  Future<void> playCorrect() => _playSfx(correctAsset);

  Future<void> playWrong() => _playSfx(wrongAsset);

  Future<void> _playSfx(String asset) async {
    if (!enabled) {
      return;
    }
    try {
      await _engine.playSfx(asset, volume: 0.85);
    } catch (error, stack) {
      debugPrint('SFX failed ($asset): $error\n$stack');
    }
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
}
