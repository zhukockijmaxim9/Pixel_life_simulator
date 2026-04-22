# API Documentation

## Overview

This project now includes a simple backend API written in Dart.

Base URL during local development:

```text
http://localhost:8080
```

## Endpoints

### `GET /`

Returns basic API information and the list of available routes.

Example response:

```json
{
  "name": "Pixel Life API",
  "version": "1.0.0",
  "routes": [
    { "method": "GET", "path": "/" },
    { "method": "GET", "path": "/health" },
    { "method": "GET", "path": "/game-state" },
    { "method": "POST", "path": "/game-state" },
    { "method": "DELETE", "path": "/game-state" }
  ]
}
```

### `GET /health`

Checks that the API is running.

Example response:

```json
{
  "status": "ok",
  "timestamp": "2026-04-22T10:00:00.000Z"
}
```

### `GET /game-state`

Returns the current saved game state.

Example response:

```json
{
  "playerName": "Player",
  "currentDay": 1,
  "currentMonth": 1,
  "walletBalance": 0,
  "mood": 60,
  "inventory": [],
  "updatedAt": null
}
```

### `POST /game-state`

Saves the game state.

Request body example:

```json
{
  "playerName": "Max",
  "currentDay": 5,
  "currentMonth": 2,
  "walletBalance": 1250,
  "mood": 74,
  "inventory": ["mug", "cap"]
}
```

Example response:

```json
{
  "message": "Game state saved",
  "data": {
    "playerName": "Max",
    "currentDay": 5,
    "currentMonth": 2,
    "walletBalance": 1250,
    "mood": 74,
    "inventory": ["mug", "cap"],
    "updatedAt": "2026-04-22T10:05:00.000Z"
  }
}
```

### `DELETE /game-state`

Resets the saved game state to the default value.

Example response:

```json
{
  "message": "Game state cleared",
  "data": {
    "playerName": "Player",
    "currentDay": 1,
    "currentMonth": 1,
    "walletBalance": 0,
    "mood": 60,
    "inventory": [],
    "updatedAt": null
  }
}
```

## Storage

The API stores data in:

```text
backend/data/game_state.json
```

This is a simple local JSON file. There is no database yet.

## Run the server

Open a terminal in `backend/` and run:

```bash
dart run bin/server.dart
```

## Connect Flutter to the API

The Flutter app uses `http://localhost:8080` by default.

If you need a different backend URL, run the app with `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:8080
```

For an Android emulator, `localhost` usually points to the emulator itself, not your computer.
In that case use:

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

## Quick test with curl

Check health:

```bash
curl http://localhost:8080/health
```

Read game state:

```bash
curl http://localhost:8080/game-state
```

Save game state:

```bash
curl -X POST http://localhost:8080/game-state \
  -H "Content-Type: application/json" \
  -d "{\"playerName\":\"Max\",\"currentDay\":5,\"currentMonth\":2,\"walletBalance\":1250,\"mood\":74,\"inventory\":[\"mug\",\"cap\"]}"
```

Clear game state:

```bash
curl -X DELETE http://localhost:8080/game-state
```

## Notes

- The API supports CORS for local frontend development.
- The API is intentionally minimal and easy to extend.
- The next step would be connecting the Flutter app to these endpoints.
