import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Soft UI sounds + future BGM gate. Persists across launches.
class SoundSettings {
  SoundSettings._();
  static final SoundSettings instance = SoundSettings._();

  static const _key = 'sound_enabled';

  bool enabled = true;
  final List<VoidCallback> _listeners = [];

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_key) ?? true;
    _notify();
  }

  Future<void> setEnabled(bool value) async {
    if (enabled == value) {
      return;
    }
    enabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, value);
    _notify();
    if (value) {
      playTap();
    }
  }

  Future<void> toggle() => setEnabled(!enabled);

  void playTap() {
    if (!enabled) {
      return;
    }
    SystemSound.play(SystemSoundType.click);
  }

  void addListener(VoidCallback listener) => _listeners.add(listener);

  void removeListener(VoidCallback listener) => _listeners.remove(listener);

  void _notify() {
    for (final listener in List<VoidCallback>.from(_listeners)) {
      listener();
    }
  }
}

typedef VoidCallback = void Function();
