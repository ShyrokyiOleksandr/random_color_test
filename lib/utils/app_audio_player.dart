import 'package:audioplayers/audioplayers.dart';
import 'package:random_color_test/constants/app_assets.dart';

/// Lazy Singleton AudioPlayer wrapper
class AppAudioPlayer {
  static const _audioAssetPath = AppAssets.pushMeSound;
  static AppAudioPlayer? _instance;

  final AudioPlayer _audioPlayer = AudioPlayer();

  /// Provides info weather player is playing a sound or not
  bool get isPlaying => _audioPlayer.state == PlayerState.playing;

  /// Initiates AppAudioPlayer instance lazily
  factory AppAudioPlayer() => _instance ?? AppAudioPlayer._internal();

  AppAudioPlayer._internal() {
    _instance = this;
  }

  /// Plays or pauses sound, basing on current AudioPlayer state
  Future<void> playOrStop() async {
    if (!isPlaying) {
      await _audioPlayer.play(AssetSource(_audioAssetPath));
    } else {
      await _audioPlayer.pause();
    }
  }

  /// Disposes AudioPlayer
  void dispose() {
    _audioPlayer.dispose();
  }
}
