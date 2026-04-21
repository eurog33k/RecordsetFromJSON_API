#tag Class
Protected Class UseDatabase
Implements IDatabase
	#tag Method, Flags = &h0
		Function Connect() As Boolean
		  ' Obtain an access token from the API server.
		  ' Returns True if a token was successfully retrieved.
		  m_strError = ""
		  Try
		    modSQL.GetAccessToken(m_strAccessToken, m_dtTokenValidUntil)
		    m_bConnected = (m_strAccessToken <> "")
		    If Not m_bConnected Then
		      m_strError = "Could not obtain access token."
		    End If
		  Catch err As RuntimeException
		    m_bConnected = False
		    m_strError = err.Message
		  End Try
		  Return m_bConnected
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  ' Releases the connection state and clears the cached token.
		  ' For the HTTP-based driver there is no persistent socket to close.
		  m_bConnected = False
		  m_strError = ""
		  m_strAccessToken = ""
		  m_dtTokenValidUntil = Nil
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(strSQL As String) As UseRecordSet
		  ' Execute a SELECT query and return the result as a UseRecordSet.
		  ' Returns Nil if the query fails; check ErrorMessage for details.
		  m_strError = ""
		  EnsureToken
		  Dim rs As UseRecordSet
		  Try
		    rs = modSQL.Openrecordset(strSQL, m_strAccessToken)
		    If IsNull(rs) Then
		      m_strError = "Query returned no result."
		    Else
		      rs.SetDatabase(Me)
		    End If
		  Catch err As RuntimeException
		    m_strError = err.Message
		    rs = Nil
		  End Try
		  Return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(strSQL As String)
		  ' Execute a non-SELECT SQL statement (INSERT, UPDATE, DELETE, DDL).
		  ' Check Error / ErrorMessage afterward to detect failures.
		  m_strError = ""
		  EnsureToken
		  Try
		    Dim rs As UseRecordSet = modSQL.Openrecordset(strSQL, m_strAccessToken)
		    If Not IsNull(rs) Then rs.Close
		  Catch err As RuntimeException
		    m_strError = err.Message
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelectDB(strSQL As String) As UseRecordSet
		  ' Execute a SELECT query using the in-memory SQLite backend (DB mode).
		  ' DB mode supports full bidirectional navigation via MovePrevious / MoveLast.
		  ' Returns Nil if the query fails; check ErrorMessage for details.
		  m_strError = ""
		  EnsureToken
		  Dim rs As UseRecordSet
		  Try
		    rs = modSQL.Openrecordset(strSQL, m_strAccessToken, True)
		    If IsNull(rs) Then
		      m_strError = "Query returned no result."
		    Else
		      rs.SetDatabase(Me)
		    End If
		  Catch err As RuntimeException
		    m_strError = err.Message
		    rs = Nil
		  End Try
		  Return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(strTableName As String, record As UseDatabaseRecord)
		  ' Insert a new row using a UseDatabaseRecord (API 1.0 style).
		  ' Mirrors Database.InsertRecord(tableName, DatabaseRecord).
		  ' Check Error / ErrorMessage afterward.
		  m_strError = ""
		  If IsNull(record) Or record.FieldCount = 0 Then
		    m_strError = "InsertRecord: no columns specified."
		    Return
		  End If
		  Dim strFields As String = ""
		  Dim strValues As String = ""
		  Dim i As Integer
		  For i = 0 To record.FieldCount - 1
		    If strFields <> "" Then
		      strFields = strFields + ", "
		      strValues = strValues + ", "
		    End If
		    strFields = strFields + record.FieldName(i)
		    strValues = strValues + "'" + modSQL.EscapeSQLData(record.ValueAt(i)) + "'"
		  Next
		  Dim strSQL As String = "INSERT INTO " + strTableName + " (" + strFields + ") VALUES (" + strValues + ");"
		  SQLExecute(strSQL)
		End Sub
	#tag EndMethod


	#tag Method, Flags = &h0
		Function Prepare(strSQL As String) As UsePreparedStatement
		  ' Returns a UsePreparedStatement for the given SQL template.
		  ' Supports ? (SQLite style) and $N (PostgreSQL style) parameter markers.
		  ' Call BindType then Bind for each parameter, then SQLSelect or SQLExecute.
		  Return New UsePreparedStatement(strSQL, Me)
		End Function
	#tag EndMethod


	#tag Method, Flags = &h0
		Function Error() As Boolean
		  ' Returns True if the last operation produced an error.
		  ' Matches Database.Error (Boolean) in Xojo API 1.0.
		  Return (m_strError <> "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorMessage() As String
		  ' Returns the error description from the last failed operation.
		  ' Matches Database.ErrorMessage (String) in Xojo API 1.0.
		  Return m_strError
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorCode() As Integer
		  ' Returns a numeric error code.
		  ' Always 0 for the HTTP-based driver (no driver-level error codes).
		  Return 0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Connected() As Boolean
		  ' Returns True after a successful Connect call and before Close is called.
		  Return m_bConnected
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub EnsureToken()
		  ' Refreshes the access token if it is missing or expired.
		  ' Called automatically by SQLSelect and SQLExecute before each request.
		  Dim dtNow As New Date
		  If m_strAccessToken = "" Or IsNull(m_dtTokenValidUntil) Or dtNow.TotalSeconds >= m_dtTokenValidUntil.TotalSeconds Then
		    modSQL.GetAccessToken(m_strAccessToken, m_dtTokenValidUntil)
		  End If
		End Sub
	#tag EndMethod


	#tag Note, Name = Usage
		  ' --- Connect and check for error ---
		  Dim db As New UseDatabase
		  If Not db.Connect Then
		    MsgBox "Connect failed: " + db.ErrorMessage
		    Return
		  End If

		  ' --- SQLSelect ---
		  Dim rs As UseRecordSet = db.SQLSelect("SELECT * FROM Team ORDER BY Name")
		  If IsNull(rs) Then
		    MsgBox "Query failed: " + db.ErrorMessage
		    Return
		  End If
		  While Not rs.EOF
		    System.DebugLog rs.Field("Name").StringValue
		    rs.MoveNext
		  Wend
		  rs.Close

		  ' --- InsertRecord (API 1.0 style) ---
		  Dim row As New UseDatabaseRecord
		  row.Column("Name") = "Penguins"
		  row.Column("Coach") = "Bob Roberts"
		  row.IntegerColumn("Score") = 42
		  db.InsertRecord("Team", row)
		  If db.Error Then MsgBox "Insert failed: " + db.ErrorMessage

	#tag EndNote


	#tag Property, Flags = &h21
		Private m_bConnected As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_dtTokenValidUntil As Date
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strAccessToken As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strError As String
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
