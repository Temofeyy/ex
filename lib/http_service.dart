import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class HttpService {
  static Future<Map<String, dynamic>> get(String url, {Map<String, String>? headers}) async {
    final uri = Uri.parse(url);

    final response = await http.get(uri, headers: headers);

    switch(response.statusCode){
      case 401:
      case 505:
    }
    return jsonDecode(response.body);
  }
}

abstract class HttpException implements Exception{
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}

class UnauthorizedException extends HttpException {
  UnauthorizedException(): super('Unauthorized');
}
class ServerException extends HttpException {
  ServerException(): super('Server Exception');
}