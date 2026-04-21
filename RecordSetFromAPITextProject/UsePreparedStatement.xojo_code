#tag Class
Protected Class UsePreparedStatement
	#tag Method, Flags = &h0
		Sub Constructor(strSQL As String, db As UseDatabase)
		  ' Creates a prepared statement from a SQL template and binds it to the given UseDatabase connection.
		  ' Use ? (SQLite-style) or $N (PostgreSQL-style) markers as parameter placeholders.
		  m_strSQL = strSQL
		  m_db = db
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Bind(index As Integer, value As Variant)
		  ' Binds a value to the parameter at the given 0-based index.
		  ' Matches SQLitePreparedStatement.Bind / PostgreSQLPreparedStatement.Bind.
		  Dim nullVar As Variant
		  While m_arrValues.Ubound < index
		    m_arrValues.Append(nullVar)
		  Wend
		  m_arrValues(index) = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BindType(index As Integer, iType As Integer)
		  ' Sets the SQL type for the parameter at the given 0-based index.
		  ' Use the SQLITE_* constants defined on this class.
		  ' Must be called before Bind when using integer or double parameters,
		  ' otherwise the value will be formatted as a quoted text literal.
		  While m_arrTypes.Ubound < index
		    m_arrTypes.Append(0)
		  Wend
		  m_arrTypes(index) = iType
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(ParamArray values As Variant) As UseRecordSet
		  ' Executes the prepared SELECT query. Optionally pass values inline in order;
		  ' they are bound starting at index 0 and override any prior Bind calls.
		  BindInlineValues(values)
		  Return m_db.SQLSelect(BuildSQL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(ParamArray values As Variant)
		  ' Executes the prepared non-SELECT statement (INSERT, UPDATE, DELETE, DDL).
		  ' Optionally pass values inline in order.
		  BindInlineValues(values)
		  m_db.SQLExecute(BuildSQL)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub BindInlineValues(values() As Variant)
		  ' Binds an array of values sequentially starting at index 0.
		  ' Called internally by the ParamArray overloads of SQLSelect and SQLExecute.
		  For i As Integer = 0 To values.Ubound
		    Bind(i, values(i))
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BuildSQL() As String
		  ' Substitutes bound parameters into the SQL template, producing a safe SQL string.
		  ' Supported markers:
		  '   ?       Sequential positional (SQLite style). First ? = index 0.
		  '   $N      Named positional (PostgreSQL style). $1 = index 0.
		  ' Markers inside single-quoted string literals are left untouched.
		  Dim result As String = ""
		  Dim iParamIndex As Integer = 0
		  Dim bInString As Boolean = False
		  Dim i As Integer = 1
		  Dim iLen As Integer = Len(m_strSQL)

		  While i <= iLen
		    Dim ch As String = Mid(m_strSQL, i, 1)

		    If bInString Then
		      result = result + ch
		      If ch = "'" Then
		        If i < iLen And Mid(m_strSQL, i + 1, 1) = "'" Then
		          ' Escaped quote '' — copy second quote and skip ahead
		          result = result + "'"
		          i = i + 1
		        Else
		          bInString = False
		        End If
		      End If

		    Else
		      Select Case ch
		      Case "'"
		        bInString = True
		        result = result + ch

		      Case "?"
		        result = result + FormatParam(iParamIndex)
		        iParamIndex = iParamIndex + 1

		      Case "$"
		        ' Collect digits following $
		        Dim j As Integer = i + 1
		        Dim strNum As String = ""
		        While j <= iLen
		          Dim numCh As String = Mid(m_strSQL, j, 1)
		          If numCh >= "0" And numCh <= "9" Then
		            strNum = strNum + numCh
		            j = j + 1
		          Else
		            Exit While  ' leave j pointing at the non-digit so i = j-1 resumes correctly
		          End If
		        Wend
		        If strNum <> "" Then
		          result = result + FormatParam(Val(strNum) - 1)  ' $1 → index 0
		          i = j - 1
		        Else
		          result = result + ch
		        End If

		      Case Else
		        result = result + ch
		      End Select
		    End If

		    i = i + 1
		  Wend

		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FormatParam(iIndex As Integer) As String
		  ' Formats the bound value at iIndex as a safe SQL fragment.
		  '
		  ' Type rules (resolved in order):
		  '   1. Unbound index or Nil value        → NULL (unquoted)
		  '   2. BindType = SQLITE_INTEGER          → unquoted integer
		  '   3. BindType = SQLITE_DOUBLE           → unquoted decimal
		  '   4. BindType = SQLITE_NULL             → NULL (unquoted)
		  '   5. BindType = SQLITE_TEXT / SQLITE_BLOB / unset (0)
		  '                                         → single-quoted, ' escaped as ''
		  '
		  ' Always call BindType before Bind for integer and double parameters.
		  ' Without BindType the value is quoted as text, which works for string
		  ' comparisons but may cause type mismatch on strict numeric columns.

		  If iIndex < 0 Or iIndex > m_arrValues.Ubound Then
		    Return "NULL"
		  End If

		  Dim v As Variant = m_arrValues(iIndex)
		  If IsNull(v) Then Return "NULL"

		  Dim iType As Integer = 0
		  If iIndex <= m_arrTypes.Ubound Then
		    iType = m_arrTypes(iIndex)
		  End If

		  Select Case iType
		  Case SQLITE_INTEGER
		    Return CStr(v.Int64Value)
		  Case SQLITE_DOUBLE
		    Return CStr(v.DoubleValue)
		  Case SQLITE_NULL
		    Return "NULL"
		  Case Else
		    ' SQLITE_TEXT, SQLITE_BLOB, or unset — quote and escape
		    Return "'" + ReplaceAll(CStr(v), "'", "''") + "'"
		  End Select
		End Function
	#tag EndMethod


	#tag Note, Name = Usage
		  ' SQLite-style (? markers, BindType required for non-text parameters):
		  Dim ps As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		  ps.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		  ps.Bind(0, 3)
		  Dim rs As UseRecordSet = ps.SQLSelect

		  ' SQLite inline values (same binding rules apply):
		  Dim rs2 As UseRecordSet = ps.SQLSelect(3)

		  ' PostgreSQL-style ($N markers):
		  Dim ps2 As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE name LIKE $1")
		  ps2.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		  ps2.Bind(0, "%API%")
		  Dim rs3 As UseRecordSet = ps2.SQLSelect

		  ' Non-SELECT:
		  Dim ps3 As UsePreparedStatement = db.Prepare("UPDATE tracks SET name = $1 WHERE id = $2")
		  ps3.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		  ps3.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		  ps3.Bind(0, "New Name")
		  ps3.Bind(1, 5)
		  ps3.SQLExecute
	#tag EndNote


	#tag Constant, Name = SQLITE_INTEGER, Type = Integer, Dynamic = False, Default = \"1", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SQLITE_DOUBLE, Type = Integer, Dynamic = False, Default = \"2", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SQLITE_NULL, Type = Integer, Dynamic = False, Default = \"3", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SQLITE_BLOB, Type = Integer, Dynamic = False, Default = \"4", Scope = Public
	#tag EndConstant

	#tag Constant, Name = SQLITE_TEXT, Type = Integer, Dynamic = False, Default = \"5", Scope = Public
	#tag EndConstant


	#tag Property, Flags = &h21
		Private m_arrTypes() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_arrValues() As Variant
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_db As UseDatabase
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strSQL As String
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
