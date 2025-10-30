import 'package:flutter/material.dart';
import 'partA.dart';
import 'partB.dart';
import 'partC.dart';
import 'partD.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Tasks',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Task Hub')),
      body: ListView(
        children: [
          ListTile(
            title: Text('Click for Part A '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PartAScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Part B – SQLite Notes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PartBScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Part C'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PartCScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Part D'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PartDScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
