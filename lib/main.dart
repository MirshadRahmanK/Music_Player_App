import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musicapp2022/Screens/playScreen.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:just_audio/just_audio.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: MyHomeApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomeApp extends StatefulWidget {
  const MyHomeApp({Key? key}) : super(key: key);

  @override
  State<MyHomeApp> createState() => _MyHomeAppState();
}

class _MyHomeAppState extends State<MyHomeApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reuestpermission();
  }

  void reuestpermission() {
    Permission.storage.request();
  }

  final _audioQuery = OnAudioQuery();
  final _audioPlayer = AudioPlayer();

  playAudio(String? uri) {
    try {
    _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      _audioPlayer.play();
    } catch (e) {
      log("ERROR$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music player 2022"),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: _audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return Center(
              child: Text("Not data found"),
            );
          }
          return ListView.builder(
            itemBuilder: ((context, index) {
              return ListTile(
                leading: QueryArtworkWidget(
                  id: item.data![index].id,
                  type: ArtworkType.AUDIO,
                  nullArtworkWidget: Icon(Icons.music_note),
                ),
                title: Text(item.data![index].displayNameWOExt),
                subtitle: Text("${item.data![index].artist}"),
                trailing:
                    IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context){
                    return PlayScreen(songModel: item.data![index],audioPlayer: _audioPlayer,);
                  }));
                },
              );
            }),
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }
}
