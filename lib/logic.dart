import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  final url;
  final bool isLocal;
  final PlayerMode mode;

  PlayerWidget(
      {required this.url,
      this.isLocal = false,
      this.mode = PlayerMode.MEDIA_PLAYER});

  @override
  State<StatefulWidget> createState() {
    return _PlayerWidgetState(
      url, 
      isLocal, 
      mode,
      );
  }
}

class _PlayerWidgetState extends State<PlayerWidget> {
  String url;
  bool isLocal;
  PlayerMode mode;

 late  AudioPlayer _audioPlayer;
 late  Duration _duration;
 late  Duration _position;

  late PlayerState _playerState = PlayerState.stopped;
  late StreamSubscription _durationSubscription;
  late StreamSubscription _positionSubscription;
  late StreamSubscription _playerCompleteSubscription;
  late StreamSubscription _playerErrorSubscription;
  late StreamSubscription _playerStateSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => _duration.toString().split('.').first;
  get _positionText => _position.toString().split('.').first;

  _PlayerWidgetState(
    this.url,
    this.isLocal,
    this.mode,
  );

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _durationSubscription.cancel();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription.cancel();
    _playerStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Stack(
                children: [
                  Slider(
                    onChanged: (v) {
                      final Position = v * _duration.inMilliseconds;
                      _audioPlayer
                          .seek(Duration(milliseconds: Position.round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position.inMilliseconds > 0 &&
                            _position.inMilliseconds < _duration.inMilliseconds)
                        ? _position.inMilliseconds / _duration.inMilliseconds
                        : 0.0,
                    activeColor: Colors.white,
                  ),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              //mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  _position != null ? '${_positionText ?? ''}' : "00:00",
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  _position != null
                      ? '${_durationText ?? ''}'
                      : _duration != null
                          ? _durationText
                          : "00:00",
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              iconSize: 64.0,
              icon: const Icon(Icons.skip_previous),
              color: Colors.white70,
              onPressed: () {},
            ),
            IconButton(
                onPressed: _isPlaying ? () => _pause() : () => _play(),
                iconSize: 64.0,
                icon: _isPlaying
                    ? const Icon(Icons.pause_circle_filled)
                    : const Icon(Icons.play_circle_filled),
                color: Colors.white70),
            IconButton(
              iconSize: 64.0,
              icon: const Icon(Icons.skip_next),
              color: Colors.white70,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      print('audioPlayer error : $msg');
      setState(() {
        _playerState = PlayerState.stopped;
        _duration = const Duration(seconds: 0);
        _position = const Duration(seconds: 0);
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        // _audioPlayerState = state;
      });
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(url, isLocal: false, position: playPosition);

    if (result == 1) setState(() => _playerState = PlayerState.playing);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    return result;
  }

  Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = const Duration();
      });
    }
    return result;
  }

  void _onComplete() {
    setState(() => _playerState = PlayerState.stopped);
  }
}
