package com.alikaankoc.sevimligolgeler

import android.content.res.AssetFileDescriptor
import android.media.AudioAttributes
import android.media.MediaPlayer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "sevimli_golgeler/audio"
    private var bgmPlayer: MediaPlayer? = null
    private var sfxPlayer: MediaPlayer? = null
    private var currentBgmAsset: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "playBgm" -> {
                        val asset = call.argument<String>("asset")
                        val volume = (call.argument<Double>("volume") ?: 0.4).toFloat()
                        val reuse = call.argument<Boolean>("reuse") ?: false
                        if (asset == null) {
                            result.error("bad_args", "asset required", null)
                            return@setMethodCallHandler
                        }
                        playBgm(asset, volume, reuse)
                        result.success(null)
                    }
                    "pauseBgm" -> {
                        pauseBgm()
                        result.success(null)
                    }
                    "playSfx" -> {
                        val asset = call.argument<String>("asset")
                        val volume = (call.argument<Double>("volume") ?: 0.85).toFloat()
                        if (asset == null) {
                            result.error("bad_args", "asset required", null)
                            return@setMethodCallHandler
                        }
                        playSfx(asset, volume)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun playBgm(asset: String, volume: Float, reuse: Boolean) {
        if (reuse && bgmPlayer != null && currentBgmAsset == asset) {
            bgmPlayer?.setVolume(volume, volume)
            if (bgmPlayer?.isPlaying != true) {
                bgmPlayer?.start()
            }
            return
        }

        pauseBgm()
        bgmPlayer?.release()
        bgmPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_GAME)
                    .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC)
                    .build(),
            )
            setDataSourceFromFlutterAsset(asset)
            isLooping = true
            setVolume(volume, volume)
            prepare()
            start()
        }
        currentBgmAsset = asset
    }

    private fun pauseBgm() {
        try {
            if (bgmPlayer?.isPlaying == true) {
                bgmPlayer?.pause()
            }
        } catch (_: IllegalStateException) {
            // ignore
        }
    }

    private fun playSfx(asset: String, volume: Float) {
        try {
            sfxPlayer?.stop()
            sfxPlayer?.release()
        } catch (_: Exception) {
            // ignore
        }

        sfxPlayer = MediaPlayer().apply {
            setAudioAttributes(
                AudioAttributes.Builder()
                    .setUsage(AudioAttributes.USAGE_GAME)
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .build(),
            )
            setDataSourceFromFlutterAsset(asset)
            setVolume(volume, volume)
            setOnCompletionListener { player ->
                player.release()
                if (sfxPlayer === player) {
                    sfxPlayer = null
                }
            }
            prepare()
            start()
        }
    }

    private fun MediaPlayer.setDataSourceFromFlutterAsset(asset: String) {
        val flutterPath = "flutter_assets/$asset"
        val afd: AssetFileDescriptor = assets.openFd(flutterPath)
        setDataSource(afd.fileDescriptor, afd.startOffset, afd.length)
        afd.close()
    }

    override fun onDestroy() {
        try {
            bgmPlayer?.release()
            sfxPlayer?.release()
        } catch (_: Exception) {
            // ignore
        }
        bgmPlayer = null
        sfxPlayer = null
        super.onDestroy()
    }
}
