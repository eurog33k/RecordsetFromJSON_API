#tag DesktopWindow
Begin DesktopWindow wndTest
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   400
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1429219327
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "RecordsetTest"
   Type            =   0
   Visible         =   True
   Width           =   600
   Begin DesktopButton btnExecute
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "ExecuteJSON"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   157
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   110
   End
   Begin DesktopTextArea taSQL
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   133
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   "SELECT * FROM tracks ORDER BY id ASC"
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   12
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   560
   End
   Begin DesktopListBox lbResult
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   True
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   1
      ColumnWidths    =   ""
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   191
      Index           =   -2147483648
      InitialValue    =   ""
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   False
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   189
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   560
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
   Begin DesktopButton btnExecuteDB
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "ExecuteDB"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   142
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   3
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   157
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   92
   End
   Begin DesktopButton btnTests
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Run Tests"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   246
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   False
      LockRight       =   True
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   4
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   157
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   100
   End
   Begin DesktopButton btnDemoTest
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Demotest"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   500
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   5
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   157
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopButton btnAutoDemoTest
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Auto Demotest"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   358
      LockBottom      =   False
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   6
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   157
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   130
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Method, Flags = &h21
		Private Sub SaveTestReport(strReport As String, iPass As Integer, iFail As Integer)
		  ' Walk up from executable to find the project folder
		  Var fiDir As FolderItem = App.ExecutableFile.Parent
		  Var iLevels As Integer = 0
		  While Not IsNull(fiDir) And iLevels < 8
		    Var fiCheck As FolderItem = fiDir.Child("RecordsetFromAPIv1.xojo_project")
		    If Not IsNull(fiCheck) And fiCheck.Exists Then
		      Exit
		    End If
		    Var fiParent As FolderItem = fiDir.Parent
		    If IsNull(fiParent) Then
		      fiDir = App.ExecutableFile.Parent  ' fallback
		      Exit
		    End If
		    fiDir = fiParent
		    iLevels = iLevels + 1
		  Wend
		  
		  Var fiReport As FolderItem = fiDir.Child("UseRecordSetTestReport.txt")
		  Try
		    Var tos As TextOutputStream = TextOutputStream.Create(fiReport)
		    tos.Write(strReport)
		    tos.Close
		    MessageBox "Tests done: " + CStr(iPass) + " passed, " + CStr(iFail) + " failed." + EndOfLine + "Report saved to:" + EndOfLine + fiReport.NativePath
		  Catch err As IOException
		    MessageBox "Could not save report: " + err.Message + EndOfLine + EndOfLine + strReport
		  End Try
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function TestCheck(strName As String, strExpected As String, strActual As String, ByRef iPass As Integer, ByRef iFail As Integer) As String
		  If strActual = strExpected Then
		    iPass = iPass + 1
		    Return "[PASS] " + strName + " -> """ + strActual + """"
		  Else
		    iFail = iFail + 1
		    Return "[FAIL] " + strName + " -> expected """ + strExpected + """, got """ + strActual + """"
		  End If
		End Function
	#tag EndMethod


#tag EndWindowCode

#tag Events btnExecute
	#tag Event
		Sub Pressed()
		  var rs As UseRecordSet
		  Var strSQL As String
		  Var strFieldValue As String
		  strSQL = taSQL.Text
		  lbResult.RemoveAllRows
		  Var tmpDB As New UseDatabase
		  If tmpDB.Connect Then
		    rs = tmpDB.SQLSelect(strSQL)
		  else
		    MsgBox "Connect failed: " + tmpDB.ErrorMessage
		    Return
		  End If
		  If rs <> Nil And Not rs.EOF Then
		    lbResult.ColumnCount=rs.FieldCount
		    for i As Integer=1 to rs.FieldCount
		      lbResult.HeaderAt(i-1)=rs.DbFieldName(i)
		    next
		    While not rs.EOF
		      lbResult.AddRow(rs.IdxField(1).StringValue)
		      for i As Integer=2 to rs.FieldCount
		        strFieldValue=rs.IdxField(i).StringValue
		        lbResult.CellTextAt(lbResult.LastAddedRowIndex,i-1)=strFieldValue
		      next
		      rs.MoveNext
		    Wend
		  End If
		  if rs<>nil then
		    rs.Close
		  end if
		  rs=nil
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnExecuteDB
	#tag Event
		Sub Pressed()
		  var rs As UseRecordSet
		  Var strSQL As String
		  Var strFieldValue As String
		  strSQL = taSQL.Text
		  lbResult.RemoveAllRows
		  Var tmpDB As New UseDatabase
		  If tmpDB.Connect Then
		    rs = tmpDB.SQLSelectDB(strSQL)
		  else
		    MsgBox "Connect failed: " + tmpDB.ErrorMessage
		    Return
		  End If
		  If rs <> Nil And Not rs.EOF Then
		    lbResult.ColumnCount=rs.FieldCount
		    for i As Integer=1 to rs.FieldCount
		      lbResult.HeaderAt(i-1)=rs.DbFieldName(i)
		    next
		    While not rs.EOF
		      lbResult.AddRow(rs.IdxField(1).StringValue)
		      for i As Integer=2 to rs.FieldCount
		        strFieldValue=rs.IdxField(i).StringValue
		        lbResult.CellTextAt(lbResult.LastAddedRowIndex,i-1)=strFieldValue
		      next
		      rs.MoveNext
		    Wend
		  End If
		  if rs<>nil then
		    rs.Close
		  end if
		  rs=nil
		  
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnTests
	#tag Event
		Sub Pressed()
		  ' Tests run against the XojoDemoServer (tracks, products, sessions, speakers tables).
		  ' Start the XojoDemoServer before pressing Run Tests.
		  Var strSQL As String = "SELECT * FROM tracks ORDER BY id ASC"
		  Var strReport As String
		  Var iPass As Integer = 0
		  Var iFail As Integer = 0
		  
		  Var dtNow As New Date
		  strReport = "UseRecordSet Test Report" + EndOfLine
		  strReport = strReport + "========================" + EndOfLine
		  strReport = strReport + "Date  : " + dtNow.ShortDate + " " + dtNow.ShortTime + EndOfLine
		  strReport = strReport + "Query : " + strSQL + EndOfLine
		  strReport = strReport + EndOfLine
		  
		  Try
		    
		    ' Shared connection used for Groups 1-6.
		    Var dbMain As New UseDatabase
		    If Not dbMain.Connect Then
		      strReport = strReport + "[ABRT] Cannot connect: " + dbMain.ErrorMessage + EndOfLine
		      SaveTestReport(strReport, 0, 1)
		      Return
		    End If
		    
		    ' ── Group 1: JSON Mode — Structure ────────────────────────────────────
		    strReport = strReport + "[ Group 1: JSON Mode — Structure ]" + EndOfLine
		    
		    Var rs As UseRecordSet
		    rs = dbMain.SQLSelect(strSQL)
		    
		    If rs = Nil Then
		      strReport = strReport + "[ABRT] Could not open recordset — all tests aborted." + EndOfLine
		      iFail = iFail + 1
		      SaveTestReport(strReport, iPass, iFail)
		      Return
		    End If
		    
		    strReport = strReport + TestCheck("RecordCount",             "6",    CStr(rs.RecordCount),   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("FieldCount",              "2",    CStr(rs.FieldCount),    iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("DbFieldName(1)",          "id",   rs.DbFieldName(1),      iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("DbFieldName(2)",          "name", rs.DbFieldName(2),      iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("ColumnType(1) [Integer]", "5",    CStr(rs.ColumnType(1)), iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("ColumnType(2) [String]",  "5",    CStr(rs.ColumnType(2)), iPass, iFail) + EndOfLine
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 2: JSON Mode — Initial State ────────────────────────────────
		    strReport = strReport + "[ Group 2: JSON Mode — Initial State ]" + EndOfLine
		    strReport = strReport + "  Note: Both JSON mode and DB mode (SelectSQL) start with the cursor on the first record." + EndOfLine
		    strReport = strReport + "        BOF=False at start. Data is available immediately without needing an explicit MoveFirst." + EndOfLine
		    
		    strReport = strReport + TestCheck("BOF at start (cursor on first record)", "False",    CStr(rs.BOF),                          iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("EOF with 6 records available",          "False",    CStr(rs.EOF),                          iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record DbField(1) id",            "1",        CStr(rs.DbField(1)),                   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record DbField(2) name",          "Desktop",  CStr(rs.DbField(2)),                   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record Field(""id"")",            "1",        rs.Field("id").StringValue,            iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record Field(""name"")",          "Desktop",  rs.Field("name").StringValue,          iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("Field(DbFieldName(1)) round-trip",      "1",        rs.Field(rs.DbFieldName(1)).StringValue, iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("Field(""id"").Name property",           "id",       rs.Field("id").Name,                   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record IdxField(1).StringValue",  "1",        rs.IdxField(1).StringValue,            iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record IdxField(1).IntegerValue","1",        CStr(rs.IdxField(1).IntegerValue),     iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record IdxField(1).Name",        "id",       rs.IdxField(1).Name,                   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("First record IdxField(2).Name",        "name",     rs.IdxField(2).Name,                   iPass, iFail) + EndOfLine
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 3: JSON Mode — Forward Traversal ────────────────────────────
		    strReport = strReport + "[ Group 3: JSON Mode — Forward Traversal ]" + EndOfLine
		    
		    Var iCount As Integer = 0
		    Var strLastId As String = ""
		    Var strLastName As String = ""
		    
		    While Not rs.EOF
		      iCount = iCount + 1
		      strLastId   = CStr(rs.DbField(1))
		      strLastName = CStr(rs.DbField(2))
		      rs.MoveNext
		    Wend
		    
		    strReport = strReport + TestCheck("Total records visited by forward traversal", "6",              CStr(iCount),   iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("Last record id at end of traversal",         "6",              strLastId,      iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("Last record name at end of traversal",       "Best Practices", strLastName,    iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("EOF=True after full traversal",              "True",           CStr(rs.EOF),   iPass, iFail) + EndOfLine
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 3b: JSON Mode — Navigation ──────────────────────────────────
		    strReport = strReport + "[ Group 3b: JSON Mode — Navigation ]" + EndOfLine
		    
		    rs.MoveFirst
		    strReport = strReport + TestCheck("JSON MoveFirst → BOF=False",          "False",          CStr(rs.BOF),        iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("JSON MoveFirst → first id",           "1",              CStr(rs.DbField(1)), iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("JSON MoveFirst → first name",         "Desktop",        CStr(rs.DbField(2)), iPass, iFail) + EndOfLine
		    
		    rs.MoveLast
		    strReport = strReport + TestCheck("JSON MoveLast → last id",             "6",              CStr(rs.DbField(1)), iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("JSON MoveLast → last name",           "Best Practices", CStr(rs.DbField(2)), iPass, iFail) + EndOfLine
		    
		    rs.MovePrevious
		    strReport = strReport + TestCheck("JSON MovePrevious → second-to-last id",   "5",                 CStr(rs.DbField(1)), iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("JSON MovePrevious → second-to-last name", "API & Integration", CStr(rs.DbField(2)), iPass, iFail) + EndOfLine
		    
		    rs.MoveFirst
		    rs.MovePrevious
		    strReport = strReport + TestCheck("JSON MovePrevious past first → BOF=True",           "True", CStr(rs.BOF),        iPass, iFail) + EndOfLine
		    rs.MoveNext
		    strReport = strReport + TestCheck("JSON MoveNext from BOF lands on first record id=1", "1",    CStr(rs.DbField(1)), iPass, iFail) + EndOfLine
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 4: JSON Mode — Lifecycle ────────────────────────────────────
		    strReport = strReport + "[ Group 4: JSON Mode — Lifecycle ]" + EndOfLine
		    
		    rs.Close
		    strReport = strReport + TestCheck("EOF after Close()",         "True", CStr(rs.EOF),        iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("RecordCount after Close()", "0",    CStr(rs.RecordCount), iPass, iFail) + EndOfLine
		    rs = Nil
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 5: DB Mode — Structure ──────────────────────────────────────
		    strReport = strReport + "[ Group 5: DB Mode — Structure ]" + EndOfLine
		    strReport = strReport + "  Note: DB mode uses an in-memory SQLite RowSet backed by the API data." + EndOfLine
		    
		    Var rsDB As UseRecordSet
		    rsDB = dbMain.SQLSelectDB(strSQL)
		    
		    If rsDB = Nil Then
		      strReport = strReport + "[ABRT] Could not open DB recordset — Groups 5 & 6 aborted." + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("DB RecordCount",    "6",      CStr(rsDB.RecordCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB FieldCount",     "2",      CStr(rsDB.FieldCount),   iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB DbFieldName(1)", "id",     rsDB.DbFieldName(1),     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB DbFieldName(2)", "name",   rsDB.DbFieldName(2),     iPass, iFail) + EndOfLine
		      strReport = strReport + EndOfLine
		      
		      ' ── Group 6: DB Mode — Bidirectional Navigation ───────────────────────
		      strReport = strReport + "[ Group 6: DB Mode — Bidirectional Navigation ]" + EndOfLine
		      strReport = strReport + "  Note: DB mode BOF=False at start — SelectSQL positions cursor on first row immediately." + EndOfLine
		      
		      strReport = strReport + TestCheck("DB BOF at start (cursor on first row)", "False", CStr(rsDB.BOF), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB EOF at start (not past last row)",   "False", CStr(rsDB.EOF), iPass, iFail) + EndOfLine
		      
		      rsDB.MoveFirst
		      strReport = strReport + TestCheck("DB BOF=False after MoveFirst",              "False",   CStr(rsDB.BOF),        iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB first record id after MoveFirst",        "1",       CStr(rsDB.DbField(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB first record name after MoveFirst",      "Desktop", CStr(rsDB.DbField(2)), iPass, iFail) + EndOfLine
		      
		      rsDB.MoveLast
		      Var strLastIdMoveLast   As String = CStr(rsDB.DbField(1))
		      Var strLastNameMoveLast As String = CStr(rsDB.DbField(2))
		      strReport = strReport + TestCheck("DB EOF=False on last record (not past it)", "False",          CStr(rsDB.EOF),        iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB last record id via MoveLast",            "6",              strLastIdMoveLast,     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB last record name via MoveLast",          "Best Practices", strLastNameMoveLast,   iPass, iFail) + EndOfLine
		      
		      rsDB.MoveFirst
		      Var iDBCount         As Integer = 0
		      Var strLastIdIter    As String = ""
		      Var strLastNameIter  As String = ""
		      While Not rsDB.EOF
		        iDBCount = iDBCount + 1
		        strLastIdIter   = CStr(rsDB.DbField(1))
		        strLastNameIter = CStr(rsDB.DbField(2))
		        rsDB.MoveNext
		      Wend
		      
		      strReport = strReport + TestCheck("DB forward traversal count",       "6",    CStr(iDBCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB EOF=True after full traversal", "True", CStr(rsDB.EOF),  iPass, iFail) + EndOfLine
		      
		      Var bLastMatch As Boolean = (strLastIdIter = strLastIdMoveLast) And (strLastNameIter = strLastNameMoveLast)
		      strReport = strReport + TestCheck("DB last record from traversal matches MoveLast result", "True", CStr(bLastMatch), iPass, iFail) + EndOfLine
		      If Not bLastMatch Then
		        strReport = strReport + "       Traversal : id=" + strLastIdIter + ", """ + strLastNameIter + """" + EndOfLine
		        strReport = strReport + "       MoveLast  : id=" + strLastIdMoveLast + ", """ + strLastNameMoveLast + """" + EndOfLine
		      End If
		      
		      rsDB.MoveLast
		      rsDB.MovePrevious
		      strReport = strReport + TestCheck("DB MovePrevious from last gives second-to-last id=5",               "5",                 CStr(rsDB.DbField(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB MovePrevious from last gives second-to-last ""API & Integration""", "API & Integration", CStr(rsDB.DbField(2)), iPass, iFail) + EndOfLine
		      
		      ' ColumnType in SQLite mode — must use OID-mapped values, not RowSet storage type
		      rsDB.MoveFirst
		      strReport = strReport + TestCheck("DB ColumnType(1) id [Integer → 4]", "4", CStr(rsDB.ColumnType(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("DB ColumnType(2) name [String → 5]", "5", CStr(rsDB.ColumnType(2)), iPass, iFail) + EndOfLine
		      
		      rsDB.Close
		      rsDB = Nil
		    End If
		    
		    ' ── Group 7: UseDatabase — Connection and SQLSelect ───────────────────
		    strReport = strReport + "[ Group 7: UseDatabase — Connection and SQLSelect ]" + EndOfLine
		    
		    Var db As New UseDatabase
		    If Not db.Connect Then
		      strReport = strReport + "[ABRT] UseDatabase.Connect failed: " + db.ErrorMessage + " — Groups 7-10 aborted." + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("db.Error=False after Connect",     "False", CStr(db.Error),     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("db.ErrorMessage="" after Connect", "",      db.ErrorMessage,    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("db.Connected=True after Connect",  "True",  CStr(db.Connected), iPass, iFail) + EndOfLine
		      
		      Var rs7 As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		      If IsNull(rs7) Then
		        strReport = strReport + "[ABRT] UseDatabase.SQLSelect returned Nil: " + db.ErrorMessage + " — Groups 7-10 aborted." + EndOfLine
		        iFail = iFail + 1
		      Else
		        strReport = strReport + TestCheck("UseDatabase.SQLSelect RecordCount=6", "6",       CStr(rs7.RecordCount), iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("UseDatabase.SQLSelect first id",      "1",       CStr(rs7.DbField(1)),  iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("UseDatabase.SQLSelect first name",    "Desktop", CStr(rs7.DbField(2)),  iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("db.Error=False after SQLSelect",      "False",   CStr(db.Error),        iPass, iFail) + EndOfLine
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 8: UseRecordSetField — Additional Properties ──────────────
		        strReport = strReport + "[ Group 8: UseRecordSetField — Additional Properties ]" + EndOfLine
		        
		        Var f8id As UseRecordSetField = rs7.Field("id")
		        strReport = strReport + TestCheck("GetString() matches StringValue",     "1",    f8id.GetString,                       iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("NativeValue is not Nil",              "True", CStr(Not IsNull(f8id.NativeValue)),   iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("PictureValue returns Nil",            "True", CStr(IsNull(f8id.PictureValue)),      iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("CurrencyValue matches DoubleValue",   "True", CStr(f8id.CurrencyValue = f8id.DoubleValue), iPass, iFail) + EndOfLine
		        
		        ' SetString: call on a standalone field object and verify the value changes
		        Var fSet As New UseRecordSetField("test", "original")
		        fSet.SetString("changed")
		        strReport = strReport + TestCheck("SetString changes field value",       "changed", fSet.StringValue, iPass, iFail) + EndOfLine
		        rs7.Close
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 9: UseDatabaseRecord — Column Setters (local) ─────────────
		        strReport = strReport + "[ Group 9: UseDatabaseRecord — Column Setters ]" + EndOfLine
		        
		        Var rec As New UseDatabaseRecord
		        rec.Column("name") = "Desktop"
		        rec.IntegerColumn("score") = 42
		        rec.BooleanColumn("active") = True
		        
		        strReport = strReport + TestCheck("FieldCount after 3 columns",          "3",       CStr(rec.FieldCount), iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("FieldName(0)=name",                   "name",    rec.FieldName(0),     iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("FieldName(1)=score",                  "score",   rec.FieldName(1),     iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("Column string stored correctly",      "Desktop", rec.ValueAt(0),       iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("IntegerColumn stores as string 42",   "42",      rec.ValueAt(1),       iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("BooleanColumn True stores as 1",      "1",       rec.ValueAt(2),       iPass, iFail) + EndOfLine
		        
		        Var rec2 As New UseDatabaseRecord
		        rec2.BooleanColumn("flag") = False
		        strReport = strReport + TestCheck("BooleanColumn False stores as 0",     "0",       rec2.ValueAt(0),      iPass, iFail) + EndOfLine
		        
		        Var rec3 As New UseDatabaseRecord
		        rec3.Column("x") = "first"
		        rec3.Column("x") = "second"
		        strReport = strReport + TestCheck("Overwrite same column: FieldCount=1", "1",       CStr(rec3.FieldCount), iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("Overwrite same column: value=second", "second",  rec3.ValueAt(0),       iPass, iFail) + EndOfLine
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 10: Write Operations ──────────────────────────────────────
		        strReport = strReport + "[ Group 10: Write Operations ]" + EndOfLine
		        strReport = strReport + "  Note: Inserts id=7, edits, then deletes to restore the database." + EndOfLine
		        
		        ' Clean up any leftover from a previous test run
		        db.SQLExecute("DELETE FROM tracks WHERE id=7")
		        
		        ' InsertRecord
		        Var recNew As New UseDatabaseRecord
		        recNew.Column("id") = "7"
		        recNew.Column("name") = "Test Track"
		        db.InsertRecord("tracks", recNew)
		        strReport = strReport + TestCheck("InsertRecord: db.Error=False",        "False", CStr(db.Error), iPass, iFail) + EndOfLine
		        
		        Var rsAfterInsert As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		        strReport = strReport + TestCheck("InsertRecord: RecordCount=7",         "7",          CStr(rsAfterInsert.RecordCount), iPass, iFail) + EndOfLine
		        rsAfterInsert.MoveLast
		        strReport = strReport + TestCheck("InsertRecord: last id=7",             "7",          CStr(rsAfterInsert.DbField(1)),  iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("InsertRecord: last name=Test Track",  "Test Track", CStr(rsAfterInsert.DbField(2)),  iPass, iFail) + EndOfLine
		        rsAfterInsert.Close
		        
		        ' Edit + Update
		        Var rsToEdit As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=7")
		        rsToEdit.Edit
		        rsToEdit.Field("name").Value = "Updated Track"
		        rsToEdit.Update
		        rsToEdit.Close
		        
		        Var rsAfterEdit As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=7")
		        strReport = strReport + TestCheck("Edit+Update: name changed",           "Updated Track", CStr(rsAfterEdit.DbField(2)), iPass, iFail) + EndOfLine
		        rsAfterEdit.Close
		        
		        ' DeleteRecord
		        Var rsToDel As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=7")
		        rsToDel.DeleteRecord
		        rsToDel.Close
		        
		        Var rsAfterDelete As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		        strReport = strReport + TestCheck("DeleteRecord: RecordCount back to 6", "6", CStr(rsAfterDelete.RecordCount), iPass, iFail) + EndOfLine
		        rsAfterDelete.Close
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 11: UseDatabaseRecord — CurrencyColumn ──────────────────
		        strReport = strReport + "[ Group 11: UseDatabaseRecord — CurrencyColumn ]" + EndOfLine
		        
		        Var recCurr As New UseDatabaseRecord
		        recCurr.CurrencyColumn("price") = 100
		        strReport = strReport + TestCheck("CurrencyColumn: FieldCount=1",     "1",     CStr(recCurr.FieldCount),   iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("CurrencyColumn: FieldName=price",  "price", recCurr.FieldName(0),       iPass, iFail) + EndOfLine
		        ' Value is stored as CStr(Currency) — verify it contains "100"
		        strReport = strReport + TestCheck("CurrencyColumn: value contains 100", "True", CStr(InStr(recCurr.ValueAt(0), "100") > 0), iPass, iFail) + EndOfLine
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 12: UsePreparedStatement — SELECT with ? markers ────────
		        strReport = strReport + "[ Group 12: UsePreparedStatement — SELECT (? markers) ]" + EndOfLine
		        
		        Var psQ As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE name = ?")
		        psQ.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		        psQ.Bind(0, "Desktop")
		        Var rsPsQ As UseRecordSet = psQ.SQLSelect
		        If IsNull(rsPsQ) Then
		          strReport = strReport + "[ABRT] Prepared ? SELECT returned Nil: " + db.ErrorMessage + EndOfLine
		          iFail = iFail + 1
		        Else
		          strReport = strReport + TestCheck("Prepare ?: RecordCount=1",   "1",       CStr(rsPsQ.RecordCount), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("Prepare ?: id=1",            "1",       CStr(rsPsQ.DbField(1)),  iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("Prepare ?: name=Desktop",    "Desktop", CStr(rsPsQ.DbField(2)),  iPass, iFail) + EndOfLine
		          rsPsQ.Close
		        End If
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 13: UsePreparedStatement — SELECT with $N markers ───────
		        strReport = strReport + "[ Group 13: UsePreparedStatement — SELECT ($N markers) ]" + EndOfLine
		        
		        Var psDollar As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = $1")
		        psDollar.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		        psDollar.Bind(0, 6)
		        Var rsPsDollar As UseRecordSet = psDollar.SQLSelect
		        If IsNull(rsPsDollar) Then
		          strReport = strReport + "[ABRT] Prepared $N SELECT returned Nil: " + db.ErrorMessage + EndOfLine
		          iFail = iFail + 1
		        Else
		          strReport = strReport + TestCheck("Prepare $N: id=6",                  "6",              CStr(rsPsDollar.DbField(1)), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("Prepare $N: name=Best Practices",   "Best Practices", CStr(rsPsDollar.DbField(2)), iPass, iFail) + EndOfLine
		          rsPsDollar.Close
		        End If
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 14: UsePreparedStatement — SQLExecute + inline ParamArray
		        strReport = strReport + "[ Group 14: UsePreparedStatement — write + inline values ]" + EndOfLine
		        strReport = strReport + "  Note: Inserts id=8, verifies, then deletes to restore." + EndOfLine
		        
		        ' Clean up any leftover from a previous run
		        db.SQLExecute("DELETE FROM tracks WHERE id=8")
		        
		        Var psInsert As UsePreparedStatement = db.Prepare("INSERT INTO tracks (id, name) VALUES (?, ?)")
		        psInsert.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		        psInsert.BindType(1, UsePreparedStatement.SQLITE_TEXT)
		        psInsert.Bind(0, 8)
		        psInsert.Bind(1, "Prepared Track")
		        psInsert.SQLExecute
		        strReport = strReport + TestCheck("Prepare SQLExecute: db.Error=False",   "False", CStr(db.Error), iPass, iFail) + EndOfLine
		        
		        Var rsAfterPs As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		        strReport = strReport + TestCheck("Prepare SQLExecute: RecordCount=7",    "7",              CStr(rsAfterPs.RecordCount), iPass, iFail) + EndOfLine
		        rsAfterPs.MoveLast
		        strReport = strReport + TestCheck("Prepare SQLExecute: last name",        "Prepared Track", CStr(rsAfterPs.DbField(2)),  iPass, iFail) + EndOfLine
		        rsAfterPs.Close
		        
		        ' Inline ParamArray SELECT (reuses type set by BindType above)
		        Var psInline As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		        psInline.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		        Var rsInline As UseRecordSet = psInline.SQLSelect(8)
		        If IsNull(rsInline) Then
		          strReport = strReport + "[ABRT] Inline ParamArray SELECT returned Nil" + EndOfLine
		          iFail = iFail + 1
		        Else
		          strReport = strReport + TestCheck("Prepare inline ParamArray: name", "Prepared Track", CStr(rsInline.DbField(2)), iPass, iFail) + EndOfLine
		          rsInline.Close
		        End If
		        
		        ' Clean up
		        db.SQLExecute("DELETE FROM tracks WHERE id=8")
		        Var rsCleanup As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		        strReport = strReport + TestCheck("Prepare cleanup: RecordCount=6",       "6", CStr(rsCleanup.RecordCount), iPass, iFail) + EndOfLine
		        rsCleanup.Close
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 18: UseDatabase.SQLSelect — Bidirectional Navigation ────────
		        strReport = strReport + "[ Group 18: UseDatabase.SQLSelect — Bidirectional Navigation ]" + EndOfLine
		        
		        Var rs18 As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		        If IsNull(rs18) Then
		          strReport = strReport + "[ABRT] SQLSelect returned Nil — Group 18 aborted." + EndOfLine
		          iFail = iFail + 1
		        Else
		          strReport = strReport + TestCheck("SQLSelect BOF=False at start",                "False",          CStr(rs18.BOF),        iPass, iFail) + EndOfLine
		          rs18.MoveFirst
		          strReport = strReport + TestCheck("SQLSelect MoveFirst → BOF=False",              "False",          CStr(rs18.BOF),        iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelect MoveFirst → first id",               "1",              CStr(rs18.DbField(1)), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelect MoveFirst → first name",             "Desktop",        CStr(rs18.DbField(2)), iPass, iFail) + EndOfLine
		          rs18.MoveLast
		          strReport = strReport + TestCheck("SQLSelect MoveLast → last id",                 "6",              CStr(rs18.DbField(1)), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelect MoveLast → last name",               "Best Practices", CStr(rs18.DbField(2)), iPass, iFail) + EndOfLine
		          rs18.MovePrevious
		          strReport = strReport + TestCheck("SQLSelect MovePrevious → id=5",                "5",              CStr(rs18.DbField(1)), iPass, iFail) + EndOfLine
		          rs18.MoveFirst
		          rs18.MovePrevious
		          strReport = strReport + TestCheck("SQLSelect MovePrev past first → BOF=True",     "True",           CStr(rs18.BOF),        iPass, iFail) + EndOfLine
		          rs18.MoveNext
		          strReport = strReport + TestCheck("SQLSelect MoveNext from BOF → id=1",           "1",              CStr(rs18.DbField(1)), iPass, iFail) + EndOfLine
		          rs18.MoveLast
		          Var i18Count As Integer = 0
		          While Not rs18.BOF
		            i18Count = i18Count + 1
		            rs18.MovePrevious
		          Wend
		          strReport = strReport + TestCheck("SQLSelect backward traversal count",           "6",              CStr(i18Count),        iPass, iFail) + EndOfLine
		          rs18.Close
		        End If
		        strReport = strReport + EndOfLine
		        
		        ' ── Group 19: UseDatabase.SQLSelectDB — Bidirectional Navigation ──────
		        strReport = strReport + "[ Group 19: UseDatabase.SQLSelectDB — Bidirectional Navigation ]" + EndOfLine
		        
		        Var rs19 As UseRecordSet = db.SQLSelectDB("SELECT * FROM tracks ORDER BY id ASC")
		        If IsNull(rs19) Then
		          strReport = strReport + "[ABRT] SQLSelectDB returned Nil — Group 19 aborted." + EndOfLine
		          iFail = iFail + 1
		        Else
		          strReport = strReport + TestCheck("SQLSelectDB BOF=False at start",                "False",          CStr(rs19.BOF),        iPass, iFail) + EndOfLine
		          rs19.MoveFirst
		          strReport = strReport + TestCheck("SQLSelectDB MoveFirst → BOF=False",             "False",          CStr(rs19.BOF),        iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelectDB MoveFirst → first id",              "1",              CStr(rs19.DbField(1)), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelectDB MoveFirst → first name",            "Desktop",        CStr(rs19.DbField(2)), iPass, iFail) + EndOfLine
		          rs19.MoveLast
		          strReport = strReport + TestCheck("SQLSelectDB MoveLast → last id",                "6",              CStr(rs19.DbField(1)), iPass, iFail) + EndOfLine
		          strReport = strReport + TestCheck("SQLSelectDB MoveLast → last name",              "Best Practices", CStr(rs19.DbField(2)), iPass, iFail) + EndOfLine
		          rs19.MovePrevious
		          strReport = strReport + TestCheck("SQLSelectDB MovePrevious → id=5",               "5",              CStr(rs19.DbField(1)), iPass, iFail) + EndOfLine
		          rs19.MoveFirst
		          rs19.MovePrevious
		          strReport = strReport + TestCheck("SQLSelectDB MovePrev past first → BOF=True",    "True",           CStr(rs19.BOF),        iPass, iFail) + EndOfLine
		          rs19.MoveNext
		          strReport = strReport + TestCheck("SQLSelectDB MoveNext from BOF → id=1",          "1",              CStr(rs19.DbField(1)), iPass, iFail) + EndOfLine
		          rs19.MoveLast
		          Var i19Count As Integer = 0
		          While Not rs19.BOF
		            i19Count = i19Count + 1
		            rs19.MovePrevious
		          Wend
		          strReport = strReport + TestCheck("SQLSelectDB backward traversal count",           "6",              CStr(i19Count),        iPass, iFail) + EndOfLine
		          rs19.Close
		        End If
		        strReport = strReport + EndOfLine
		        
		        db.Close
		        strReport = strReport + EndOfLine
		      End If
		    End If
		    
		    ' ── Group 15: products — JSON Mode Structure ──────────────────────────
		    strReport = strReport + "[ Group 15: products — JSON Mode Structure ]" + EndOfLine
		    strReport = strReport + "  Note: Covers Integer, Real, and String column types. All ColumnType values must be 5 (String) in JSON mode." + EndOfLine
		    
		    Var strSQLProd As String = "SELECT * FROM products ORDER BY id ASC"
		    Var rsProd As UseRecordSet = dbMain.SQLSelect(strSQLProd)
		    
		    If IsNull(rsProd) Then
		      strReport = strReport + "[ABRT] Could not open products recordset — Groups 15-16 aborted." + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("products RecordCount",             "10", CStr(rsProd.RecordCount),   iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products FieldCount",              "5",  CStr(rsProd.FieldCount),    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products DbFieldName(1)",          "id",          rsProd.DbFieldName(1), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products DbFieldName(2)",          "name",        rsProd.DbFieldName(2), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products DbFieldName(3)",          "category",    rsProd.DbFieldName(3), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products DbFieldName(4)",          "price",       rsProd.DbFieldName(4), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products DbFieldName(5)",          "description", rsProd.DbFieldName(5), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products ColumnType(1) [Integer]", "5", CStr(rsProd.ColumnType(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products ColumnType(2) [String]",  "5", CStr(rsProd.ColumnType(2)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products ColumnType(3) [String]",  "5", CStr(rsProd.ColumnType(3)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products ColumnType(4) [Real]",    "5", CStr(rsProd.ColumnType(4)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products ColumnType(5) [String]",  "5", CStr(rsProd.ColumnType(5)), iPass, iFail) + EndOfLine
		      strReport = strReport + EndOfLine
		      
		      ' ── Group 16: products — JSON Mode Data ──────────────────────────────
		      strReport = strReport + "[ Group 16: products — JSON Mode Data ]" + EndOfLine
		      
		      strReport = strReport + TestCheck("products first id",            "1",                              CStr(rsProd.DbField(1)),                          iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products first name",          "Xojo Desktop (Single Platform)", CStr(rsProd.DbField(2)),                          iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products first category",      "License",                        CStr(rsProd.DbField(3)),                          iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products price DoubleValue=99","True", CStr(rsProd.Field("price").DoubleValue = 99.0),                             iPass, iFail) + EndOfLine
		      rsProd.MoveLast
		      strReport = strReport + TestCheck("products last id",             "10",                 CStr(rsProd.DbField(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("products last name",           "Annual Support Plan",CStr(rsProd.DbField(2)), iPass, iFail) + EndOfLine
		      rsProd.Close
		      strReport = strReport + EndOfLine
		    End If
		    
		    ' ── Group 17: JOIN — sessions × tracks × speakers ───────────────────────
		    strReport = strReport + "[ Group 17: JOIN — sessions x tracks x speakers ]" + EndOfLine
		    
		    Var strSQLJoin As String = "SELECT sessions.id, sessions.title, tracks.name AS track_name, speakers.name AS speaker_name FROM sessions JOIN tracks ON sessions.track_id = tracks.id JOIN speakers ON sessions.speaker_id = speakers.id ORDER BY sessions.id ASC"
		    Var rsJoin As UseRecordSet = dbMain.SQLSelect(strSQLJoin)
		    
		    If IsNull(rsJoin) Then
		      strReport = strReport + "[ABRT] Could not open JOIN recordset — Group 17 aborted." + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("JOIN RecordCount",        "12",                      CStr(rsJoin.RecordCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN FieldCount",         "4",                       CStr(rsJoin.FieldCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN DbFieldName(1)",     "id",                      rsJoin.DbFieldName(1),    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN DbFieldName(2)",     "title",                   rsJoin.DbFieldName(2),    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN DbFieldName(3)",     "track_name",              rsJoin.DbFieldName(3),    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN DbFieldName(4)",     "speaker_name",            rsJoin.DbFieldName(4),    iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN first id",           "1",                       CStr(rsJoin.DbField(1)),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN first title",        "What's New in Xojo 2026", CStr(rsJoin.DbField(2)),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN first track_name",   "Best Practices",          CStr(rsJoin.DbField(3)),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN first speaker_name", "James Morrison",          CStr(rsJoin.DbField(4)),  iPass, iFail) + EndOfLine
		      
		      Var iJoinCount As Integer = 0
		      Var strJoinLastTitle As String = ""
		      While Not rsJoin.EOF
		        iJoinCount = iJoinCount + 1
		        strJoinLastTitle = CStr(rsJoin.DbField(2))
		        rsJoin.MoveNext
		      Wend
		      strReport = strReport + TestCheck("JOIN traversal count",   "12",                                       CStr(iJoinCount),     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JOIN last title",        "The Future of Cross-Platform Development", strJoinLastTitle,     iPass, iFail) + EndOfLine
		      rsJoin.Close
		      strReport = strReport + EndOfLine
		    End If
		    
		    ' ── Group 20: UsePreparedStatement — multi-parameter ? markers ──────────
		    strReport = strReport + "[ Group 20: UsePreparedStatement — multi-parameter ? markers ]" + EndOfLine
		    
		    Var psMultiQ As UsePreparedStatement = dbMain.Prepare("SELECT * FROM tracks WHERE id >= ? AND id <= ?")
		    psMultiQ.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		    psMultiQ.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		    psMultiQ.Bind(0, 2)
		    psMultiQ.Bind(1, 4)
		    Var rsMultiQ As UseRecordSet = psMultiQ.SQLSelect
		    If IsNull(rsMultiQ) Then
		      strReport = strReport + "[ABRT] Multi-param ? SELECT returned Nil: " + dbMain.ErrorMessage + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("Multi-? RecordCount=3",  "3", CStr(rsMultiQ.RecordCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Multi-? first id=2",     "2", CStr(rsMultiQ.DbField(1)),  iPass, iFail) + EndOfLine
		      rsMultiQ.MoveLast
		      strReport = strReport + TestCheck("Multi-? last id=4",      "4", CStr(rsMultiQ.DbField(1)),  iPass, iFail) + EndOfLine
		      rsMultiQ.Close
		    End If
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 21: UsePreparedStatement — multi-parameter $N markers ─────────
		    strReport = strReport + "[ Group 21: UsePreparedStatement — multi-parameter $N markers ]" + EndOfLine
		    
		    Var psMultiDollar As UsePreparedStatement = dbMain.Prepare("SELECT * FROM tracks WHERE id >= $1 AND id <= $2")
		    psMultiDollar.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		    psMultiDollar.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		    psMultiDollar.Bind(0, 2)
		    psMultiDollar.Bind(1, 4)
		    Var rsMultiDollar As UseRecordSet = psMultiDollar.SQLSelect
		    If IsNull(rsMultiDollar) Then
		      strReport = strReport + "[ABRT] Multi-param $N SELECT returned Nil: " + dbMain.ErrorMessage + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("Multi-$N RecordCount=3", "3", CStr(rsMultiDollar.RecordCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Multi-$N first id=2",    "2", CStr(rsMultiDollar.DbField(1)),  iPass, iFail) + EndOfLine
		      rsMultiDollar.MoveLast
		      strReport = strReport + TestCheck("Multi-$N last id=4",     "4", CStr(rsMultiDollar.DbField(1)),  iPass, iFail) + EndOfLine
		      rsMultiDollar.Close
		    End If
		    strReport = strReport + EndOfLine
		    
		    ' ── Group 22: UsePreparedStatement — UPDATE via SQLExecute ───────────────
		    strReport = strReport + "[ Group 22: UsePreparedStatement — UPDATE via SQLExecute ]" + EndOfLine
		    strReport = strReport + "  Note: Inserts id=7, updates via PreparedStatement, then deletes to restore." + EndOfLine
		    
		    dbMain.SQLExecute("DELETE FROM tracks WHERE id=7")
		    dbMain.SQLExecute("INSERT INTO tracks VALUES(7,'Before Update')")
		    Var psUpdate As UsePreparedStatement = dbMain.Prepare("UPDATE tracks SET name = $1 WHERE id = $2")
		    psUpdate.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		    psUpdate.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		    psUpdate.Bind(0, "After Update")
		    psUpdate.Bind(1, 7)
		    psUpdate.SQLExecute
		    strReport = strReport + TestCheck("PreparedStatement UPDATE: db.Error=False",   "False",        CStr(dbMain.Error),              iPass, iFail) + EndOfLine
		    Var rsAfterUpdate As UseRecordSet = dbMain.SQLSelect("SELECT * FROM tracks WHERE id=7")
		    strReport = strReport + TestCheck("PreparedStatement UPDATE: name changed",     "After Update", CStr(rsAfterUpdate.DbField(2)),  iPass, iFail) + EndOfLine
		    rsAfterUpdate.Close
		    dbMain.SQLExecute("DELETE FROM tracks WHERE id=7")
		    Var rsUpdateClean As UseRecordSet = dbMain.SQLSelect("SELECT * FROM tracks ORDER BY id ASC")
		    strReport = strReport + TestCheck("PreparedStatement UPDATE cleanup: RecordCount=6", "6",       CStr(rsUpdateClean.RecordCount), iPass, iFail) + EndOfLine
		    rsUpdateClean.Close
		    strReport = strReport + EndOfLine
		    
		    ' ── Summary ───────────────────────────────────────────────────────────
		    strReport = strReport + EndOfLine
		    strReport = strReport + "[ Summary ]" + EndOfLine
		    strReport = strReport + "Passed : " + CStr(iPass) + " / " + CStr(iPass + iFail) + EndOfLine
		    strReport = strReport + "Failed : " + CStr(iFail) + " / " + CStr(iPass + iFail) + EndOfLine
		    If iFail = 0 Then
		      strReport = strReport + "Result : ALL TESTS PASSED" + EndOfLine
		    Else
		      strReport = strReport + "Result : " + CStr(iFail) + " TEST(S) FAILED" + EndOfLine
		    End If
		    
		    SaveTestReport(strReport, iPass, iFail)
		    
		  Catch err As RuntimeException
		    strReport = strReport + EndOfLine
		    strReport = strReport + "[CRASH] " + err.Message + EndOfLine
		    SaveTestReport(strReport, iPass, iFail + 1)
		  End Try
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnDemoTest
	#tag Event
		Sub Pressed()
		  // ── slide 6: UseDatabase — Connect ────────────────────────────────────────
		  Var db As New UseDatabase
		  if not db.Connect() Then
		    MsgBox "Connect failed: " + db.ErrorMessage
		    Return
		  end if
		  Var ur As UseRecordSet
		  var id As Integer
		  var name As String
		  // ── slide 7: UseDatabase — Querying ───────────────────────────────────────
		  //get a json recordset
		  ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil and ur.eof = false then
		    while not ur.eof
		      id = ur.IdxField(1).IntegerValue
		      name = ur.Field("name").StringValue
		      ur.MoveNext
		    wend
		    ur.Close
		  end if
		  ur = nil
		  //SQLSelectDB: in-memory SQLite with accurate column types (both modes support bidirectional nav)
		  ur = db.SQLSelectDB("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil and ur.eof = false then
		    ur.MoveLast
		    while not ur.bof
		      id = ur.IdxField(1).IntegerValue
		      name = ur.Field("name").StringValue
		      ur.MovePrevious
		    wend
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 7 cont.: SQLExecute ────────────────────────────────────────────
		  var strSQL As String
		  //insert a record through sql
		  strSQL = "INSERT INTO tracks VALUES(7,'Adding Tests')"
		  db.SQLExecute(strSQL)
		  If db.Error Then
		    MsgBox "INSERT failed: " + db.ErrorMessage
		  End If
		  ur = db.SQLSelect("SELECT * FROM tracks WHERE id=7;")
		  if ur <> nil and ur.eof = false then
		    id = ur.IdxField(1).IntegerValue
		    name = ur.Field("name").StringValue
		    ur.Close
		  end if
		  ur = nil
		  //delete a record through sql
		  strSQL = "DELETE FROM tracks WHERE id=7;"
		  db.SQLExecute(strSQL)
		  If db.Error Then
		    MsgBox "DELETE failed: " + db.ErrorMessage
		  End If
		  ur = db.SQLSelect("SELECT * FROM tracks WHERE id=7;")
		  if ur <> nil and ur.eof = false then
		    id = ur.IdxField(1).IntegerValue
		    name = ur.Field("name").StringValue
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 8: UseDatabase — Writing & Error Handling ───────────────────────
		  // InsertRecord: builds INSERT from a UseDatabaseRecord
		  var rec As New UseDatabaseRecord
		  rec.Column("name") = "Adding Tests"
		  rec.IntegerColumn("id") = 7
		  db.InsertRecord("tracks", rec)
		  If db.Error Then
		    MsgBox "InsertRecord failed: " + db.ErrorMessage
		  End If
		  // Prepare: brief intro — full PreparedStatement demo is on slide 14
		  var psIntro As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		  psIntro.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		  psIntro.Bind(0, 7)
		  ur = psIntro.SQLSelect
		  if ur <> nil and ur.eof = false then
		    name = ur.Field("name").StringValue   // "Adding Tests"
		    ur.Close
		  end if
		  ur = nil
		  // db.Error / db.ErrorMessage
		  db.SQLExecute("SELECT * FROM track WHERE id = 7")   //Error is True
		  var bErr As Boolean = db.Error           // False
		  var strErr As String = db.ErrorMessage   // ""
		  db.SQLExecute("DELETE FROM tracks WHERE id=7")   // clean up
		  strErr =  ""
		  // ── slide 9: UseRecordSet — Navigation ────────────────────────────────────
		  ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil then
		    ur.MoveLast
		    id = ur.IdxField(1).IntegerValue   // 6
		    ur.MoveFirst
		    id = ur.IdxField(1).IntegerValue   // 1
		    var bBof As Boolean = ur.bof       // False
		    ur.MovePrevious
		    bBof = ur.bof                      // True
		    ur.MoveNext
		    id = ur.IdxField(1).IntegerValue   // 1 — back at first record
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 10: UseRecordSet — Reading Field Values ─────────────────────────
		  ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil then
		    var recordCount As Integer = ur.RecordCount     // 6
		    var fieldCount As Integer = ur.FieldCount       // 2
		    var fieldName1 As String = ur.DbFieldName(1)   // "id"
		    ur.Close
		  end if
		  ur = nil
		  ur = db.SQLSelect("SELECT * FROM products ORDER BY id ASC;")
		  if ur <> nil and ur.eof = false then
		    var fldName As String = ur.Field("name").Name           // "name"
		    var fldNameByColumnNumber As String = ur.IdxField(2).Name
		    var strVal As String = ur.Field("name").StringValue     // "Xojo Desktop (Single Platform)"
		    var intVal As Integer = ur.Field("id").IntegerValue     // 1
		    var dblVal As Double = ur.Field("price").DoubleValue    // 99.0
		    var natVal As Variant = ur.Field("id").NativeValue      // "1"
		    var gsVal As String = ur.Field("name").GetString        // "Xojo Desktop (Single Platform)"
		    var isNil As Boolean = (ur.Field("id").Value Is Nil)    // False
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 11: UseRecordSet — Edit, Update & Delete ────────────────────────
		  db.SQLExecute("DELETE FROM tracks WHERE id=8")   // clean up any leftover
		  db.SQLExecute("INSERT INTO tracks VALUES(8,'Demo Track')")
		  ur = db.SQLSelect("SELECT * FROM tracks WHERE id=8;")
		  if ur <> nil and ur.eof = false then
		    ur.Edit
		    ur.Field("name").Value = "Updated Demo Track"
		    ur.Update
		    ur.Close
		  end if
		  ur = nil
		  ur = db.SQLSelect("SELECT * FROM tracks WHERE id=8;")
		  if ur <> nil and ur.eof = false then
		    name = ur.Field("name").StringValue   // "Updated Demo Track"
		    ur.DeleteRecord
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 12: JSON & SQLite Mode — Bidirectional Navigation ───────────────
		  ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil then
		    // navigate backward — start at last record
		    ur.MoveLast
		    while not ur.bof
		      id = ur.IdxField(1).IntegerValue
		      name = ur.Field("name").StringValue
		      ur.MovePrevious
		    wend
		    // ── slide 13: cont. — navigate forward back to start ───────────────────
		    ur.MoveFirst
		    while not ur.eof
		      id = ur.IdxField(1).IntegerValue
		      name = ur.Field("name").StringValue
		      ur.MoveNext
		    wend
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 14: SQLite Mode — accurate ColumnType values ────────────────────
		  ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil then
		    var colTypeJSON As Integer = ur.ColumnType(1)   // 5 (String — JSON mode always returns 5)
		    ur.Close
		  end if
		  ur = nil
		  ur = db.SQLSelectDB("SELECT * FROM tracks ORDER BY id ASC;")
		  if ur <> nil then
		    var colTypeDB As Integer = ur.ColumnType(1)     // 4 (Integer — SQLite mode returns real types)
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 15: UsePreparedStatement — ? markers ────────────────────────────
		  var ps As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		  ps.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		  ps.Bind(0, 3)
		  ur = ps.SQLSelect
		  if ur <> nil and ur.eof = false then
		    name = ur.Field("name").StringValue   // track with id=3
		    ur.Close
		  end if
		  ur = nil
		  // ── slide 16: UsePreparedStatement — $N markers ────────────────────────────
		  var ps2 As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id >= $1 AND id <= $2")
		  ps2.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		  ps2.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		  ps2.Bind(0, 2)
		  ps2.Bind(1, 4)
		  ur = ps2.SQLSelect
		  while ur <> nil and not ur.eof
		    id = ur.IdxField(1).IntegerValue      // 2, 3, 4
		    name = ur.Field("name").StringValue
		    ur.MoveNext
		  wend
		  if ur <> nil then ur.Close
		  ur = nil
		  // ── slide 17: UsePreparedStatement — SQLExecute ────────────────────────────
		  db.SQLExecute("DELETE FROM tracks WHERE id=9")   // clean up any leftover
		  db.SQLExecute("INSERT INTO tracks VALUES(9,'Prep Demo')")
		  var ps3 As UsePreparedStatement = db.Prepare("UPDATE tracks SET name = $1 WHERE id = $2")
		  ps3.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		  ps3.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		  ps3.Bind(0, "Updated via PreparedStatement")
		  ps3.Bind(1, 9)
		  ps3.SQLExecute
		  if db.Error then
		    MsgBox "Update failed: " + db.ErrorMessage
		  end if
		  db.SQLExecute("DELETE FROM tracks WHERE id=9")   // clean up
		  // ── slide 18: IDatabase Interface ─────────────────────────────────────────
		  var dbIface As IDatabase = New UseDatabase
		  if dbIface.Connect then
		    ur = dbIface.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    if ur <> nil and ur.eof = false then
		      id = ur.IdxField(1).IntegerValue
		      name = ur.Field("name").StringValue
		      ur.Close
		    end if
		    ur = nil
		    dbIface.Close
		  end if
		  db.Close
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events btnAutoDemoTest
	#tag Event
		Sub Pressed()
		  Var iPass As Integer = 0
		  Var iFail As Integer = 0
		  Var strReport As String
		  Var dtNow As New Date
		  strReport = "Auto Demo Test Report" + EndOfLine
		  strReport = strReport + "=====================" + EndOfLine
		  strReport = strReport + "Date: " + dtNow.ShortDate + " " + dtNow.ShortTime + EndOfLine
		  strReport = strReport + EndOfLine

		  Try

		    // ── slide 6: UseDatabase — Connect ──────────────────────────────────────
		    strReport = strReport + "[ Slide 6: Connect ]" + EndOfLine
		    Var db As New UseDatabase
		    If Not db.Connect() Then
		      strReport = strReport + "[ABRT] Connect failed: " + db.ErrorMessage + EndOfLine
		      SaveTestReport(strReport, iPass, iFail + 1)
		      Return
		    End If
		    strReport = strReport + TestCheck("Connected=True",           "True",  CStr(db.Connected), iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("Error=False after Connect","False", CStr(db.Error),     iPass, iFail) + EndOfLine
		    strReport = strReport + EndOfLine

		    Var ur As UseRecordSet
		    Var id As Integer
		    Var name As String

		    // ── slide 7: UseDatabase — Querying (JSON SQLSelect, forward) ────────────
		    strReport = strReport + "[ Slide 7: SQLSelect — JSON mode ]" + EndOfLine
		    ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur = Nil Then
		      strReport = strReport + "[ABRT] SQLSelect returned Nil: " + db.ErrorMessage + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("SQLSelect RecordCount=6",           "6",       CStr(ur.RecordCount),              iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelect first id=1",              "1",       CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelect first name=Desktop",      "Desktop", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		      Var iJsonFwdCount As Integer = 0
		      Var strJsonLastId As String = ""
		      Var strJsonLastName As String = ""
		      While Not ur.EOF
		        iJsonFwdCount = iJsonFwdCount + 1
		        strJsonLastId   = CStr(ur.IdxField(1).IntegerValue)
		        strJsonLastName = ur.Field("name").StringValue
		        ur.MoveNext
		      Wend
		      strReport = strReport + TestCheck("SQLSelect forward count=6",         "6",              CStr(iJsonFwdCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelect last id=6",               "6",              strJsonLastId,       iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelect last name=Best Practices","Best Practices", strJsonLastName,     iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil

		    // ── slide 7: SQLSelectDB — backward traversal ────────────────────────────
		    strReport = strReport + "[ Slide 7: SQLSelectDB — backward traversal ]" + EndOfLine
		    ur = db.SQLSelectDB("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur = Nil Then
		      strReport = strReport + "[ABRT] SQLSelectDB returned Nil: " + db.ErrorMessage + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("SQLSelectDB RecordCount=6",         "6",              CStr(ur.RecordCount),              iPass, iFail) + EndOfLine
		      ur.MoveLast
		      strReport = strReport + TestCheck("SQLSelectDB MoveLast id=6",         "6",              CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelectDB MoveLast name",         "Best Practices", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		      Var iDBBwdCount As Integer = 0
		      Var strDBBwdLastId As String = ""
		      While Not ur.BOF
		        iDBBwdCount = iDBBwdCount + 1
		        strDBBwdLastId = CStr(ur.IdxField(1).IntegerValue)
		        ur.MovePrevious
		      Wend
		      strReport = strReport + TestCheck("SQLSelectDB backward count=6",      "6",    CStr(iDBBwdCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelectDB BOF=True at end",       "True", CStr(ur.BOF),      iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLSelectDB last id visited=1",     "1",    strDBBwdLastId,    iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 7 cont.: SQLExecute — INSERT then DELETE ───────────────────────
		    strReport = strReport + "[ Slide 7 cont.: SQLExecute ]" + EndOfLine
		    db.SQLExecute("DELETE FROM tracks WHERE id=7")  // ensure clean state
		    db.SQLExecute("INSERT INTO tracks VALUES(7,'Adding Tests')")
		    strReport = strReport + TestCheck("SQLExecute INSERT: no error",         "False", CStr(db.Error), iPass, iFail) + EndOfLine
		    Var urIns As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=7;")
		    If urIns = Nil Or urIns.EOF Then
		      strReport = strReport + "[FAIL] INSERT id=7: row not found" + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("INSERT: id=7",                      "7",            CStr(urIns.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("INSERT: name=Adding Tests",         "Adding Tests", urIns.Field("name").StringValue,       iPass, iFail) + EndOfLine
		      urIns.Close
		    End If
		    db.SQLExecute("DELETE FROM tracks WHERE id=7;")
		    strReport = strReport + TestCheck("SQLExecute DELETE: no error",         "False", CStr(db.Error), iPass, iFail) + EndOfLine
		    Var urDel As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=7;")
		    If urDel <> Nil Then
		      strReport = strReport + TestCheck("DELETE: row gone (EOF=True)",       "True", CStr(urDel.EOF), iPass, iFail) + EndOfLine
		      urDel.Close
		    End If
		    strReport = strReport + EndOfLine

		    // ── slide 8: InsertRecord + Prepare + db.Error ──────────────────────────
		    strReport = strReport + "[ Slide 8: InsertRecord + Prepare + db.Error ]" + EndOfLine
		    Var rec As New UseDatabaseRecord
		    rec.Column("name") = "Adding Tests"
		    rec.IntegerColumn("id") = 7
		    db.InsertRecord("tracks", rec)
		    strReport = strReport + TestCheck("InsertRecord: no error",              "False", CStr(db.Error), iPass, iFail) + EndOfLine
		    Var psIntro As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		    psIntro.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		    psIntro.Bind(0, 7)
		    ur = psIntro.SQLSelect
		    If ur = Nil Or ur.EOF Then
		      strReport = strReport + "[FAIL] Prepare intro SELECT: Nil or empty" + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("Prepare intro: name=Adding Tests",  "Adding Tests", ur.Field("name").StringValue, iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    // Intentional bad table name to trigger db.Error
		    db.SQLExecute("SELECT * FROM track WHERE id = 7")  // "track" does not exist
		    strReport = strReport + TestCheck("db.Error=True after bad SQL",         "True", CStr(db.Error),               iPass, iFail) + EndOfLine
		    strReport = strReport + TestCheck("db.ErrorMessage not empty",           "True", CStr(db.ErrorMessage <> ""),  iPass, iFail) + EndOfLine
		    db.SQLExecute("DELETE FROM tracks WHERE id=7")  // clean up
		    strReport = strReport + EndOfLine

		    // ── slide 9: UseRecordSet — Navigation ──────────────────────────────────
		    strReport = strReport + "[ Slide 9: Navigation ]" + EndOfLine
		    ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur = Nil Then
		      strReport = strReport + "[ABRT] SQLSelect returned Nil — slide 9 skipped" + EndOfLine
		      iFail = iFail + 1
		    Else
		      ur.MoveLast
		      strReport = strReport + TestCheck("MoveLast id=6",                     "6",     CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      ur.MoveFirst
		      strReport = strReport + TestCheck("MoveFirst id=1",                    "1",     CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("BOF=False after MoveFirst",         "False", CStr(ur.BOF),                      iPass, iFail) + EndOfLine
		      ur.MovePrevious
		      strReport = strReport + TestCheck("BOF=True after MovePrev past first","True",  CStr(ur.BOF),                      iPass, iFail) + EndOfLine
		      ur.MoveNext
		      strReport = strReport + TestCheck("MoveNext from BOF → id=1",          "1",     CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 10: UseRecordSet — Reading Field Values ────────────────────────
		    strReport = strReport + "[ Slide 10: Reading Field Values ]" + EndOfLine
		    ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur <> Nil Then
		      strReport = strReport + TestCheck("tracks RecordCount=6",              "6",  CStr(ur.RecordCount), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("tracks FieldCount=2",               "2",  CStr(ur.FieldCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("tracks DbFieldName(1)=id",          "id", ur.DbFieldName(1),    iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    ur = db.SQLSelect("SELECT * FROM products ORDER BY id ASC;")
		    If ur <> Nil And Not ur.EOF Then
		      strReport = strReport + TestCheck("Field(name).Name=name",             "name",                           ur.Field("name").Name,             iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("IdxField(2).Name=name",             "name",                           ur.IdxField(2).Name,               iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(name).StringValue",           "Xojo Desktop (Single Platform)", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(id).IntegerValue=1",          "1",                              CStr(ur.Field("id").IntegerValue),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(price).DoubleValue=99.0",     "True",                           CStr(ur.Field("price").DoubleValue = 99.0), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(id).NativeValue=1",           "1",                              CStr(ur.Field("id").NativeValue),   iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(name).GetString",             "Xojo Desktop (Single Platform)", ur.Field("name").GetString,        iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Field(id).Value Is Nil=False",      "False",                          CStr(ur.Field("id").Value Is Nil),  iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 11: UseRecordSet — Edit, Update & Delete ───────────────────────
		    strReport = strReport + "[ Slide 11: Edit, Update & Delete ]" + EndOfLine
		    db.SQLExecute("DELETE FROM tracks WHERE id=8")
		    db.SQLExecute("INSERT INTO tracks VALUES(8,'Demo Track')")
		    ur = db.SQLSelect("SELECT * FROM tracks WHERE id=8;")
		    If ur = Nil Or ur.EOF Then
		      strReport = strReport + "[ABRT] INSERT id=8 failed — slide 11 skipped" + EndOfLine
		      iFail = iFail + 1
		    Else
		      ur.Edit
		      ur.Field("name").Value = "Updated Demo Track"
		      ur.Update
		      ur.Close
		      Var urPostEdit As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=8;")
		      If urPostEdit <> Nil And Not urPostEdit.EOF Then
		        strReport = strReport + TestCheck("Edit+Update: name changed",        "Updated Demo Track", urPostEdit.Field("name").StringValue, iPass, iFail) + EndOfLine
		        urPostEdit.DeleteRecord
		        urPostEdit.Close
		      End If
		      Var urPostDel As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=8;")
		      If urPostDel <> Nil Then
		        strReport = strReport + TestCheck("DeleteRecord: row gone (EOF=True)", "True", CStr(urPostDel.EOF), iPass, iFail) + EndOfLine
		        urPostDel.Close
		      End If
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 12: Bidirectional — backward (JSON) ────────────────────────────
		    strReport = strReport + "[ Slide 12: Bidirectional — backward (JSON) ]" + EndOfLine
		    ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur = Nil Then
		      strReport = strReport + "[ABRT] SQLSelect returned Nil — slides 12/13 skipped" + EndOfLine
		      iFail = iFail + 1
		    Else
		      ur.MoveLast
		      strReport = strReport + TestCheck("MoveLast id=6",                     "6",              CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("MoveLast name=Best Practices",      "Best Practices", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		      Var iBwdCount As Integer = 0
		      Var strBwdLastId As String = ""
		      While Not ur.BOF
		        iBwdCount = iBwdCount + 1
		        strBwdLastId = CStr(ur.IdxField(1).IntegerValue)
		        ur.MovePrevious
		      Wend
		      strReport = strReport + TestCheck("Backward count=6",                  "6",    CStr(iBwdCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("BOF=True after backward",           "True", CStr(ur.BOF),     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Last id visited backward=1",        "1",    strBwdLastId,     iPass, iFail) + EndOfLine

		      // ── slide 13: forward back to start ────────────────────────────────────
		      strReport = strReport + "[ Slide 13: Bidirectional — forward (JSON) ]" + EndOfLine
		      ur.MoveFirst
		      Var iFwdCount As Integer = 0
		      Var strFwdLastId As String = ""
		      Var strFwdLastName As String = ""
		      While Not ur.EOF
		        iFwdCount = iFwdCount + 1
		        strFwdLastId   = CStr(ur.IdxField(1).IntegerValue)
		        strFwdLastName = ur.Field("name").StringValue
		        ur.MoveNext
		      Wend
		      strReport = strReport + TestCheck("Forward count=6",                   "6",              CStr(iFwdCount),  iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Forward last id=6",                 "6",              strFwdLastId,     iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Forward last name=Best Practices",  "Best Practices", strFwdLastName,   iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 14: ColumnType ─────────────────────────────────────────────────
		    strReport = strReport + "[ Slide 14: ColumnType ]" + EndOfLine
		    ur = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur <> Nil Then
		      strReport = strReport + TestCheck("JSON ColumnType(1)=5 (always String)","5", CStr(ur.ColumnType(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("JSON ColumnType(2)=5 (always String)","5", CStr(ur.ColumnType(2)), iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    ur = db.SQLSelectDB("SELECT * FROM tracks ORDER BY id ASC;")
		    If ur <> Nil Then
		      strReport = strReport + TestCheck("SQLite ColumnType(1)=4 (Integer)",   "4", CStr(ur.ColumnType(1)), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("SQLite ColumnType(2)=5 (String)",    "5", CStr(ur.ColumnType(2)), iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 15: PreparedStatement — ? markers ──────────────────────────────
		    strReport = strReport + "[ Slide 15: PreparedStatement — ? markers ]" + EndOfLine
		    Var ps As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id = ?")
		    ps.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		    ps.Bind(0, 3)
		    ur = ps.SQLSelect
		    If ur = Nil Or ur.EOF Then
		      strReport = strReport + "[FAIL] Prepare ? SELECT: Nil or empty" + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("Prepare ?: RecordCount=1",           "1",            CStr(ur.RecordCount),              iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Prepare ?: id=3",                    "3",            CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Prepare ?: name=Mobile & iOS",       "Mobile & iOS", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 16: PreparedStatement — $N markers ─────────────────────────────
		    strReport = strReport + "[ Slide 16: PreparedStatement — $N markers ]" + EndOfLine
		    Var ps2 As UsePreparedStatement = db.Prepare("SELECT * FROM tracks WHERE id >= $1 AND id <= $2")
		    ps2.BindType(0, UsePreparedStatement.SQLITE_INTEGER)
		    ps2.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		    ps2.Bind(0, 2)
		    ps2.Bind(1, 4)
		    ur = ps2.SQLSelect
		    If ur = Nil Or ur.EOF Then
		      strReport = strReport + "[FAIL] Prepare $N SELECT: Nil or empty" + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("Prepare $N: RecordCount=3",          "3", CStr(ur.RecordCount),              iPass, iFail) + EndOfLine
		      strReport = strReport + TestCheck("Prepare $N: first id=2",             "2", CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      ur.MoveLast
		      strReport = strReport + TestCheck("Prepare $N: last id=4",              "4", CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		      ur.Close
		    End If
		    ur = Nil
		    strReport = strReport + EndOfLine

		    // ── slide 17: PreparedStatement — SQLExecute ─────────────────────────────
		    strReport = strReport + "[ Slide 17: PreparedStatement — SQLExecute ]" + EndOfLine
		    db.SQLExecute("DELETE FROM tracks WHERE id=9")
		    db.SQLExecute("INSERT INTO tracks VALUES(9,'Prep Demo')")
		    Var ps3 As UsePreparedStatement = db.Prepare("UPDATE tracks SET name = $1 WHERE id = $2")
		    ps3.BindType(0, UsePreparedStatement.SQLITE_TEXT)
		    ps3.BindType(1, UsePreparedStatement.SQLITE_INTEGER)
		    ps3.Bind(0, "Updated via PreparedStatement")
		    ps3.Bind(1, 9)
		    ps3.SQLExecute
		    strReport = strReport + TestCheck("PS SQLExecute UPDATE: no error",       "False", CStr(db.Error), iPass, iFail) + EndOfLine
		    Var urAfterPS As UseRecordSet = db.SQLSelect("SELECT * FROM tracks WHERE id=9;")
		    If urAfterPS = Nil Or urAfterPS.EOF Then
		      strReport = strReport + "[FAIL] PS UPDATE: row not found after update" + EndOfLine
		      iFail = iFail + 1
		    Else
		      strReport = strReport + TestCheck("PS SQLExecute UPDATE: name changed",  "Updated via PreparedStatement", urAfterPS.Field("name").StringValue, iPass, iFail) + EndOfLine
		      urAfterPS.Close
		    End If
		    db.SQLExecute("DELETE FROM tracks WHERE id=9")  // clean up
		    Var urPSClean As UseRecordSet = db.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		    If urPSClean <> Nil Then
		      strReport = strReport + TestCheck("PS cleanup: RecordCount=6",          "6", CStr(urPSClean.RecordCount), iPass, iFail) + EndOfLine
		      urPSClean.Close
		    End If
		    strReport = strReport + EndOfLine

		    // ── slide 18: IDatabase Interface ────────────────────────────────────────
		    strReport = strReport + "[ Slide 18: IDatabase Interface ]" + EndOfLine
		    Var dbIface As IDatabase = New UseDatabase
		    If Not dbIface.Connect Then
		      strReport = strReport + "[ABRT] IDatabase.Connect failed" + EndOfLine
		      iFail = iFail + 1
		    Else
		      ur = dbIface.SQLSelect("SELECT * FROM tracks ORDER BY id ASC;")
		      If ur = Nil Or ur.EOF Then
		        strReport = strReport + "[FAIL] IDatabase.SQLSelect: Nil or empty" + EndOfLine
		        iFail = iFail + 1
		      Else
		        strReport = strReport + TestCheck("IDatabase RecordCount=6",          "6",       CStr(ur.RecordCount),              iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("IDatabase first id=1",             "1",       CStr(ur.IdxField(1).IntegerValue), iPass, iFail) + EndOfLine
		        strReport = strReport + TestCheck("IDatabase first name=Desktop",     "Desktop", ur.Field("name").StringValue,      iPass, iFail) + EndOfLine
		        ur.Close
		      End If
		      ur = Nil
		      dbIface.Close
		    End If
		    strReport = strReport + EndOfLine

		    db.Close

		    // ── Summary ──────────────────────────────────────────────────────────────
		    strReport = strReport + "[ Summary ]" + EndOfLine
		    strReport = strReport + "Passed : " + CStr(iPass) + " / " + CStr(iPass + iFail) + EndOfLine
		    strReport = strReport + "Failed : " + CStr(iFail) + " / " + CStr(iPass + iFail) + EndOfLine
		    If iFail = 0 Then
		      strReport = strReport + "Result : ALL DEMO CHECKS PASSED" + EndOfLine
		    Else
		      strReport = strReport + "Result : " + CStr(iFail) + " DEMO CHECK(S) FAILED" + EndOfLine
		    End If

		    SaveTestReport(strReport, iPass, iFail)

		  Catch err As RuntimeException
		    strReport = strReport + EndOfLine
		    strReport = strReport + "[CRASH] " + err.Message + EndOfLine
		    SaveTestReport(strReport, iPass, iFail + 1)
		  End Try
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Interfaces"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="600"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="400"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumWidth"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MinimumHeight"
		Visible=true
		Group="Size"
		InitialValue="64"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumWidth"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MaximumHeight"
		Visible=true
		Group="Size"
		InitialValue="32000"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Type"
		Visible=true
		Group="Frame"
		InitialValue="0"
		Type="Types"
		EditorType="Enum"
		#tag EnumValues
			"0 - Document"
			"1 - Movable Modal"
			"2 - Modal Dialog"
			"3 - Floating Window"
			"4 - Plain Box"
			"5 - Shadowed Box"
			"6 - Rounded Window"
			"7 - Global Floating Window"
			"8 - Sheet Window"
			"9 - Modeless Dialog"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Title"
		Visible=true
		Group="Frame"
		InitialValue="Untitled"
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasCloseButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMaximizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasMinimizeButton"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasFullScreenButton"
		Visible=true
		Group="Frame"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Resizeable"
		Visible=true
		Group="Frame"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composite"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MacProcID"
		Visible=false
		Group="OS X (Carbon)"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="FullScreen"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="DefaultLocation"
		Visible=true
		Group="Behavior"
		InitialValue="2"
		Type="Locations"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Parent Window"
			"2 - Main Screen"
			"3 - Parent Window Screen"
			"4 - Stagger"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="ImplicitInstance"
		Visible=true
		Group="Window Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=true
		Group="Background"
		InitialValue="&cFFFFFF"
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=true
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBar"
		Visible=true
		Group="Menus"
		InitialValue=""
		Type="DesktopMenuBar"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="MenuBarVisible"
		Visible=true
		Group="Deprecated"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
