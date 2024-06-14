import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Laporan {
  final int id;
  final String lokasi;
  final String deskripsi;
  final String fotoLink;

  Laporan({
    required this.id,
    required this.lokasi,
    required this.deskripsi,
    required this.fotoLink,
  });

  factory Laporan.fromJson(Map<String, dynamic> json) {
    return Laporan(
      id: json['id'],
      lokasi: json['lokasi'],
      deskripsi: json['deskripsi'],
      fotoLink: json['fotoLink'],
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laporan App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LaporanScreen(),
    );
  }
}

class LaporanScreen extends StatefulWidget {
  @override
  _LaporanScreenState createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController fotoLinkController = TextEditingController();
  List<Laporan> laporanList = [];

  @override
  void initState() {
    super.initState();
    fetchLaporan();
  }

  Future<void> fetchLaporan() async {
    final response = await http.get(
      Uri.parse('http://192.168.14.131:1000/api/laporan'),
    );

    if (response.statusCode == 200) {
      List<dynamic> laporanJson = jsonDecode(response.body);
      setState(() {
        laporanList = laporanJson.map((json) => Laporan.fromJson(json)).toList();
      });
    } else {
      print('Failed to fetch laporan. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteLaporan(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.14.131:1000/api/laporan/$id'),
      );

      if (response.statusCode == 200) {
        setState(() {
          laporanList.removeWhere((laporan) => laporan.id == id);
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil dihapus')));
      } else {
        print('Failed to delete laporan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting laporan: $e');
    }
  }

  void navigateToEditLaporan(Laporan laporan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LaporanEditScreen(laporan: laporan),
      ),
    ).then((_) {
      fetchLaporan();
    });
  }

  Future<void> submitLaporan() async {
    final String lokasi = lokasiController.text;
    final String deskripsi = deskripsiController.text;
    final String fotoLink = fotoLinkController.text;

    try {
      final response = await http.post(
        Uri.parse('http://192.168.14.131:1000/api/laporan'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lokasi': lokasi,
          'deskripsi': deskripsi,
          'fotoLink': fotoLink,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil dikirim')));
        fetchLaporan();
      } else {
        print('Failed to submit laporan. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error submitting laporan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Laporan App')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: lokasiController,
              decoration: InputDecoration(labelText: 'Lokasi'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              controller: fotoLinkController,
              decoration: InputDecoration(labelText: 'Foto Link (Google Drive)'),
            ),
          ),
          ElevatedButton(
            onPressed: submitLaporan,
            child: Text('Submit'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: laporanList.length,
              itemBuilder: (context, index) {
                final laporan = laporanList[index];
                return ListTile(
                  title: Text(laporan.lokasi),
                  subtitle: Text(laporan.deskripsi),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => navigateToEditLaporan(laporan),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteLaporan(laporan.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LaporanEditScreen extends StatefulWidget {
  final Laporan laporan;

  LaporanEditScreen({required this.laporan});

  @override
  _LaporanEditScreenState createState() => _LaporanEditScreenState();
}

class _LaporanEditScreenState extends State<LaporanEditScreen> {
  late TextEditingController lokasiController;
  late TextEditingController deskripsiController;
  late TextEditingController fotoLinkController;

  @override
  void initState() {
    super.initState();
    lokasiController = TextEditingController(text: widget.laporan.lokasi);
    deskripsiController = TextEditingController(text: widget.laporan.deskripsi);
    fotoLinkController = TextEditingController(text: widget.laporan.fotoLink);
  }

  Future<void> editLaporan() async {
    final String lokasi = lokasiController.text;
    final String deskripsi = deskripsiController.text;
    final String fotoLink = fotoLinkController.text;

    try {
      final response = await http.put(
        Uri.parse('http://192.168.14.131/api/laporan/${widget.laporan.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'lokasi': lokasi,
          'deskripsi': deskripsi,
          'fotoLink': fotoLink,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Laporan berhasil diperbarui')));
        Navigator.pop(context);
      } else {
        print('Failed to update laporan. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error updating laporan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Laporan')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: lokasiController,
              decoration: InputDecoration(labelText: 'Lokasi'),
            ),
            TextField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextField(
              controller: fotoLinkController,
              decoration: InputDecoration(labelText: 'Foto Link (Google Drive)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: editLaporan,
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
