import 'dart:collection';
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:chewie_example/app/theme.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:video_player/video_player.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as YTE;

class ChewieDemo extends StatefulWidget {
  const ChewieDemo({
    Key? key,
    this.title = 'Chewie Demo',
  }) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() {
    return _ChewieDemoState();
  }
}

class _ChewieDemoState extends State<ChewieDemo> {
  TargetPlatform? _platform;
  late VideoPlayerController _videoPlayerController3;
  ChewieController? _chewieController;
  int? bufferDelay;

  UnmodifiableListView<YTE.MuxedStreamInfo>? youTubeVideoQualities;
  YTE.MuxedStreamInfo? selectedYouTubeVideoQuality;

  @override
  void initState() {
    super.initState();
    initializePlayer(null);
  }

  @override
  void dispose() {
    _videoPlayerController3.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer(YTE.MuxedStreamInfo? selectedQuality) async {
    if (selectedQuality != null) {
      setState(() {
        selectedYouTubeVideoQuality = selectedQuality;
      });
      _videoPlayerController3 = VideoPlayerController.network(selectedYouTubeVideoQuality!.url.toString());
    } else {
      final extractor = YTE.YoutubeExplode();
      const videoId = '2DKry0vJ58k';
      final streamManifest = await extractor.videos.streamsClient.getManifest(videoId);
      youTubeVideoQualities = streamManifest.muxed;
      final streamInfoHQ = youTubeVideoQualities?.bestQuality;
      setState(() {
        selectedYouTubeVideoQuality = streamInfoHQ;
      });
      final primaryStreamUrl = selectedYouTubeVideoQuality?.url.toString();
      if (primaryStreamUrl != null) {
        _videoPlayerController3 = VideoPlayerController.network(primaryStreamUrl);
      }
    }

    await _videoPlayerController3.initialize();
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    // final subtitles = [
    //     Subtitle(
    //       index: 0,
    //       start: Duration.zero,
    //       end: const Duration(seconds: 10),
    //       text: 'Hello from subtitles',
    //     ),
    //     Subtitle(
    //       index: 0,
    //       start: const Duration(seconds: 10),
    //       end: const Duration(seconds: 20),
    //       text: 'Whats up? :)',
    //     ),
    //   ];

    final subtitles = [
      Subtitle(
        index: 0,
        start: Duration.zero,
        end: const Duration(seconds: 10),
        text: const TextSpan(
          children: [
            TextSpan(
              text: 'Hello',
              style: TextStyle(color: Colors.red, fontSize: 22),
            ),
            TextSpan(
              text: ' from ',
              style: TextStyle(color: Colors.green, fontSize: 20),
            ),
            TextSpan(
              text: 'subtitles',
              style: TextStyle(color: Colors.blue, fontSize: 18),
            )
          ],
        ),
      ),
      Subtitle(
        index: 0,
        start: const Duration(seconds: 10),
        end: const Duration(seconds: 20),
        text: 'Whats up? :)',
        // text: const TextSpan(
        //   text: 'Whats up? :)',
        //   style: TextStyle(color: Colors.amber, fontSize: 22, fontStyle: FontStyle.italic),
        // ),
      ),
    ];

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController3,
      autoPlay: true,
      looping: true,
      progressIndicatorDelay: bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      youTubeVideoQualities: youTubeVideoQualities,
      onYTVideoQualityChanged: (context, streamInfo) {
        _videoPlayerController3.pause();
        _videoPlayerController3.seekTo(Duration.zero);
        initializePlayer(streamInfo);
      },
      selectedYouTubeVideoQuality: selectedYouTubeVideoQuality,
      // additionalOptions: (context) {
      //   return <OptionItem>[
      //     OptionItem(
      //       onTap: toggleVideo,
      //       iconData: Icons.live_tv_sharp,
      //       title: 'Toggle Video Src',
      //     ),
      //   ];
      // },
      subtitle: Subtitles(subtitles),
      subtitleBuilder: (context, dynamic subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: subtitle is InlineSpan
            ? RichText(
                text: subtitle,
              )
            : Text(
                subtitle.toString(),
                style: const TextStyle(color: Colors.black),
              ),
      ),

      hideControlsTimer: const Duration(seconds: 1),

      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
  }

  int currPlayIndex = 0;

  // Future<void> toggleVideo() async {
  //   await _videoPlayerController1.pause();
  //   currPlayIndex += 1;
  //   if (currPlayIndex >= srcs.length) {
  //     currPlayIndex = 0;
  //   }
  //   await initializePlayer();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: AppTheme.light.copyWith(
        platform: _platform ?? Theme.of(context).platform,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                    ? Chewie(
                        controller: _chewieController!,
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Loading'),
                        ],
                      ),
              ),
            ),
            TextButton(
              onPressed: () {
                _chewieController?.enterFullScreen();
              },
              child: const Text('Fullscreen'),
            ),
            Row(
              children: <Widget>[
                // Expanded(
                //   child: TextButton(
                //     onPressed: () {
                //       setState(() {
                //         _videoPlayerController1.pause();
                //         _videoPlayerController1.seekTo(Duration.zero);
                //         _createChewieController();
                //       });
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 16.0),
                //       child: Text("Landscape Video"),
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: TextButton(
                //     onPressed: () {
                //       setState(() {
                //         _videoPlayerController2.pause();
                //         _videoPlayerController2.seekTo(Duration.zero);
                //         _chewieController = _chewieController!.copyWith(
                //           videoPlayerController: _videoPlayerController2,
                //           autoPlay: true,
                //           looping: true,
                //           youTubeVideoQualities: UnmodifiableListView([]),
                //           /* subtitle: Subtitles([
                //             Subtitle(
                //               index: 0,
                //               start: Duration.zero,
                //               end: const Duration(seconds: 10),
                //               text: 'Hello from subtitles',
                //             ),
                //             Subtitle(
                //               index: 0,
                //               start: const Duration(seconds: 10),
                //               end: const Duration(seconds: 20),
                //               text: 'Whats up? :)',
                //             ),
                //           ]),
                //           subtitleBuilder: (context, subtitle) => Container(
                //             padding: const EdgeInsets.all(10.0),
                //             child: Text(
                //               subtitle,
                //               style: const TextStyle(color: Colors.white),
                //             ),
                //           ), */
                //         );
                //       });
                //     },
                //     child: const Padding(
                //       padding: EdgeInsets.symmetric(vertical: 16.0),
                //       child: Text("Portrait Video"),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _videoPlayerController3.pause();
                        _videoPlayerController3.seekTo(Duration.zero);
                        _chewieController = _chewieController!.copyWith(
                          videoPlayerController: _videoPlayerController3,
                          autoPlay: true,
                          looping: true,
                          youTubeVideoQualities: youTubeVideoQualities,
                          onYTVideoQualityChanged: (context, streamInfo) {
                            _videoPlayerController3.pause();
                            _videoPlayerController3.seekTo(Duration.zero);
                            initializePlayer(streamInfo);
                          },
                          selectedYouTubeVideoQuality: selectedYouTubeVideoQuality,
                        );
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("YouTube Video"),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.android;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Android controls"),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.iOS;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("iOS controls"),
                    ),
                  ),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _platform = TargetPlatform.windows;
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text("Desktop controls"),
                    ),
                  ),
                ),
              ],
            ),
            if (Platform.isAndroid)
              ListTile(
                title: const Text("Delay"),
                subtitle: DelaySlider(
                  delay: _chewieController?.progressIndicatorDelay?.inMilliseconds,
                  onSave: (delay) async {
                    if (delay != null) {
                      bufferDelay = delay == 0 ? null : delay;
                      await initializePlayer(null);
                    }
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}

class DelaySlider extends StatefulWidget {
  const DelaySlider({Key? key, required this.delay, required this.onSave}) : super(key: key);

  final int? delay;
  final void Function(int?) onSave;
  @override
  State<DelaySlider> createState() => _DelaySliderState();
}

class _DelaySliderState extends State<DelaySlider> {
  int? delay;
  bool saved = false;

  @override
  void initState() {
    super.initState();
    delay = widget.delay;
  }

  @override
  Widget build(BuildContext context) {
    const int max = 1000;
    return ListTile(
      title: Text(
        "Progress indicator delay ${delay != null ? "${delay.toString()} MS" : ""}",
      ),
      subtitle: Slider(
        value: delay != null ? (delay! / max) : 0,
        onChanged: (value) async {
          delay = (value * max).toInt();
          setState(() {
            saved = false;
          });
        },
      ),
      trailing: IconButton(
        icon: const Icon(Icons.save),
        onPressed: saved
            ? null
            : () {
                widget.onSave(delay);
                setState(() {
                  saved = true;
                });
              },
      ),
    );
  }
}
