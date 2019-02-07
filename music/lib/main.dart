import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music/music.dart';
import 'package:audioplayer2/audioplayer2.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Fox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MyHomePage(title: 'Music Fox'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Music> playlist = [
    new Music('Dreams', 'Dreams Team', 'assets/img/un.jpg', 'https://www.bensound.com/royalty-free-music?download=dreams'),
    new Music('Endless Motion', 'Ema area', 'assets/img/deux.jpg', 'https://www.bensound.com/royalty-free-music?download=endlessmotion'),
  ];

  Music playlistNow;
  Duration position = new Duration(seconds: 0);
  AudioPlayer audioPlayer;
  StreamSubscription positionSub;
  StreamSubscription stateSubscription;
  Duration duree = new Duration(seconds: 0);
  PlayerState statut = PlayerState.stopped;
  int index = 0;

  @override
  void initState() {
    super.initState();
    playlistNow = playlist[index];
    configAudioPlayer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: new Stack(
        children: <Widget>[
          new Container(
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("assets/img/background.jpg"), 
                fit: BoxFit.cover
              )
            ),
          ),
          SingleChildScrollView(
            child: new Container(
              color: Colors.transparent,
              margin: EdgeInsets.all(10),
              child: Center(
                child: new Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(3.0),
                  decoration: new BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.deepOrangeAccent,
                        Colors.deepPurple,
                      ],
                      begin: FractionalOffset(1.2, 0.4),
                      end: FractionalOffset(-0.3, 0.8),
                      stops: [0.0, 1.0],
                    ),
                    border: new Border.all(
                      color: Colors.deepOrange,
                      style: BorderStyle.solid
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.orange,
                        offset: Offset(1.0, 0.9),
                        blurRadius: 20.0,
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      new Card(
                        elevation: 9.0,
                        color: Colors.orange,
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: CircleAvatar(
                            radius: 100.0,
                            child: Image.asset(
                              playlistNow.imagePath,
                            ),
                          ),
                        ),
                      ),
                      new SizedBox(
                        height: 50.0,
                        child: new Center(
                          child: new Container(
                            margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                            height: 5.0,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          textStyleWidget(playlistNow.title, 1.5),
                        textStyleWidget(playlistNow.artiste, 1.0),
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          buttonStyleWidget(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                          buttonStyleWidget(
                            (statut == PlayerState.playing) ? Icons.pause : Icons.play_arrow , 100.0
                            , (statut == PlayerState.playing) ? ActionMusic.pause : ActionMusic.play 
                            ),
                          buttonStyleWidget(Icons.fast_forward, 30.0, ActionMusic.forward),
                        ],
                      ),
                      new SizedBox(
                        height: 100.0,
                        child: new Center(
                          child: new Container(
                            margin: new EdgeInsetsDirectional.only(start: 1.0, end: 1.0),
                            height: 100.0,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          textStyleWidget(fromDuration(position), 0.8),
                          new Slider(
                            value: position?.inMilliseconds?.toDouble() ?? 0.0,
                            min: 0.0,
                            max: duree.inMilliseconds.toDouble(),
                            inactiveColor: Colors.grey,
                            activeColor: Colors.orangeAccent,
                            onChanged: (double d) {
                              setState(() {
                                audioPlayer.seek((d / 1000).roundToDouble());
                              });
                          }),
                          textStyleWidget(fromDuration(duree), 0.8),
                        ],
                      ),
                      
                    ],
                  ),
                ),
              ),
            )
          )
        ]
      )       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  IconButton buttonStyleWidget(IconData icone, double size, ActionMusic action) {
    return new IconButton(
      icon: new Icon(icone),
      color: Colors.black,
      iconSize: size,
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            play();
            break;
          case ActionMusic.pause:
            pause();
            break;
          case ActionMusic.rewind:
            rewind();
            break;
          case ActionMusic.forward:
            forward();
            break;  
        }
      },
    );
  }

  Text textStyleWidget(String name, double scale) {
    return new Text(
      name,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      ),
    );
  }

  void configAudioPlayer() {
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen(
      (pos) => setState(() => position = pos)
    );
    stateSubscription = audioPlayer.onPlayerStateChanged.listen(
      (state) {
        if (state == AudioPlayerState.PLAYING) {
          setState(() {
            duree = audioPlayer.duration;
          });
        } else if (state == AudioPlayerState.STOPPED) {
          setState(() {
            statut = PlayerState.stopped;
          });
        }
      },
      onError: (error) {
        print('Error: $error');
        setState(() {
            statut = PlayerState.stopped;
            duree = new Duration(seconds: 0);
            position = new Duration(seconds: 0);
        });
      }
    );
  }

  String fromDuration(Duration duree) {
    return duree.toString().split('.').first;
  }

  Future play() async {
    await audioPlayer.play(playlistNow.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  void forward() {
    if (index == playlist.length - 1) {
      index = 0;
    } else {
      index++;
    }
    playlistNow = playlist[index];
    audioPlayer.stop();
    configAudioPlayer();
    play();
  }

  void rewind() {
    if (position > Duration(seconds: 3)) {
      audioPlayer.seek(0.0);
    } else {
      if (index == 0) {
        index = playlist.length - 1;
      } else {
        index--;
      }
      playlistNow = playlist[index];
      audioPlayer.stop();
      configAudioPlayer();
      play();
    }
  }

}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}

enum PlayerState {
  playing,
  stopped,
  paused
}