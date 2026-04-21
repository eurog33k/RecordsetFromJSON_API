# Xojo API 1.0 vs UseDatabase / UseRecordSet — Comparison

> Source: Xojo 2019r1.1 documentation (last release with API 1.0).
> Implementation state: as of 2026-03-24.

---

## 1. Database class (Xojo API 1.0)

`Database` is the abstract base class for all database drivers. Concrete subclasses: `SQLiteDatabase`, `PostgreSQLDatabase`, `MySQLCommunityServer`, `ODBCDatabase`, `OracleDatabase`, `MSSQLServerDatabase`.

### Properties

| Property | Type | Description |
|---|---|---|
| `DatabaseName` | `String` | Name of the database |
| `Host` | `String` | Server hostname or IP |
| `UserName` | `String` | Login username |
| `Password` | `String` | Login password |
| `Error` | **`Boolean`** | `True` if the last operation produced an error |
| `ErrorMessage` | `String` | Human-readable description of the last error |
| `ErrorCode` | `Integer` | Numeric error code from the database driver |

### Methods

| Method | Returns | Description |
|---|---|---|
| `Connect()` | `Boolean` | Opens the connection. Returns `True` on success. |
| `Close()` | — | Closes the connection and frees resources. |
| `SQLSelect(sql As String)` | `RecordSet` | Executes a SELECT query. Returns `Nil` on error. |
| `SQLExecute(sql As String)` | — | Executes INSERT / UPDATE / DELETE / DDL. Sets `Error` / `ErrorMessage` on failure. |
| `InsertRecord(tableName As String, record As DatabaseRecord)` | — | Inserts a new row from a `DatabaseRecord`. Check `Error` afterward. |
| `Prepare(sql As String)` | `PreparedSQLStatement` | Creates a prepared statement with `?` / `$1` placeholders. |
| `Commit()` | — | Commits the current transaction. |
| `Rollback()` | — | Rolls back the current transaction. |
| `TableSchema(tableName As String = "")` | `RecordSet` | Lists tables (no arg) or column info for a table. |
| `FieldSchema(tableName As String)` | `RecordSet` | Returns column metadata for the given table. |
| `IndexSchema(tableName As String)` | `RecordSet` | Returns index metadata for the given table. |

---

## 2. UseDatabase

`UseDatabase` wraps `modSQL`, routing all SQL over HTTP to the XojoDemoServer or the production Bouwsoft API. Each instance holds its own access token, enabling multiple simultaneous connections with different credentials.

`UseDatabase` implements the `IDatabase` interface, so `Dim db As IDatabase` accepts it.

### Methods

| Method | Returns | Description |
|---|---|---|
| `Connect()` | `Boolean` | Calls `modSQL.GetAccessToken`. Stores the token on the instance. Returns `True` if a token was obtained. |
| `Close()` | — | Clears connection state and token. No-op for the HTTP driver (no persistent socket). |
| `SQLSelect(sql As String)` | `UseRecordSet` | POSTs SQL to the API; parses JSON into a `UseRecordSet` (JSON mode). Returns `Nil` on failure. |
| `SQLSelectDB(sql As String)` | `UseRecordSet` | Same as `SQLSelect` but uses the in-memory SQLite backend (DB mode). Supports full bidirectional navigation. |
| `SQLExecute(sql As String)` | — | POSTs a non-SELECT statement; discards result. Sets `ErrorMessage` on failure. |
| `InsertRecord(tableName As String, record As UseDatabaseRecord)` | — | Builds INSERT from a `UseDatabaseRecord` and calls `SQLExecute`. |
| `Prepare(sql As String)` | `UsePreparedStatement` | Returns a `UsePreparedStatement` for the given SQL template. Supports `?` and `$N` markers. |
| `Error()` | **`Boolean`** | `True` if the last operation produced an error. |
| `ErrorMessage()` | `String` | Human-readable error from the last failed operation. Server-side JSON `{"error":"..."}` is surfaced here. |
| `ErrorCode()` | `Integer` | Always `0` — no driver-level error codes in HTTP mode. |
| `Connected()` | `Boolean` | `True` after a successful `Connect`. |

---

## 3. Side-by-side: Database (API 1.0) vs UseDatabase

| Feature | Xojo `Database` (API 1.0) | `UseDatabase` | Gap |
|---|---|---|---|
| `Connect()` | ✅ Returns `Boolean` | ✅ Returns `Boolean` | — |
| `Close()` | ✅ | ✅ No-op (HTTP) | No socket to close, but compiles |
| `SQLSelect(sql)` | ✅ Returns `RecordSet` | ✅ Returns `UseRecordSet` | Different return type — `Dim rs As RecordSet` won't compile |
| `SQLExecute(sql)` | ✅ | ✅ | — |
| `InsertRecord(table, DatabaseRecord)` | ✅ Takes `DatabaseRecord` | ✅ Takes `UseDatabaseRecord` | Parameter type differs — not a true drop-in |
| `Prepare(sql)` | ✅ Returns `PreparedSQLStatement` | ✅ Returns `UsePreparedStatement` | Return type differs; `Dim ps As PreparedSQLStatement` won't compile |
| `Commit()` | ✅ | ❌ Not implemented | Transactions are not possible over stateless HTTP |
| `Rollback()` | ✅ | ❌ Not implemented | Transactions are not possible over stateless HTTP |
| `Error` | ✅ **Boolean** property | ✅ `Error()` returns **Boolean** | Method vs property — `If db.Error` works |
| `ErrorMessage` | ✅ String property | ✅ `ErrorMessage()` returns String. Server JSON `error` key is surfaced. | Method vs property — `db.ErrorMessage` works |
| `ErrorCode` | ✅ Integer property | ✅ `ErrorCode()` returns `0` | Always 0 — no driver error codes |
| `TableSchema()` | ✅ | ❌ Not implemented | |
| `FieldSchema()` | ✅ | ❌ Not implemented | |
| `IndexSchema()` | ✅ | ❌ Not implemented | |
| `DatabaseName` / `Host` / `UserName` / `Password` | ✅ | ❌ Not implemented | Config is handled by constants in `modSQL` |
| Per-instance token | N/A (driver manages) | ✅ Each instance holds its own token | Extra capability vs native driver |
| `IDatabase` interface | ✅ `Dim db As Database` | ✅ `Dim db As IDatabase` | Interface name differs; `As Database` still won't compile |

### Methods/properties still missing from UseDatabase

| Missing | Priority |
|---|---|
| `TableSchema()` / `FieldSchema()` / `IndexSchema()` | Low — rarely used in application code |
| `DatabaseName` / `Host` / `UserName` / `Password` | Low — connection config not exposed on the object |

---

## 4. DatabaseRecord class (Xojo API 1.0)

Used as the argument to `Database.InsertRecord`. Populated with typed column setters, all using Assigns syntax.

### Methods

| Method | Description |
|---|---|
| `Column(name As String, Assigns value As String)` | Stores a String value |
| `IntegerColumn(name As String, Assigns value As Integer)` | Stores an Integer |
| `DoubleColumn(name As String, Assigns value As Double)` | Stores a Double |
| `BooleanColumn(name As String, Assigns value As Boolean)` | Stores a Boolean |
| `DateColumn(name As String, Assigns value As Date)` | Stores a Date/Timestamp |
| `Int64Column(name As String, Assigns value As Int64)` | Stores an Int64 |
| `CurrencyColumn(name As String, Assigns value As Currency)` | Stores a Currency value |
| `BlobColumn(name As String, Assigns value As MemoryBlock)` | Stores binary data |
| `PictureColumn(name As String, Assigns value As Picture)` | Stores a Picture |
| `FieldCount() As Integer` | Number of columns set |
| `FieldName(index As Integer) As String` | Column name at 0-based index |
| `FieldType(index As Integer) As Integer` | Column type code at 0-based index |

---

## 5. DatabaseRecord vs UseDatabaseRecord

| Feature | `DatabaseRecord` (API 1.0) | `UseDatabaseRecord` | Gap |
|---|---|---|---|
| `Column(name) = value` (String) | ✅ Assigns | ✅ Assigns | — |
| `IntegerColumn(name) = value` | ✅ Assigns | ✅ Assigns | — |
| `DoubleColumn(name) = value` | ✅ Assigns | ✅ Assigns | — |
| `BooleanColumn(name) = value` | ✅ Assigns (True/False) | ✅ Assigns → stores "1"/"0" | — |
| `DateColumn(name) = value` | ✅ Assigns | ✅ Assigns (formats as `YYYY-MM-DD HH:MM:SS`) | — |
| `Int64Column(name) = value` | ✅ Assigns | ✅ Assigns | — |
| `CurrencyColumn(name) = value` | ✅ Assigns | ✅ Assigns → stores via `CStr` | — |
| `BlobColumn(name) = value` | ✅ Assigns | ✅ Assigns → stores `""` | Binary data cannot be sent as JSON — stored as empty string |
| `PictureColumn(name) = value` | ✅ Assigns | ❌ Not implemented | Binary data not supported |
| `FieldCount()` | ✅ | ✅ | — |
| `FieldName(index)` | ✅ 0-based | ✅ 0-based | — |
| `FieldType(index)` | ✅ | ❌ Not implemented | Type info not stored |

---

## 6. RecordSet class (Xojo API 1.0)

### Properties

| Property | Type | Description |
|---|---|---|
| `BOF` | `Boolean` | `True` when positioned before the first record |
| `EOF` | `Boolean` | `True` when positioned after the last record |
| `FieldCount` | `Integer` | Number of columns |
| `RecordCount` | `Integer` | Total number of records |

### Methods

| Method | Returns | Description |
|---|---|---|
| `Field(name As String)` | `DatabaseField` | Returns column by name |
| `IdxField(index As Integer)` | `DatabaseField` | Returns column by 1-based index |
| `ColumnType(index As Integer)` | `Integer` | Xojo type code for the column (1-based) |
| `MoveFirst()` | — | Moves to the first record |
| `MoveLast()` | — | Moves to the last record |
| `MoveNext()` | — | Advances to the next record; releases Edit lock |
| `MovePrevious()` | — | Moves to the previous record |
| `Edit()` | — | Locks the current record for editing |
| `Update()` | — | Commits the edit and releases the lock |
| `DeleteRecord()` | — | Deletes the current record |
| `Close()` | — | Releases the cursor; releases any Edit lock |

> **Navigation limitations by driver**: SQLite, Oracle, ODBC support all four move methods. MySQL, MS SQL Server, and PostgreSQL support `MoveNext` only.

---

## 7. RecordSet vs UseRecordSet

| Feature | Xojo `RecordSet` (API 1.0) | `UseRecordSet` | Gap |
|---|---|---|---|
| `BOF` | ✅ | ✅ | — |
| `EOF` | ✅ | ✅ | — |
| `RecordCount` | ✅ | ✅ | — |
| `FieldCount` | ✅ | ✅ | — |
| `Field(name)` | ✅ Returns `DatabaseField` | ✅ Returns `UseRecordSetField` | Different return type — `Dim f As DatabaseField` won't compile |
| `IdxField(index)` | ✅ Returns `DatabaseField` | ✅ Returns `UseRecordSetField` | Different return type name — same typed accessors available |
| `ColumnType(index)` | ✅ 1-based | ✅ 1-based | — |
| `MoveFirst()` | ✅ | ✅ | — |
| `MoveLast()` | ✅ | ✅ | — |
| `MoveNext()` | ✅ Releases Edit lock | ✅ (no lock to release) | Concurrency behaviour differs |
| `MovePrevious()` | ✅ SQLite/Oracle/ODBC only | ✅ Both JSON and DB mode | Extra capability vs MySQL/PG sources |
| `Edit()` | ✅ Locks the row server-side | ✅ Copies to local buffer; no lock | No concurrency protection |
| `Update()` — non-null values | ✅ | ✅ Sends `SET col = 'value'` | — |
| `Update()` — Nil values | ✅ Writes `NULL` | ✅ Writes `SET col = NULL` | — |
| `Update()` WHERE clause | ✅ Uses live cursor | ✅ `IS NULL`-aware (`WHERE pk IS NULL` / `WHERE pk = 'val'`) | — |
| `DeleteRecord()` WHERE clause | ✅ Uses live cursor | ✅ `IS NULL`-aware | — |
| `DeleteRecord()` | ✅ | ✅ Sends DELETE via HTTP | No live cursor |
| `Close()` | ✅ Releases cursor + lock | ✅ Releases in-memory data | No server-side unlock |

---

## 8. DatabaseField class (Xojo API 1.0)

Returned by `RecordSet.Field()` and `RecordSet.IdxField()`.

### Properties

| Property | Type | Notes |
|---|---|---|
| `Name` | `String` | Column name |
| `StringValue` | `String` | Value as String |
| `IntegerValue` | `Integer` | Value as Integer |
| `DoubleValue` | `Double` | Value as Double |
| `BooleanValue` | `Boolean` | Strict: only `"0"`/`"False"` → False, `"1"`/`"True"` → True |
| `DateValue` | `Date` | Value as Date (includes time for Timestamp fields) |
| `Int64Value` | `Int64` | Value as Int64 |
| `CurrencyValue` | `Currency` | Value as Currency |
| `PictureValue` | `Picture` | Value as Picture (binary fields) |
| `NativeValue` | `Variant` | Raw driver value |
| `Value` (Assigns) | `Variant` | Read/write. Set to `Nil` to store NULL. |

### Methods

| Method | Returns | Description |
|---|---|---|
| `GetString()` | `String` | Same as `StringValue` |
| `SetString(s As String)` | — | Same as `Value = s` |

> **NULL handling**: Properties returning intrinsic types return their default value if the column is NULL. To check for NULL: `If rs.Field("x").Value Is Nil`. To set NULL: `rs.Field("x").Value = Nil`.

---

## 9. DatabaseField vs UseRecordSetField

| Feature | `DatabaseField` (API 1.0) | `UseRecordSetField` | Gap |
|---|---|---|---|
| `Name` | ✅ | ✅ | — |
| `StringValue` | ✅ | ✅ | — |
| `IntegerValue` | ✅ | ✅ | — |
| `DoubleValue` | ✅ | ✅ | — |
| `BooleanValue` | ✅ Strict Boolean parsing | ✅ Via Variant.BooleanValue | May differ for edge-case strings |
| `DateValue` | ✅ Returns `Date` with time | ✅ Returns `Date` or `Nil` | — |
| `Int64Value` | ✅ | ✅ | — |
| `CurrencyValue` | ✅ Returns `Currency` | ✅ Returns `Currency` via `CDbl` coercion | — |
| `PictureValue` | ✅ | ✅ Returns `Nil` | Binary data not supported over HTTP/JSON |
| `NativeValue` | ✅ Raw driver value | ✅ Returns same `Variant` as `Value` | Functionally equivalent |
| `Value` (Assigns) | ✅ | ✅ | — |
| `GetString()` | ✅ | ✅ | — |
| `SetString(s)` | ✅ | ✅ | — |
| NULL check via `Value Is Nil` | ✅ | ✅ Works in JSON/DB mode | — |
| NULL write via `Value = Nil` | ✅ Writes true SQL `NULL` | ✅ Writes `SET col = NULL` in Update | — |

---

## 10. PreparedSQLStatement (Xojo API 1.0)

`PreparedSQLStatement` is an interface. `Database.Prepare(sql)` returns the concrete subclass for the connected driver.

### Methods

| Method | Description |
|---|---|
| `BindType(index As Integer, type As Integer)` | Sets the type of parameter at 0-based index. Required for SQLite; optional for PostgreSQL. |
| `Bind(index As Integer, value As Variant)` | Binds a value to the parameter at 0-based index. |
| `SQLSelect(ParamArray values As Variant)` | Executes the prepared SELECT. Returns `RecordSet`. |
| `SQLExecute(ParamArray values As Variant)` | Executes the prepared INSERT/UPDATE/DELETE. |

**SQLite markers**: `?`, `?NNN`, `:VVV`, `@VVV`, `$VVV`
**PostgreSQL markers**: `$1`, `$2`, `$3`, …

```vb
' SQLite example
Dim ps As SQLitePreparedStatement = db.Prepare("SELECT * FROM Team WHERE Name = ?")
ps.BindType(0, SQLitePreparedStatement.SQLITE_TEXT)
Dim rs As RecordSet = ps.SQLSelect("Penguins")

' PostgreSQL example
Dim ps As PostgreSQLPreparedStatement = db.Prepare("SELECT * FROM Team WHERE Name LIKE $1")
ps.Bind(0, "P%")
Dim rs As RecordSet = ps.SQLSelect
```

> `UseDatabase.Prepare` returns a real `UsePreparedStatement`. It supports `?` (SQLite-style) and `$N` (PostgreSQL-style) markers. The return type is `UsePreparedStatement` rather than a driver-specific subclass of `PreparedSQLStatement`, so `Dim ps As SQLitePreparedStatement` won't compile — use `Dim ps As UsePreparedStatement`.

---

## 11. IDatabase interface

`IDatabase` is a Xojo interface implemented by `UseDatabase`. It declares all 11 public methods, allowing:

```vb
Dim db As IDatabase = New UseDatabase
```

This closes the "shared interface" blocker for dependency injection and testability. Code that declares `Dim db As Database` (the Xojo abstract class) still requires a source change to `Dim db As IDatabase`.

---

## 12. Drop-in replacement gap summary

### Remaining compile-time blockers

| Issue | Detail |
|---|---|
| `SQLSelect` / `SQLExecute` return types | `RecordSet` vs `UseRecordSet`; `DatabaseField` vs `UseRecordSetField`. Typed `Dim` declarations won't compile. |
| `InsertRecord` parameter type | `DatabaseRecord` vs `UseDatabaseRecord`. Code passing a `DatabaseRecord` won't compile. |
| `Dim db As Database` | Requires change to `Dim db As IDatabase`. |
| `Prepare(sql)` return type | Returns `UsePreparedStatement` not `PreparedSQLStatement`. `Dim ps As PreparedSQLStatement` won't compile. |
| `Commit()` / `Rollback()` | Not implemented — transactions are not possible over stateless HTTP. |
| `TableSchema()` / `FieldSchema()` / `IndexSchema()` | Any schema inspection code won't compile. |

### Remaining behavioural gaps — compiles but differs

| Issue | Detail |
|---|---|
| No row locking | `Edit()` in Xojo locks the row server-side. `UseRecordSet.Edit` only buffers locally. Concurrent writes silently overwrite each other. |
| `MoveNext` does not release a lock | In Xojo, `MoveNext` releases an Edit lock. In `UseRecordSet` there is nothing to release. |
| No cursor refresh after `Update` | After `Update()` in Xojo the live cursor reflects the new value. `UseRecordSet` requires re-opening the recordset to see changes. |
| `PictureValue` always returns `Nil` | Binary/image data cannot be transmitted over the HTTP/JSON driver. |
| `BlobColumn` stores `""` | Binary data in `UseDatabaseRecord.BlobColumn` is silently discarded. Use Base64 + `Column()` as a workaround. |
| `PictureColumn` not implemented | `UseDatabaseRecord` has no `PictureColumn` setter. |
| `FieldType(index)` not implemented | `UseDatabaseRecord` does not record type codes per column. |
| `DatabaseName` / `Host` / `UserName` / `Password` | Connection config is baked into `modSQL` constants; not settable on the `UseDatabase` instance. |

### Priority list to close remaining gaps

| Item | Effort | Impact |
|---|---|---|
| `PictureColumn` + Base64 round-trip | Medium | Binary data support |
| `DatabaseName` / `Host` on `UseDatabase` | Low | Removes last hard-coded config from `modSQL` |
| `UseDatabaseRecord.FieldType(index)` | Low | Removes last `DatabaseRecord` gap |
| `TableSchema()` / `FieldSchema()` | Low | Schema inspection for tooling |
