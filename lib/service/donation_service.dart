import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/donation.dart';

class DonationService {
  static const String _baseUrl =
      'https://soschildrenvillage.azurewebsites.net/api/Donation/GetDonationByUserId/';

  // Method to fetch donations for a specific user
  Future<List<Donation>> fetchDonations(String userId) async {
    final response = await http.get(Uri.parse('$_baseUrl$userId'));

    if (response.statusCode == 200) {
      // Decode the response body as a map
      final Map<String, dynamic> responseData = json.decode(response.body);

      // Check if the response has a "data" field (or adjust if your API uses a different name)
      if (responseData.containsKey('data')) {
        // If 'data' contains a list, map it to Donation objects
        List<dynamic> donationJson = responseData['data'];
        return donationJson.map((json) => Donation.fromJson(json)).toList();
      } else {
        throw Exception('No donation data found');
      }
    } else {
      throw Exception('Failed to load donations');
    }
  }
}
