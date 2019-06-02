import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData(
    String protocol, String domain, String port, String collector,
    {String fetchURL = null}) async {
  String retriveURL = (fetchURL == null)
      ? protocol +
          '://' +
          domain +
          ':' +
          port +
          '/api/v1/data?options=nonzero&chart=' +
          collector
      : protocol + '://' + domain + ':' + port + fetchURL;
  final response = await http.get(retriveURL);
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load post');
  }
}
