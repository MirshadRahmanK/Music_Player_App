import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayScreen extends StatefulWidget {
  PlayScreen({Key? key, required this.songModel, required this.audioPlayer})
      : super(key: key);
  final SongModel songModel;
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  bool isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    playSong();
  }

  void playSong() {
    try {
      widget.audioPlayer
          .setAudioSource(AudioSource.uri(Uri.parse(widget.songModel.uri!)));
      widget.audioPlayer.play();
      isPlaying = true;
    } on Exception catch (e) {
      print("Error$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 200,
                      width: 200,
                      color: Colors.black,
                      child: Center(
                        child: Icon(
                          Icons.music_note,
                          size: 80,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      widget.songModel.displayNameWOExt,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.songModel.artist.toString() == "<unknown>"
                          ? "Unknown Artist"
                          : widget.songModel.artist.toString(),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("0:00"),
                        Expanded(
                            child: Slider(value: 0.0, onChanged: (value) {})),
                        Text("0.0"),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_previous,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (isPlaying) {
                                  widget.audioPlayer.pause();
                                } else {
                                  widget.audioPlayer.play();
                                }
                                isPlaying = !isPlaying;
                              });
                            },
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 40,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.skip_next,
                              size: 40,
                            ))
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
