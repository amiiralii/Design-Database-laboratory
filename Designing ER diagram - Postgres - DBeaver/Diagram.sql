CREATE TABLE "Site User"
(
 "User ID"       int NOT NULL,
 Name          char(50) NOT NULL,
 "Family name"   char(50) NOT NULL,
 Email         varchar(50) NOT NULL,
 "Profile Image" bytea NOT NULL,
 Phone         varchar(50) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( "User ID" )
);

CREATE TABLE Dashbord
(
 "Dashboard ID" int NOT NULL,
 Name         char(50) NOT NULL,
 CONSTRAINT PK_73 PRIMARY KEY ( "Dashboard ID" )
);


CREATE TABLE Project
(
 "Project ID"            int NOT NULL,
 "Theme Color"           char(50) NOT NULL,
 Title                 text NOT NULL,
 "Project Profile Photo" bytea NOT NULL,
 CONSTRAINT PK_86 PRIMARY KEY ( "Project ID" )
);


CREATE TABLE Responsibility
(
 "Resposibility ID" int NOT NULL,
 Title            text NOT NULL,
 Attachment       bytea NOT NULL,
 Discription      text NOT NULL,
 Tags             text NOT NULL,
 "Reminder time"    time NOT NULL,
 CONSTRAINT PK_112 PRIMARY KEY ( "Resposibility ID" )
);


CREATE TABLE Meeting
(
 "Meeting ID"    int NOT NULL,
 "Date and Time" time with time zone NOT NULL,
 Location      char(50) NOT NULL,
 Topic         text NOT NULL,
 Attachment    bytea NOT NULL,
 Report        text NOT NULL,
 CONSTRAINT PK_146 PRIMARY KEY ( "Meeting ID" )
);


CREATE TABLE Costumer
(
 "Costumer ID"   int NOT NULL,
 Name          char(50) NOT NULL,
 Email         char(50) NOT NULL,
 "Business Name" char(50) NOT NULL,
 "Postal Code"   varchar(50) NOT NULL,
 Fax           varchar(50) NOT NULL,
 "S-ID"          varchar(50) NOT NULL,
 "Business Code" varchar(50) NOT NULL,
 Address       text NOT NULL,
 "Phone Number"  varchar(50) NOT NULL,
 "Mobile Number" varchar(50) NOT NULL,
 Website       char(50) NOT NULL,
 CONSTRAINT PK_168 PRIMARY KEY ( "Costumer ID" )
);


CREATE TABLE Agency
(
 "Agency ID"     int NOT NULL,
 Name          char(50) NOT NULL,
 Email         char(50) NOT NULL,
 "Phone Number"  varchar(50) NOT NULL,
 "Mobile Number" varchar(50) NOT NULL,
 Post          char(50) NOT NULL,
 CONSTRAINT PK_182 PRIMARY KEY ( "Agency ID" )
);


CREATE TABLE List
(
 "List ID"     int NOT NULL,
 Name        char(50) NOT NULL,
 "Theme Color" char(50) NOT NULL,
 Template    char(50) NOT NULL,
 CONSTRAINT PK_137 PRIMARY KEY ( "List ID" )
);


CREATE TABLE Note
(
 "Note ID"     int NOT NULL,
 Title       char(50) NOT NULL,
 Content     text NOT NULL,
 "Theme Color" char(50) NOT NULL,
 Attachment  bytea NOT NULL,
 Tag         text NOT NULL,
 CONSTRAINT PK_13 PRIMARY KEY ( "Note ID" )
);

CREATE TABLE Mail
(
 "Mail ID"    int NOT NULL,
 Title      text NOT NULL,
 Content    text NOT NULL,
 Tags       text NOT NULL,
 Attachment bytea NOT NULL,
 CONSTRAINT PK_209 PRIMARY KEY ( "Mail ID" )
);


CREATE TABLE "Agancy-Costumer  Relation"
(
 "Agency ID_1" int NOT NULL,
 "Costumer ID" int NOT NULL,
 "Agency ID"   int NOT NULL,
 CONSTRAINT PK_253 PRIMARY KEY ( "Agency ID_1" ),
 CONSTRAINT FK_192 FOREIGN KEY ( "Costumer ID" ) REFERENCES Costumer ( "Costumer ID" ),
 CONSTRAINT FK_195 FOREIGN KEY ( "Agency ID" ) REFERENCES Agency ( "Agency ID" )
);

CREATE INDEX FK_194 ON "Agancy-Costumer  Relation"
(
 "Costumer ID"
);

CREATE INDEX FK_197 ON "Agancy-Costumer  Relation"
(
 "Agency ID"
);


CREATE TABLE Collaboration
(
 "Collaboration ID" int NOT NULL,
 "Dashboard ID"     int NOT NULL,
 "Costumer ID"      int NOT NULL,
 CONSTRAINT PK_251 PRIMARY KEY ( "Collaboration ID" ),
 CONSTRAINT FK_201 FOREIGN KEY ( "Dashboard ID" ) REFERENCES Dashbord ( "Dashboard ID" ),
 CONSTRAINT FK_204 FOREIGN KEY ( "Costumer ID" ) REFERENCES Costumer ( "Costumer ID" )
);

CREATE INDEX FK_203 ON Collaboration
(
 "Dashboard ID"
);

CREATE INDEX FK_206 ON Collaboration
(
 "Costumer ID"
);

CREATE TABLE enactment
(
 "Enactment ID"     int NOT NULL,
 "Resposibility ID" int NOT NULL,
 "Meeting ID"       int NOT NULL,
 CONSTRAINT PK_257 PRIMARY KEY ( "Enactment ID" ),
 CONSTRAINT FK_160 FOREIGN KEY ( "Resposibility ID" ) REFERENCES Responsibility ( "Resposibility ID" ),
 CONSTRAINT FK_163 FOREIGN KEY ( "Meeting ID" ) REFERENCES Meeting ( "Meeting ID" )
);

CREATE INDEX FK_162 ON enactment
(
 "Resposibility ID"
);

CREATE INDEX FK_165 ON enactment
(
 "Meeting ID"
);


CREATE TABLE "Member"
(
 "Dashboard Member ID" int NOT NULL,
 "Dashboard ID"        int NOT NULL,
 "User ID"             int NOT NULL,
 Rule                char(50) NOT NULL,
 CONSTRAINT PK_243 PRIMARY KEY ( "Dashboard Member ID" ),
 CONSTRAINT FK_77 FOREIGN KEY ( "Dashboard ID" ) REFERENCES Dashbord ( "Dashboard ID" ),
 CONSTRAINT FK_80 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" )
);

CREATE INDEX FK_79 ON "Member"
(
 "Dashboard ID"
);

CREATE INDEX FK_82 ON "Member"
(
 "User ID"
);


CREATE TABLE "Member2"
(
 "Project Member ID" int NOT NULL,
 "User ID"           int NOT NULL,
 "Dashboard ID"      int NOT NULL,
 "Project ID"        int NOT NULL,
 CONSTRAINT PK_245 PRIMARY KEY ( "Project Member ID" ),
 CONSTRAINT FK_99 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" ),
 CONSTRAINT FK_102 FOREIGN KEY ( "Project ID" ) REFERENCES Project ( "Project ID" ),
 CONSTRAINT FK_107 FOREIGN KEY ( "Dashboard ID" ) REFERENCES Dashbord ( "Dashboard ID" )
);

CREATE INDEX FK_101 ON "Member"
(
 "User ID"
);

CREATE INDEX FK_104 ON "Member"
(
 "Project ID"
);

CREATE INDEX FK_109 ON "Member"
(
 "Dashboard ID"
);



CREATE TABLE "Project-Dashboard Relation"
(
 "Project Dashboar ID" int NOT NULL,
 "Project ID"          int NOT NULL,
 "Dashboard ID"        int NOT NULL,
 CONSTRAINT PK_249 PRIMARY KEY ( "Project Dashboar ID" ),
 CONSTRAINT FK_92 FOREIGN KEY ( "Project ID" ) REFERENCES Project ( "Project ID" ),
 CONSTRAINT FK_95 FOREIGN KEY ( "Dashboard ID" ) REFERENCES Dashbord ( "Dashboard ID" )
);

CREATE INDEX FK_94 ON "Project-Dashboard Relation"
(
 "Project ID"
);

CREATE INDEX FK_97 ON "Project-Dashboard Relation"
(
 "Dashboard ID"
);


CREATE TABLE Reciever
(
 "Reciever ID" int NOT NULL,
 "Mail ID"     int NOT NULL,
 "User ID"     int NOT NULL,
 CONSTRAINT PK_239 PRIMARY KEY ( "Reciever ID" ),
 CONSTRAINT FK_226 FOREIGN KEY ( "Mail ID" ) REFERENCES Mail ( "Mail ID" ),
 CONSTRAINT FK_229 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" )
);

CREATE INDEX FK_228 ON Reciever
(
 "Mail ID"
);

CREATE INDEX FK_231 ON Reciever
(
 "User ID"
);



CREATE TABLE Record
(
 "Record ID"  int NOT NULL,
 "Meeting ID" int NOT NULL,
 "Project ID" int NOT NULL,
 CONSTRAINT PK_255 PRIMARY KEY ( "Record ID" ),
 CONSTRAINT FK_153 FOREIGN KEY ( "Meeting ID" ) REFERENCES Meeting ( "Meeting ID" ),
 CONSTRAINT FK_156 FOREIGN KEY ( "Project ID" ) REFERENCES Project ( "Project ID" )
);

CREATE INDEX FK_155 ON Record
(
 "Meeting ID"
);

CREATE INDEX FK_158 ON Record
(
 "Project ID"
);


CREATE TABLE "Responsibility-Project Relation"
(
 "Res. Pro ID"      int NOT NULL,
 "Resposibility ID" int NOT NULL,
 "List ID"          int NOT NULL,
 "Project ID"       int NOT NULL,
 CONSTRAINT PK_259 PRIMARY KEY ( "Res. Pro ID" ),
 CONSTRAINT FK_129 FOREIGN KEY ( "Resposibility ID" ) REFERENCES Responsibility ( "Resposibility ID" ),
 CONSTRAINT FK_132 FOREIGN KEY ( "Project ID" ) REFERENCES Project ( "Project ID" ),
 CONSTRAINT FK_141 FOREIGN KEY ( "List ID" ) REFERENCES List ( "List ID" )
);

CREATE INDEX FK_131 ON "Responsibility-Project Relation"
(
 "Resposibility ID"
);

CREATE INDEX FK_134 ON "Responsibility-Project Relation"
(
 "Project ID"
);

CREATE INDEX FK_143 ON "Responsibility-Project Relation"
(
 "List ID"
);


CREATE TABLE Responsible
(
 "Responsibility ID" int NOT NULL,
 "Resposibility ID"  int NOT NULL,
 "User ID"           int NOT NULL,
 "Project ID"        int NOT NULL,
 CONSTRAINT PK_247 PRIMARY KEY ( "Responsibility ID" ),
 CONSTRAINT FK_119 FOREIGN KEY ( "Resposibility ID" ) REFERENCES Responsibility ( "Resposibility ID" ),
 CONSTRAINT FK_122 FOREIGN KEY ( "Project ID" ) REFERENCES Project ( "Project ID" ),
 CONSTRAINT FK_125 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" )
);

CREATE INDEX FK_121 ON Responsible
(
 "Resposibility ID"
);

CREATE INDEX FK_124 ON Responsible
(
 "Project ID"
);

CREATE INDEX FK_127 ON Responsible
(
 "User ID"
);


CREATE TABLE Sender
(
 "Sender ID"    int NOT NULL,
 "Mail ID"      int NOT NULL,
 "User ID"      int NOT NULL,
 "Dashboard ID" int NOT NULL,
 CONSTRAINT PK_241 PRIMARY KEY ( "Sender ID" ),
 CONSTRAINT FK_215 FOREIGN KEY ( "Mail ID" ) REFERENCES Mail ( "Mail ID" ),
 CONSTRAINT FK_218 FOREIGN KEY ( "Dashboard ID" ) REFERENCES Dashbord ( "Dashboard ID" ),
 CONSTRAINT FK_233 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" )
);

CREATE INDEX FK_217 ON Sender
(
 "Mail ID"
);

CREATE INDEX FK_220 ON Sender
(
 "Dashboard ID"
);

CREATE INDEX FK_235 ON Sender
(
 "User ID"
);


CREATE TABLE "User-Note Relation"
(
 "User-Note id" int NOT NULL,
 "Note ID"      int NOT NULL,
 "User ID"      int NOT NULL,
 CONSTRAINT PK_237 PRIMARY KEY ( "User-Note id" ),
 CONSTRAINT FK_64 FOREIGN KEY ( "Note ID" ) REFERENCES Note ( "Note ID" ),
 CONSTRAINT FK_68 FOREIGN KEY ( "User ID" ) REFERENCES "Site User" ( "User ID" )
);

CREATE INDEX FK_66 ON "User-Note Relation"
(
 "Note ID"
);

CREATE INDEX FK_70 ON "User-Note Relation"
(
 "User ID"
);


