# XojoDemoServer — Developer Manual

## Overview

XojoDemoServer is a lightweight local HTTP server that mimics the Bouwsoft REST API.
It lets you develop and test the RecordSetFromAPITextProject client library without connecting to the production server.

The server exposes two endpoints:

| Method | Path | Description |
|--------|------|-------------|
| GET | `/api/v1/Authorize/AccessToken` | Returns a fixed demo access token (valid until 2099). |
| POST | `/api/v2/apps/power/query` | Executes a SQL statement and returns JSON results. |

Any other path returns `{"error":"Not Found"}` with HTTP 404.

---

## Architecture

```
wndServer  (UI)
   │
   ├─ modDatabase      ← database backend (SQLite or PostgreSQL)
   ├─ modHTTPServer    ← server lifecycle (start / stop)
   │     └─ clsHTTPServer (ServerSocket)
   │           └─ clsHTTPConnection (TCPSocket) — one instance per connection
   └─ modQueryAPI      ← SQL execution + JSON serialisation
```

`modHTTPServer` manages the server lifecycle only. The actual HTTP work is handled by `clsHTTPServer` and `clsHTTPConnection`:

- **`clsHTTPServer`** extends `ServerSocket`. When a client connects, `AddSocket` returns a new `clsHTTPConnection` for that connection.
- **`clsHTTPConnection`** extends `TCPSocket`. Each instance independently buffers incoming data, parses the HTTP request, executes the query, and sends the response. Multiple connections are handled concurrently — one instance per client.

---

## Starting the Server

1. Build and run the project in Xojo.
2. In the **wndServer** window, select a backend from the dropdown:
   - **SQLite (in-memory)** — default; fast, no external dependencies.
   - **PostgreSQL (localhost)** — requires a local PostgreSQL instance (see below).
3. Enter a port number (default: **8080**).
4. Click **Start Server**.

The query log at the bottom shows every SQL statement received, how many rows it returned, and whether it produced an error.

Click **Stop Server** to shut down. The server can be restarted with a different backend without restarting the application.

---

## Database Backends

### SQLite (in-memory)

A fresh in-memory SQLite database is created every time the server starts. All four demo tables are created and seeded automatically. The database is discarded when the server stops — no files are written to disk.

### PostgreSQL (localhost)

Requires PostgreSQL running locally on port 5432 with:

| Setting | Value |
|---------|-------|
| Host | `localhost` |
| Port | `5432` |
| Database | `demo` (created automatically if missing) |
| Username | `postgres` |
| Password | `supersecretpwd` |

On every startup the server **drops and recreates** all four tables and reseeds them with the standard demo data. This guarantees a known state regardless of any changes made between runs.

---

## Demo Tables

All four tables are available in both backends:

### tracks (6 rows)
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key |
| name | TEXT | Track name (e.g. "Desktop", "Web") |

### speakers (10 rows)
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key |
| name | TEXT | Full name |
| country | TEXT | Country of origin |
| bio | TEXT | Short biography |

### sessions (12 rows, 2 days)
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key |
| title | TEXT | Session title |
| speaker_id | INTEGER | References speakers.id |
| track_id | INTEGER | References tracks.id |
| day | INTEGER | Conference day (1 or 2) |
| room | TEXT | Room name |
| start_time | TEXT | HH:MM |
| duration_minutes | INTEGER | Session length |

### products (10 rows)
| Column | Type | Description |
|--------|------|-------------|
| id | INTEGER | Primary key |
| name | TEXT | Product name |
| category | TEXT | "License", "Conference", or "Support" |
| price | REAL | Price in USD |
| description | TEXT | Short description |

---

## API Reference

### GET /api/v1/Authorize/AccessToken

Returns a fixed demo token. No authentication is required.

**Request headers:** none required (clientnr and refreshtoken are accepted but ignored).

**Response:**
```json
{
  "AccessToken": "demo-token",
  "ValidUntil": "2099-12-31T23:59:59Z"
}
```

---

### POST /api/v2/apps/power/query

Executes a SQL statement sent as the plain-text request body.

**Request headers:**
- `Accesstoken` — any non-empty value is accepted
- `ClientNr` — accepted but ignored
- `Content-Type` — `text/plain`

**Query parameters:**

| Parameter | Default | Description |
|-----------|---------|-------------|
| `removeNulls` | `true` | Accepted but currently ignored. |
| `returnInfo` | `false` | When `true`, includes a `fields` array with column metadata. |

**SELECT response (returnInfo=false):**
```json
{
  "rowCount": 6,
  "rows": [
    {"id": 1, "name": "Desktop"},
    ...
  ]
}
```

**SELECT response (returnInfo=true):**
```json
{
  "fields": [
    {"name": "id",   "tableID": 0, "columnID": 1, "dataTypeID": 23, "dataTypeSize": -1, "dataTypeModifier": -1, "format": "text"},
    {"name": "name", "tableID": 0, "columnID": 2, "dataTypeID": 25, "dataTypeSize": -1, "dataTypeModifier": -1, "format": "text"}
  ],
  "rowCount": 6,
  "rows": [...]
}
```

The `dataTypeID` values are PostgreSQL OIDs. The client library uses them to determine column types when loading results into a local SQLite table (SQLite/DB mode).

**Non-SELECT response:**
```json
{"rowCount": 0, "rows": []}
```

**Error response:**
```json
{"rowCount": 0, "rows": [], "error": "near \"SELEC\": syntax error"}
```

---

## PostgreSQL OID Mapping

The server maps Xojo `DatabaseColumn.Type` values to PostgreSQL OIDs so the JSON metadata matches what a real PostgreSQL server would return. This allows the client library to work identically against both the demo server and production.

| Xojo Type | OID | PostgreSQL type |
|-----------|-----|-----------------|
| SmallInt | 21 | int2 |
| Integer | 23 | int4 |
| Int64 | 20 | int8 |
| Float | 700 | float4 |
| Double / Currency / Decimal | 701 | float8 |
| Text / String | 25 | text |
| Char / Byte | 18 | char |
| Boolean | 16 | bool |
| Date | 1082 | date |
| Time / Timestamp | 1114 | timestamp |
| Everything else | 25 | text |

---

## CORS Support

All responses include `Access-Control-Allow-Origin: *` and `Access-Control-Allow-Headers: *`. OPTIONS preflight requests are answered with HTTP 204. This allows the server to be called directly from browser-based tools such as Postman or a web frontend during development.

---

## Module Reference

### modDatabase

| Method | Description |
|--------|-------------|
| `Initialize(bUsePostgres)` | Sets up the chosen backend, creates schema, and seeds data. |
| `GetDB() As Database` | Returns the active database connection for use by modQueryAPI. |

### modQueryAPI

| Method | Description |
|--------|-------------|
| `ExecuteQuery(sql, removeNulls, returnInfo) As String` | Runs SQL and returns a JSON string. |
| `GetQueryParam(queryString, param) As String` | Extracts a named value from a URL query string. |
| `EscapeJSON(s) As String` | Escapes a string for safe embedding in JSON. |

### modHTTPServer

| Method | Description |
|--------|-------------|
| `StartServer(port)` | Creates a `clsHTTPServer`, sets the port, and calls `Listen`. |
| `StopServer()` | Closes the `clsHTTPServer` and stops accepting new connections. |

### clsHTTPServer

Extends `ServerSocket`. Returns a new `clsHTTPConnection` for every accepted connection, enabling multiple simultaneous clients.

### clsHTTPConnection

Extends `TCPSocket`. Each instance handles one client connection from start to finish:

| Method | Description |
|--------|-------------|
| `DataAvailable` | Accumulates received bytes and calls `TryParseRequest` when data arrives. |
| `SendComplete` | Closes the connection after the response has been fully sent. |
| `TryParseRequest` | Waits for the full HTTP request (headers + body), then calls `HandleRequest`. |
| `HandleRequest` | Routes the request: CORS preflight, access token, query, or 404. |
| `SendResponse` | Writes the HTTP response with JSON content-type and CORS headers. |
| `SendCORSHeaders` | Responds to OPTIONS preflight with HTTP 204 and CORS allow headers. |
