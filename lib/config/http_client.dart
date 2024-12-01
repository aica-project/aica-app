import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

// TODO : remove this method in production
http.Client createHttpClient() {
  final httpClient = HttpClient()
    ..badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

  return IOClient(httpClient);
}