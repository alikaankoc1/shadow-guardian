import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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

  /// False when the app is backgrounded / inactive.
  bool _appInForeground = true;

  /// True after audio is allowed to play (always on Android; web may need 1 gesture).
  bool _audioReady = !kIsWeb;
  bool _prefsLoaded = false;

  final List<VoidCallback> _listeners = [];
  final AudioEngine _engine = createAudioEngine();

  /// Fast prefs-only load — does not block on BGM decode.
  Future<void> loadPrefs() async {
    if (_prefsLoaded) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_key) ?? true;
    menusAllowMusic = true;
    _prefsLoaded = true;
    _notify();
  }

  /// Prefs + best-effort music start (non-blocking caller should unawait).
  Future<void> load() async {
    await loadPrefs();
    await syncMusic(forceAttempt: true);
  }

  /// Call from the first tap / button press (required on some browsers).
  Future<void> unlockAudio() async {
    await loadPrefs();
    _audioReady = true;
    await syncMusic(forceAttempt: true);
  }

  Future<void> setEnabled(bool value) async {
    await loadPrefs();
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

  /// Pause BGM when leaving the app; restore when returning.
  Future<void> handleAppLifecycle(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _appInForeground = true;
        await syncMusic(forceAttempt: true);
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        _appInForeground = false;
        try {
          await _engine.pauseBgm();
        } catch (error, stack) {
          debugPrint('BGM pause failed: $error\n$stack');
        }
    }
  }

  Future<void> syncMusic({bool forceAttempt = false}) async {
    if (!_audioReady && !forceAttempt) {
      return;
    }
    final shouldPlay = enabled && menusAllowMusic && _appInForeground;
    try {
      if (shouldPlay) {
        await _engine.playBgm(bgmAsset, volume: 0.42);
        _audioReady = true;
      } else {
        await _engine.pauseBgm();
      }
    } catch (error, stack) {
      debugPrint('BGM failed: $error\n$stack');
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
