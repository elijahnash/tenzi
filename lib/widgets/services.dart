import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tenzi_za_rohoni/widgets/song.dart';
import 'package:flutter/services.dart' as bundle;

class Services {
  static const String url = 'http://jsonplaceholder.typicode.com/users';

  static Future<List<Song>> getSongsOnline() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<Song> list = parseSongs(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Song> parseSongs(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Song>((json) => Song.fromJson(json)).toList();
  }

  static Future<List<Song>> getSongsLocal() async {
    final songList =
        await bundle.rootBundle.loadString('assets/json/sample.json');
    final list = json.decode(songList) as List<dynamic>;

    return list.map((json) => Song.fromJson(json)).toList();
  }
}
