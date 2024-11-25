import 'package:flutter/material.dart';
import 'package:sos_mobile_app/user_state.dart'; // Access the logged-in user state
import '../service/donation_service.dart'; // Adjust the import path as necessary
import '../models/donation.dart'; // Adjust the import path as necessary

class DonationListScreen extends StatefulWidget {
  const DonationListScreen({super.key});

  @override
  _DonationListScreenState createState() => _DonationListScreenState();
}

class _DonationListScreenState extends State<DonationListScreen> {
  late Future<List<Donation>> donations;

  @override
  void initState() {
    super.initState();

    // Temporarily hardcode the user ID
    String userId = "UA013";

    // Ensure userId is not null before fetching donations
    donations = DonationService()
        .fetchDonations(userId); // Pass userId to fetchDonations
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation Records'),
      ),
      body: FutureBuilder<List<Donation>>(
        future: donations,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No donations found.'));
          } else {
            List<Donation> donationList = snapshot.data!;

            return ListView.builder(
              itemCount: donationList.length,
              itemBuilder: (context, index) {
                Donation donation = donationList[index];

                // Parse the date string to DateTime
                DateTime dateTime = DateTime.parse(donation.dateTime);

                return ListTile(
                  title: Text(donation.donationType), // Display donation type
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Amount: \$${donation.amount}'),
                      Text('Description: ${donation.description}'),
                      Text('Status: ${donation.status}'),
                      Text(
                          'Date: ${dateTime.toLocal()}'), // Use DateTime.toLocal() after parsing
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
