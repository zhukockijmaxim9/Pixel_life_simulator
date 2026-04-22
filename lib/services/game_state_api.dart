import 'dart:convert';

import 'package:http/http.dart' as http;

class GameStateApi {
  GameStateApi({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  static const String _defaultBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  Uri _buildUri(String path) => Uri.parse('$_defaultBaseUrl$path');

  Future<Map<String, dynamic>?> fetchGameState() async {
    final response = await _client.get(_buildUri('/game-state'));
    if (response.statusCode != 200) {
      throw GameStateApiException(
        'Failed to load game state: ${response.statusCode}',
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const GameStateApiException('API returned invalid game state JSON');
  }

  Future<void> saveGameState(Map<String, dynamic> payload) async {
    final response = await _client.post(
      _buildUri('/game-state'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode != 200) {
      throw GameStateApiException(
        'Failed to save game state: ${response.statusCode}',
      );
    }
  }

  Future<void> clearGameState() async {
    final response = await _client.delete(_buildUri('/game-state'));
    if (response.statusCode != 200) {
      throw GameStateApiException(
        'Failed to clear game state: ${response.statusCode}',
      );
    }
  }
}

class GameStateApiException implements Exception {
  const GameStateApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
