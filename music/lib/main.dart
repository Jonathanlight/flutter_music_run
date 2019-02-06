import 'package:flutter/material.dart';
import 'package:music/music.dart';

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
    new Music('Slow Down', 'Ema area', 'assets/img/un.jpg', 'https://www.bensound.com/royalty-free-music?download=summer'),
    new Music('Slow Down', 'Ema area', 'assets/img/deux.jpg', 'https://www.bensound.com/royalty-free-music?download=summer'),
  ];

  Music playlistNow;

  @override
  void initState() {
    super.initState();
    playlistNow = playlist[0];
  }

  @override
  Widget build(BuildContext context) {

    print(playlistNow.imagePath);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.orange,
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 9.0,
              child: Container(
                width: MediaQuery.of(context).size.width / 2.5,
                child: new Image.asset(playlistNow.imagePath),
              ),
            ),
            textStyleWidget(playlistNow.title, 1.5),
            textStyleWidget(playlistNow.artiste, 1.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buttonStyleWidget(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                buttonStyleWidget(Icons.play_arrow, 45.0, ActionMusic.play),
                buttonStyleWidget(Icons.fast_forward, 30.0, ActionMusic.forward),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                textStyleWidget('0:0', 0.8),
                textStyleWidget('0:23', 0.8),
              ],
            )
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  IconButton buttonStyleWidget(IconData icone, double size, ActionMusic action) {
    return new IconButton(
      icon: new Icon(icone),
      color: Colors.grey,
      iconSize: size,
      onPressed: () {
        switch (action) {
          case ActionMusic.play:
            print('play');
            break;
          case ActionMusic.pause:
            print('pause');
            break;
          case ActionMusic.rewind:
            print('rewind');
            break;
          case ActionMusic.forward:
            print('forward');
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
}

enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}