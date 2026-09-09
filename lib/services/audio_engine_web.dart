import 'dart:js_interop';

import 'package:flutter/services.dart';
import 'package:web/web.dart' as web;

import 'audio_engine.dart';

class _WebAudioEngine implements AudioEngine {
  web.HTMLAudioElement? _bgm;
  String? _bgmUrl;
  final Map<String, String> _urlCache = {};

  Future<String> _blobUrl(String assetPath) async {
    final cached = _urlCache[assetPath];
    if (cached != null) {
      return cached;
    }
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();
    final buffer = bytes.buffer.toJS;
    final parts = [buffer].toJS;
    final blob = web.Blob(parts, web.BlobPropertyBag(type: 'audio/mpeg'));
    final url = web.URL.createObjectURL(blob);
    _urlCache[assetPath] = url;
    return url;
  }

  @override
  Future<void> playBgm(String assetPath, {double volume = 0.4}) async {
    final url = await _blobUrl(assetPath);
    if (_bgm != null && _bgmUrl == url) {
      _bgm!.volume = volume;
      if (_bgm!.paused) {
        await _bgm!.play().toDart;
      }
      return;
    }
    _bgm?.pause();
    _bgm = web.HTMLAudioElement()
      ..src = url
      ..loop = true
      ..volume = volume;
    _bgmUrl = url;
    await _bgm!.play().toDart;
  }

  @override
  Future<void> pauseBgm() async {
    _bgm?.pause();
  }

  @override
  Future<void> playSfx(String assetPath, {double volume = 0.85}) async {
    final url = await _blobUrl(assetPath);
    final sfx = web.HTMLAudioElement()
      ..src = url
      ..volume = volume;
    await sfx.play().toDart;
  }
}

AudioEngine createAudioEngineImpl() => _WebAudioEngine();
