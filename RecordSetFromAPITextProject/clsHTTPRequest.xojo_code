#tag Class
Protected Class clsHTTPRequest
	#tag Method, Flags = &h0
		Sub ClearRequestHeaders()
		  ' Resets all request headers, the HTTP method, the request body, and the URL.
		  ' Call before reusing this instance for a new request.
		  Redim m_strArrHeaders(-1)
		  Redim m_strArrHeaderValues(-1)
		  m_strMethod = ""
		  m_strRequestContent = ""
		  m_strRequestMimeType = ""
		  m_strURL = ""
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub CreateTimer()
		  ' Creates a repeating 1-second timer that calls TimerEvent_Action to enforce the request timeout.
		  m_tmr = New Timer
		  m_iTimeOut = Ticks
		  
		  AddHandler m_tmr.Action, AddressOf TimerEvent_Action
		  
		  m_tmr.Period = 1000
		  m_tmr.Enabled = True
		  m_tmr.Mode = Timer.ModeMultiple
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function CreateURLCSocket() As URLConnection
		  ' Creates a new URLConnection, wires all event handlers, disables certificate validation,
		  ' resets the timeout, and starts the watchdog timer. Destroys any previous socket first.
		  DestroySockets
		  
		  m_htsURLC = New URLConnection
		  AddHandler m_htsURLC.Error, AddressOf URLCEvent_Error
		  AddHandler m_htsURLC.ContentReceived, AddressOf URLCEvent_ContentReceived
		  AddHandler m_htsURLC.HeadersReceived, AddressOf URLCEvent_HeadersReceived
		  AddHandler m_htsURLC.ReceivingProgressed, AddressOf URLCEvent_ReceivingProgressed
		  AddHandler m_htsURLC.SendingProgressed, AddressOf URLCEvent_SendingProgressed
		  AddHandler m_htsURLC.AuthenticationRequested, AddressOf URLCEvent_AuthenticationRequested
		  AddHandler m_htsURLC.FileReceived, AddressOf URLCEvent_FileReceived
		  
		  m_htsURLC.ClearRequestHeaders
		  m_htsURLC.AllowCertificateValidation = False
		  m_iTimeOutLength = m_iTimeOutLengthBase 'Timeout 15 seconden
		  
		  CreateTimer
		  
		  Return m_htsURLC
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub DestroySockets()
		  ' Removes all event handlers from the URLConnection and the timer, disconnects, and
		  ' sets both to Nil. Resets all transient state (answered flag, status code, error, content).
		  If Not IsNull(m_htsURLC) Then
		    RemoveHandler m_htsURLC.Error, AddressOf URLCEvent_Error
		    RemoveHandler m_htsURLC.ContentReceived, AddressOf URLCEvent_ContentReceived
		    RemoveHandler m_htsURLC.HeadersReceived, AddressOf URLCEvent_HeadersReceived
		    RemoveHandler m_htsURLC.ReceivingProgressed, AddressOf URLCEvent_ReceivingProgressed
		    RemoveHandler m_htsURLC.SendingProgressed, AddressOf URLCEvent_SendingProgressed
		    RemoveHandler m_htsURLC.AuthenticationRequested, AddressOf URLCEvent_AuthenticationRequested
		    RemoveHandler m_htsURLC.FileReceived, AddressOf URLCEvent_FileReceived
		    
		    m_htsURLC.Disconnect()
		    m_htsURLC = Nil
		  End If
		  
		  If Not IsNull(m_tmr) Then
		    RemoveHandler m_tmr.Action, AddressOf TimerEvent_Action
		    
		    m_tmr = Nil
		  End If
		  
		  m_bAnswered = False
		  m_iStatusCode = 0
		  m_oError = Nil
		  m_strReceivedContent = ""
		  m_iTimeOut = Ticks
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Disconnect()
		  ' Cancels any in-progress request and releases all socket and timer resources.
		  DestroySockets()
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub DownloadFile(strURL As String, fi As FolderItem, bBlocking As Boolean, Optional iBaseTimeOutInSeconds As Integer = 15)
		  ' Downloads the resource at strURL to the FolderItem fi using GET.
		  ' fi must not already exist. Set bBlocking=True to wait for completion.
		  ' Minimum timeout is 15 seconds. Fires DownloadComplete when done.
		  Dim iLenB As Integer
		  
		  If (strURL.Left(7) = "http://" Or strURL.Left(8) = "https://") And Not IsNull(fi) And Not fi.Exists Then
		    
		    If iBaseTimeOutInSeconds < 15 Then
		      'Minimum timeout op 15 seconden
		      m_iTimeOutLengthBase = 900
		    Else
		      m_iTimeOutLengthBase = (iBaseTimeOutInSeconds * 60)
		    End If
		    m_strMethod = "GET"
		    m_strURL = strURL
		    m_strReceivedContent = ""
		    m_fiReceived = Nil
		    m_fiRequestedFile = fi
		    m_bSecure = (strURL.Left(8) = "https://")
		    Redim m_strArrReceivedHeaders(-1)
		    Redim m_strArrReceivedHeaderValues(-1)
		    
		    'Set Content-Length if there is a content
		    iLenB = m_strRequestContent.LenB
		    If iLenB > 0 Then
		      RequestHeader("Content-Length") = Format(iLenB, "0")
		    Else
		      RequestHeader("Content-Length") = ""
		    End If
		    
		    Send_Intern(bBlocking)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetAnswer(ByRef iStatusCode As Integer, ByRef strContent As String) As Boolean
		  ' Returns True and fills iStatusCode and strContent if a response has been received.
		  ' Returns False (with zero status and empty content) if the request is still in progress.
		  If m_bAnswered Then
		    iStatusCode = m_iStatusCode
		    strContent = m_strReceivedContent
		  Else
		    iStatusCode = 0
		    strContent = ""
		  End If
		  
		  Return m_bAnswered
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetMethod() As String
		  ' Returns the HTTP method (GET, POST, etc.) used for the last request.
		  Return m_strMethod
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function GetUsedURL() As String
		  ' Returns the URL used for the last request.
		  Return m_strURL
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub RequestHeader(strHeader As String, Assigns strValue As String)
		  ' Sets, updates, or removes a request header. Assigning an empty string removes the header.
		  ' Usage: RequestHeader("Content-Type") = "application/json"
		  Dim iPos As Integer
		  
		  iPos = m_strArrHeaders.IndexOf(strHeader)
		  If strValue.Len = 0 Then
		    If iPos >= 0 Then
		      'Delete
		      m_strArrHeaders.Remove(iPos)
		      m_strArrHeaderValues.Remove(iPos)
		    End If
		  Else
		    If iPos >= 0 Then
		      'Update
		      m_strArrHeaderValues(iPos) = strValue
		    Else
		      'Insert
		      m_strArrHeaders.Append(strHeader)
		      m_strArrHeaderValues.Append(strValue)
		    End If
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ResponseHeader(strHeader As String) As String
		  ' Returns the value of the named response header, or "" if not present.
		  Dim strRtVal As String
		  Dim iPos As Integer
		  
		  iPos = m_strArrReceivedHeaders.IndexOf(strHeader)
		  If iPos >= 0 Then
		    strRtVal = m_strArrReceivedHeaderValues(iPos)
		  Else
		    strRtVal = ""
		  End If
		  
		  Return strRtVal
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ResponseHeaderName(iIndex As Integer) As String
		  ' Returns the name of the response header at the given 0-based index, or "" if out of range.
		  If iIndex >= 0 And iIndex <= m_strArrReceivedHeaders.Ubound Then
		    Return m_strArrReceivedHeaders(iIndex)
		  Else
		    Return ""
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Send(strMethod As String, strURL As String, bBlocking As Boolean, optional iBaseTimeOutInSeconds As Integer = 15)
		  ' Sends an HTTP request using strMethod (GET/POST/PUT/DELETE/PATCH) to strURL.
		  ' Set bBlocking=True to wait synchronously for the response before returning.
		  ' Fires PageReceived when done. Minimum timeout is 15 seconds.
		  Dim iLenB As Integer
		  
		  If (strMethod = "POST" Or strMethod = "GET" Or strMethod = "PUT" Or strMethod = "DELETE" Or strMethod = "PATCH") And _
		    (strURL.Left(7) = "http://" Or strURL.Left(8) = "https://") Then
		    
		    If iBaseTimeOutInSeconds < 15 Then
		      'Minimum timeout op 15 seconden
		      m_iTimeOutLengthBase = 900
		    Else
		      m_iTimeOutLengthBase = (iBaseTimeOutInSeconds * 60)
		    End If
		    m_strMethod = strMethod
		    m_strURL = strURL
		    m_strReceivedContent = ""
		    m_fiReceived = Nil
		    m_fiRequestedFile = Nil
		    m_bSecure = (strURL.Left(8) = "https://")
		    Redim m_strArrReceivedHeaders(-1)
		    Redim m_strArrReceivedHeaderValues(-1)
		    
		    'Set Content-Length if there is a content
		    iLenB = m_strRequestContent.LenB
		    If iLenB > 0 Then
		      RequestHeader("Content-Length") = Format(iLenB, "0")
		    Else
		      RequestHeader("Content-Length") = ""
		    End If
		    
		    Send_Intern(bBlocking)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Send_Intern(bBlocking As Boolean)
		  ' Dispatches the request on a background thread when called from the main thread.
		  ' When called from within a thread, runs synchronously on the current thread.
		  ' If bBlocking=True, spins with DoEvents/SleepCurrent until m_bAnswered is set.
		  m_bThrRunning = False
		  m_bThrStartedRunning = False
		  If IsNull(Thread.Current) And bBlocking Then
		    m_thr = New Thread

		    AddHandler m_thr.Run, AddressOf Send_ThreadRun

		    m_thr.Run
		  Else
		    Send_ThreadRun(Nil)
		  End If
		  
		  While Not m_bThrStartedRunning
		    Thread.SleepCurrent(100)
		    If IsNull(Thread.Current) Then
		      App.DoEvents
		    End If
		  Wend
		  
		  If m_bThrRunning And bBlocking Then
		    While Not m_bAnswered 
		      Thread.SleepCurrent(100)
		      If IsNull(Thread.Current) Then
		        App.DoEvents
		      End If
		    Wend
		  End If
		  
		  If Not IsNull(m_thr) Then
		    RemoveHandler m_thr.Run, AddressOf Send_ThreadRun
		    
		    m_thr = Nil
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Send_ThreadRun(thr As Thread)
		  ' Thread run handler. Calls Send_URLC to start the actual HTTP transfer.
		  ' When running on a background thread, waits in a sleep loop until the response arrives.
		  #If TargetLinux And XojoVersionString <= "2020" 
		    If Send_XNH Then
		      m_bThrRunning = True
		    ElseIf Send_HTTPSS Then
		      m_bThrRunning = True
		    ElseIf Send_URLC Then
		      m_bThrRunning = True
		    ElseIf Not IsNull(m_oError) Then
		      Error m_oError
		    End If
		  #Else
		    If Send_URLC Then
		      m_bThrRunning = True
		    Else
		      System.DebugLog "Send_ThreadRun: Send_URLC returned False — send did not start"
		      If Not IsNull(m_oError) Then
		        System.DebugLog "Send_ThreadRun: m_oError=" + CStr(m_oError.ErrorNumber) + " - " + m_oError.Message
		        Error m_oError
		      End If
		    End If
		  #EndIf
		  
		  'Deze thread is gestart
		  m_bThrStartedRunning = True
		  
		  If Not IsNull(thr) Then
		    'system.debuglog "clsHttpRequest Send_ThreadRun - pre wait - " + m_strURL
		    While Not m_bAnswered 
		      Thread.SleepCurrent(100)
		    Wend
		    'system.debuglog "clsHttpRequest Send_ThreadRun - after wait" + m_strURL
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Send_URLC() As Boolean
		  ' Performs the actual HTTP transfer using URLConnection.
		  ' Applies all staged request headers, sets the body if present, and calls URLConnection.Send.
		  ' Returns True if the send was started successfully; False if a RuntimeException was thrown.
		  Dim t As Integer
		  Dim iLast As Integer
		  Dim hts As URLConnection
		  Dim bRtVal As Boolean
		  
		  System.DebugLog "Send_URLC: method=" + m_strMethod + " url=" + m_strURL
		  System.DebugLog "Send_URLC: request content length=" + CStr(Len(m_strRequestContent)) + " mimeType=" + m_strRequestMimeType
		  
		  'Create HTTPSocket
		  hts = CreateURLCSocket
		  
		  iLast = m_strArrHeaders.Ubound
		  For t = 0 To iLast 
		    hts.RequestHeader(m_strArrHeaders(t)) = m_strArrHeaderValues(t)
		    'System.debuglog "hts.Header(" + Cstr(t) + ") = " + m_strArrHeaderValues(t)
		  Next t
		  
		  If m_strRequestMimeType.Len > 0 And m_strRequestContent.Len > 0 Then
		    hts.SetRequestContent(m_strRequestContent, m_strRequestMimeType)
		  End If
		  
		  m_iTimeOut = Ticks
		  Try
		    If Not IsNull(m_fiRequestedFile) Then
		      hts.Send(m_strMethod, m_strURL, m_fiRequestedFile)
		    Else
		      'dMs = Microseconds
		      'system.debuglog "clsHTTPRequest.Send_URLC start: " + Format(dMs, "0") '+ " ms"
		      hts.Send(m_strMethod, m_strURL)
		    End If
		    bRtVal = True
		  Catch err As RuntimeException
		    bRtVal = False
		    System.DebugLog "URLConnection => RuntimeException: "  + CStr(err.ErrorNumber) + " - " + err.Message
		    m_oError = err
		  Catch err As Xojo.Net.NetException
		    bRtVal = False 
		    System.DebugLog "URLConnection => Xojo.Net.NetException: "  + CStr(err.ErrorNumber) + " - " + err.Message
		    m_oError = err
		  End Try
		  
		  Return bRtVal
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFileAsMultipartFormData(fi As FolderItem)
		  ' Reads fi and wraps its content in a multipart/form-data body with a fixed boundary.
		  ' Sets the request content and MIME type ready for Send or UploadFile.
		  Dim strFileName As String
		  Dim strContent As String
		  Dim strPre As String
		  Dim strPost As String
		  Dim s As TextInputStream
		  Dim strExtention As String
		  Dim strMimeType As String
		  
		  If Not IsNull(fi) And fi.Exists And Not fi.Directory Then
		    strFileName = fi.Name
		    
		    s = TextInputStream.Open(fi)
		    strContent = s.ReadAll
		    s.Close
		    
		    strMimeType = fi.GetMimeType
		    
		    'Create content block
		    strPre = "--__X_MY_BOUNDARY__" + EndOfLine.Windows + _
		    "Content-Disposition: form-data; name=""file""; filename=""" + strFileName + """" + EndOfLine.Windows + _
		    "Content-Length: " + Format(strContent.LenB, "0") + EndOfLine.Windows + _
		    "Content-Type: " + strMimeType + " " + EndOfLine.Windows + EndOfLine.Windows 
		    
		    strPost = EndOfLine.Windows + _
		    "--__X_MY_BOUNDARY__--" + EndOfLine.Windows
		    
		    strContent = strPre + strContent + strPost
		    
		    SetRequestContent(strContent, "multipart/form-data; charset=utf-8; boundary=__X_MY_BOUNDARY__")
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetFileAsRawContent(fi As FolderItem)
		  ' Reads fi and sets its content as the raw request body with the file's MIME type.
		  ' Sets the request content and MIME type ready for Send or UploadFile.
		  Dim strFileName As String
		  Dim strContent As String
		  Dim strPre As String
		  Dim strPost As String
		  Dim s As TextInputStream
		  Dim strExtention As String
		  Dim strMimeType As String
		  
		  If Not IsNull(fi) And fi.Exists And Not fi.Directory Then
		    strFileName = fi.Name
		    
		    s = TextInputStream.Open(fi)
		    strContent = s.ReadAll
		    s.Close
		    
		    strMimeType = fi.GetMimeType
		    
		    SetRequestContent(strContent, strMimeType)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SetRequestContent(strContent As String, strMimeType As String)
		  ' Sets the request body and its MIME type. Called before Send to attach a body to the request.
		  m_strRequestContent = strContent
		  m_strRequestMimeType = strMimeType
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub TimerEvent_Action(tmr As Timer)
		  ' Watchdog timer callback. If no response has arrived within m_iTimeOutLength ticks,
		  ' destroys the socket, marks the request as answered with status -1 and "Timeout",
		  ' and raises a RuntimeException so the caller can detect the failure.
		  If Not m_bAnswered And Abs(Ticks - m_iTimeOut) > m_iTimeOutLength Then 
		    Dim err As New RuntimeException
		    
		    DestroySockets
		    
		    m_strReceivedContent = "Timeout"
		    m_iStatusCode = -1
		    m_bAnswered = True
		    
		    err.ErrorNumber = -1
		    err.Message = m_strReceivedContent
		    err.Reason = m_strReceivedContent.ToText
		    
		    m_oError = err
		    Error err
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub UploadFile(strMethod As String, strURL As String, fi As FolderItem, bBlocking As Boolean, iFileUploadMethod As Integer = 0, iBaseTimeOutInSeconds As Integer = 15)
		  ' Uploads fi to strURL using PUT or POST (defaults to PUT if strMethod is neither).
		  ' iFileUploadMethod: FILEUPLOADMETHOD_MULTIPARTFORMDATA (0) or FILEUPLOADMETHOD_RAWCONTENT (1).
		  ' Raises InvalidArgumentException if an unrecognised upload method is passed.
		  Dim iLenB As Integer
		  
		  If (strURL.Left(7) = "http://" Or strURL.Left(8) = "https://") And Not IsNull(fi) And fi.Exists And Not fi.IsFolder And fi.Length > 0 Then
		    
		    If iBaseTimeOutInSeconds < 15 Then
		      'Minimum timeout op 15 seconden
		      m_iTimeOutLengthBase = 900
		    Else
		      m_iTimeOutLengthBase = (iBaseTimeOutInSeconds * 60)
		    End If
		    If strMethod <> "PUT" And strMethod <> "POST" Then
		      m_strMethod = "PUT"
		    Else
		      m_strMethod = strMethod
		    End If
		    m_strURL = strURL
		    m_strReceivedContent = ""
		    m_fiReceived = Nil
		    m_fiRequestedFile = Nil
		    m_bSecure = (strURL.Left(8) = "https://")
		    Redim m_strArrReceivedHeaders(-1)
		    Redim m_strArrReceivedHeaderValues(-1)
		    
		    If iFileUploadMethod = FILEUPLOADMETHOD_MULTIPARTFORMDATA Then
		      SetFileAsMultipartFormData(fi)
		    Elseif iFileUploadMethod = FILEUPLOADMETHOD_RAWCONTENT Then
		      SetFileAsRawContent(fi)
		    Else
		      Dim err As New InvalidArgumentException
		      
		      err.ErrorNumber = 400
		      err.Message = "FileUploadMethod moet MultipartFormData of Raw zijn"
		      
		      Raise err
		    End If
		    
		    'Set Content-Length if there is a content
		    iLenB = m_strRequestContent.LenB
		    If iLenB > 0 Then
		      RequestHeader("Content-Length") = Format(iLenB, "0")
		    Else
		      RequestHeader("Content-Length") = ""
		    End If
		    
		    Send_Intern(bBlocking)
		  End If
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function URLCEvent_AuthenticationRequested(hts As URLConnection, strRealm As String, ByRef strName As String, ByRef strPassword As String) As Boolean
		  ' Forwards the server authentication challenge to the AuthenticationRequired event hook.
		  Return AuthenticationRequired(strRealm, strName, strPassword)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_ContentReceived(hts As URLConnection, strURL As String, iStatus As Integer, strContent As String)
		  ' Called by URLConnection when the full response body has been received.
		  ' Stores the status code and content, marks the request as answered, and fires PageReceived.
		  ' Skipped when downloading a file (handled by URLCEvent_FileReceived instead).
		  'dMsStop = Microseconds
		  'System.debuglog "clsHTTPRequest.Send_URLC duurde: " + Format(Afronden(((dMsStop - dMs) / 1000), 0), "0") + " ms tot ContentReceived " + _
		  'self.m_strURL
		  'If Self.m_strURL = "https://85oygmetf8.execute-api.eu-central-1.amazonaws.com/accounting/listSoftware" Then
		  'System.debuglog "clsHTTPRequest.Send_URLC strContent: " + EndOfLine + strContent
		  'End If
		  System.DebugLog "URLCEvent_ContentReceived: iStatus=" + CStr(iStatus) + " content length=" + CStr(Len(strContent))
		  If Len(strContent) > 0 Then
		    System.DebugLog "URLCEvent_ContentReceived: content (first 200)=" + Left(strContent, 200)
		  End If
		  If IsNull(m_fiRequestedFile) Then
		    DestroySockets
		    
		    m_iStatusCode = iStatus
		    m_strReceivedContent = strContent
		    m_bAnswered = True
		    
		    PageReceived strURL, iStatus, strContent
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_Error(hts As URLConnection, err As RuntimeException)
		  ' Called by URLConnection on a network-level error (connection refused, DNS failure, etc.).
		  ' Destroys the socket, marks the request answered with status -1, and raises the error.
		  System.DebugLog "URLCEvent_Error: ErrorNumber=" + CStr(err.ErrorNumber) + " Reason=" + err.Reason + " Message=" + err.Message
		  DestroySockets
		  
		  m_bAnswered = True
		  m_iStatusCode = -1
		  m_strReceivedContent = "URLCEvent_Error " + CStr(err.ErrorNumber) + " - " + err.Reason
		  
		  m_oError = err
		  Error err
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_FileReceived(hts As URLConnection, strURL As String, iStatus As Integer, fi As FolderItem)
		  ' Called by URLConnection when a file download completes.
		  ' On success stores the downloaded FolderItem; on error reads and stores the error body.
		  ' Fires DownloadComplete in both cases.
		  DestroySockets
		  
		  m_iStatusCode = iStatus
		  If iStatus >= 200 And iStatus < 300 Then
		    m_fiReceived = New FolderItem(fi.NativePath, FolderItem.PathTypeNative)
		  Else
		    If fi.Exists Then
		      m_strReceivedContent = ReadTxtFile(fi)
		      fi.Delete
		    Else
		      m_strReceivedContent = "No content"
		    End If
		  End If
		  m_bAnswered = True
		  
		  DownloadComplete strURL, iStatus, fi
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_HeadersReceived(hts As URLConnection, strURL As String, iStatus As Integer)
		  ' Called by URLConnection when the response headers arrive. Stores all headers for later
		  ' retrieval via ResponseHeader() and ResponseHeaderName().
		  For Each header As Pair In hts.ResponseHeaders
		    m_strArrReceivedHeaders.Append(header.Left)
		    m_strArrReceivedHeaderValues.Append(header.Right)
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_ReceivingProgressed(hts As URLConnection, iBytesReceived As Int64, iTotalBytes As Int64, strNewData As String)
		  ' Called periodically as response bytes arrive. Resets the timeout and fires ReceiveProgress.
		  m_iTimeOut = Ticks
		  'dMsStop = Microseconds
		  'system.debuglog "clsHTTPRequest.Send_URLC duurde: " + Format(Afronden(((dMsStop - dMs) / 1000), 0), "0") + " ms tot ReceivingProgressed "  + _
		  'self.m_strURL
		  'If self.m_strURL = "https://85oygmetf8.execute-api.eu-central-1.amazonaws.com/accounting/listSoftware" Then
		  'system.debuglog "clsHTTPRequest.Send_URLC iBytesReceived: " + Cstr(iBytesReceived)
		  'system.debuglog "clsHTTPRequest.Send_URLC iTotalBytes: " + Cstr(iTotalBytes)
		  ''system.debuglog "clsHTTPRequest.Send_URLC strNewData: " + strNewData
		  'End If
		  ReceiveProgress iBytesReceived, iTotalBytes
		  
		  m_iTimeOut = Ticks
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub URLCEvent_SendingProgressed(hts As URLConnection, iBytesSent As Int64, iBytesLeft As Int64)
		  ' Called periodically as request bytes are sent. Resets the timeout and fires SendProgress.
		  m_iTimeOut = Ticks
		  
		  SendProgress iBytesSent, (iBytesSent + iBytesLeft)
		  
		  m_iTimeOut = Ticks
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event AuthenticationRequired(strRealm As String, ByRef strName As String, ByRef strPassword As String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DownloadComplete(strURL As String, iStatus As Integer, fi As FolderItem)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(err As RuntimeException)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PageReceived(strURL As String, iStatus As Integer, strContent As String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event ReceiveProgress(iBytesReceived As Integer, iBytesTotal As Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SendProgress(iBytesSent As Integer, iBytesTotal As Integer)
	#tag EndHook


	#tag Property, Flags = &h0
		dMS As Double
	#tag EndProperty

	#tag Property, Flags = &h0
		dMsStop As Double
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_oError
			End Get
		#tag EndGetter
		httpRuntimeException As RuntimeException
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private m_bAnswered As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bSecure As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bThrRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_bThrStartedRunning As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_cs As CriticalSection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_fiReceived As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_fiRequestedFile As FolderItem
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_htsURLC As URLConnection
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iStatusCode As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iTimeOut As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_iTimeOutLength As Integer
	#tag EndProperty

	#tag Property, Flags = &h0
		m_iTimeOutLengthBase As Integer = 900
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_oError As RuntimeException
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strArrHeaders() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strArrHeaderValues() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strArrReceivedHeaders() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strArrReceivedHeaderValues() As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strMethod As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strReceivedContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strRequestContent As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strRequestMimeType As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_strURL As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_thr As Thread
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_tmr As Timer
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_strReceivedContent
			End Get
		#tag EndGetter
		ReceivedContent As String
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  Return m_iStatusCode
			End Get
		#tag EndGetter
		StatusCode As Integer
	#tag EndComputedProperty


	#tag Constant, Name = FILEUPLOADMETHOD_MULTIPARTFORMDATA, Type = Double, Dynamic = False, Default = \"0", Scope = Public
	#tag EndConstant

	#tag Constant, Name = FILEUPLOADMETHOD_RAWCONTENT, Type = Double, Dynamic = False, Default = \"1", Scope = Public
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
		#tag ViewProperty
			Name="StatusCode"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="ReceivedContent"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="m_iTimeOutLengthBase"
			Visible=false
			Group="Behavior"
			InitialValue="900"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="dMS"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="dMsStop"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
