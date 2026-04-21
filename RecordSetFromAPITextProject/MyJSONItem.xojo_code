#tag Class
Protected Class MyJSONItem
	#tag Method, Flags = &h0
		Sub Add(v as Variant)
		  // for arrays we use array node instead of object node, so we need to switch
		  If Not IsArray Then
		    j = JSONMBS.NewArrayNode
		  End If
		  
		  Dim p As JSONMBS = ToJSON(v)
		  
		  j.AddItemToArray p
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Append(v as Variant)
		  Add(v)
		  
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(n As Integer) As MyJSONItem
		  if j = nil then Return nil
		  
		  Select case j.Type
		  case JSONMBS.kTypeArray
		    if n>= 0 and n<j.ArraySize then
		      Return new MyJSONItem(j.ArrayItem(n))
		    else
		      'Return nil
		      dim k as new OutOfBoundsException
		      k.Message = "Item "+str(n)+" not found."
		      raise k
		    end if
		  case else
		    Return nil
		  end Select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Child(strKey As String) As MyJSONItem
		  if j = nil then Return nil
		  
		  Select case j.Type
		  case JSONMBS.kTypeObject
		    If j.HasChild(strKey)=False Then
		      dim k as new KeyNotFoundException
		      k.Message = "Key "+ strKey +" not found."
		      raise k 
		      'Return Nil
		    else
		      Return new MyJSONItem(j.Child(strKey))
		    End If
		  case else
		    Return nil
		  end Select
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Child(strKey As String, assigns myji As MyJSONItem)
		  value(strKey) = myji
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ChildAt(n As Integer) As MyJSONItem
		  return child(n)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ChildAt(n As Integer, assigns myji As MyJSONItem)
		  ValueAt(n) = myji
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  // start with new object
		  j = JSONMBS.NewObjectNode
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Constructor(j as JSONMBS)
		  // wrap a JSONMBS
		  self.j = j
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor(data as String)
		  Load data
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Count() As Integer
		  // only for array objects, give size of array
		  Return j.ArraySize
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DoubleValue(key As Variant, Assigns value As Variant)
		  j.AddItemToObject key, ToJSON(Value, True)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function FromJSON(j as JSONMBS) As Variant
		  if j = nil then Return nil
		  #If XojoVersionString >= "2023r4" Then
		    Select case j.Type
		    case JSONMBS.kTypeArray
		      Return new MyJSONItem(j)
		    case JSONMBS.kTypeBoolean
		      Return j.ValueBoolean
		    case JSONMBS.kTypeNull
		      return nil
		    Case JSONMBS.kTypeSingle
		      Return j.ValueDouble
		    case JSONMBS.kTypeInt64
		      Return j.ValueInt64
		    case JSONMBS.kTypeUInt64
		      Return j.ValueUInt64
		    Case JSONMBS.kTypeDouble
		      Return j.ValueDouble
		    case JSONMBS.kTypeObject
		      Return new MyJSONItem(j)
		    case JSONMBS.kTypeString
		      If j.IsInt64 Then Return j.ValueInt64
		      If j.IsNumber Then Return j.ValueDouble
		      Return j.ValueString.ReplaceLineEndings(EndOfLine)
		    End Select
		  #Else
		    Select case j.Type
		    case JSONMBS.kTypeArray
		      Return new MyJSONItem(j)
		    case JSONMBS.kTypeFalse
		      Return false
		    case JSONMBS.kTypeNull
		      return nil
		    case JSONMBS.kTypeNumber
		      If j.IsInt64 Then
		        Return j.ValueInteger
		      else
		        Return j.ValueDouble
		      End If
		    case JSONMBS.kTypeObject
		      Return new MyJSONItem(j)
		    case JSONMBS.kTypeString
		      Return j.ValueString.ReplaceLineEndings(EndOfLine)
		    case JSONMBS.kTypetrue
		      Return true
		    end Select
		  #endif
		  
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Haskey(key as String) As Boolean
		  Return HasName(key)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function HasName(key as String) As Boolean
		  Dim bReturn As Boolean=False
		  
		  If Not IsNull(j) And j.HasChild(key) Then
		    bReturn=True
		  End If
		  
		  Return bReturn
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsArray() As Boolean
		  If IsNull(j) Then
		    Return False
		  Else
		    Return (j.Type = JSONMBS.kTypeArray)
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function KeyAt(index as integer) As String
		  Return Name(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Keys() As string()
		  Dim strReturn() As String
		  
		  dim c as JSONMBS
		  
		  for i as integer = 0 to j.ArraySize-1
		    if i=0 Then
		      c  = j.ChildNode
		    else
		      c = c.NextNode
		    end if
		    if c.Type<>JSONMBS.kTypeArray And c.Name<>"" Then
		      strReturn.Add c.Name
		    end if
		  next
		  
		  Return strReturn
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function LastRowIndex() As Integer
		  Return Count-1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Load(strJson As String)
		  #If XojoVersionString >= "2023r4" Then
		    Try
		  #EndIf
		  // parse and raise exception on error
		  If strJson="" Then
		    j = JSONMBS.NewObjectNode
		  Else
		    j = New JSONMBS(strJson)
		  End If
		  #If XojoVersionString >= "2023r4" Then
		    Catch e As RuntimeException
		      Dim je As New MyJSONException
		      je.Message = e.Message
		      Raise je
		    End Try
		  #Else
		    If j.Valid = False Then
		      Dim je As New MyJSONException
		      je.Message = j.ParseError
		      Raise je
		    End If
		  #EndIf
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Lookup(key as Variant, defaultValue as Variant) As Variant
		  // lookup a value
		  
		  Select case j.Type
		  case JSONMBS.kTypeArray
		    dim n as integer = key.IntegerValue
		    try
		      dim c as JSONMBS = j.ArrayItem(n)
		      if c = nil then
		        Return defaultValue
		      else
		        Return FromJSON(c)
		      end if
		    Catch
		      Return defaultValue
		    end try
		  case JSONMBS.kTypeObject
		    Dim l As String = key
		    If j.HasChild(l) Then
		      Try
		        Dim c As JSONMBS = j.Child(l)
		        If c = Nil Then
		          Return defaultValue
		        Else
		          Return FromJSON(c)
		        End If
		      Catch
		        Return defaultValue
		      End Try
		    Else
		      Return defaultValue
		    End If
		  else
		    Break
		  end Select
		  
		  
		  Return defaultValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Name(index as integer) As string
		  // find name of an item
		  dim strReturn As String
		  dim c as JSONMBS = j.ChildNode
		  If index<0 or index>LastRowIndex Then
		    dim k as new OutOfBoundsException
		    k.Message = "Item "+str(index)+" not found."
		    raise k
		  else
		    for i as integer = 1 to index
		      c = c.NextNode
		    next
		  End If
		  
		  Return c.Name
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function NameAt(index as integer) As String
		  Return Name(index)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Names() As String()
		  // find name of an item
		  Dim iLast As Integer
		  Dim t As Integer
		  Dim strArrNames() As String
		  Dim c As JSONMBS 
		  
		  c = j.ChildNode
		  strArrNames.Append(c.Name)
		  
		  iLast = j.ArraySize - 1
		  For t = 1 To iLast
		    c = c.NextNode
		    strArrNames.Append(c.Name)
		  Next t
		  
		  Return strArrNames
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Operator_Convert(d As Dictionary)
		  j=JSONMBS.Convert(d)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Remove(strKey As Variant)
		  Dim iKeyType As Integer=VarType(strKey)
		  if iKeyType=Variant.TypeString Then
		    If j.HasChild(strKey) Then
		      j.DeleteItem(strKey.StringValue)
		    Else
		      dim k as new KeyNotFoundException
		      k.Message = "Item " + strKey + " not found."
		      raise k
		    End If
		  elseif iKeyType=Variant.TypeInteger or iKeyType=Variant.TypeInt64 Then
		    Dim index As Integer=strKey
		    If index<0 or index>LastRowIndex Then
		      dim k as new OutOfBoundsException
		      k.Message = "Item " + str(index) + " not found."
		      raise k
		    End If
		    j.DeleteItem(index)
		  Else
		    exit sub
		  end if
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAll()
		  If j.IsArray Then
		    j=New JSONMBS
		    If Not IsArray Then
		      j = JSONMBS.NewArrayNode
		    End If
		  elseif j.IsObject Then
		    j=New JSONMBS
		    If IsArray Then
		      j = JSONMBS.NewObjectNode
		    End If
		  Else
		    Var e As New RuntimeException // subclass of RuntimeException
		    e.Message = "RemoveAll failed because the myJSONItem in neither an array nor an object"
		    Raise e
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RemoveAt(Index As Integer)
		  Remove(index)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ToJSON(v As Variant, Optional bDouble As Boolean = False) As JSOnMBS
		  // get a myjsonitem for Variant
		  
		  if v = nil then 
		    Return JSONMBS.NewNullNode
		  end if
		  
		  if v isa MyJSONItem then
		    dim m as MyJSONItem = v
		    Return m.j
		  end if
		  
		  if v isa JSONMBS then
		    Return v
		  End If
		  
		  If v IsA Dictionary Then
		    Dim m As MyJSONItem
		    Dim iLast As Integer
		    Dim t As Integer
		    Dim dt As Dictionary
		    Dim strKey As String
		    
		    dt = Dictionary(v)
		    m = New MyJSONItem
		    iLast = dt.Count
		    For t = 0 To iLast -1
		      strKey = dt.Key(t).StringValue
		      
		      m.j.AddItemToObject(strKey, ToJSON(dt.Value(strKey)))
		    Next t
		    
		    Return m.j
		  End If
		  
		  Select case v.Type
		  case Variant.TypeString
		    If bDouble Then
		      Return JSONMBS.NewNumberNode(v.StringValue)
		    Else
		      Return JSONMBS.NewStringNode(v.StringValue)
		    End If
		  case Variant.TypeBoolean
		    Return JSONMBS.NewBoolNode(v.BooleanValue)
		  case Variant.TypeDouble, Variant.TypeSingle
		    Return JSONMBS.NewNumberNode(v.DoubleValue)
		    
		    #if RBVersion < 2013 then
		  case Variant.TypeInteger, Variant.TypeLong
		    #else
		  case Variant.TypeInt64, Variant.TypeInt32 // 2
		    #endif
		    If bDouble Then
		      Return JSONMBS.NewNumberNode(v.DoubleValue)
		    Else
		      Return JSONMBS.NewInt64Node(v.Int64Value)
		    End If
		  case Variant.TypeDate
		    Return JSONMBS.NewStringNode(Date(v).SQLDateTime)
		  else
		    'Dim iVarType As Integer
		    Dim vElementType As Variant
		    if v.IsArray Then
		      'iVarType = VarType(v)
		      vElementType = v.ArrayElementType
		      Select case vElementType
		      case 8,9,4,5,2,3,11,6
		        Return JSONMBS.Convert(v)
		      End Select
		    end if
		    Break
		  end Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ToString() As string
		  // return 
		  Return j.ToString(Not Compact)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Value(key as Variant) As Variant
		  Select Case j.Type
		  Case JSONMBS.kTypeArray
		    dim n as integer = key
		    dim c as JSONMBS = j.ArrayItem(n)
		    if c = nil then
		      dim k as new KeyNotFoundException
		      k.Message = "Item "+str(n)+" not found."
		      raise k
		    else
		      Return FromJSON(c)
		    end if
		  case JSONMBS.kTypeObject
		    dim l as string = key
		    dim c as JSONMBS = j.Child(l)
		    if c = nil then
		      dim k as new KeyNotFoundException
		      k.Message = "Key "+L+" not found."
		      raise k
		      
		    else
		      Return FromJSON(c)
		    end if
		  else
		    Break
		  end Select
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Value(key as Variant, assigns value as Variant)
		  If Not IsNull(key) Then
		    If Self.HasName(key) Then
		      Self.Remove(key)
		    End If
		    
		    j.AddItemToObject key, ToJSON(Value)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ValueAt(n As Integer) As Variant
		  Select Case j.Type
		  Case JSONMBS.kTypeArray
		    'dim n as integer = key
		    dim c as JSONMBS = j.ArrayItem(n)
		    if c = nil then
		      dim k as new OutOfBoundsException
		      k.Message = "Item " + str(n) + " not found."
		      raise k
		    else
		      Return FromJSON(c)
		    end if
		  case JSONMBS.kTypeObject
		    'dim l as string = key
		    'dim c as JSONMBS = j.Child(l)
		    'if c = nil then
		    dim k as new KeyNotFoundException
		    k.Message = "ValueAt " + Cstr(n) + " not found (JSON Object instead of Array)."
		    raise k
		    'else
		    'Return FromJSON(c)
		    'end if
		  else
		    Break
		  end Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ValueAt(n As Integer, assigns value As Variant)
		  'If Not IsNull(key) Then
		  'If Self.HasName(key) Then
		  'Self.Remove(key)
		  'End If
		  '
		  'j.AddItemToObject key, ToJSON(Value)
		  'End If
		  dim c as JSONMBS
		  Select Case j.Type
		  Case JSONMBS.kTypeArray
		    'dim n as integer = key
		    c = j.ArrayItem(n)
		    if c = nil then
		      dim k as new OutOfBoundsException
		      k.Message = "Item "+str(n)+" not found."
		      raise k
		    else
		      //c= New JSONMBS(Value)
		      'c = ToJSON(Value)
		      Self.Remove(n)
		      'j.ArrayItem(n)=ToJSON(value)
		      j.AddItemToArray ToJSON(Value)
		    end if
		  case JSONMBS.kTypeObject
		    'dim l as string = key
		    'dim c as JSONMBS = j.Child(l)
		    'if c = nil then
		    dim k as new KeyNotFoundException
		    k.Message = "ValueAt "+Cstr(n)+" cannot be set (JSON Object instead of Array)."
		    raise k
		    'else
		    'Return FromJSON(c)
		    'end if
		  else
		    Break
		  end Select
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		Compact As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h21
		Private j As JSONMBS
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
		#tag ViewProperty
			Name="Compact"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
