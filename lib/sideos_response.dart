import 'dart:convert';

class SideosResponse {
  bool error = false;
  String message = "";

  SideosResponse(this.error, this.message);

  SideosResponse.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        message = json['message'];

  SideosResponse.fromJsonString(String jsonString) {
    var r = jsonDecode(jsonString);
    error = r['error'];
    message = r['message'];
  }

  Map<String, dynamic> toJson() => {'error': error, 'message': message};
}
