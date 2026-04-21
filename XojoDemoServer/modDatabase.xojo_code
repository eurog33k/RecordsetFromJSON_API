#tag Module
Protected Module modDatabase
	#tag Method, Flags = &h21
		Private Sub CreateSchema()
		  ' Drop existing tables so the database is always reset to a known state on startup.
		  ' Sessions is dropped first because it references tracks and speakers.
		  m_db.ExecuteSQL("DROP TABLE IF EXISTS sessions")
		  m_db.ExecuteSQL("DROP TABLE IF EXISTS products")
		  m_db.ExecuteSQL("DROP TABLE IF EXISTS speakers")
		  m_db.ExecuteSQL("DROP TABLE IF EXISTS tracks")
		  m_db.ExecuteSQL("CREATE TABLE tracks (id INTEGER PRIMARY KEY, name TEXT NOT NULL)")
		  m_db.ExecuteSQL("CREATE TABLE speakers (id INTEGER PRIMARY KEY, name TEXT NOT NULL, country TEXT NOT NULL, bio TEXT NOT NULL)")
		  m_db.ExecuteSQL("CREATE TABLE sessions (id INTEGER PRIMARY KEY, title TEXT NOT NULL, speaker_id INTEGER NOT NULL, track_id INTEGER NOT NULL, day INTEGER NOT NULL, room TEXT NOT NULL, start_time TEXT NOT NULL, duration_minutes INTEGER NOT NULL)")
		  m_db.ExecuteSQL("CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT NOT NULL, category TEXT NOT NULL, price REAL NOT NULL, description TEXT NOT NULL)")
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Function GetDB() As Database
		  ' Returns the active database connection. Called by modQueryAPI to execute SQL.
		  ' Returns Nil if Initialize has not been called yet.
		  Return m_db
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1
		Protected Sub Initialize(bUsePostgres As Boolean)
		  ' Initialises the database backend. Pass True to use PostgreSQL (localhost:5432),
		  ' False for an in-memory SQLite database. Called from wndServer when the server starts.
		  m_bUsePostgres = bUsePostgres
		  If bUsePostgres Then
		    InitializePostgres
		  Else
		    InitializeSQLite
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitializePostgres()
		  ' Connects to the local PostgreSQL server (localhost:5432).
		  ' Creates the "demo" database if it does not exist, then resets the schema
		  ' and seeds all tables with fresh demo data on every startup.
		  Dim pgAdmin As New PostgreSQLDatabase
		  pgAdmin.Host = "localhost"
		  pgAdmin.Port = 5432
		  pgAdmin.DatabaseName = "postgres"
		  pgAdmin.UserName = "postgres"
		  pgAdmin.Password = "supersecretpwd"
		  Try
		    pgAdmin.Connect
		    Dim rs As RowSet = pgAdmin.SelectSQL("SELECT 1 FROM pg_database WHERE datname = 'demo'")
		    If rs.AfterLastRow Then
		      rs.Close
		      pgAdmin.ExecuteSQL("CREATE DATABASE demo")
		    Else
		      rs.Close
		    End If
		    pgAdmin.Close
		  Catch err As DatabaseException
		    MessageBox "PostgreSQL setup error: " + err.Message
		    Return
		  End Try
		  
		  ' Connect to the demo database
		  Dim pg As New PostgreSQLDatabase
		  pg.Host = "localhost"
		  pg.Port = 5432
		  pg.DatabaseName = "demo"
		  pg.UserName = "postgres"
		  pg.Password = "supersecretpwd"
		  Try
		    pg.Connect
		  Catch err As DatabaseException
		    MessageBox "PostgreSQL connection error: " + err.Message
		    Return
		  End Try
		  m_db = pg
		  CreateSchema
		  PopulateData
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub InitializeSQLite()
		  ' Creates an in-memory SQLite database, builds the schema, and seeds it with demo data.
		  ' The database is discarded when the server stops.
		  Dim db As New SQLiteDatabase
		  db.DatabaseFile = Nil
		  Try
		    db.Connect
		  Catch err As DatabaseException
		    MessageBox "SQLite error: " + err.Message
		    Return
		  End Try
		  m_db = db
		  CreateSchema
		  PopulateData
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub PopulateData()
		  ' Inserts all demo seed rows into every table.
		  ' Always called after CreateSchema, which drops and recreates all tables first,
		  ' so there is no need to check for existing data.
		  ' Tracks
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(1,'Desktop')")
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(2,'Web')")
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(3,'Mobile & iOS')")
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(4,'Database & Data')")
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(5,'API & Integration')")
		  m_db.ExecuteSQL("INSERT INTO tracks VALUES(6,'Best Practices')")
		  
		  ' Speakers
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(1,'James Morrison','USA','Xojo developer and keynote speaker with 15 years of experience building cross-platform desktop applications.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(2,'Sarah Chen','Canada','Specialises in Xojo Web and REST API development. Author of several open-source Xojo libraries.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(3,'Klaus Weber','Germany','Database performance expert and creator of multiple SQLite optimisation tools for Xojo.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(4,'Marie Dubois','France','Cross-platform desktop application specialist, known for elegant UI design in Xojo.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(5,'Carlos Mendez','Spain','Web developer who transitioned to Xojo and now builds high-traffic web applications.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(6,'Yuki Tanaka','Japan','Software quality and debugging expert, passionate about clean and maintainable Xojo code.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(7,'Emma Richardson','UK','iOS and mobile development specialist with a focus on Xojo for Apple platforms.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(8,'Luca Rossi','Italy','API integration and JSON processing expert, author of the popular XojoJSON library.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(9,'Ana Silva','Portugal','Database architect specialising in Xojo applications with complex data models.')")
		  m_db.ExecuteSQL("INSERT INTO speakers VALUES(10,'Mark Johnson','Australia','Plugin developer and Xojo community contributor, creator of several popular open-source plugins.')")
		  
		  ' Sessions (day 1)
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(1,'What''s New in Xojo 2026',1,6,1,'Main Hall','09:00',60)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(2,'Building REST APIs with Xojo',2,5,1,'Room A','10:30',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(3,'SQLite Deep Dive: Performance & Optimisation',3,4,1,'Room B','10:30',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(4,'Cross-Platform Desktop: One Codebase, Every OS',4,1,1,'Room A','14:00',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(5,'Xojo Web: From Zero to Production',5,2,1,'Room B','14:00',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(6,'Debugging Techniques That Actually Work',6,6,1,'Main Hall','16:00',60)")
		  
		  ' Sessions (day 2)
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(7,'iOS Development with Xojo',7,3,2,'Main Hall','09:00',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(8,'Working with JSON and External APIs',8,5,2,'Room A','10:30',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(9,'Database Design Patterns for Xojo Apps',9,4,2,'Room B','10:30',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(10,'Plugin Development Masterclass',10,6,2,'Room A','14:00',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(11,'Migrating from API 1.0 to API 2.0',1,6,2,'Room B','14:00',75)")
		  m_db.ExecuteSQL("INSERT INTO sessions VALUES(12,'The Future of Cross-Platform Development',2,6,2,'Main Hall','16:00',60)")
		  
		  ' Products
		  m_db.ExecuteSQL("INSERT INTO products VALUES(1,'Xojo Desktop (Single Platform)','License',99.00,'Build native desktop apps for one platform: macOS, Windows, or Linux.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(2,'Xojo Desktop (All Platforms)','License',199.00,'Build native desktop apps for macOS, Windows, and Linux with one codebase.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(3,'Xojo Web','License',299.00,'Build web applications that run in any modern browser.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(4,'Xojo iOS','License',299.00,'Build native iOS apps for iPhone and iPad.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(5,'Xojo Pro','License',599.00,'Build desktop, web, and iOS apps. Includes all platforms and targets.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(6,'Xojo Enterprise','License',1999.00,'Full Xojo Pro with team collaboration features and priority support.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(7,'XDC Early Bird Ticket','Conference',399.00,'Full access to all sessions and workshops. Available until 31 January.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(8,'XDC Regular Ticket','Conference',499.00,'Full access to all sessions and workshops at the Xojo Developer Conference.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(9,'XDC Workshop Add-on','Conference',149.00,'Hands-on workshop day. Requires a conference ticket.')")
		  m_db.ExecuteSQL("INSERT INTO products VALUES(10,'Annual Support Plan','Support',199.00,'Priority email and phone support for one year.')")
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h21
		Private m_bUsePostgres As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private m_db As Database
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
