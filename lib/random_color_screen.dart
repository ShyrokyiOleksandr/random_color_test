import 'package:flutter/material.dart';
import 'package:random_color_test/constants/app_assets.dart';
import 'package:random_color_test/utils/app_audio_player.dart';
import 'package:random_color_test/utils/app_color_randomizer.dart';
import 'package:rive/rive.dart';

// todo: extract separate classes to manage color and audio
// todo: process exceptions

/// Screen widget, providing next features:
/// - Changes background color after tapping anywhere on the screen
/// - Runs/stops playing music with color change on pressing "Push/Stop me"
/// button
class RandomColorScreen extends StatefulWidget {
  /// Initialises RandomColorScreen
  const RandomColorScreen({super.key});

  @override
  State<RandomColorScreen> createState() => _RandomColorScreenState();
}

class _RandomColorScreenState extends State<RandomColorScreen> {
  static const _animationDuration = Duration(milliseconds: 240);

  final _audioPlayer = AppAudioPlayer();
  final _colorGenerator = AppColorRandomizer();

  Color? _backgroundColor;
  bool _isTextBig = false;

  @override
  void initState() {
    super.initState();
    _backgroundColor = _colorGenerator.currentColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _changeBackgroundColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_audioPlayer.isPlaying) ...{
                  const SizedBox(height: 80),
                  const Expanded(child: _DancingAnimation()),
                },
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ScalingLuminantText(
                        animationDuration: _animationDuration,
                        isTextBig: _isTextBig,
                        luminant: _colorGenerator.getCurrentColorLuminant(),
                      ),
                      const SizedBox(height: 40),
                      _PlayOrStopButton(
                        isPlaying: _audioPlayer.isPlaying,
                        onPressed: _playOrStopContent,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  Future<void> _playOrStopContent() async {
    await _audioPlayer.playOrStop();
    await _playOrStopVisuals();
  }

  Future<void> _playOrStopVisuals() async {
    while (_audioPlayer.isPlaying) {
      await Future<void>.delayed(
        _animationDuration,
        () {
          _changeBackgroundColor();
          _changeTextScale();
        },
      );
    }
  }

  void _changeBackgroundColor() {
    setState(() {
      _backgroundColor = _colorGenerator.getRandomColor();
    });
  }

  void _changeTextScale() {
    setState(() {
      _isTextBig = !_isTextBig;
    });
  }
}

class _DancingAnimation extends StatelessWidget {
  static const _borderRadius = 16.0;

  const _DancingAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_borderRadius),
          child: const RiveAnimation.asset(
            AppAssets.pushMeAnimation,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class _ScalingLuminantText extends StatelessWidget {
  static const double _bigTextScale = 2;

  final Duration animationDuration;
  final bool isTextBig;
  final Color luminant;

  const _ScalingLuminantText({
    Key? key,
    required this.animationDuration,
    required this.isTextBig,
    required this.luminant,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: animationDuration,
      curve: Curves.ease,
      scale: !isTextBig ? 1 : _bigTextScale,
      child: Text(
        'Hey there',
        style: TextStyle(color: luminant),
      ),
    );
  }
}

class _PlayOrStopButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPressed;

  const _PlayOrStopButton({
    Key? key,
    required this.isPlaying,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      icon: !isPlaying
          ? const Icon(Icons.play_circle_outline)
          : const Icon(Icons.stop_circle_outlined),
      label: Text("${!isPlaying ? "Push" : "Stop"} me"),
      onPressed: onPressed,
    );
  }
}
