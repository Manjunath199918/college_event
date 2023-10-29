import 'dart:convert';
import 'dart:html';
import 'package:http/http.dart' as http;

class NotificationHelper{
  static Future<bool> sendFcmMessage(String title, String message,String fcmtoken) async {
    try {

      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=your_server_key",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": fcmtoken,
      };

      var client = http.Client();
      var response =
      await client.post(Uri.parse(url), headers: header, body: json.encode(request));
      return true;
    } catch (e, s) {
      print(e);
      return false;
    }
  }
}