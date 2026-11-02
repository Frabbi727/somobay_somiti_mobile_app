import 'dart:convert';
import 'dart:io';

/// A real API response body captured from the backend (docs/examples → test/fixtures).
Map<String, dynamic> fixture(String name) =>
    jsonDecode(File('test/fixtures/$name.json').readAsStringSync()) as Map<String, dynamic>;
