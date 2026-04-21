#tag Interface
Interface IDatabase
	#tag Method, Flags = &h0
		Function Connect() As Boolean
		  ' Opens the API connection. Returns True if a token was successfully obtained.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Close()
		  ' Closes the connection and clears any cached credentials or state.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelect(strSQL As String) As UseRecordSet
		  ' Executes a SELECT query over the API and returns the result as a UseRecordSet. Returns Nil on failure.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLSelectDB(strSQL As String) As UseRecordSet
		  ' Executes a SELECT query over the API, then loads the result into an in-memory SQLite table
		  ' for full bidirectional navigation (MovePrevious, MoveLast). Returns Nil on failure.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub SQLExecute(strSQL As String)
		  ' Executes a non-SELECT SQL statement (INSERT, UPDATE, DELETE). Check Error/ErrorMessage afterward.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub InsertRecord(strTableName As String, record As UseDatabaseRecord)
		  ' Inserts a new row into the named table using the column values from a UseDatabaseRecord.
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Prepare(strSQL As String) As UsePreparedStatement
		  ' Creates a UsePreparedStatement for the given SQL template with ? or $N parameter markers.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Error() As Boolean
		  ' Returns True if the last operation produced an error.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorMessage() As String
		  ' Returns the error description from the last failed operation, or "" if there was no error.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function ErrorCode() As Integer
		  ' Returns a numeric error code. Always 0 for the HTTP-based driver.
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Connected() As Boolean
		  ' Returns True after a successful Connect call and before Close is called.
		End Function
	#tag EndMethod

End Interface
#tag EndInterface
