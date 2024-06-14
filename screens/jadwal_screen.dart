import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(JadwalScreen());
}

class JadwalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jadwal Tim',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JadwalTimPage(),
    );
  }
}

class JadwalTimPage extends StatefulWidget {
  @override
  _JadwalTimPageState createState() => _JadwalTimPageState();
}

class _JadwalTimPageState extends State<JadwalTimPage> {
  late Future<List<Jadwal>> futureJadwal;

  @override
  void initState() {
    super.initState();
    futureJadwal = fetchJadwal();
  }

  Future<List<Jadwal>> fetchJadwal() async {
    final response =
        await http.get(Uri.https('mohammad-ilham-setiawan.github.io', '/api/jadwal.json'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['jadwal'];
      return jsonResponse.map((jadwal) => Jadwal.fromJson(jadwal)).toList();
    } else {
      throw Exception('Failed to load jadwal');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jadwal Tim'),
      ),
      body: Center(
        child: FutureBuilder<List<Jadwal>>(
          future: futureJadwal,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Jadwal>? jadwal = snapshot.data;
              return ListView.builder(
                itemCount: jadwal!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(jadwal[index].tim),
                    subtitle: Text(jadwal[index].hari),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

class Jadwal {
  final String tim;
  final String hari;

  Jadwal({required this.tim, required this.hari});

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      tim: json['tim'],
      hari: json['hari'],
    );
  }
}
