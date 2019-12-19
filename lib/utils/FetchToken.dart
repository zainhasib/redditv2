import 'package:http/http.dart' as http;

Future fetchToken() async {
  var url =
      'https://www.reddit.com/api/v1/access_token?grant_type=refresh_token&refresh_token=xxxxxxxxxxx-C_BHgHe98oTlUc4O4qKZoyCYFSY';
  Map<String, String> headers = {'Authorization': 'Basic xxxxxxxxxxxx'};
  var response = await http.post(url, headers: headers);
  return response;
}
