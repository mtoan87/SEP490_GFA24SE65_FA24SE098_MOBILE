import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> donations = [];

  @override
  void initState() {
    super.initState();
    _fetchDonations();
  }

  Future<void> _fetchDonations() async {
    // Retrieve userId from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');

    if (userId == null) {
      print("User is not logged in");
      return;
    }

    try {
      // Call the API
      final response = await http.get(
        Uri.parse(
            'https://soschildrenvillage.azurewebsites.net/api/Donation/GetDonationByUserId/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final responseBody = json.decode(response.body) as Map<String, dynamic>;

        if (responseBody.containsKey('\$values')) {
          setState(() {
            donations = responseBody['\$values'] as List<dynamic>;
          });
        } else {
          print('No donations found.');
        }
      } else {
        print('Failed to load donations. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching donations: $e');
    }
  }

  Widget build(BuildContext context) {
    double totalDonations =
        donations.fold(0, (sum, item) => sum + item['amount']);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: donations.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: donations.length,
              itemBuilder: (context, index) {
                var donation = donations[index];
                return ListTile(
                  title: Text(donation['donationType']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: ${donation['amount']}'),
                      Text('Date: ${donation['dateTime']}'),
                      Text('Desc: ${donation['description']}'),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(donation['status']),
                    ],
                  ),
                  onTap: () {
                    // Thực hiện hành động khi nhấn vào donation nếu cần
                  },
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Total Donations'),
                    content: Text(
                        'Total Donations: \$${totalDonations.toStringAsFixed(2)}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Icon(Icons.attach_money),
            tooltip: 'Total Donate',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              // Thực hiện hành động khi nhấn vào nút My Donate nếu cần
            },
            child: Icon(Icons.list),
            tooltip: 'My Donations',
          ),
        ],
      ),
    );
  }
}
