#tag Class
Protected Class UseRecordSet
	#tag Method, Flags = &h0
		Function BOF() As Boolean
		  ' Returns True when the cursor is positioned before the first record.
		  ' False at the start of a freshly opened recordset (cursor is already on the first record).
		  Dim bRtVal As Boolean
		  
		  If Not IsNull(m_rs) Then
		    Try
		      bRtVal = m_rs.BeforeFirstRow
		    Catch err As UnsupportedOperationException
		      bRtVal = True
		    End Try 
		  ElseIf m_iRecordCount = 0 Or m_bBeforeFirst Then
		    bRtVal = True
		  Else
		    bRtVal = False
		  End If
		  
		  Return bRtVal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  ' Releases all resources held by this recordset.
		  ' Clears the JSON row array in JSON mode; closes the SQLite RowSet in SQLite mode.
		  If Not IsNull(m_rs) Then
		    Try
		      m_rs.Close
		    Catch err As UnsupportedOperationException
		      'Do Nothing, it is closed allready
		    End Try
		    m_rs = Nil
		    m_strSql = ""
		    Redim m_arrColumnTypes(-1)
		  ElseIf Not IsNull(m_jsRows) Then
		    m_jsRows = Nil
		    m_jsCurrentRow = Nil
		    m_iRecordCount = 0
		    m_iCursor = 0
		    m_bBeforeFirst = False
		    m_strSql = ""
		    Redim m_arrColumnTypes(-1)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ColumnType(iIndex As Integer) As Integer
		  ' Returns the Xojo type code for the column at the given 1-based index.
		  ' Reads from m_arrColumnTypes, which is populated from server metadata during CreateRecordset:
		  '   JSON mode:   always 5 (String) — all values arrive as text over HTTP.
		  '   SQLite mode: mapped from PostgreSQL OID codes — returns the real backend type.
		  ' Type codes: 1=Boolean, 2=Date, 3=Double, 4=Integer, 5=String.
		  ' Note: do NOT delegate to m_rs.ColumnType() in SQLite mode — SQLite reports the storage
		  '       type of the inserted value (TEXT, since rows come from JSON strings), not the
		  '       column affinity, so it would always return 5.
		  If iIndex >= 1 And iIndex <= m_arrColumnTypes.Count Then
		    Return m_arrColumnTypes(iIndex - 1)
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function CreateRecordset(strSql As String, strContent As String, bDB As Boolean = False) As UseRecordSet
		  ' Factory method. Parses the JSON response body from the API into a UseRecordSet.
		  ' bDB=False (default): JSON mode — rows are navigated directly from the parsed JSON array.
		  ' bDB=True: SQLite mode — rows are loaded into an in-memory SQLite table so that
		  '           MovePrevious and MoveLast are available without re-querying the server.
		  ' Returns Nil if the JSON cannot be parsed.
		  Dim rs As New UseRecordSet
		  Dim strSQLCreate As String
		  Dim strSQLInsertInto As String
		  Dim strSQLInsertValues As String
		  Dim strSQLToDB As String
		  Dim jsContent As MyJSONItem
		  Dim jsRow As MyJSONItem
		  Dim bConnected As Boolean
		  Dim strFieldName As String
		  Dim strFieldValue As String
		  
		  rs.m_rs = Nil
		  rs.m_iRecordCount = 0
		  rs.m_iCursor = 0
		  rs.m_jsCurrentRow = Nil
		  rs.SetSql(strSql, 0)
		  ' Auto-detect table name from "... FROM tablename ..."
		  Dim strUpperSQL As String = strSql.Uppercase
		  Dim iFrom As Integer = InStr(strUpperSQL, " FROM ")
		  If iFrom > 0 Then
		    Dim strRest As String = Mid(strSql, iFrom + 6)
		    Dim iSpace As Integer = InStr(strRest, " ")
		    If iSpace > 0 Then
		      rs.m_strTableName = Left(strRest, iSpace - 1)
		    Else
		      rs.m_strTableName = Trim(strRest)
		    End If
		  End If
		  rs.m_strPrimaryKey = "id"
		  Try
		    jsContent = New MyJSONItem(strContent)
		    If jsContent.Haskey("rows") Then
		      If jsContent.Haskey("rowCount") Then
		        rs.m_iRecordCount = jsContent.Value("rowCount")
		      End If
		      ' Parse field type info when returnInfo=true
		      Redim rs.m_arrColumnTypes(-1)
		      If jsContent.HasKey("fields") Then
		        
		        Dim jsFields As MyJSONItem
		        Dim jsFieldItem As MyJSONItem
		        Dim dataTypeID As Integer
		        Dim xojoType As Integer
		        jsFields = jsContent.Value("fields")
		        For fi As Integer = 0 To jsFields.Count - 1
		          jsFieldItem = jsFields.ValueAt(fi)
		          If bDB Then
		            ' DB mode: map PostgreSQL OIDs to Xojo types for SQLite column creation
		            dataTypeID = jsFieldItem.Value("dataTypeID")
		            Select Case dataTypeID
		            Case 16         ' bool
		              xojoType = 1  ' Boolean
		            Case 1082, 1083, 1114, 1184, 1186  ' date, time, timestamp, timestamptz, interval
		              xojoType = 2  ' Date
		            Case 700, 701, 1700, 790  ' float4, float8, numeric, money
		              xojoType = 3  ' Double
		            Case 20, 21, 23, 26  ' int8, int2, int4, oid
		              xojoType = 4  ' Integer
		            Case 17, 18, 19, 25, 1042, 1043, 114, 3802, 2950  ' bytea, char, name, text, bpchar, varchar, json, jsonb, uuid
		              xojoType = 5  ' String
		            Case Else
		              System.DebugLog "CreateRecordset: unmapped dataTypeID=" + CStr(dataTypeID) + " for field=" + jsFieldItem.Value("name")
		              Break  ' Unknown PostgreSQL type - inspect dataTypeID and field name in debugger
		              xojoType = 0
		            End Select
		          Else
		            ' JSON mode: all values arrive as text over HTTP regardless of backend type
		            xojoType = 5  ' String
		          End If
		          rs.m_arrColumnTypes.Append(xojoType)
		        Next
		      End If
		      if bDB=False Then
		        rs.m_jsRows = jsContent.Value("rows")
		        If rs.m_jsRows.Count > 0 Then
		          rs.m_jsCurrentRow = rs.m_jsRows.ValueAt(0)
		        End If
		      Else
		        jsContent = jsContent.Value("rows")
		        If jsContent.Count > 0 Then
		          jsRow = jsContent.ValueAt(0)
		          If jsRow.Count>0 Then
		            rs.m_DB = new SQLiteDatabase
		            Try
		              rs.m_DB.Connect
		              bConnected = True
		              for i As Integer=0 to jsRow.Count-1
		                strFieldname=jsRow.NameAt(i)
		                ' Determine SQLite column type from mapped Xojo type
		                Dim strSQLiteType As String
		                Dim iColType As Integer
		                If i < rs.m_arrColumnTypes.Count Then
		                  iColType = rs.m_arrColumnTypes(i)
		                Else
		                  iColType = 0
		                End If
		                Select Case iColType
		                Case 4  ' Integer (Boolean also stored as INTEGER)
		                  strSQLiteType = " INTEGER"
		                Case 3  ' Double
		                  strSQLiteType = " REAL"
		                Case 1  ' Boolean
		                  strSQLiteType = " INTEGER"
		                Case 2  ' Date
		                  strSQLiteType = " TEXT"
		                Case Else  ' String or Unknown
		                  strSQLiteType = " TEXT"
		                End Select
		                if strSQLCreate="" Then
		                  strSQLCreate = "CREATE TABLE t1("  + strFieldName + strSQLiteType + ","
		                elseif i < jsRow.Count-1 then
		                  strSQLCreate =  strSQLCreate + strFieldName + strSQLiteType + ","
		                else
		                  strSQLCreate =  strSQLCreate + strFieldName + strSQLiteType + ");"
		                end if
		                if strSQLInsertInto="" Then
		                  strSQLInsertInto =  "INSERT INTO t1("  + strFieldName + ","
		                elseif i < jsRow.Count-1 then
		                  strSQLInsertInto =  strSQLInsertInto + strFieldName + ","
		                else
		                  strSQLInsertInto =  strSQLInsertInto + strFieldName + ") "
		                end if
		              next
		              strSQLInsertInto = strSQLInsertInto + "VALUES "
		              rs.m_DB.ExecuteSQL(strSQLCreate)
		              strSQL=""
		            Catch error As DatabaseException
		              MessageBox("DB Connection Error: " + error.Message)
		            End Try
		          end if
		          If bConnected and jsContent.Count > 0 Then
		            for ir As Integer =0 to jsContent.Count- 1
		              strSQLInsertValues = strSQLInsertValues + "("
		              jsRow = jsContent.ValueAt(ir)
		              For i As Integer=0 to jsRow.Count-1
		                strFieldValue=jsRow.Value(jsRow.NameAt(i))
		                ' Insert numerics without quotes so SQLite stores the correct affinity.
		                ' Strings and dates are quoted. Empty values become NULL.
		                Dim strToken As String
		                If strFieldValue = "" Then
		                  strToken = "NULL"
		                ElseIf i < rs.m_arrColumnTypes.Count And (rs.m_arrColumnTypes(i) = 4 Or rs.m_arrColumnTypes(i) = 3 Or rs.m_arrColumnTypes(i) = 1) Then
		                  ' Integer (4), Double (3), Boolean (1) — unquoted
		                  strToken = strFieldValue
		                Else
		                  ' String (5), Date (2), unknown — quoted
		                  strToken = "'" + ReplaceAll(strFieldValue, "'", "''") + "'"
		                End If
		                if i < jsRow.Count - 1 Then
		                  strSQLInsertValues = strSQLInsertValues + strToken + ","
		                else
		                  strSQLInsertValues = strSQLInsertValues + strToken + ")"
		                end if
		              next
		              if ir< jsContent.Count-1 Then
		                strSQLInsertValues = strSQLInsertValues + ","
		              else
		                strSQLInsertValues = strSQLInsertValues + ";"
		              end if
		            next
		            strSQLToDB = strSQLInsertInto + strSQLInsertValues
		            rs.m_DB.ExecuteSQL(strSQLToDB)
		            strSQL=""
		            rs.m_rs = rs.m_DB.SelectSQL("SELECT * FROM t1;")
		          End If
		        End If
		        
		      End If
		    End If
		  Catch err As MyJSONException
		    rs = Nil
		  End Try
		  
		  Return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DbField(iIndex As Integer) As Variant
		  ' Returns the value of the column at the given 1-based index as a Variant.
		  ' Returns Nil if the index is out of range or the recordset is closed.
		  Dim v As Variant
		  Dim iPos As Integer
		  Dim strKey As String

		  v = Nil
		  If Not IsNull(m_rs) Then
		    If Not IsNull(m_rs.ColumnAt(iIndex-1)) Then
		      v = m_rs.ColumnAt(iIndex-1).Value
		    End If
		  ElseIf Not IsNull(m_jsCurrentRow) Then
		    iPos = iIndex - 1
		    If iPos >= 0 And m_jsCurrentRow.Count > iPos Then
		      strKey = m_jsCurrentRow.KeyAt(iPos)
		      If strKey <> "" Then
		        v = m_jsCurrentRow.Value(strKey)
		      End If
		    End If
		  End If
		  
		  Return v
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DbField(strFieldName As String) As Variant
		  ' Returns the value of the named column as a Variant.
		  ' Returns Nil if the column is not found or the recordset is closed.
		  Dim v As Variant
		  Dim iPos As Integer

		  v = Nil
		  If Not IsNull(m_rs) Then
		    If Not IsNull(m_rs.Column(strFieldName)) Then
		      v = m_rs.Column(strFieldName).Value
		    End If
		  ElseIf Not IsNull(m_jsCurrentRow) Then
		    If m_jsCurrentRow.Haskey(strFieldName) Then
		      v = m_jsCurrentRow.Value(strFieldName)
		    End If
		  End If
		  
		  Return v
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DbFieldName(iIndex As Integer) As String
		  ' Returns the column name at the given 1-based index. Returns "" if out of range.
		  Dim strRtVal As String
		  
		  If IsNull(m_rs) Or IsNull(m_rs.ColumnAt(iIndex-1)) Then
		    If Not IsNull(m_jsCurrentRow) then
		      strRtVal=m_jsCurrentRow.NameAt(iIndex-1)
		    else
		      strRtVal = ""
		    End If
		  Else
		    strRtVal = m_rs.ColumnAt(iIndex-1).Name
		  End If
		  
		  Return strRtVal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DeleteRecord()
		  ' Deletes the current row from the server by sending DELETE FROM table WHERE pk = ...
		  ' through the owning UseDatabase connection.
		  ' TableName and PrimaryKey are auto-detected from the SELECT SQL; override them if needed.
		  Dim strPK As String = m_strPrimaryKey
		  If strPK = "" Then strPK = "id"
		  If m_strTableName = "" Then Return
		  Dim vPK As Variant = DbField(strPK)
		  Dim strSQL As String = "DELETE FROM " + m_strTableName + " WHERE " + BuildWhereEqual(strPK, vPK) + ";"
		  If Not IsNull(m_ownerDB) Then
		    m_ownerDB.SQLExecute(strSQL)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Edit()
		  ' Copies the current row into a local edit buffer so field values can be changed.
		  ' After calling Edit, modify values with rs.Field("col").Value = newValue, then call Update.
		  ' Has no effect if Edit has already been called without a matching Update.
		  If m_bEditing Then Return
		  m_bEditing = True
		  Dim strPK As String = m_strPrimaryKey
		  If strPK = "" Then strPK = "id"
		  m_varPKValueForEdit = DbField(strPK)
		  Redim m_arrEditBuffer(-1)
		  For i As Integer = 1 To FieldCount
		    Dim strName As String = DbFieldName(i)
		    m_arrEditBuffer.Append(New UseRecordSetField(strName, DbField(strName)))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function EOF() As Boolean
		  ' Returns True when the cursor is past the last record, or when the recordset is empty or closed.
		  Dim bRtVal As Boolean
		  
		  If Not IsNull(m_rs) Then
		    Try
		      bRtVal = m_rs.AfterLastRow
		    Catch err As UnsupportedOperationException
		      bRtVal = True
		    End Try
		  ElseIf m_iRecordCount = 0 Then
		    bRtVal = True
		  ElseIf m_iCursor >= m_iRecordCount Then
		    bRtVal = True
		  Else
		    bRtVal = False
		  End If
		  
		  Return bRtVal 
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ExecutionTime() As Double
		  ' Returns the query execution time in seconds as reported by the API server.
		  Return m_dExecutionTime
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Field(strFieldName As String) As UseRecordSetField
		  ' Returns a UseRecordSetField for the named column on the current row.
		  ' If Edit has been called, returns the editable buffer entry so that Value assignments are buffered
		  ' until Update is called.
		  If m_bEditing Then
		    For i As Integer = 0 To m_arrEditBuffer.Count - 1
		      If m_arrEditBuffer(i).Name = strFieldName Then
		        Return m_arrEditBuffer(i)
		      End If
		    Next
		  End If
		  Return New UseRecordSetField(strFieldName, DbField(strFieldName))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldCount() As Integer
		  ' Returns the number of columns in the result set.
		  If Not IsNull(m_rs) Then
		    Return m_rs.ColumnCount
		  ElseIf not IsNull(m_jsCurrentRow) then
		    Return m_jsCurrentRow.Count
		  ElseIf not IsNull(m_jsRows) and m_jsRows.Count>0 then
		    Return MyJSONItem(m_jsRows.ValueAt(0)).Count
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IdxField(iIndex As Integer) As UseRecordSetField
		  ' Returns the column at the given 1-based index as a UseRecordSetField.
		  ' Consistent with Field(name): supports .Name, .StringValue, .IntegerValue, etc.
		  Return New UseRecordSetField(DbFieldName(iIndex), DbField(iIndex))
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveFirst()
		  ' Moves the cursor to the first record. BOF becomes False.
		  If Not IsNull(m_rs) Then
		    m_rs.MoveToFirstRow
		  ElseIf Not IsNull(m_jsRows) Then
		    m_bBeforeFirst = False
		    m_iCursor = 0
		    If m_jsRows.Count > 0 Then
		      m_jsCurrentRow = m_jsRows.ValueAt(0)
		    Else
		      m_jsCurrentRow = Nil
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveLast()
		  ' Moves the cursor to the last record.
		  If Not IsNull(m_rs) Then
		    m_rs.MoveToLastRow
		  ElseIf Not IsNull(m_jsRows) Then
		    m_bBeforeFirst = False
		    m_iCursor = m_iRecordCount - 1
		    If m_iCursor >= 0 And m_jsRows.Count > m_iCursor Then
		      m_jsCurrentRow = m_jsRows.ValueAt(m_iCursor)
		    Else
		      m_jsCurrentRow = Nil
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MoveNext()
		  ' Advances the cursor to the next record. After the last record, EOF becomes True.
		  If Not IsNull(m_rs) Then
		    m_rs.MoveToNextRow
		  ElseIf Not IsNull(m_jsRows) Then
		    If m_bBeforeFirst Then
		      m_bBeforeFirst = False
		      m_iCursor = 0
		      If m_jsRows.Count > 0 Then
		        m_jsCurrentRow = m_jsRows.ValueAt(0)
		      Else
		        m_jsCurrentRow = Nil
		      End If
		    ElseIf m_iCursor < m_iRecordCount Then
		      m_iCursor = m_iCursor + 1
		      If m_jsRows.Count > m_iCursor Then
		        m_jsCurrentRow = m_jsRows.ValueAt(m_iCursor)
		      Else
		        m_jsCurrentRow = Nil
		      End If
		    Else
		      m_jsCurrentRow = Nil
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MovePrevious()
		  ' Moves the cursor to the previous record. Before the first record, BOF becomes True.
		  If Not IsNull(m_rs) Then
		    m_rs.MoveToPreviousRow
		  ElseIf Not IsNull(m_jsRows) Then
		    If m_bBeforeFirst Then
		      'Already before first record; do nothing
		    ElseIf m_iCursor > 0 Then
		      m_iCursor = m_iCursor - 1
		      m_jsCurrentRow = m_jsRows.ValueAt(m_iCursor)
		    Else
		      m_bBeforeFirst = True
		      m_jsCurrentRow = Nil
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(rs As Rowset)
		  ' Allows a Xojo RowSet to be assigned directly to a UseRecordSet variable.
		  ' Used when wrapping a native SQLite result in a UseRecordSet.
		  Self.m_rs = rs
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PrimaryKey() As String
		  ' Returns the primary key column name used by Edit/Update/DeleteRecord. Defaults to "id".
		  If m_strPrimaryKey = "" Then Return "id"
		  Return m_strPrimaryKey
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PrimaryKey(Assigns s As String)
		  ' Sets the primary key column name used by Edit/Update/DeleteRecord.
		  m_strPrimaryKey = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function RecordCount() As Integer
		  ' Returns the total number of records in the result set.
		  ' In JSON mode this is the rowCount value from the API response.
		  ' In SQLite mode this is the row count of the in-memory SQLite table.
		  If Not IsNull(m_rs) Then
		    Return m_rs.RowCount
		  Else
		    Return m_iRecordCount
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetDatabase(db As UseDatabase)
		  ' Binds this recordset to its originating UseDatabase instance.
		  ' Required so that Edit/Update and DeleteRecord can route write operations
		  ' through the correct database connection and access token.
		  ' Called automatically by UseDatabase.SQLSelect and SQLSelectDB.
		  m_ownerDB = db
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetSql(strSql As String, dExecutionTime As Double)
		  ' Stores the original SQL statement and the server-reported execution time.
		  ' Called internally by CreateRecordset; not intended to be called directly.
		  m_strSql = strSql
		  m_dExecutionTime = dExecutionTime
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function TableName() As String
		  ' Returns the table name used by Edit/Update/DeleteRecord.
		  ' Auto-detected from the FROM clause of the SELECT SQL; override with TableName = "name" if needed.
		  Return m_strTableName
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub TableName(Assigns s As String)
		  ' Sets the table name used by Edit/Update/DeleteRecord.
		  ' Override when the auto-detected name from the SELECT SQL is incorrect (e.g. schema-qualified or aliased tables).
		  m_strTableName = s
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Update()
		  ' Flushes the edit buffer to the server by sending an UPDATE statement through the owning
		  ' UseDatabase connection. Must be preceded by a call to Edit.
		  ' Builds "UPDATE table SET col='val', ... WHERE pk = 'pkval'" using the buffered field values.
		  ' Clears the edit buffer and resets the editing flag on completion.
		  If Not m_bEditing Then Return
		  If m_strTableName = "" Or m_arrEditBuffer.Count = 0 Then
		    m_bEditing = False
		    Redim m_arrEditBuffer(-1)
		    Return
		  End If
		  Dim strPK As String = m_strPrimaryKey
		  If strPK = "" Then strPK = "id"
		  Dim strSet As String = ""
		  For i As Integer = 0 To m_arrEditBuffer.Count - 1
		    Dim f As UseRecordSetField = m_arrEditBuffer(i)
		    If f.Name <> strPK Then
		      If strSet <> "" Then strSet = strSet + ", "
		      If IsNull(f.Value) Then
		        strSet = strSet + f.Name + " = NULL"
		      Else
		        strSet = strSet + f.Name + " = '" + modSQL.EscapeSQLData(f.StringValue) + "'"
		      End If
		    End If
		  Next
		  If strSet <> "" Then
		    Dim strSQL As String = "UPDATE " + m_strTableName + " SET " + strSet + " WHERE " + BuildWhereEqual(strPK, m_varPKValueForEdit) + ";"
		    If Not IsNull(m_ownerDB) Then
		      m_ownerDB.SQLExecute(strSQL)
		    End If
		  End If
		  m_bEditing = False
		  Redim m_arrEditBuffer(-1)
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h21
		Private Function BuildWhereEqual(strFieldName As String, vValue As Variant) As String
		  ' Returns a SQL comparison fragment that is NULL-safe.
		  ' Nil values produce "col IS NULL"; non-Nil values produce "col = 'escaped_value'".
		  If IsNull(vValue) Then
		    Return strFieldName + " IS NULL"
		  Else
		    Return strFieldName + " = '" + modSQL.EscapeSQLData(CStr(vValue)) + "'"
		  End If
		End Function
	#tag EndMethod

	#tag Note, Name = FieldTypes
		                                                                                                                                                                                              
		  ┌─────────────────┬───────┬─────────────────────────────────────────────┐                                                                                                                   
		  │    Xojo type    │ Value │               PostgreSQL OIDs               │                                                                                                                   
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ Boolean         │ 1     │ 16 (bool)                                   │                                                                                                                   
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ Date            │ 2     │ 1082, 1083, 1114, 1184, 1186                │
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ Double          │ 3     │ 700, 701, 1700, 790                         │
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ Integer         │ 4     │ 20, 21, 23, 26                              │
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ String          │ 5     │ 17, 18, 19, 25, 1042, 1043, 114, 3802, 2950 │
		  ├─────────────────┼───────┼─────────────────────────────────────────────┤                                                                                                                   
		  │ Unknown → Break │ 0     │ anything else                               │
		  └─────────────────┴───────┴─────────────────────────────────────────────┘                                                                                                                   
		       
		
	#tag EndNote

	#tag Note, Name = Usage
		  UseRecordSet handles navigation and editing of an open result set.
		  Use UseDatabase for connecting, selecting, and inserting rows.
		
		  Update an existing record:
		  Dim db As New UseDatabase
		  db.Connect
		  Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM k115.aansprekingen WHERE id=1")
		  rs.Edit
		  rs.Field("aansprekingen").Value = "De Heer."
		  rs.Update
		  rs.Close
		
		  Delete a record:
		  Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM k115.aansprekingen WHERE id=42")
		  rs.DeleteRecord
		  rs.Close
		
		  Notes:
		  - Table name is auto-detected from the FROM clause of the SELECT SQL.
		    If the query is complex, set it manually: rs.TableName = "k115.aansprekingen"
		  - Primary key defaults to "id". Override with rs.PrimaryKey = "other_field"
		  - Write operations send SQL back through the same API endpoint.
		    Re-open the recordset if you need updated data.
	#tag EndNote


	#tag Property, Flags = &h21
		Private m_arrColumnTypes() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_arrEditBuffer() As UseRecordSetField
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bBeforeFirst As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bEditing As Boolean
	#tag EndProperty

	#tag Property, Flags = &h1
		Protected m_DB As SQLiteDatabase
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dExecutionTime As Double
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iCursor As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iRecordCount As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_jsCurrentRow As MyJSONItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_jsRows As MyJSONItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_ownerDB As UseDatabase
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_rs As RowSet
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_varPKValueForEdit As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strPrimaryKey As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strSql As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strTableName As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
