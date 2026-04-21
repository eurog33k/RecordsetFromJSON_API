#tag Module
Protected Module modQueryAPI
	#tag Method, Flags = &h21
		Private Sub AddLogEntry(strSQL As String, iRowCount As Integer)
		  ' Appends a row to the on-screen query log (wndServer.lbLog).
		  ' iRowCount is the number of rows returned, or -1 if the query produced an error.
		  Dim dt As DateTime = DateTime.Now
		  Dim hr As String = CStr(dt.Hour)
		  Dim mn As String = CStr(dt.Minute)
		  Dim sc As String = CStr(dt.Second)
		  If hr.Length < 2 Then hr = "0" + hr
		  If mn.Length < 2 Then mn = "0" + mn
		  If sc.Length < 2 Then sc = "0" + sc
		  Dim strRC As String = If(iRowCount = -1, "ERR", CStr(iRowCount))
		  wndServer.lbLog.AddRow(hr + ":" + mn + ":" + sc, Left(strSQL.Trim, 80), strRC)
		  wndServer.lbLog.SelectedRowIndex = wndServer.lbLog.RowCount - 1
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function EscapeJSON(s As String) As String
		  ' Escapes a string for safe embedding inside a JSON value.
		  ' Escapes backslashes, double quotes, newlines, carriage returns, and tabs.
		  s = s.ReplaceAll(Chr(92), Chr(92) + Chr(92))
		  s = s.ReplaceAll(Chr(34), Chr(92) + Chr(34))
		  s = s.ReplaceAll(Chr(10), "\n")
		  s = s.ReplaceAll(Chr(13), "\r")
		  s = s.ReplaceAll(Chr(9),  "\t")
		  Return s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function ExecuteQuery(strSQL As String, bRemoveNulls As Boolean, bReturnInfo As Boolean) As String
		  ' Executes strSQL against the active database and returns a JSON string.
		  ' SELECT and WITH queries return {"rowCount":N,"rows":[...]}.
		  ' When bReturnInfo=True, a "fields" array with column metadata (name, dataTypeID, etc.) is prepended.
		  ' Non-SELECT statements are executed and return {"rowCount":0,"rows":[]}.
		  ' Any database error is returned as {"rowCount":0,"rows":[],"error":"message"}.
		  #Pragma Unused bRemoveNulls
		  Dim db As Database = modDatabase.GetDB
		  If IsNull(db) Then Return "{""rowCount"":0,""rows"":[]}"
		  Dim strFirst As String = strSQL.Trim.Left(6).Uppercase
		  If strFirst <> "SELECT" And strSQL.Trim.Left(4).Uppercase <> "WITH" Then
		    Try
		      db.ExecuteSQL(strSQL)
		    Catch err As DatabaseException
		      AddLogEntry(strSQL, -1)
		      Return "{""rowCount"":0,""rows"":[],""error"":""" + EscapeJSON(err.Message) + """}"
		    End Try
		    AddLogEntry(strSQL, 0)
		    Return "{""rowCount"":0,""rows"":[]}"
		  End If
		  Dim rs As RowSet
		  Try
		    rs = db.SelectSQL(strSQL)
		  Catch err As DatabaseException
		    Return "{""rowCount"":0,""rows"":[],""error"":""" + EscapeJSON(err.Message) + """}"
		  End Try
		  Dim iFieldCount As Integer = rs.ColumnCount
		  Dim arrNames() As String
		  Dim arrTypes() As Integer
		  For i As Integer = 0 To iFieldCount - 1
		    arrNames.Append(rs.ColumnAt(i).Name)
		    Dim tv As Variant = rs.ColumnAt(i).Type
		    arrTypes.Append(tv.IntegerValue)
		  Next
		  Dim strRows As String = ""
		  Dim iRowCount As Integer = 0
		  While Not rs.AfterLastRow
		    iRowCount = iRowCount + 1
		    If strRows <> "" Then strRows = strRows + ","
		    strRows = strRows + "{"
		    Dim bFirst As Boolean = True
		    For i As Integer = 0 To iFieldCount - 1
		      Dim col As DatabaseColumn = rs.ColumnAt(i)
		      If Not bFirst Then strRows = strRows + ","
		      strRows = strRows + Chr(34) + EscapeJSON(arrNames(i)) + Chr(34) + ":" + FormatValue(col, arrTypes(i))
		      bFirst = False
		    Next
		    strRows = strRows + "}"
		    rs.MoveToNextRow
		  Wend
		  rs.Close
		  Dim strJSON As String = "{"
		  If bReturnInfo Then
		    strJSON = strJSON + """fields"":["
		    For i As Integer = 0 To iFieldCount - 1
		      If i > 0 Then strJSON = strJSON + ","
		      strJSON = strJSON + "{""name"":" + Chr(34) + EscapeJSON(arrNames(i)) + Chr(34)
		      strJSON = strJSON + ",""tableID"":0,""columnID"":" + CStr(i + 1)
		      strJSON = strJSON + ",""dataTypeID"":" + CStr(XojoTypeToOID(arrTypes(i)))
		      strJSON = strJSON + ",""dataTypeSize"":-1,""dataTypeModifier"":-1,""format"":""text""}"
		    Next
		    strJSON = strJSON + "],"
		  End If
		  strJSON = strJSON + """rowCount"":" + CStr(iRowCount) + ",""rows"":[" + strRows + "]}"
		  AddLogEntry(strSQL, iRowCount)
		  Return strJSON
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatValue(col As DatabaseColumn, iType As Integer) As String
		  ' Formats a DatabaseColumn value as a JSON literal appropriate for its Xojo column type.
		  ' Integers and doubles are emitted unquoted; booleans as true/false; everything else as a quoted string.
		  Select Case iType
		  Case 2, 3, 19      ' SmallInt, Integer, Int64
		    Return CStr(col.IntegerValue)
		  Case 6, 7, 11, 13  ' Float, Double, Currency, Decimal
		    Return CStr(col.DoubleValue)
		  Case 12            ' Boolean
		    If col.BooleanValue Then Return "true" Else Return "false"
		  Case Else          ' Text, Char, Byte, Date, Time, Timestamp, Binary, String, Unknown
		    Return Chr(34) + EscapeJSON(col.StringValue) + Chr(34)
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetQueryParam(strQS As String, strParam As String) As String
		  ' Extracts the value of a named parameter from a URL query string (e.g. "removeNulls=false&returnInfo=true").
		  ' Parameter name matching is case-insensitive. Returns "" if the parameter is not found.
		  Dim parts() As String = Split(strQS, "&")
		  For Each p As String In parts
		    Dim iEq As Integer = InStr(p, "=")
		    If iEq > 0 Then
		      If Left(p, iEq - 1).Uppercase = strParam.Uppercase Then Return Mid(p, iEq + 1)
		    End If
		  Next
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function XojoTypeToOID(iType As Integer) As Integer
		  ' Maps Xojo DatabaseColumn.DatabaseColumnType values to PostgreSQL OIDs
		  Select Case iType
		  Case 1              ' Byte
		    Return 18         ' char
		  Case 2              ' SmallInt
		    Return 21         ' int2
		  Case 3              ' Integer
		    Return 23         ' int4
		  Case 4              ' Char
		    Return 18         ' char
		  Case 5              ' Text / VarChar / String
		    Return 25         ' text
		  Case 6              ' Float
		    Return 700        ' float4
		  Case 7              ' Double
		    Return 701        ' float8
		  Case 8              ' Date
		    Return 1082       ' date
		  Case 9, 10          ' Time, TimeStamp
		    Return 1114       ' timestamp
		  Case 11, 13         ' Currency, Decimal
		    Return 701        ' float8
		  Case 12             ' Boolean
		    Return 16         ' bool
		  Case 18             ' String
		    Return 25         ' text
		  Case 19             ' Int64
		    Return 20         ' int8
		  Case Else           ' Null, Binary, BLOB types, MacPICT, Unknown
		    Return 25         ' text
		  End Select
		End Function
	#tag EndMethod


	#tag ViewBehavior
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
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
