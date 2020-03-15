import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AudioPlayer extends StatefulWidget {
  final String src;
  final VoidCallback onFinish;

  AudioPlayer({this.src, this.onFinish});

  @override
  _AudioPlayerState createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {
  VideoPlayerController _controller;

  Future<void> _play() async {
    try {
      await _controller.initialize();
      _controller.addListener(() {
        if (!_controller.value.isPlaying) {
          _onFinish();
        }
      });
      await _controller.play();
    } catch (_) {
      _onFinish();
    }
  }

  void _onFinish() => widget.onFinish();

  @override
  void initState() {
    super.initState();
    if (widget.src.startsWith('file://')) {
      _controller = VideoPlayerController.file(
          File(widget.src.substring('file://'.length)));
    } else {
      _controller = VideoPlayerController.network(widget.src);
    }
    _play();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0,
      height: 0,
      child: VideoPlayer(_controller),
    );
  }
}
