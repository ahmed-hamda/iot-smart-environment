import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {

  final String baseUrl = "http://192.168.1.11:5000";

  Future getData(String uri) async {
    final url = Uri.parse(baseUrl + uri);

    print("GET => $url");

    final response = await http.get(url);

    print("STATUS => ${response.statusCode}");
    print("BODY => ${response.body}");

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("API error: ${response.statusCode}");
    }
  }

  Future patchData(String uri, Map<String, dynamic> body) async {
    final url = Uri.parse(baseUrl + uri);

    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("API error");
    }
  }

  Future deleteData(String uri) async {
    final url = Uri.parse(baseUrl + uri);

    final response = await http.delete(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("API error");
    }
  }
}