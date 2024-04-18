import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';


void main() => runApp(const BottomNavigationBarExampleApp());

class BottomNavigationBarExampleApp extends StatelessWidget {
  const BottomNavigationBarExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'Roberts rodeo',
      themeMode: ThemeMode.system, // Use the system theme mode
      theme: ThemeData.light(), // Default light theme
      darkTheme: ThemeData.dark(), // Default dark theme
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
        title: const Text('Roberts rodeo'),
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
            label: 'Fun Screen',
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


class HomeScreen extends StatefulWidget {
  @override
  _GeolocationDemoState createState() => _GeolocationDemoState();
}

class _GeolocationDemoState extends State<HomeScreen> {
  String _locationMessage = '';

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  _getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _locationMessage =
      "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.location_on,
              size: 60.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Text(
              'Your Current Location is:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 10.0),
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
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
    var response;
    try {
      response = await http.get(Uri.parse('gs://rides-and-gardens.appspot.com'));
    } catch (e) {
      print('Failed to fetch data from API. Loading offline data...');
      // Load data from local JSON file if offline
      response = await rootBundle.loadString('assets/rides_and_gardens.json');

    }


    setState(() {
      ridesAndGardens = json.decode(response);
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
            SizedBox(height: 60),
            Image(image: AssetImage('assets/Images/${item["image"]}')),
          ],
        ),
      ),
    );
  }
}