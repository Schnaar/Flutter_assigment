import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationBarExample(),
    );
  }
}

class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({Key? key}) : super(key: key);

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState
    extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    ThemeParkScreen(),
    SchoolScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BottomNavigationBar Sample'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Rides',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'School',
            backgroundColor: Colors.purple,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            backgroundColor: Colors.pink,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}

class BusinessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business'),
      ),
      body: Center(
        child: Text('Business Screen'),
      ),
    );
  }
}

class SchoolScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('School'),
      ),
      body: Center(
        child: Text('School Screen'),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: Text('Settings Screen'),
      ),
    );
  }
}

class ThemeParkScreen extends StatefulWidget {
  @override
  _ThemeParkScreenState createState() => _ThemeParkScreenState();
}

class _ThemeParkScreenState extends State<ThemeParkScreen> {
  List<dynamic> ridesAndGardens = [];

  @override
  void initState() {
    super.initState();
    loadRidesAndGardens();
  }

  Future<void> loadRidesAndGardens() async {
    String data = await rootBundle.loadString('assets/rides_and_gardens.json');
    setState(() {
      ridesAndGardens = json.decode(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Theme Park'),
      ),
      body: ListView.builder(
        itemCount: ridesAndGardens.length,
        itemBuilder: (context, index) {
          final item = ridesAndGardens[index];
          return ListTile(
            title: Text(item['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(item: item),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;

  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Description:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['description']),
            SizedBox(height: 20),
            Text(
              'Location:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['location']),
            SizedBox(height: 20),
            Text(
              'Capacity:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['capacity'].toString()),
            SizedBox(height: 20),
            Text(
              'Wait time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(item['wait time'].toString()),
          ],
        ),
      ),
    );
  }
}