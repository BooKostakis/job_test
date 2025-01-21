import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchDataFromUrl(String urlString) async {
  final url = Uri.parse(urlString);

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      return decodedData;
    } else {
      throw Exception('Failed to load data from $urlString. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error during HTTP request to $urlString: $e');
  }
}
