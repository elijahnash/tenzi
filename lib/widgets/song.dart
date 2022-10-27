class Song{
  int id;
  String song_swname;
  String song_enname;

  Song({required this.id, required this.song_swname, required this.song_enname});

  factory Song.fromJson(Map<String, dynamic> json){
    return Song(
      id: json["id"] as int,
      song_swname: json["name"] as String,
      song_enname: json["email"] as String,
    );
  }
}