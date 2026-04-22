import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  final port = int.tryParse(Platform.environment['PORT'] ?? '') ?? 8080;
  final storage = GameStateStorage('data/game_state.json');
  final server = await HttpServer.bind(InternetAddress.anyIPv4, port);

  stdout.writeln('Pixel Life API running on http://localhost:$port');

  await for (final request in server) {
    try {
      await handleRequest(request, storage);
    } catch (error, stackTrace) {
      stderr.writeln('Request failed: $error');
      stderr.writeln(stackTrace);
      await writeJson(
        request.response,
        HttpStatus.internalServerError,
        {'error': 'Internal server error'},
      );
    }
  }
}

Future<void> handleRequest(
  HttpRequest request,
  GameStateStorage storage,
) async {
  addCorsHeaders(request.response);

  if (request.method == 'OPTIONS') {
    request.response.statusCode = HttpStatus.noContent;
    await request.response.close();
    return;
  }

  final path = request.uri.path;

  if (request.method == 'GET' && path == '/') {
    await writeJson(request.response, HttpStatus.ok, {
      'name': 'Pixel Life API',
      'version': '1.0.0',
      'routes': [
        {'method': 'GET', 'path': '/'},
        {'method': 'GET', 'path': '/health'},
        {'method': 'GET', 'path': '/game-state'},
        {'method': 'POST', 'path': '/game-state'},
        {'method': 'DELETE', 'path': '/game-state'},
      ],
    });
    return;
  }

  if (request.method == 'GET' && path == '/health') {
    await writeJson(request.response, HttpStatus.ok, {
      'status': 'ok',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
    return;
  }

  if (request.method == 'GET' && path == '/game-state') {
    final state = await storage.read();
    await writeJson(request.response, HttpStatus.ok, state);
    return;
  }

  if (request.method == 'POST' && path == '/game-state') {
    final body = await utf8.decoder.bind(request).join();
    if (body.trim().isEmpty) {
      await writeJson(
        request.response,
        HttpStatus.badRequest,
        {'error': 'Request body is empty'},
      );
      return;
    }

    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      await writeJson(
        request.response,
        HttpStatus.badRequest,
        {'error': 'JSON body must be an object'},
      );
      return;
    }

    final saved = await storage.write(decoded);
    await writeJson(request.response, HttpStatus.ok, {
      'message': 'Game state saved',
      'data': saved,
    });
    return;
  }

  if (request.method == 'DELETE' && path == '/game-state') {
    await storage.clear();
    await writeJson(request.response, HttpStatus.ok, {
      'message': 'Game state cleared',
      'data': storage.defaultState,
    });
    return;
  }

  await writeJson(
    request.response,
    HttpStatus.notFound,
    {'error': 'Route not found'},
  );
}

void addCorsHeaders(HttpResponse response) {
  response.headers.set('Access-Control-Allow-Origin', '*');
  response.headers.set(
    'Access-Control-Allow-Methods',
    'GET, POST, DELETE, OPTIONS',
  );
  response.headers.set('Access-Control-Allow-Headers', 'Content-Type');
}

Future<void> writeJson(
  HttpResponse response,
  int statusCode,
  Object data,
) async {
  response.statusCode = statusCode;
  response.headers.contentType = ContentType.json;
  response.write(jsonEncode(data));
  await response.close();
}

class GameStateStorage {
  GameStateStorage(this.relativePath);

  final String relativePath;

  Future<Map<String, dynamic>> read() async {
    final file = await _ensureFile();
    final content = await file.readAsString();

    if (content.trim().isEmpty) {
      return defaultState;
    }

    final decoded = jsonDecode(content);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return defaultState;
  }

  Future<Map<String, dynamic>> write(Map<String, dynamic> state) async {
    final file = await _ensureFile();
    final payload = {
      ...state,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };

    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(payload),
    );

    return payload;
  }

  Future<File> _ensureFile() async {
    final file = File(relativePath);

    if (!await file.parent.exists()) {
      await file.parent.create(recursive: true);
    }

    if (!await file.exists()) {
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(defaultState),
      );
    }

    return file;
  }

  Future<void> clear() async {
    final file = await _ensureFile();
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(defaultState),
    );
  }

  Map<String, dynamic> get defaultState => {
        'playerName': 'Player',
        'currentDay': 1,
        'currentMonth': 1,
        'walletBalance': 0,
        'mood': 60,
        'inventory': <Object>[],
        'updatedAt': null,
      };
}
