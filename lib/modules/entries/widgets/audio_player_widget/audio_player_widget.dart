import 'package:audioplayers/audioplayers.dart';
import 'package:dictionary/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({required this.audioUrl, Key? key}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  final RxBool _isPlaying = false.obs;
  final Rx<Duration> _currentPosition = Duration.zero.obs;
  final Rx<Duration> _totalDuration = Duration.zero.obs;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _currentPosition.value = p;
    });

    _audioPlayer.onDurationChanged.listen((Duration d) {
      _totalDuration.value = d;
    });

    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        _isPlaying.value = false;
        _currentPosition.value = Duration.zero;
      } else if (state == PlayerState.stopped) {
        _isPlaying.value = false;
        _currentPosition.value = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play(UrlSource(widget.audioUrl));
    _isPlaying(true);
  }

  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    _isPlaying(false);
  }

  Future<void> _seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
    _currentPosition.value = position;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: _isPlaying.value
                        ? const Icon(Icons.stop, color: Colors.red)
                        : const Icon(Icons.play_arrow, color: Colors.green),
                    onPressed: () {
                      if (_isPlaying.isTrue) {
                        _stopAudio();
                      } else {
                        _playAudio();
                      }
                    },
                  ),
                  Expanded(
                    child: Slider(
                      value: _currentPosition.value.inMilliseconds.toDouble(),
                      max: _totalDuration.value.inMilliseconds.toDouble(),
                      onChanged: (double value) {
                        final position = Duration(milliseconds: value.toInt());
                        _seekAudio(position);
                      },
                    ),
                  ),
                  Text(
                    Utils.formatDuration(_totalDuration.value),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
