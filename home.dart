import 'package:flutter/material.dart';
import 'screens/laporan_screen.dart';
import 'screens/jadwal_screen.dart';
import 'screens/denah_screen.dart';
import 'screens/feedback_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    LaporanScreen(),
    JadwalScreen(),
    DenahScreen(),
    FeedbackScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter App'),
          backgroundColor: Colors.black,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.report, color: Colors.black87),
              label: 'Laporan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.schedule, color: Colors.black87),
              label: 'Jadwal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map, color: Colors.black87),
              label: 'Denah',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.feedback, color: Colors.black87),
              label: 'Feedback',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.pink,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
