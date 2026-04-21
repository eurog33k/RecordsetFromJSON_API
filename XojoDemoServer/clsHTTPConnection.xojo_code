#tag Class
Protected Class clsHTTPConnection
Inherits TCPSocket
	#tag Event
		Sub DataAvailable()
		  ' Accumulates incoming data into the buffer and attempts to parse a complete HTTP request.
		  m_strBuffer = m_strBuffer + Me.ReadAll
		  TryParseRequest
		End Sub
	#tag EndEvent

	#tag Event
		Sub SendComplete(userAborted as Boolean)
		  ' Called after the response has been fully sent. Closes the connection.
		  Me.Close
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub HandleRequest(strMethod As String, strPath As String, strQuery As String, strBody As String, strRefreshToken As String)
		  ' Routes the request to the appropriate handler based on path and method.
		  ' OPTIONS → CORS preflight. GET /api/v1/Authorize/AccessToken → demo token.
		  ' POST /api/v2/apps/power/query → SQL execution. Anything else → 404.
		  If strMethod = "OPTIONS" Then
		    SendCORSHeaders
		    Return
		  End If
		  
		  Dim strBody2 As String
		  Dim iStatus As Integer = 200
		  
		  If strPath = "/api/v1/Authorize/AccessToken" Then
		    If strRefreshToken = "demo-refreshtoken" Then
		      strBody2 = "{""AccessToken"":""demo-token"",""ValidUntil"":""2099-12-31T23:59:59Z""}"
		    Else
		      iStatus = 404
		      strBody2 = "{""Code"":""404"",""Message"":""Not found"",""Description"":""Combination of RefreshToken and ClientNr Not Found""}"
		    End If
		    
		  ElseIf strPath = "/api/v2/apps/power/query" And strMethod = "POST" Then
		    Dim bRemoveNulls As Boolean = True
		    Dim bReturnInfo As Boolean = False
		    Dim strRN As String = modQueryAPI.GetQueryParam(strQuery, "removeNulls")
		    If strRN <> "" Then bRemoveNulls = (strRN.Lowercase <> "false")
		    Dim strRI As String = modQueryAPI.GetQueryParam(strQuery, "returnInfo")
		    If strRI <> "" Then bReturnInfo = (strRI.Lowercase = "true")
		    strBody2 = modQueryAPI.ExecuteQuery(strBody.Trim, bRemoveNulls, bReturnInfo)
		    
		  Else
		    iStatus = 404
		    strBody2 = "{" + Chr(34) + "error" + Chr(34) + ":" + Chr(34) + "Not Found" + Chr(34) + "}"
		  End If
		  
		  SendResponse(iStatus, If(iStatus = 200, "OK", "Not Found"), strBody2)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendCORSHeaders()
		  ' Responds to an HTTP OPTIONS preflight with 204 No Content and CORS allow headers.
		  Dim r As String
		  r = "HTTP/1.1 204 No Content" + Chr(13) + Chr(10)
		  r = r + "Access-Control-Allow-Origin: *" + Chr(13) + Chr(10)
		  r = r + "Access-Control-Allow-Methods: POST, GET, OPTIONS" + Chr(13) + Chr(10)
		  r = r + "Access-Control-Allow-Headers: *" + Chr(13) + Chr(10)
		  r = r + "Content-Length: 0" + Chr(13) + Chr(10)
		  r = r + "Connection: close" + Chr(13) + Chr(10)
		  r = r + Chr(13) + Chr(10)
		  Me.Write(r)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SendResponse(iStatus As Integer, strStatusText As String, strBody As String)
		  ' Writes a complete HTTP/1.1 response to this connection with JSON content-type,
		  ' CORS headers, and Connection: close.
		  Dim r As String
		  r = "HTTP/1.1 " + CStr(iStatus) + " " + strStatusText + Chr(13) + Chr(10)
		  r = r + "Content-Type: application/json; charset=utf-8" + Chr(13) + Chr(10)
		  r = r + "Access-Control-Allow-Origin: *" + Chr(13) + Chr(10)
		  r = r + "Access-Control-Allow-Headers: *" + Chr(13) + Chr(10)
		  r = r + "Content-Length: " + CStr(Len(strBody)) + Chr(13) + Chr(10)
		  r = r + "Connection: close" + Chr(13) + Chr(10)
		  r = r + Chr(13) + Chr(10)
		  r = r + strBody
		  Me.Write(r)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TryParseRequest()
		  ' Attempts to parse a complete HTTP request from the receive buffer.
		  ' Returns early if the headers or body have not yet fully arrived.
		  ' On success, extracts method, path, query string, and body, then calls HandleRequest.
		  Dim strSep As String = Chr(13) + Chr(10) + Chr(13) + Chr(10)
		  Dim iHeaderEnd As Integer = InStr(m_strBuffer, strSep)
		  If iHeaderEnd = 0 Then Return
		  
		  Dim strHeaderBlock As String = Left(m_strBuffer, iHeaderEnd - 1)
		  Dim arrLines() As String = Split(strHeaderBlock, Chr(13) + Chr(10))
		  
		  ' Parse Content-Length and relevant request headers
		  Dim iContentLength As Integer = 0
		  Dim strRefreshToken As String = ""
		  For Each h As String In arrLines
		    If InStr(h.Uppercase, "CONTENT-LENGTH:") = 1 Then
		      iContentLength = Trim(Mid(h, 16)).ToInteger
		    ElseIf InStr(h.Uppercase, "REFRESHTOKEN:") = 1 Then
		      strRefreshToken = Trim(Mid(h, 14))
		    End If
		  Next
		  
		  ' Wait until full body has arrived
		  Dim iBodyStart As Integer = iHeaderEnd + 4
		  If Len(m_strBuffer) < iBodyStart + iContentLength - 1 Then Return
		  Dim strBody As String = Mid(m_strBuffer, iBodyStart, iContentLength)
		  
		  ' Parse request line
		  If arrLines.Count = 0 Then
		    SendResponse(400, "Bad Request", "{" + Chr(34) + "error" + Chr(34) + ":" + Chr(34) + "Bad Request" + Chr(34) + "}")
		    Return
		  End If
		  Dim arrParts() As String = Split(arrLines(0), " ")
		  If arrParts.Count < 2 Then
		    SendResponse(400, "Bad Request", "{" + Chr(34) + "error" + Chr(34) + ":" + Chr(34) + "Bad Request" + Chr(34) + "}")
		    Return
		  End If
		  
		  Dim strMethod As String = arrParts(0)
		  Dim strFullPath As String = arrParts(1)
		  Dim strPath As String = strFullPath
		  Dim strQuery As String = ""
		  Dim iQ As Integer = InStr(strFullPath, "?")
		  If iQ > 0 Then
		    strPath = Left(strFullPath, iQ - 1)
		    strQuery = Mid(strFullPath, iQ + 1)
		  End If
		  
		  HandleRequest(strMethod, strPath, strQuery, strBody, strRefreshToken)
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_strBuffer As String
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue=""
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
			Name="Address"
			Visible=true
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group="Behavior"
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
End Class
#tag EndClass
