import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class SongDetailPage extends StatefulWidget {
  final String text1; // Song title
  final String text2; // Artist name
  final String text3; // Audio file name
  final List<Map<String, dynamic>> lyrics; // List of songs

  SongDetailPage({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.lyrics,
  });

  @override
  _SongDetailPageState createState() => _SongDetailPageState();
}

class _SongDetailPageState extends State<SongDetailPage>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  double currentPosition = 0.0;
  double totalDuration = 1.0;
  late int currentIndex;
  bool isShuffle = false;
  bool isRepeat = false;
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _controller;

  void playMusic() {
    if (!isPlaying) {
      _player.play(AssetSource(widget.lyrics[currentIndex]['text3']!));
      _controller.repeat();
    } else {
      _player.resume();
      _controller.forward();
    }
    setState(() {
      isPlaying = true;
    });
  }

  void stopMusic() {
    _player.pause();
    _controller.stop();
    setState(() {
      isPlaying = false;
    });
  }

  void nextSong() {
    setState(() {
      currentPosition = 0.0;
      totalDuration = 1.0;
      currentIndex = (currentIndex + 1) % widget.lyrics.length;
    });

    _player.stop();
    _player.play(AssetSource(widget.lyrics[currentIndex]['text3']!));
  }

  void previousSong() {
    setState(() {
      currentPosition = 0.0;
      totalDuration = 1.0;
      currentIndex =
          (currentIndex - 1 + widget.lyrics.length) % widget.lyrics.length;
    });

    _player.stop();
    _player.play(AssetSource(widget.lyrics[currentIndex]['text3']!));
  }

  void randomSong() {
    setState(() {
      currentPosition = 0.0;
      totalDuration = 1.0;
      int newIndex;
      do {
        newIndex = Random().nextInt(widget.lyrics.length);
      } while (newIndex == currentIndex);

      currentIndex = newIndex;
    });

    _player.stop();
    _player.play(AssetSource(widget.lyrics[currentIndex]['text3']!));
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );

    currentIndex =
        widget.lyrics.indexWhere((song) => song['text3'] == widget.text3);

    _player.onPositionChanged.listen((Duration p) {
      setState(() {
        currentPosition = p.inMilliseconds / 1000.0;
      });
    });

    _player.onDurationChanged.listen((Duration d) {
      setState(() {
        totalDuration = d.inMilliseconds / 1000.0;
        if (totalDuration <= 0.0) totalDuration = 1.0;
      });
    });

    _player.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          currentPosition = 0.0;
        });
        if (isRepeat) {
          _player.seek(Duration.zero);
          playMusic();
        } else if (isShuffle) {
          randomSong();
        } else {
          nextSong();
        }
      }
    });

    _player.setSource(AssetSource(widget.lyrics[currentIndex]['text3']!));
  }

  @override
  void dispose() {
    _player.dispose();
    _controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitsMinutes:$twoDigitsSeconds";
  }

  @override
  Widget build(BuildContext context) {
    if (currentIndex < 0 || currentIndex >= widget.lyrics.length) {
      return Scaffold(
        body: Center(
          child: Text("Không tìm thấy bài hát",
              style: TextStyle(color: Colors.white)),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lyrics[currentIndex]['text1']!,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1D3557),
        centerTitle: true,
        elevation: 5,
      ),
      backgroundColor: Color(0xFF0F172A),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.purple,
                    child: Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              widget.lyrics[currentIndex]['text1']!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              widget.lyrics[currentIndex]['text2']!,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 20),
            Slider(
              value: currentPosition.clamp(0.0, totalDuration),
              min: 0.0,
              max: totalDuration > 0.0 ? totalDuration : 1.0,
              activeColor: Colors.purpleAccent,
              inactiveColor: Colors.white24,
              onChanged: (value) {
                setState(() {
                  currentPosition = value;
                });
                _player.seek(Duration(seconds: value.toInt()));
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(Duration(seconds: currentPosition.toInt())),
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  formatDuration(Duration(seconds: totalDuration.toInt())),
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: previousSong,
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  iconSize: 40,
                ),
                IconButton(
                  onPressed: isPlaying ? stopMusic : playMusic,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                  ),
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: nextSong,
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  iconSize: 40,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      isShuffle = !isShuffle;
                    });
                  },
                  icon: Icon(
                    isShuffle ? Icons.shuffle_on : Icons.shuffle,
                    color: isShuffle ? Colors.purpleAccent : Colors.white,
                  ),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isRepeat = !isRepeat;
                    });
                  },
                  icon: Icon(
                    isRepeat ? Icons.repeat_on : Icons.repeat,
                    color: isRepeat ? Colors.purpleAccent : Colors.white,
                  ),
                  iconSize: 30,
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.lyrics[currentIndex]['lyrics']?.length ?? 0,
                itemBuilder: (context, index) {
                  var lyricData = widget.lyrics[currentIndex]['lyrics']?[index];
                  if (lyricData == null) return SizedBox();

                  var lyricText = lyricData['lyric'] ?? '';
                  var lyricTime =
                      double.tryParse(lyricData['time'].toString()) ?? 0;

                  return ListTile(
                    title: Text(
                      lyricText,
                      style: TextStyle(
                        color: currentPosition >= lyricTime
                            ? Colors.white
                            : Colors.white60,
                        fontWeight: currentPosition >= lyricTime
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
