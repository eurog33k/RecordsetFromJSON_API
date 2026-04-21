# RecordSetFromAPIv1 — Developer Manual

## Overview

This library provides a drop-in replacement for the Xojo `Database` / `RecordSet` pair that talks to a REST API instead of a direct database connection.
SQL queries are sent as plain text over HTTP; results come back as JSON.

The public surface is intentionally close to the classic Xojo API 1.0 database classes so that existing code can be migrated with minimal changes.

---

## Architecture

```
Your code
   │
   ▼
UseDatabase              ← connection + query entry point (implements IDatabase)
   │
   ├─ SQLSelect()        → UseRecordSet  (JSON mode — bidirectional, lightweight)
   ├─ SQLSelectDB()      → UseRecordSet  (SQLite mode — bidirectional, in-memory)
   ├─ SQLExecute()                       (INSERT / UPDATE / DELETE / DDL)
   ├─ Prepare()          → UsePreparedStatement
   └─ InsertRecord()     ← UseDatabaseRecord

UseRecordSet             ← navigate rows, read/edit/delete
   └─ Field()            → UseRecordSetField  ← typed value accessors

modSQL                   ← HTTP transport, token management, utility functions
```

All network traffic is HTTP to two endpoints:

| Operation | Method | Path |
|-----------|--------|------|
| Get access token | GET | `/api/v1/Authorize/AccessToken` |
| Run SQL | POST | `/api/v2/apps/power/query?removeNulls=false&returnInfo=true` |

---

## Quick Start

### 1. Connect

```xojo
Dim db As New UseDatabase
If Not db.Connect() Then
  MsgBox "Could not connect: " + db.ErrorMessage
  Return
End If
```

`Connect` fetches an access token from the server and caches it. All subsequent calls reuse it; the token is refreshed automatically when it expires.

### 2. Run a SELECT query

```xojo
Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks")
If rs = Nil Then
  MsgBox "Query failed: " + db.ErrorMessage
  Return
End If

While Not rs.EOF
  Dim id   As Integer = rs.Field("id").IntegerValue
  Dim name As String  = rs.Field("name").StringValue
  System.DebugLog CStr(id) + " – " + name
  rs.MoveNext
Wend

rs.Close
```

### 3. Bidirectional navigation

Both `SQLSelect` and `SQLSelectDB` support full bidirectional navigation — `MoveFirst`, `MoveLast`, `MovePrevious`, and `BOF` all work in either mode.

```xojo
Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks")
rs.MoveLast
System.DebugLog "Last: " + rs.Field("name").StringValue
rs.MoveFirst
System.DebugLog "First: " + rs.Field("name").StringValue
rs.Close
```

Use `SQLSelectDB` when you need accurate column type codes (`ColumnType` returns the real database type rather than always String).
It loads the API result into a local in-memory SQLite table — the network call still goes through the API.

---

## Configuration (modSQL constants)

These constants are defined in `modSQL` and control where the library connects:

| Constant | Default | Description |
|----------|---------|-------------|
| `DemoMode` | `True` | When True, uses `DemoServerURL` instead of the production server. |
| `DemoRefreshToken` | `"demo-refreshtoken"` | Refresh token used when `DemoMode` is True. |
| `DemoServerURL` | `http://localhost:8080` | URL of the local XojoDemoServer. |
| `KlantNr` | `115` | Client number sent as the `clientnr` / `ClientNr` request header. |
| `RefreshToken` | *(token string)* | Refresh token used to obtain an access token. |
| `ServerName` | `ra` | Production server host prefix (e.g. `ra` → `https://ra.bouwsoft.be/`). |

To switch to the production server set `DemoMode = False`. The library appends `.bouwsoft.be/` to `ServerName` automatically if not already present.

---

## UseDatabase Reference

### Connection

| Method | Description |
|--------|-------------|
| `Connect() As Boolean` | Fetches an access token. Returns True on success. |
| `Close()` | Clears the token and resets connection state. |
| `Connected() As Boolean` | True after a successful `Connect` and before `Close`. |

### Querying

| Method | Description |
|--------|-------------|
| `SQLSelect(sql) As UseRecordSet` | Bidirectional JSON result set. Returns Nil on failure. |
| `SQLSelectDB(sql) As UseRecordSet` | Bidirectional in-memory SQLite result set. Returns Nil on failure. |
| `SQLExecute(sql)` | Non-SELECT statement (INSERT / UPDATE / DELETE / DDL). |

### Writing rows

| Method | Description |
|--------|-------------|
| `InsertRecord(tableName, record As UseDatabaseRecord)` | Insert a new row using a named-column record object. |

### Prepared statements

```xojo
Dim ps As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
ps.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
ps.Bind(0, 3)
Dim rs As UseRecordSet = ps.SQLSelect
```

See [UsePreparedStatement Reference](#usepreparedstatement-reference) for full details.

### Error handling

| Method | Description |
|--------|-------------|
| `Error() As Boolean` | True if the last operation failed. |
| `ErrorMessage() As String` | Human-readable error description. |
| `ErrorCode() As Integer` | Always 0 for the HTTP-based driver. |

---

## UseRecordSet Reference

### Navigation

| Method | Description |
|--------|-------------|
| `MoveFirst()` | Go to the first record. |
| `MoveNext()` | Advance one record. After the last record EOF becomes True. |
| `MovePrevious()` | Go back one record. Before the first record BOF becomes True. |
| `MoveLast()` | Go to the last record. |
| `BOF() As Boolean` | True when positioned before the first record. |
| `EOF() As Boolean` | True when positioned after the last record or when the set is empty. |
| `Close()` | Releases all resources held by this recordset. |

> **Note:** Both JSON mode and SQLite mode start with the cursor on the first record (BOF = False). No explicit `MoveFirst` is needed after opening a recordset.

### Metadata

| Method | Description |
|--------|-------------|
| `RecordCount() As Integer` | Total number of rows. |
| `FieldCount() As Integer` | Number of columns. |
| `DbFieldName(index) As String` | Column name at 1-based index. |
| `ColumnType(index) As Integer` | Xojo type code at 1-based index (see table below). |
| `ExecutionTime() As Double` | Server-reported query execution time in seconds. |
| `TableName As String` | Table name — auto-detected from the FROM clause; override if needed. |
| `PrimaryKey As String` | Primary key column name — defaults to `"id"`. |

**ColumnType codes**

| Code | Type |
|------|------|
| 1 | Boolean |
| 2 | Date |
| 3 | Double |
| 4 | Integer |
| 5 | String |

> In JSON mode (`SQLSelect`) all columns always return type **5 (String)** because HTTP transport delivers every value as text, regardless of the underlying database column type. Use the typed accessors on `UseRecordSetField` to convert to the desired type.
>
> In SQLite mode (`SQLSelectDB`) the actual column types from the server metadata are used so the in-memory SQLite table is created with the correct affinity.

### Reading field values

```xojo
' By column name — returns UseRecordSetField
Dim name As String = rs.Field("name").StringValue

' By 1-based index — returns UseRecordSetField (same typed accessors as Field)
Dim id As Integer = rs.IdxField(1).IntegerValue
Dim colName As String = rs.IdxField(1).Name   ' "id"

' By 1-based index — returns raw Variant (no typed accessors)
Dim val As Variant = rs.DbField(1)

' Typed accessors on UseRecordSetField
rs.Field("price").DoubleValue       ' As Double
rs.Field("qty").IntegerValue        ' As Integer
rs.Field("active").BooleanValue     ' As Boolean
rs.Field("created").DateValue       ' As Date (or Nil)
rs.Field("notes").StringValue       ' As String
rs.Field("amount").CurrencyValue    ' As Currency
rs.Field("big_id").Int64Value       ' As Int64
```

### Editing a row

```xojo
Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id = 1")
rs.Edit
rs.Field("name").Value = "New Name"
rs.Update   ' sends: UPDATE tracks SET name='New Name' WHERE id='1'
rs.Close
```

`Edit` copies the current row into a local buffer. All `Field("col").Value = x` assignments go to the buffer. `Update` builds and sends the SQL UPDATE, then clears the buffer.

### Deleting a row

```xojo
Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id = 42")
rs.DeleteRecord   ' sends: DELETE FROM tracks WHERE id='42'
rs.Close
```

### Overriding table name and primary key

The table name is auto-detected from the first word after `FROM`. Override manually for schema-qualified tables or aliased queries:

```xojo
rs.TableName = "k115.aansprekingen"
rs.PrimaryKey = "aansprekingen_id"
```

---

## UsePreparedStatement Reference

Prepared statements substitute `?` (SQLite-style) or `$N` (PostgreSQL-style) markers with properly escaped and typed values.

```xojo
' SQLite-style ? markers
Dim ps As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
ps.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
ps.Bind(0, 3)
Dim rs As UseRecordSet = ps.SQLSelect

' PostgreSQL-style $N markers ($1 = index 0)
Dim ps2 As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE name LIKE $1")
ps2.BindType(0, UsePreparedStatement.SQLITE_TEXT)
ps2.Bind(0, "%API%")
Dim rs2 As UseRecordSet = ps2.SQLSelect

' Inline shorthand — values bound in order starting at index 0
Dim rs3 As UseRecordSet = ps.SQLSelect(3)

' Non-SELECT
Dim ps3 As UsePreparedStatement = db.Prepare("UPDATE tracks SET name = $1 WHERE id = $2")
ps3.BindType(0, UsePreparedStatement.SQLITE_TEXT)
ps3.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
ps3.Bind(0, "Updated Name")
ps3.Bind(1, 5)
ps3.SQLExecute
```

**BindType constants**

| Constant | Value | SQL rendering |
|----------|-------|---------------|
| `SQLITE_INTEGER` | 1 | Unquoted integer |
| `SQLITE_DOUBLE` | 2 | Unquoted decimal |
| `SQLITE_NULL` | 3 | `NULL` keyword |
| `SQLITE_BLOB` | 4 | Quoted text |
| `SQLITE_TEXT` | 5 | Quoted text (default when BindType not called) |

> Always call `BindType` before `Bind` for numeric parameters. Without it the value is quoted as text, which may cause a type mismatch on strict numeric columns.

---

## UseDatabaseRecord Reference

Preferred way to insert a new row:

```xojo
Dim rec As New UseDatabaseRecord
rec.Column("name")            = "New Track"
rec.IntegerColumn("score")    = 42
rec.DoubleColumn("ratio")     = 1.23
rec.BooleanColumn("active")   = True
rec.DateColumn("created")     = New Date
db.InsertRecord("tracks", rec)
If db.Error Then MsgBox "Insert failed: " + db.ErrorMessage
```

| Method | Description |
|--------|-------------|
| `Column(name) = value` | Store a String value. |
| `IntegerColumn(name) = value` | Store an Integer. |
| `DoubleColumn(name) = value` | Store a Double. |
| `BooleanColumn(name) = value` | Store True as `1`, False as `0`. |
| `DateColumn(name) = value` | Store a Date as `YYYY-MM-DD HH:MM:SS`. |
| `Int64Column(name) = value` | Store an Int64. |
| `CurrencyColumn(name) = value` | Store a Currency value. |
| `BlobColumn(name) = value` | Not supported — stores empty string. |
| `FieldCount() As Integer` | Number of columns set. |
| `FieldName(index) As String` | Column name at 0-based index. |
| `ValueAt(index) As String` | String value at 0-based index. |

---

## IDatabase Interface

`UseDatabase` implements `IDatabase`. Code against the interface to decouple your business logic from the HTTP implementation:

```xojo
Dim db As IDatabase = New UseDatabase
db.Connect
Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks")
```

---

## Error Handling Pattern

```xojo
Dim db As New UseDatabase
If Not db.Connect() Then
  System.DebugLog "Connect failed: " + db.ErrorMessage
  Return
End If

Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks")
If rs = Nil Then
  System.DebugLog "Query failed: " + db.ErrorMessage
  Return
End If

Try
  While Not rs.EOF
    ' process row
    rs.MoveNext
  Wend
Finally
  rs.Close
End Try
```

---

## Postman Testing

A Postman collection (`RecordSetFromAPI.postman_collection.json`) is included. Import it and configure the collection variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `authBaseUrl` | `https://charon.bouwsoft.be` | Auth server for token requests. |
| `baseUrl` | `http://localhost:8080` | Query server (local XojoDemoServer). |
| `clientNr` | `115` | Client number. |
| `refreshToken` | *(set in collection)* | Refresh token. |

Run **Get Access Token** first — the test script saves the returned token to `{{accessToken}}` automatically. Then run any request in the **Power Query** folder.

---

## Demo Server

For local development, use **XojoDemoServer** (separate project). It provides the same two API endpoints backed by either an in-memory SQLite database or a local PostgreSQL instance. See the XojoDemoServer manual for setup instructions.

Default connection when `DemoMode = True`:
- URL: `http://localhost:8080`
- Access token: any request returns the fixed token `demo-token`
