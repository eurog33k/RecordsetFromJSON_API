#tag Class
Protected Class UseRecordSetField
	#tag Method, Flags = &h0
		Sub Constructor(strName As String, value As Variant)
		  ' Initialises the field with its column name and the raw value received from the API.
		  m_name = strName
		  m_value = value
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function BooleanValue() As Boolean
		  ' Returns the field value as Boolean. Returns False if the value is Nil.
		  If IsNull(m_value) Then Return False
		  Return m_value.BooleanValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DateValue() As Date
		  ' Returns the field value as a Date, or Nil if the value is Nil or not a Date object.
		  If IsNull(m_value) Then Return Nil
		  If m_value IsA Date Then Return CType(m_value, Date)
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DoubleValue() As Double
		  ' Returns the field value as Double. Returns 0.0 if the value is Nil.
		  If IsNull(m_value) Then Return 0.0
		  Return CDbl(m_value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Int64Value() As Int64
		  ' Returns the field value as Int64. Returns 0 if the value is Nil.
		  If IsNull(m_value) Then Return 0
		  Return m_value.Int64Value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IntegerValue() As Integer
		  ' Returns the field value as Integer. Returns 0 if the value is Nil.
		  If IsNull(m_value) Then Return 0
		  Return m_value.IntegerValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name() As String
		  ' Returns the column name as reported by the API.
		  Return m_name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Operator_Convert() As Variant
		  ' Allows the field to be used directly as a Variant (e.g. Dim v As Variant = rs.Field("id")).
		  Return m_value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function StringValue() As String
		  ' Returns the field value as a String. Returns "" if the value is Nil.
		  If IsNull(m_value) Then Return ""
		  Return CStr(m_value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value() As Variant
		  ' Returns the raw Variant value as stored.
		  Return m_value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(Assigns v As Variant)
		  ' Sets the field value. Assign Nil to represent a SQL NULL.
		  m_value = v
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NativeValue() As Variant
		  ' Returns the raw stored value. Matches DatabaseField.NativeValue.
		  Return m_value
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function CurrencyValue() As Currency
		  ' Returns the value as Currency. Matches DatabaseField.CurrencyValue.
		  If IsNull(m_value) Then Return 0
		  Return CDbl(m_value)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function PictureValue() As Picture
		  ' Not supported in HTTP mode. Returns Nil.
		  Return Nil
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetString() As String
		  ' Returns the value as String. Matches DatabaseField.GetString.
		  Return StringValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetString(strValue As String)
		  ' Sets the value from a String. Matches DatabaseField.SetString.
		  m_value = strValue
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_name As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_value As Variant
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
