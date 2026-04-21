#tag Class
Protected Class UseDatabaseRecord
	#tag Method, Flags = &h0
		Sub Column(strName As String, Assigns strValue As String)
		  ' Stores a String value for the named column.
		  ' Usage: record.Column("Name") = "Penguins"
		  SetColumnValue(strName, strValue)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub IntegerColumn(strName As String, Assigns iValue As Integer)
		  ' Stores an Integer value for the named column.
		  SetColumnValue(strName, CStr(iValue))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleColumn(strName As String, Assigns dValue As Double)
		  ' Stores a Double value for the named column.
		  SetColumnValue(strName, CStr(dValue))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BooleanColumn(strName As String, Assigns bValue As Boolean)
		  ' Stores a Boolean as 1 (True) or 0 (False).
		  If bValue Then
		    SetColumnValue(strName, "1")
		  Else
		    SetColumnValue(strName, "0")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DateColumn(strName As String, Assigns dtValue As Date)
		  ' Stores a Date as a SQL timestamp string: YYYY-MM-DD HH:MM:SS
		  ' A Nil date stores an empty string.
		  If IsNull(dtValue) Then
		    SetColumnValue(strName, "")
		    Return
		  End If
		  Dim yr As String = CStr(dtValue.Year)
		  Dim mo As String = CStr(dtValue.Month)
		  Dim dy As String = CStr(dtValue.Day)
		  Dim hr As String = CStr(dtValue.Hour)
		  Dim mn As String = CStr(dtValue.Minute)
		  Dim sc As String = CStr(dtValue.Second)
		  If Len(mo) < 2 Then mo = "0" + mo
		  If Len(dy) < 2 Then dy = "0" + dy
		  If Len(hr) < 2 Then hr = "0" + hr
		  If Len(mn) < 2 Then mn = "0" + mn
		  If Len(sc) < 2 Then sc = "0" + sc
		  Dim strTimestamp As String = yr + "-" + mo + "-" + dy + " " + hr + ":" + mn + ":" + sc
		  SetColumnValue(strName, strTimestamp)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Int64Column(strName As String, Assigns i64Value As Int64)
		  ' Stores an Int64 value for the named column.
		  SetColumnValue(strName, CStr(i64Value))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CurrencyColumn(strName As String, Assigns cValue As Currency)
		  ' Stores a Currency value for the named column.
		  SetColumnValue(strName, CStr(cValue))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub BlobColumn(strName As String, Assigns mbValue As MemoryBlock)
		  ' Binary data is not supported over the HTTP/JSON driver.
		  ' The column is stored as an empty string.
		  ' If you need to store binary data, encode it as Base64 and use Column() instead.
		  SetColumnValue(strName, "")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldCount() As Integer
		  ' Returns the number of columns that have been set.
		  Return m_arrNames.Ubound + 1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function FieldName(iIndex As Integer) As String
		  ' Returns the column name at the given 0-based index.
		  If iIndex >= 0 And iIndex <= m_arrNames.Ubound Then
		    Return m_arrNames(iIndex)
		  End If
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAt(iIndex As Integer) As String
		  ' Returns the stored string value at the given 0-based index.
		  ' Used by UseDatabase.InsertRecord.
		  If iIndex >= 0 And iIndex <= m_arrValues.Ubound Then
		    Return m_arrValues(iIndex)
		  End If
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SetColumnValue(strName As String, strValue As String)
		  ' Inserts a new name/value pair or updates an existing one. Used by all typed column setters.
		  Dim i As Integer
		  For i = 0 To m_arrNames.Ubound
		    If m_arrNames(i) = strName Then
		      m_arrValues(i) = strValue
		      Return
		    End If
		  Next
		  m_arrNames.Append(strName)
		  m_arrValues.Append(strValue)
		End Sub
	#tag EndMethod


	#tag Note, Name = Usage
		  Dim row As New UseDatabaseRecord
		  row.Column("Name") = "Penguins"
		  row.Column("Coach") = "Bob Roberts"
		  row.IntegerColumn("Score") = 42
		  row.DoubleColumn("Ratio") = 1.23
		  row.BooleanColumn("Active") = True
		  db.InsertRecord("Team", row)
		  If db.Error Then MsgBox "DB Error: " + db.ErrorMessage
	#tag EndNote


	#tag Property, Flags = &h21
		Private m_arrNames() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_arrValues() As String
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
