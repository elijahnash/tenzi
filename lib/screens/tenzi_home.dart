import 'package:flutter/material.dart';
import 'dart:async';
import 'package:tenzi_za_rohoni/widgets/song.dart';
import 'package:tenzi_za_rohoni/widgets/services.dart';

class TenziHome extends StatefulWidget {
  const TenziHome({Key? key}) : super(key: key);

  @override
  State<TenziHome> createState() => _TenziHomeState();
}
class Debouncer{
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});
  run(VoidCallback action) {
    if(null != _timer){
      _timer?.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _TenziHomeState extends State<TenziHome> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Song> songs = [];
  List<Song> filteredSongs = [];

  @override
  void initState() {
    super.initState();
    Services.getSongsLocal().then((songsFromServer) {
      setState(() {
        songs = songsFromServer;
        filteredSongs = songs;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Tenzi za Rohoni"),
        ),
        drawer: const Drawer(),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  hintText: 'Enter Swahili or English song name'
              ),
              onChanged: (string) {
                _debouncer.run(() {
                  setState(() {
                    filteredSongs = songs.where((s) =>
                    (s.song_swname.toLowerCase().contains(
                        string.toLowerCase()) || s.song_enname.toLowerCase()
                        .contains(string.toLowerCase()))).toList();
                  });
                });
              },
            ),
            Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: filteredSongs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredSongs[index].song_swname,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5.0,),
                              Text(
                                filteredSongs[index].song_enname.toLowerCase(),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
