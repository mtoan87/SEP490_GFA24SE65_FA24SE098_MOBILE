import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sos_mobile_app/models/donation.dart';
import 'donate_list_screen.dart'; // Import DonationListScreen
import 'profile_screen.dart'; // Import ProfileScreen

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  List<Event> _events = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    const String url = 'https://soschildrenvillage.azurewebsites.net/api/Event';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _events = data.map((eventData) => Event.fromJson(eventData)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load events');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[50], // Lighter background color for a modern look
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.blue[700],
      title: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue[300],
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Huynh Minh',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Spread Goodness',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: const [
        Icon(Icons.home, size: 28),
        SizedBox(width: 15),
        Icon(Icons.notifications, size: 28),
        SizedBox(width: 15),
        Icon(Icons.settings, size: 28),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0: // Tab Home
        return _buildHomeBody();
      case 1: // Tab Search
        return _buildSearchBody();
      case 2: // Tab Profile
        return ProfileScreen(); // Navigate to ProfileScreen here
      default:
        return _buildHomeBody();
    }
  }

  Widget _buildHomeBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Suggested for You',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  'See more',
                  style: TextStyle(
                    color: Colors.blue[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: _events.isEmpty
                  ? [Center(child: CircularProgressIndicator())]
                  : _events
                      .map((event) => buildSuggestedItem(
                          event.name, "some location", event.imageUrls.first))
                      .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.blue[50],
                      child: Icon(
                        Icons.cached,
                        color: Colors.blue[600],
                        size: 36,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DonationListScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                      ),
                      child: const Text('Donate Now'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSuggestedItem(String title, String subtitle, String imageUrl) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 18),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBody() {
    return Center(child: Text('Search functionality goes here.'));
  }

  Widget _buildProfileBody() {
    return Center(child: Text('Profile functionality goes here.'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class Event {
  final int id;
  final String name;
  final List<String> imageUrls;

  Event({
    required this.id,
    required this.name,
    required this.imageUrls,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      name: json['name'],
      imageUrls: List<String>.from(
          json['imageUrls'] ?? []), // Ensure it's an empty list if no images
    );
  }
}
