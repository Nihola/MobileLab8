import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PartAScreen extends StatefulWidget {
  @override
  _PartAScreenState createState() => _PartAScreenState();
}

class _PartAScreenState extends State<PartAScreen> {
  int _counter = 0;
  String _username = '';
  bool _isDarkMode = false;
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = prefs.getInt('counter') ?? 0;
      _username = prefs.getString('username') ?? '';
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _usernameController.text = _username;
    });
  }

  Future<void> _saveUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text);
    setState(() {
      _username = _usernameController.text;
    });
  }

  Future<void> _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter++;
    });
    await prefs.setInt('counter', _counter);
  }

  Future<void> _toggleDarkMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = value;
    });
    await prefs.setBool('isDarkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('Part A')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text('Task 1: Save Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: _usernameController),
              ElevatedButton(
                  onPressed: _saveUsername, child: Text('Save Username')),
              Text('Saved Username: $_username'),
              Divider(),
              Text('Task 2: Persistent Counter',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text('Counter: $_counter', style: TextStyle(fontSize: 24)),
              ElevatedButton(
                  onPressed: _incrementCounter,
                  child: Text('Increment Counter')),
              Divider(),
              Text('Task 3: Dark Mode Toggle',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SwitchListTile(
                title: Text('Dark Mode'),
                value: _isDarkMode,
                onChanged: _toggleDarkMode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
