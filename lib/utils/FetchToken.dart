import 'package:http/http.dart' as http;

Future fetchToken() async {
  var url =
      'https://www.reddit.com/api/v1/access_token?grant_type=refresh_token&refresh_token=10667572874-C_BHgHe98oTlUc4O4qKZoyCYFSY';
  Map<String, String> headers = {'Authorization': 'Basic M0g2RzY2Qm1ZRmFfOHc6'};
  var response = await http.post(url, headers: headers);
  return response;
}
