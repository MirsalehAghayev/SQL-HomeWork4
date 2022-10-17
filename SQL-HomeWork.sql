CREATE DATABASE MoviesApp
USE MoviesApp

CREATE TABLE Directors
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(30) NOT NULL,
	Surname nvarchar(30) NOT NULL
)
INSERT INTO Directors
VALUES
('Mirsaleh','Agayev'),
('Mirabbas','Seyidov')

CREATE TABLE Languages
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(30) NOT NULL UNIQUE
)
INSERT INTO Languages
VALUES
('Aze'),
('Eng')

CREATE TABLE Actors
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(30) NOT NULL,
	Surname nvarchar(30) NOT NULL
)
INSERT INTO Actors
VALUES
('Bred','Pitt'),
('Ceff','Yanq'),
('Keri','Qrant'),
('Kevin','Klayn')

CREATE TABLE Movies
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(30) NOT NULL,
	Description nvarchar(300) NOT NULL,
	CoverPhoto nvarchar(300) NOT NULL,
	DirectorId int FOREIGN KEY REFERENCES Directors(Id),
	LanguageId int FOREIGN KEY REFERENCES Languages(Id)
)
INSERT INTO Movies
VALUES('The Spy','Israil Film, Bir cox janirlari ozunde cemlesdiren maraqli filmidir','TheSpyPhoto',1,2),
('127 Hours','Filmde bir dagcinin basina gelen hadislerden behs edir','127HoursPhoto',2,1)


CREATE TABLE Genres
(
	Id int PRIMARY KEY IDENTITY,
	Name nvarchar(30) NOT NULL UNIQUE
)
INSERT INTO Genres
VALUES
('sports'),
('drama'),
('action'),
('comedy')


CREATE TABLE MoviesActors
(
	Id int PRIMARY KEY IDENTITY,
	MovieId int FOREIGN KEY REFERENCES Movies(Id),
	ActorId int FOREIGN KEY REFERENCES Actors(id)
)
INSERT INTO MoviesActors
VALUES(2,1)

CREATE TABLE MoviesGenres(
	Id int PRIMARY KEY IDENTITY,
	MovieId int FOREIGN KEY REFERENCES Movies(Id),
	GenreId int FOREIGN KEY REFERENCES Genres(id)
)
INSERT INTO MoviesGenres
VALUES(1,2)

SELECT*FROM Directors
SELECT*FROM Actors
SELECT*FROM Languages
SELECT*FROM Genres
SELECT*FROM Movies
SELECT*FROM MoviesActors
SELECT*FROM MoviesGenres


CREATE OR ALTER PROCEDURE usp_FilmsAndLanguage @directorId int
AS
SELECT m.Id,m.Name,l.Name FROM Movies AS m
INNER JOIN Languages AS l ON m.LanguageId= l.Id
WHERE m.DirectorId=@directorId
EXEC usp_FilmsAndLanguage @directorId=1

CREATE FUNCTION LanguageMoviesCount (@languageId int)
RETURNS int
AS
BEGIN
     DECLARE @CountMovie int
	 SELECT @CountMovie=COUNT(*) FROM Movies WHERE Movies.LanguageId=@languageId
	 RETURN @CountMovie
END
SELECT  dbo.LanguageMoviesCount(2)


CREATE OR ALTER PROCEDURE usp_GFAndDirector @genreId int
AS
SELECT m.Name,d.Name FROM MoviesGenres AS mg
INNER JOIN Movies AS m ON mg.MovieId=m.Id
INNER JOIN Directors AS d ON m.DirectorId=d.Id
WHERE mg.GenreId=@genreId
EXEC usp_GFAndDirector @genreId=4


CREATE TRIGGER AllMoviesAfterInsert ON Movies
AFTER INSERT
AS
BEGIN
	SELECT m.Name,m.Description,d.Name,d.Surname,l.Name FROM Movies AS m
	INNER JOIN Directors AS d ON m.DirectorId=d.Id
	INNER JOIN Languages AS l ON m.LanguageId=l.Id
END

