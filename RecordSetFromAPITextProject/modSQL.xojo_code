#tag Module
Protected Module modSQL
	#tag Method, Flags = &h0
		Function EscapeSQLData(data As String) As String
		  // Prepare a string for use in a SQL statement.  A string which is being
		  // placed into a SQL statement cannot have a single quote in it since that will
		  // make the database engine believe the string is finished.
		  // For example the word "can't" will not work in SQL because it will see the word
		  // as just "can".
		  // In order to get around this you must escape all single quotes by adding a second
		  // one.  So "can't" will become "can''t" and then SQL command will work.
		  
		  // Replace all single quotes with two single quote characters
		  data = replaceAll( data, "'", "''" )
		  
		  // Similar issues occur with & so we double it in the statement
		  data = replaceAll( data, "&", "&&" )
		  
		  // Return the new data which is ready to be used in SQL
		  return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GetAccessToken(ByRef strToken As String, ByRef dtValidUntil As Date)
		  ' Fetches a new access token from the API server.
		  ' On success, strToken receives the token string and dtValidUntil receives its expiry.
		  ' On failure both are left as "" / Nil.
		  Dim hts As clsHTTPRequest
		  Dim iStatusCode As Integer
		  Dim strContent As String
		  Dim js As MyJSONItem
		  
		  strToken = ""
		  dtValidUntil = Nil
		  
		  hts = New clsHTTPRequest
		  hts.ClearRequestHeaders
		  hts.RequestHeader("clientnr") = Format(KlantNr, "0")
		  
		  If DemoMode Then
		    hts.RequestHeader("refreshtoken") = DemoRefreshToken
		    hts.Send("GET", DemoServerURL + "/api/v1/Authorize/AccessToken", True)
		  Else
		    hts.RequestHeader("refreshtoken") = RefreshToken
		    hts.Send("GET", "https://charon.bouwsoft.be/api/v1/Authorize/AccessToken", True)
		  End If
		  
		  If hts.GetAnswer(iStatusCode, strContent) Then
		    If iStatusCode = 200 Then
		      strContent = strContent.DefineEncoding(Encodings.UTF8)
		      Try
		        js = New MyJSONItem(strContent)
		        If js.HasKey("AccessToken") Then
		          strToken = js.Value("AccessToken")
		        End If
		        If js.HasKey("ValidUntil") Then
		          Dim strValidUntil As String = js.Value("ValidUntil")
		          Try
		            ' Parse ISO 8601: "YYYY-MM-DDTHH:MMZ" or "YYYY-MM-DDTHH:MM:SS"
		            Dim dtParts() As String
		            Dim dateParts() As String
		            Dim timeParts() As String
		            dtParts = Split(strValidUntil, "T")
		            If dtParts.Ubound < 1 Then
		              dtParts = Split(strValidUntil, " ")
		            End If
		            If dtParts.Ubound >= 1 Then
		              dateParts = Split(dtParts(0), "-")
		              timeParts = Split(dtParts(1), ":")
		              If dateParts.Ubound >= 2 And timeParts.Ubound >= 1 Then
		                Dim dSeconds As Double = 0
		                If timeParts.Ubound >= 2 Then
		                  dSeconds = Val(timeParts(2))
		                End If
		                Dim dtValid As New Date
		                dtValid.Year = Val(dateParts(0))
		                dtValid.Month = Val(dateParts(1))
		                dtValid.Day = Val(dateParts(2))
		                dtValid.Hour = Val(timeParts(0))
		                dtValid.Minute = Val(timeParts(1))
		                dtValid.Second = dSeconds
		                ' ValidUntil is UTC; shift to local time for comparison with New Date
		                dtValid.TotalSeconds = dtValid.TotalSeconds + (dtValid.GMTOffset * 3600)
		                dtValidUntil = dtValid
		              End If
		            End If
		          Catch
		            dtValidUntil = Nil
		          End Try
		        End If
		      Catch err As MyJSONException
		        'Could not parse access token response
		      End Try
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFileExtention(Extends fi As FolderItem) As String
		  ' Returns the file extension of the given FolderItem (e.g. "pdf"). Delegates to the string overload.
		  If Not IsNull(fi) Then
		    Return GetFileExtention(fi.Name)
		  Else
		    Return ""
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetFileExtention(strFile As String) As String
		  ' Returns the file extension from a filename string (e.g. "report.pdf" → "pdf").
		  ' Returns "" if the filename has no extension.
		  Dim t As Integer
		  Dim strExtention As String
		  Dim ch As String
		  
		  strExtention = ""
		  For t = Len(strFile) To 1 Step -1
		    ch = Mid(strFile, t, 1)
		    If ch = "." Then
		      t = 1
		    Else
		      strExtention = ch + strExtention
		    End If
		  Next t
		  If Len(strExtention) = Len(strFile) Then
		    strExtention = ""
		  End If
		  
		  Return strExtention
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMimeType(Extends fi As FolderItem) As String
		  ' Returns the MIME type string for a FolderItem based on its file extension
		  ' (e.g. "image/jpeg" for .jpg). Returns "application/octet-stream" for unknown types.
		  Dim strRtVal As String
		  Dim strExtentie As String
		  
		  strRtVal = ""
		  If Not IsNull(fi) And fi.Exists And Not fi.Directory Then
		    strExtentie = fi.GetFileExtention
		    If strExtentie = "txt" Then
		      strRtVal = "text/plain"
		      
		    ElseIf strExtentie = "bmp" Then
		      strRtVal = "image/bmp"
		    ElseIf strExtentie = "gif" Then
		      strRtVal = "image/gif"
		    ElseIf strExtentie = "ico" Then
		      strRtVal = "image/vdn.microsoft.icon"
		    ElseIf strExtentie = "jpg" Then
		      strRtVal = "image/jpeg"
		    ElseIf strExtentie = "jpeg" Then
		      strRtVal = "image/jpeg"
		    ElseIf strExtentie = "png" Then
		      strRtVal = "image/png"
		    ElseIf strExtentie = "tif" Then
		      strRtVal = "image/tiff"
		    ElseIf strExtentie = "tiff" Then
		      strRtVal = "image/tiff"
		      
		    ElseIf strExtentie = "csv" Then
		      strRtVal = "text/csv"
		    ElseIf strExtentie = "doc" Then
		      strRtVal = "application/msword"
		    ElseIf strExtentie = "docx" Then
		      strRtVal = "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
		    ElseIf strExtentie = "htm" Then
		      strRtVal = "text/html"
		    ElseIf strExtentie = "html" Then
		      strRtVal = "text/html"
		    Elseif strExtentie = "json" Then
		      strRtVal = "application/json"
		    ElseIf strExtentie = "pdf" Then
		      strRtVal = "application/pdf"
		    ElseIf strExtentie = "rtf" Then
		      strRtVal = "application/rtf"
		    ElseIf strExtentie = "xls" Then
		      strRtVal = "application/vnd.ms-excel"
		    Elseif strExtentie = "xlsx" Then
		      strRtVal = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
		    Elseif strExtentie = "ods" Then
		      strRtVal = "application/vnd.oasis.opendocument.spreadsheet"
		    ElseIf strExtentie = "xml" Then
		      strRtVal = "text/xml"
		    ElseIf strExtentie = "ppt" Then
		      strRtVal = "application/vnd.ms-powerpoint"
		    ElseIf strExtentie = "pptx" Then
		      strRtVal = "application/vnd.openxmlformats-officedocument.presentationml.presentation"
		      
		    ElseIf strExtentie = "aac" Then
		      strRtVal = "audio/aac"
		    ElseIf strExtentie = "abw" Then
		      strRtVal = "application/x-abiword"
		    ElseIf strExtentie = "arc" Then
		      strRtVal = "application/x-freearc"
		    ElseIf strExtentie = "avi" Then
		      strRtVal = "video/x-msvideo"
		    ElseIf strExtentie = "azw" Then
		      strRtVal = "application/vnd.amazon.ebook"
		    ElseIf strExtentie = "bin" Then
		      strRtVal = "application/octet-stream"
		      
		    Else
		      strRtVal = "application/octet-stream"
		    End If
		  End If
		  
		  Return strRtVal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function Openrecordset(strSql As String, strToken As String, bDB As Boolean = False) As UseRecordSet
		  ' Executes strSql against the API using the supplied access token.
		  ' The caller (UseDatabase) is responsible for ensuring the token is valid before calling.
		  Dim bRtVal As Boolean
		  Dim strURL As String
		  Dim hts As clsHTTPRequest
		  Dim iStatusCode As Integer
		  Dim strContent As String
		  Dim rs As UseRecordSet
		  
		  hts = New clsHTTPRequest
		  bRtVal = False
		  rs = Nil
		  
		  hts.ClearRequestHeaders
		  
		  hts.RequestHeader("Accesstoken") = strToken
		  hts.RequestHeader("ClientNr") = Format(KlantNr, "0")
		  If DemoMode Then
		    strURL = DemoServerURL + "/api/v2/apps/power/query?removeNulls=false&returnInfo=true"
		  Else
		    strURL = "https://" + ServerName
		    If strURL.Right(12) = ".bouwsoft.be" Then
		      strURL = strURL + "/"
		    ElseIf strURL.Right(13) = ".bouwsoft.be/" Then
		      'Do Nothing
		    Else
		      strURL = strURL + ".bouwsoft.be/"
		    End If
		    strURL = strURL + "api/v2/apps/power/query?removeNulls=false&returnInfo=true"
		  End If
		  
		  System.DebugLog "Openrecordset: POST to " + strURL
		  System.DebugLog "Openrecordset: AccessToken length=" + CStr(Len(strToken))
		  System.DebugLog "Openrecordset: SQL=" + strSql
		  
		  hts.SetRequestContent(strSql, "text/plain")
		  hts.Send("POST", strURL, True)
		  
		  bRtVal = hts.GetAnswer(iStatusCode, strContent)
		  System.DebugLog "Openrecordset: GetAnswer returned=" + CStr(bRtVal)
		  System.DebugLog "Openrecordset: iStatusCode=" + CStr(iStatusCode)
		  System.DebugLog "Openrecordset: strContent length=" + CStr(Len(strContent))
		  If Len(strContent) > 0 Then
		    System.DebugLog "Openrecordset: strContent (first 500)=" + Left(strContent, 500)
		  End If
		  If Not IsNull(hts.httpRuntimeException) Then
		    System.DebugLog "Openrecordset: httpRuntimeException=" + CStr(hts.httpRuntimeException.ErrorNumber) + " - " + hts.httpRuntimeException.Message
		  End If
		  'Break ' <-- inspect iStatusCode, strContent, bRtVal in debugger here
		  
		  If bRtVal Then
		    strContent = strContent.DefineEncoding(Encodings.UTF8)
		    ' Check for a JSON-level error key regardless of HTTP status.
		    ' The server may return {"error":"..."} with 200 or with a 4xx/5xx code.
		    Try
		      Dim jsErr As MyJSONItem = New MyJSONItem(strContent)
		      If jsErr.HasKey("error") Then
		        Dim strMsg As String = jsErr.Value("error")
		        If iStatusCode <> 200 Then
		          strMsg = "HTTP " + CStr(iStatusCode) + ": " + strMsg
		        End If
		        Raise New RuntimeException(strMsg)
		      End If
		    Catch errJson As MyJSONException
		      ' Body is not JSON or has no error key — fall through
		    End Try
		    If iStatusCode = 200 Then
		      rs = UseRecordSet.CreateRecordset(strSql, strContent, bDB)
		    Else
		      Raise New RuntimeException("HTTP error " + CStr(iStatusCode))
		    End If
		  End If
		  
		  Return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ReadTxtFile(fi As FolderItem) As String
		  ' Reads the full text content of a FolderItem and returns it as a String.
		  ' Returns "" if the file does not exist or is a directory.
		  Dim s As TextInputStream
		  Dim strRtVal As String
		  
		  strRtVal = ""
		  If Not IsNull(fi) And fi.Exists And Not fi.Directory Then
		    s = TextInputStream.Open(fi)
		    strRtVal = s.ReadAll
		    s.Close
		  End If
		  
		  return strRtVal
		End Function
	#tag EndMethod


	#tag Constant, Name = DemoMode, Type = Boolean, Dynamic = False, Default = \"true", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DemoRefreshToken, Type = String, Dynamic = False, Default = \"demo-refreshtoken", Scope = Public
	#tag EndConstant

	#tag Constant, Name = DemoServerURL, Type = String, Dynamic = False, Default = \"http://localhost:8080", Scope = Public
	#tag EndConstant

	#tag Constant, Name = KlantNr, Type = Double, Dynamic = False, Default = \"115", Scope = Public
	#tag EndConstant

	#tag Constant, Name = RefreshToken, Type = String, Dynamic = False, Default = \"PUT_YOUR_REFRESHTOKEN_HERE", Scope = Public
	#tag EndConstant

	#tag Constant, Name = ServerName, Type = String, Dynamic = False, Default = \"ra", Scope = Public
	#tag EndConstant


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
End Module
#tag EndModule
