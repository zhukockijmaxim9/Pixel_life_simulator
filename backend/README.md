# Pixel Life API Backend

This folder contains a minimal backend for the project written in pure Dart.

## What it does

The server exposes a very small HTTP API:

- `GET /` returns API info and the list of routes
- `GET /health` checks that the server is alive
- `GET /game-state` returns the saved game state
- `POST /game-state` saves the game state

The data is stored locally in `backend/data/game_state.json`.

## How to run

From the `backend/` folder:

```bash
dart run bin/server.dart
```

The default port is `8080`.

If you want a different port:

```bash
PORT=3000 dart run bin/server.dart
```

On PowerShell:

```powershell
$env:PORT=3000
dart run bin/server.dart
```
