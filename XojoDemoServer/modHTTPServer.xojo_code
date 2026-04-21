#tag Module
Protected Module modHTTPServer
	#tag Method, Flags = &h1
		Protected Sub StartServer(iPort As Integer)
		  ' Starts the HTTP server on the given port using clsHTTPServer (ServerSocket).
		  ' Each incoming connection is handled independently by its own clsHTTPConnection instance,
		  ' allowing multiple simultaneous clients.
		  m_server = New clsHTTPServer
		  m_server.Port = iPort
		  m_server.Listen
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub StopServer()
		  ' Stops the server by releasing the ServerSocket instance.
		  ' Setting it to Nil destroys the socket and stops accepting new connections.
		  ' Connections already in progress are allowed to complete naturally.
		  m_server = Nil
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_server As clsHTTPServer
	#tag EndProperty


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
