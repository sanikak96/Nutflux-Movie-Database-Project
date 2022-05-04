# CREATE A NEW DATABASE
DROP DATABASE IF EXISTS  NUTFLUX_PROJECT;
CREATE DATABASE NUTFLUX_PROJECT;

#USE THE DATABASE
USE NUTFLUX_PROJECT;


# CREATE USERS AND ASSIGN PRIVILEGES
CREATE USER IF NOT EXISTS 'sanika'@'localhost' IDENTIFIED BY 'dba';
CREATE USER IF NOT EXISTS 'proUser'@'localhost' IDENTIFIED BY 'pro123';
CREATE USER IF NOT EXISTS 'normalUser'@'localhost' IDENTIFIED BY 'normal123';


GRANT ALL PRIVILEGES ON NUTFLUX_PROJECT TO 'sanika'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON NUTFLUX_PROJECT TO 'proUser'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES  ON NUTFLUX_PROJECT TO 'normalUser'@'localhost' WITH GRANT OPTION;

FLUSH PRIVILEGES;


# CREATE DIMENSION TABLES

DROP TABLE IF EXISTS Titles;
CREATE TABLE Titles (
  title_id     INT  PRIMARY KEY auto_increment,
  title        VARCHAR(255) NOT NULL,
  start_year   INT NOT NULL,
  end_year     INT NOT NULL,
  is_adult     BOOLEAN NOT NULL,
  is_series   BOOLEAN NOT NULL,
  runtime     INT NOT NULL,
  gross_earnings_dollars INT not null,
  imdb_rating  FLOAT,
  tagline VARCHAR(255) not null
  
);


DROP TABLE IF EXISTS Directors;
CREATE TABLE Directors (
  director_name VARCHAR(255) NOT NULL PRIMARY KEY,
  director_nationality VARCHAR(255) NOT NULL,
  director_debut_year INT NOT NULL,
  director_gender VARCHAR(10) NOT NULL,
  is_famous_for  TEXT,
  check(director_gender in ('Male', 'Female', 'Other'))
);

DROP TABLE IF EXISTS Episodes;
CREATE TABLE Episodes (
  episode_id  INT NOT NULL PRIMARY KEY auto_increment,
  episode_name VARCHAR(255) NOT NULL,
  episode_title_id   INT NOT NULL,
  season_number   INT NOT NULL,
  episode_number  INT NOT NULL,
  FOREIGN KEY (episode_title_id) REFERENCES Titles (title_id)
);

DROP TABLE IF EXISTS Actors;
CREATE TABLE Actors (
  actor_name  VARCHAR(255) NOT NULL PRIMARY KEY,
  actor_nationality VARCHAR(255) NOT NULL,
  actor_gender VARCHAR(10) NOT NULL,
  actor_debut_year INT NOT NULL,
  check(actor_gender in ('Male', 'Female', 'Other'))
);

DROP TABLE IF EXISTS Producers;
CREATE TABLE Producers (
  producer_name  VARCHAR(255) NOT NULL PRIMARY KEY,
  producer_gender VARCHAR(10) NOT NULL,
  check(producer_gender in ('Male', 'Female', 'Other'))
);

DROP TABLE IF EXISTS Writers;
CREATE TABLE Writers (
writer_name  VARCHAR(255) NOT NULL PRIMARY KEY,
writer_gender VARCHAR(10) NOT NULL ,
is_famous_for   TEXT,
check(writer_gender in ('Male', 'Female', 'Other'))
);

DROP TABLE IF EXISTS Roles;
CREATE TABLE Roles (
role_id   INT not null PRIMARY KEY auto_increment,
role_name VARCHAR(255) not null
);

DROP TABLE IF EXISTS Categories;
CREATE TABLE Categories (
category_id   INT not null PRIMARY KEY auto_increment,
category_name VARCHAR(255) not null
);

DROP TABLE IF EXISTS Awards;
CREATE TABLE Awards (
award_id INT auto_increment Primary Key,
award_type VARCHAR(255) not null,
award_name VARCHAR(255) not null
);

# CREATE RELATION TABLES

DROP TABLE IF EXISTS Awards_Actors;
CREATE TABLE Awards_Actors (
aa_id INT auto_increment Primary Key,
title_id INT NOT NULL,
award_id INT NOT NULL,
actor_name VARCHAR(255) NOT NULL,
is_nominee Boolean,
FOREIGN KEY (title_id) REFERENCES Titles (title_id),
FOREIGN KEY (actor_name) REFERENCES Actors (actor_name),
FOREIGN KEY (award_id) REFERENCES Awards (award_id)
);

DROP TABLE IF EXISTS Awards_Directors;
CREATE TABLE Awards_Directors (
ad_id INT auto_increment Primary Key,
title_id INT NOT NULL,
award_id INT NOT NULL,
director_name VARCHAR(255) NOT NULL,
is_nominee Boolean,
FOREIGN KEY (title_id) REFERENCES Titles (title_id),
FOREIGN KEY (director_name) REFERENCES Directors (director_name),
FOREIGN KEY (award_id) REFERENCES Awards (award_id)
);

DROP TABLE IF EXISTS Trivia;
CREATE TABLE Trivia (
  trivia_id  INT NOT NULL PRIMARY KEY auto_increment,
  title_id   INT NOT NULL,
  trivia VARCHAR(255) not null, 
  FOREIGN KEY (title_id) REFERENCES Titles (title_id)
);

DROP TABLE IF EXISTS Genre_titles;
CREATE TABLE Genre_titles (
title_id INT NOT NULL UNIQUE, 
main_genre VARCHAR(100),
sub_genre VARCHAR(100),
PRIMARY KEY(title_id,main_genre), 
FOREIGN KEY (title_id) REFERENCES Titles (title_id)
);

DROP TABLE IF EXISTS Roles_Categories;
CREATE TABLE Roles_Categories (
role_id  INT NOT NULL,
category_id INT NOT NULL,
PRIMARY KEY (role_id,category_id), #composite key of role and category id
FOREIGN KEY (role_id) REFERENCES Roles (role_id),
FOREIGN KEY (category_id) REFERENCES Categories (category_id)
);

DROP TABLE IF EXISTS casting;
CREATE TABLE casting (
title_id   INT not null,
actor_name VARCHAR(255) not null,
role_id INT NOT NULL,
is_famous_for BOOLEAN,  #is the actor famous for a role
PRIMARY KEY (title_id,actor_name),
FOREIGN KEY (title_id) REFERENCES Titles (title_id),
FOREIGN KEY (role_id) REFERENCES Roles (role_id),
FOREIGN KEY (actor_name) REFERENCES Actors (actor_name)
);

DROP TABLE IF EXISTS title_directors;
CREATE TABLE title_directors (
	title_id INT NOT NULL,
    director_name VARCHAR(250) NOT NULL,
    FOREIGN KEY (title_id) REFERENCES Titles (title_id),
	FOREIGN KEY (director_name)
        REFERENCES Directors (director_name),
	PRIMARY KEY (title_id,director_name)  #COMPOSITE KEY OF MOVIE AND DIRECTOR PAIRING 
);

DROP TABLE IF EXISTS title_producers;
CREATE TABLE title_producers (
	title_id INT NOT NULL,
    producer_name VARCHAR(250) NOT NULL,
    FOREIGN KEY (title_id) REFERENCES Titles (title_id),
	FOREIGN KEY (producer_name)
        REFERENCES Producers (producer_name),
	PRIMARY KEY (title_id,producer_name)  #COMPOSITE KEY OF MOVIE AND DIRECTOR PAIRING 
);

DROP TABLE IF EXISTS title_writers;
CREATE TABLE title_writers (
	title_id INT NOT NULL,
    writer_name VARCHAR(250) NOT NULL,
    FOREIGN KEY (title_id) REFERENCES Titles (title_id),
	FOREIGN KEY (writer_name)
        REFERENCES Writers (writer_name),
	PRIMARY KEY (title_id,writer_name)  #COMPOSITE KEY OF MOVIE AND DIRECTOR PAIRING 
);


DROP TABLE IF EXISTS Awards_info;
CREATE TABLE Awards_info (
title_id  INT not null,
award_id INT not null,
is_nominee Boolean,
PRIMARY KEY (title_id,award_id),
FOREIGN KEY (title_id) REFERENCES Titles (title_id),
FOREIGN KEY (award_id) REFERENCES Awards (award_id)
);

DROP TABLE IF EXISTS Connections;
CREATE TABLE Connections (
conn_id INT PRIMARY KEY auto_increment,
actor_1_name VARCHAR(255) not null,
actor_2_name VARCHAR(255) not null,
relationship CHAR(250) not null,
conn_year INT not null,
FOREIGN KEY (actor_1_name) REFERENCES Actors(actor_name),
FOREIGN KEY (actor_2_name) REFERENCES Actors(actor_name));

# ----------------------------------INSERT DATA-----------------------------------------------
USE nutflux_project;

INSERT INTO Titles (title, start_year, end_year, is_adult, is_series, runtime, imdb_rating, tagline, gross_earnings_dollars) VALUES
("Good Will Hunting", 1997, 1997, 0, 0, 126, 8.3, 'Some people can never believe in themselves, until someone believes in them', 225000000),
('Argo', 2012, 2012, 120, 0,  0, 7.7, 'The movie was fake, the mission was real',232000000),
("Sherlock Holmes", 2009, 2009, 0, 0, 120, 7.6, "Nothing escapes him",524000000),
('Sherlock', 2010, 2017, 0, 1, 88, 9.1, 'The Game is On',1000000),
("Superman Returns", 2006, 2006, 0, 0, 154, 6.1, "On June 30, 2006! Look Up In The Sky!",391000000),
("Man of Steel", 2013, 2013, 0 ,0, 143, 7.1, "Accomplish Wonder",668000000),
("No Time to Die", 2021, 2021, 0, 0, 163, 7.3, "Bond is Back",762000000),
("Spectre", 2015, 2015, 0, 0, 148, 6.8, "The Dead are Alive",880700000),
("Skyfall", 2012, 2012, 0, 0, 143, 7.8, "Shaken, not stirred",10000000),
("Casino Royale", 2006, 2006, 0, 0, 144, 8.0, "Always bet on Bond",616500000),
("Quantum of Solace", 2008, 2008, 0, 0, 106, 6.6, "Have Regrets. Get Revenge",589000000),
("Never Have I Ever", 2020, 2023, 0, 1, 30, 7.8, "It's all fun and games until someone gets hurt... Then it's a party!",56411585),
("Eyes Wide Shut",1990,1990,0,0,120,7.5,"Cruise. Kidman. Kubrick.",162242684),
("Cleopatra",1963,1963,0,0,120,7.6,"The motion picture the world has been waiting for!",57777778),
("Mr. & Mrs. Smith",2005,2005,0,0,113,6.5,"A bored married couple, or spies? ",487287646),
("The Big Sleep",1946,1946,0,0,120,7.9,"The type of man she hated . . . was the type she wanted !
",223560),
("Total Recall",2012,2012,0,0,106,6.2,"What is real?",198467168),
("Daredevil",2003,2003,0,0,146,5.3,"A Guardian Devil.",179179718)
;

INSERT INTO Trivia (title_id, trivia) VALUES 
(1, 'In 2014, after Robin Williams died, the bench in the Boston Public Garden where he and Matt Damon had their conversation scene became an impromptu memorial site.'),
(2, 'For the opening scene, the director of photography gave 8mm cameras out to certain people in the crowd to make the opening scene have what would seem like this was actual footage from the riot.'),
(3, "Robert Maillet (Dredger) accidentally knocked out Robert Downey Jr. (Sherlock Holmes) while filming a fight scene."),
(4, 'The character of Greg Lestrade is a combination of Inspectors Gregson and Lestrade.'),
(5, "The stars on Clark Kent's ceiling are astronomically correct."),
(5, "Brandon Routh put on twenty pounds of muscle for the movie."),
(6, "The film released in June 2013, the 75th anniversary of Superman."),
(7, "With the announcement of Christoph Waltz returning to play Ernst Stavro Blofeld, this marks the first time in fifty-four years that an actor (the uncredited Anthony Dawson before) played the SPECTRE mastermind more than once."),
(8, "The movie shares several of the same shooting locations as The Living Daylights (1987), including Tangier, Morocco, London, England, and Austria."),
(9, "Daniel Craig performed a stunt of leaping and sliding down the escalator rail himself"),
(10, "The way Bond orders his first vodka martini is lifted directly from the Ian Fleming novels."),
(11, "Daniel Craig wasn't fond of how production went, saying that thanks to this, he'd never do a movie without a script nailed down again."),
(12, "Mindy Kaling approached John McEnroe about narrating before there was even a finished script."),
(13,"Appeared in the Guinness Book of Records with the record for The Longest Constant Movie Shoot, at four hundred days."),
(14,"The Roman forum built at Cinecitta was three times the size of the real thing."),
(15,"Brad Pitt left in the middle of shooting for three months to shoot Ocean's Twelve (2004)."),
(16,"Philip Marlowe's habit of feeling his earlobe while in deep thought was something Humphrey Bogart incorporated from his own behavior."),
(17,"Actor Colin Farrell actually spent a night on the set because he wanted to see what it would be like to wake up in the future"),
(18,"Ben Affleck was virtually blind, as he had to wear heavy-duty contact lenses, which blocked out most of his vision")
;

INSERT INTO Directors (director_name, director_nationality, director_debut_year, is_famous_for, director_gender) 
VALUES 
("Gus Van Sant", "American", 1952, "From the director of Good Will Hunting", "Male"),
('Ben Affleck', 'American', 2007, 'From the director of ARGO', "Male"),
("Guy Ritchie", "American", 1995, 'From the director of MAN from UNCLE and The Gentlemen', "Male"),
("Mark Gatiss","British",2004,'From the director of League of Gentlemen',"Male"),
("Steven Moffat","British",1989,"From the maker of BBC Doctor Who!","Male"),
("Bryan Singer", "American", 1988, "From the director of X-Men movies and Superman Returns", "Male"),
("Zack Snyder", "American", 2004, "From the maker of Justice League", "Male"),
("Cary Joji Fukunaga", "American", 2003, "From the director of James Bond", "Male"),
("Sam Mendes", "British", 1999, "From the director of James Bond", "Male"),
("Martin Campbell", "New Zealander", 1998,"From the director of James Bond", "Male"),
("Marc Forster", "German", 2001, "From the director of Stranger than Fiction", "Male"),
("Kabir Akhtar", "American", 2001, "From the director of Crazy Ex-Girlfriend", "Male"),
("Tristam Shapeero", "British", 2014, "From the director of Community", "Male"),
('Stanley Kubrick','American',1951,"From the director of a clockwork orange","Male"),
('Joseph Mankiewicz','American',1946,"From the director of cleopatra","Male"),
('Doug Liman','American',1966,"From the director of the edge of tomorrow","Male"),
('Howard Hawks','American',1926,"From the director of Red River","Male"),
('Len Wiseman','American',1988,"From the director of Underworld","Male"), 
('Mark Johnson','American',1988,"From the director of Daredevil","Male");
;

INSERT INTO Producers (producer_name,producer_gender) VALUES
("Lawrence Bender", "Male"),
('Ben Affleck', "Male"),
('Grant Heslov',"Male"),
('George Clooney',"Male"),
('Joel Silver',"Male"),
('Lionel Wigram',"Male"),
('Susan Downey',"Female"), 
('Dan Lin',"Male"),
('Sue Vertue',"Female"),
('Elaine Cameron',"Female"),
("Gilbert Adler", "Male"),
("Stephen Jones", "Male"),
("Christopher Nolan", "Male"),
("Barbara Broccolli", "Female"),
("Leanne Moore", "Female"),
("Stanley Kubrick","Male"),
("Walter Wanger","Male"),
("Lucas Foster","Male"),
("Howard Hawks","Male"),
("Toby Jaffe","Male"),
("Avi Arad","Male")


;

INSERT INTO Writers (writer_name,is_famous_for,writer_gender) VALUES
("Matt Damon","Known for writing Good Will Hunting","Male"),
("Ben Affleck","Known for writing Good Will Hunting","Male"),
('Chriss Terrio','From the writer of Argo',"Male"),
('Michael Robert Johnson',NULL,"Male"),
('Anthony Peckman',NULL,"Male"),
('Simon Kinberg',NULL,"Male"),
('Mark Gatiss','From the maker of Sherlock and Doctor Who',"Male"),
('Steven Moffat','From the maker of Sherlock and Doctor Who',"Male"),
("Michael Dougherty", "From the maker of Superman Returns", "Male"),
("Bryan Singer", "From the director of X-Men movies and Superman Returns", "Male"),
("Christopher Nolan", "From the maker of Inception", "Male"),
("David S Goyer", "From the writer of The Dark Knight", "Male"),
("Jerry Siegel", "From the creator of Superman", "Male"),
("Neal Purvis", "From the creator of James Bond", "Male"),
("Robert Wade", "From the creator of James Bond", "Male"),
("Lang Fisher", "From the creator of Brooklyn Nine-Nine", "Male"),
("Stanley Kubrick","From the writer of Eyes wide shut", "Male"),
("Sidney Buchman","From the writer of Cleopatra", "Male"),
("Simom Kinberg","From the writer of Mr. & Mrs. Smith", "Male"),
("William Faulkner","From the writer of The big sleep", "Male"),
("Kurt Wimmer","From the writer of Total Recall", "Male"),
("Mark Johnson","From the writer of Daredevil", "Male")
;

INSERT INTO Actors (actor_name,actor_nationality,actor_gender,actor_debut_year) VALUES 
("Robin Williams","American","Male",1980),
("Ben Affleck","American","Male",1993),
("Matt Damon","American","Male",1988),
('Bryan Cranston','American',"Male",1983),
("Robert Downey Jr","American","Male",1970),
("Jude Law","British","Male",1994),
('Benedict Cumberbatch','British',"Male",2006),
('Martin Freeman','British',"Male",1997),
("Kevin Spacey", "American", "Male", 1980),
("Brandon Routh", "American", "Male", 1999),
("Kate Bosworth", "American", "Female", 1998),
("Henry Cavill", "American", "Male", 2001),
("Amy Adams", "American", "Female", 1999),
("Daniel Craig", "British", "Male", 1984),
("Naomie Harris","British", "Female", 1987),
("Ben Whishaw","British", "Male", 1987),
("Maitreyi Ramakrishnan", "Canadian", "Female", 2020),
("Darren Barnet", "American", "Male", 2017),
("Ramona Young", "American", "Female", 2016),
('Tom Cruise','American',"Male",1981),('Nicole Kidman','American',"Female",1983),
('Elizabeth Taylor','British',"Female",1942),('Richard Burton','British',"Male",1949),
('Brad Pitt','American',"Male",1987), ('Angelina Jolie','American',"Female",1982),
('Humphrey Bogart','American',"Male",1928),('Lauren Bacall','American',"Female",1944),
('Colin Farrell','Irish',"Male",1998),('Bokeem Woodbine','American',"Male",1992),
('Jennifer Garner','American',"Female",1995)
;

INSERT INTO Roles(role_name) VALUES
("Sean"),
("Will"),
("Chuckie"),
("Tony Mendez"),
("Jack O'Donnel"),
("Sherlock Holmes"),
("Dr. Watson"),
("James Bond"),
("Q"),
("Superman"), -- 10
("Lex Luther"),
("Lois Lane"),
("Moneypenny"),
("Devi Vishwakumar"),
("Paxton Hall-Yoshida"),
("Elanor Wong"), 
('Dr. William Harford'),('Alice Hartford'),
('Cleopatra'),('Mark Antony'),
('John Smith'),('Jane Smith'),
('Philip Marlowe'),('Vivian Rutledge'),
('Douglas Quaid'),('Harry'),
('Daredevil'),('Elektra Natchios'); 


;

INSERT INTO Categories(category_name) VALUES 
("Lawyer"),
("Teacher"),
("Student"),
("Hero"),
("Anti-hero"),
("Detective"),
("Playboy"),
("Spy"), 
("Alien"),
("Superhero"),
("Philanthropist"),
("CEO"),
("Thief"),
("Archer"),
("Doctor"),
("Magician"),
("Villain"),
("Politician"),
("Journalist"),
("Supervillain"),
("Secretary"), 
("Agent"),
("Student"),
("Queen"),("General"),("Wife")
;

INSERT INTO Awards (award_type,award_name) VALUES 
("Oscar","Best Picture"), 
('Golden Globe','Best Motion Picture'), 
('BAFTA AWARD','Best Film'), 
('EMMY','Outstanding Television Movie'),
("Oscar","Best Actor"), 
('BAFTA AWARD','Best Actor'), 
("Screen Actors Guild Awards","Outstanding Performance by Actor"), 
('EMMY','Outstanding Actor'), 
("Screen Actors Guild Awards","Outstanding Performance by a Cast"), 
("Oscar","Best Director"), 
('Golden Globe','Best Director'), 
('BAFTA AWARD','Best Direction'), 
('EMMY', 'Outstanding Directing'),
('AAFCA', 'Best Young Adults'),
('Film Independent Spirit Award', 'Best Female Performance')
;

INSERT INTO Genre_titles (title_id,main_genre,sub_genre) VALUES
(1,"Drama","Romance"),
(2,"Biography","Drama"),
(3, "Action","Adventure"),
(4,"Crime","Drama"),
(5, "Action","SciFi"),
(6, "Action","SciFi"),
(7,	"Action","Adventure"),
(8,"Action","Adventure"),
(9,"Action","Adventure"),
(10 ,"Action","Adventure"),
(11 ,"Action","Adventure"),
(12 ,"Comedy","Drama"),
(13 ,"Mystery","Drama"),
(14 ,"Biography","Drama"),
(15 ,"Comedy","Drama"),
(16 ,"Crime","Mystery"),
(17 ,"Action","Adventure"),
(18 ,"Action","Crime")

;

INSERT INTO Roles_Categories (category_id,role_id) VALUES 
(2,1),
(3,2),
(3,3),
(4,4),
(8,4),
(8,5),
(4,6),
(6,6),
(15,7),
(10,10),
(20,11),
(19,12),
(4,8),
(8,8),
(21,13),
(22, 9),
(23,14),
(23,15),
(23,16),
(15,17),(26,18),
(24,19),(25,20),
(8,21),(8,22),
(6,23),(6,24),
(22,25),(8,26),
(10,27),(20,28)
;

INSERT INTO casting (title_id,actor_name,role_id,is_famous_for) VALUES
(1,"Robin Williams",1,0),
(1,"Matt Damon",2,0),
(1,"Ben Affleck",3,0),
(2,"Ben Affleck",4,0),
(2,'Bryan Cranston',5,0),
(3,"Robert Downey Jr",6,1),
(3,"Jude Law",7,0),
(4,"Benedict Cumberbatch",6,1),
(4,'Martin Freeman',7,1),
(5, "Brandon Routh", 10, 1),
(5, "Kevin Spacey", 11, 0),
(5, "Kate Bosworth", 12, 0),
(6, "Henry Cavill", 10, 1),
(6, "Amy Adams", 12, 0),
(7, "Daniel Craig", 8, 1),
(7, "Naomie Harris", 13, 0),
(7, "Ben Whishaw", 9, 0),
(8, "Daniel Craig", 8, 1),
(8, "Naomie Harris", 13, 0),
(8, "Ben Whishaw", 9, 0),
(9, "Daniel Craig", 8, 1),
(9, "Naomie Harris", 13, 0),
(9, "Ben Whishaw", 9, 0),
(10, "Daniel Craig", 8, 1),
(11, "Daniel Craig", 8, 1),
(12, "Maitreyi Ramakrishnan", 14, 1),
(12, "Darren Barnet", 15, 0),
(12, "Ramona Young", 16, 0),
(13,"Tom Cruise",17,0),(13,"Nicole Kidman",18,0),
(14,"Elizabeth Taylor",19,0),(14,"Richard Burton",20,0),
(15,"Brad Pitt",21,0),(15,"Angelina Jolie",22,0),
(16,"Humphrey Bogart",23,0),(16,"Lauren Bacall",24,0),
(17,"Colin Farrell",25,0),(17,"Bokeem Woodbine",26,0),
(18,"Jennifer Garner",28,0),(18,"Ben Affleck",27,0)
;
  
INSERT INTO title_directors(title_id,director_name) VALUES 
(1, "Gus Van Sant"),
(2, 'Ben Affleck'),
(3, "Guy Ritchie"),
(4, 'Mark Gatiss'),
(4,'Steven Moffat'),
(5, "Bryan Singer"),
(6, "Zack Snyder"),
(7, "Cary Joji Fukunaga"),
(8, "Sam Mendes"),
(9, "Sam Mendes"),
(10, "Martin Campbell"),
(11, "Marc Forster"),
(12, "Kabir Akhtar"),
(12, "Tristam Shapeero"),

(13,'Stanley Kubrick'),
(14,'Joseph Mankiewicz'),
(15,'Doug Liman'),
(16,'Howard Hawks'),
(17,'Len Wiseman'), 
(18,'Mark Johnson');
;

INSERT INTO title_producers (title_id,producer_name) VALUES 
(1,"Lawrence Bender"),
(2,"Ben Affleck"),
(2,"Grant Heslov"),
(2,"George Clooney"),
(3,'Joel Silver'),
(3,'Lionel Wigram'),
(3,'Susan Downey'), 
(3,'Dan Lin'),
(4,'Sue Vertue'),
(4,'Elaine Cameron'),
(5, "Gilbert Adler"),
(5, "Stephen Jones"),
(6, "Christopher Nolan"),
(7, "Barbara Broccolli"),
(8, "Barbara Broccolli"),
(9, "Barbara Broccolli"),
(10, "Barbara Broccolli"),
(11, "Barbara Broccolli"),
(12, "Leanne Moore"),
(13,"Stanley Kubrick"),
(14,"Walter Wanger"),
(15,"Lucas Foster"),
(16,"Howard Hawks"),
(17,"Toby Jaffe"),
(18,"Avi Arad")
;

INSERT INTO title_writers (title_id,writer_name) VALUES 
(1,"Matt Damon"),
(1,"Ben Affleck"),
(2,"Chriss Terrio"),
(3,'Michael Robert Johnson'),
(3,'Anthony Peckman'),
(3,'Simon Kinberg'),
(4,'Mark Gatiss'),
(4,'Steven Moffat'),
(5, "Michael Dougherty"),
(5, "Bryan Singer"),
(6, "David S Goyer"),
(6, "Jerry Siegel"),
(6, "Christopher Nolan"),
(7, "Neal Purvis"),
(7, "Robert Wade"),
(8, "Neal Purvis"),
(8, "Robert Wade"),
(9, "Neal Purvis"),
(9, "Robert Wade"),
(10, "Neal Purvis"),
(10, "Robert Wade"),
(11, "Neal Purvis"),
(11, "Robert Wade"),
(12, "Lang Fisher"),
(13,"Stanley Kubrick"),
(14,"Sidney Buchman"),
(15,"Simom Kinberg"),
(16,"William Faulkner"),
(17,"Kurt Wimmer"),
(18,"Mark Johnson")

;

INSERT INTO Awards_info (title_id,award_id,is_nominee) VALUES 
(1,1,1),
(1,2,1),
(2,1,0),
(2,3,0),
(4,4,0),
(6,3,1),
(7,2,1),
(8,3,0),
(9,3,0),
(10,3,0),
(11,3,1),
(12, 14,0),
(13,1,1),
(14,2,1),
(15,1,1),
(16,3,0),
(17,3,0),
(18,2,0)
;

INSERT INTO Awards_Actors (title_id,award_id,is_nominee,actor_name) VALUES 
(1,5,1,"Matt Damon"),
(1,7,0,"Matt Damon"),
(2,6,1,"Ben Affleck"),
(3,6,0,"Robert Downey Jr"),
(4,8,1,"Benedict Cumberbatch"),
(7,6,1, "Daniel Craig"),
(8,6,0, "Naomie Harris"),
(9,6,1, "Daniel Craig"),
(10,6,1, "Daniel Craig"),
(11, 6, 0, "Daniel Craig"),
(12, 15, 0, "Maitreyi Ramakrishnan"),
(13, 6, 0, "Tom Cruise"),
(14, 6, 1, "Elizabeth Taylor"),
(15, 6, 1, "Brad Pitt"),
(15, 7, 1, "Angelina Jolie"),
(17, 6, 0, "Colin Farrell"),
(18, 7, 0, "Jennifer Garner")


;

INSERT INTO Awards_Directors (title_id,award_id,is_nominee,director_name) VALUES 
(1,10,1,"Gus Van Sant"),
(2,12,0,"Ben Affleck"),
(6, 12, 0, "Zack Snyder"),
(7, 10, 1, "Cary Joji Fukunaga"),
(8, 11, 0, "Sam Mendes"),   
(9, 11, 1, "Sam Mendes"), 
(10, 12, 1, "Martin Campbell"),
(13, 12, 1, "Stanley Kubrick"),
(15, 10, 0, "Doug Liman"),
(17, 10, 0, "Len Wiseman"),
(18, 12, 1, "Mark Johnson")

;


INSERT INTO Episodes (episode_name ,episode_title_id,season_number,episode_number) VALUES
('A study in Pink',4,1,1),
('The Blind Banker',4,1,2),
('The Great Game',4,1,3),
('A Scandal in Belgravia',4,2,1),
('The hounds of Baskerville',4,2,2),
('The Riechenbach Fall',4,2,3),
('The Empty Hearse',4,3,1),
('The Sign of three',4,3,2),
('His last vow',4,3,3),
('The six Thatchers',4,4,1),
('The Lying Detective',4,4,2),
('The Final Problem',4,4,3),
('...been a big, fat liar', 12, 1, 1),
('...pissed off everyone I know', 12, 1, 2),
('...had to be on my best behavior', 12, 1, 3),
("...said I'm sorry", 12, 1, 4),
('...started a nuclear war', 12, 1, 5),
('...felt super Indian', 12, 1, 6),
('...been a playa', 12, 2, 1),
('...thrown a rager', 12, 2, 2),
('...opened a textbook', 12, 2, 3),
('...begged for forgiveness', 12, 2, 4),
('...been Daisy Buchanan', 12, 2, 5),
('...stopped my own mother', 12, 2, 6)
;

INSERT INTO Connections(actor_1_name,actor_2_name ,relationship ,conn_year) VALUES
("Tom Cruise",'Nicole Kidman','Married',1990),("Tom Cruise",'Nicole Kidman','Divorced',2001),
('Elizabeth Taylor','Richard Burton','Married',1964),('Elizabeth Taylor','Richard Burton','Divorced',1973),
('Brad Pitt','Angelina Jolie','Dating',2004),('Brad Pitt','Angelina Jolie','Married',2014),('Brad Pitt','Angelina Jolie','Divorced',2016),
('Humphrey Bogart','Lauren Bacall','Dating',1943),('Humphrey Bogart','Lauren Bacall','Married',1945),
("Ben Affleck",'Jennifer Garner','Dating',2004),("Ben Affleck",'Jennifer Garner','Married',2005),("Ben Affleck",'Jennifer Garner','Divorced',2018);


# ------------------------------ VIEWS ------------------------------------------------------------------


USE NUTFLUX_PROJECT;

DROP VIEW IF EXISTS Film_Franchise;
## FILMS PER FRANCHISE
CREATE VIEW Film_Franchise
AS 
(SELECT role_name AS Franchise, title AS Movies, start_year AS Release_Year
FROM titles t
	JOIN Casting c on t.title_id = c.title_id
    JOIN Roles r on r.role_id = c.role_id
WHERE role_name in (
SELECT role_name
 FROM titles t
	JOIN Casting c on t.title_id = c.title_id
    JOIN Roles r on r.role_id = c.role_id
    GROUP BY role_name
    having count(t.title_id)  > 1 and is_series=0 and is_famous_for = 1))
    ORDER BY Franchise;
	
SELECT * FROM Film_Franchise;

## FAVOURITE ACTORS PER DIRECTOR
DROP VIEW IF EXISTS Director_Favourite_Actors;

CREATE VIEW Director_Favourite_Actors
AS 
(SELECT director_name as Directors,actor_name as Actors, count(t.title_id) as Film_Count
FROM titles t
	JOIN Casting c on t.title_id = c.title_id
	JOIN title_directors td on td.title_id = t.title_id
    GROUP BY Directors,Actors
    HAVING Film_Count >1 AND Actors!=Directors);
    
SELECT * FROM Director_Favourite_Actors;

### Award Winning Movies
DROP VIEW IF EXISTS Award_winning_Movies;

CREATE VIEW Award_winning_Movies
AS
(SELECT  title as Film, start_year as Release_Year, Concat(award_type," - " ,award_name) as Award FROM
titles t
	JOIN awards_info ai on ai.title_id = t.title_id
    JOIN Awards a on a.award_id = ai.award_id
    WHERE is_series = 0 AND is_nominee = 0
    ORDER BY Release_Year DESC);
    
SELECT * FROM Award_winning_Movies;

# Award winning directors
DROP VIEW IF EXISTS Award_winning_Actors;

CREATE VIEW Award_winning_Actors
AS
(
SELECT  a.actor_name as Actor, actor_gender as Gender, Concat(award_type," - " ,award_name)  as Award FROM
Actors a
	JOIN awards_actors aa on aa.actor_name = a.actor_name
    JOIN Awards aw on aw.award_id = aa.award_id
);
    
SELECT * FROM Award_winning_Actors;


# ------------------------------ STORED PROCEDURES AND TRIGGERS ------------------------------------------------------------------
USE NUTFLUX_PROJECT;

#STORED PROCEDURE - GETTING TOP MOVIES BASED ON IMDB RATING : We specify the year and the top number of mmovies you want to fetch. 
DELIMITER //
#DROP PROCEDURE IF EXISTS Top_Rated_Movies_per_Year;
CREATE PROCEDURE  Top_Rated_Movies_per_Year(movie_year int,num_movies int)
BEGIN
    SELECT title,imdb_rating
    FROM Titles
    Where start_year = movie_year and is_series = 0
	ORDER BY imdb_rating desc
	LIMIT num_movies;
END //
DELIMITER ;

CALL Top_Rated_Movies_per_Year(2012,3);

#STORED PROCEDURE - GETTING TOP MOVIES BASED ON GENRE: We specify the genre and the top number of mmovies you want to fetch. 
DELIMITER //
#DROP PROCEDURE IF EXISTS Top_Movies_Based_On_Genre;
CREATE PROCEDURE  Top_Movies_Based_On_Genre(genra CHAR(250),num_movies int)
BEGIN
    SELECT title,imdb_rating
    FROM titles t
    LEFT JOIN Genre_titles tg on tg.title_id = t.title_id 
    WHERE main_genre = genra and is_series = 0
	ORDER BY imdb_rating desc
	LIMIT num_movies;
END //
DELIMITER ;

CALL Top_Movies_Based_On_Genre("Action",3);



#TRIGGER
#DROP trigger if exists Update_known_for_after_award;
DELIMITER //
CREATE TRIGGER Update_known_for_after_award
AFTER INSERT
   ON Awards_Directors FOR EACH ROW
BEGIN
UPDATE Directors SET is_famous_for = CONCAT("Known for directing award winning ", 
(select title FROM Titles WHERE title_id = new.title_id and is_series = 0 ))
WHERE director_name = NEW.director_name;
END //
DELIMITER ;

#CHECKING IF TRIGGER WORKS
SELECT * FROM Awards_Directors WHERE director_name = "Bryan Singer";



# Inserting golden globe award for Bryan Singer for movie superman returns to check if the trigger works

INSERT INTO Awards_Directors (title_id,award_id,is_nominee,director_name) 
VALUES (5, 11, 0, "Bryan Singer");

SELECT * FROM Awards_Directors WHERE director_name = "Bryan Singer";

# see if update has happened
SELECT  director_name, is_famous_for FROM directors
WHERE director_name = "Bryan Singer";

# ------------------------------------- EXAMPLE QUERIES ------------------------------------------
USE NUTFLUX_PROJECT;


# List TV Series that have won Emmy Awards
SELECT t.title,a.award_type FROM titles t
JOIN Awards_info ai on t.title_id = ai.title_id
JOIN Awards a on ai.award_id = a.award_id
WHERE  t.is_series = 1
AND upper(a.award_type) = "EMMY";

# List top 3 female actors who have won the most number awards for movies they have acted in. Who is at the top position? 
SELECT 
a.actor_name,
count(aa.award_id) as Number_of_Awards 
FROM Actors a
JOIN Awards_actors aa on a.actor_name = aa.actor_name
JOIN Awards aw on aa.award_id = aw.award_id
JOIN Casting c on c.actor_name = a.actor_name
JOIN Titles t on t.title_id = c.title_id
WHERE  t.is_series = 0 AND a.actor_gender = "Female"
GROUP BY a.actor_name
ORDER BY Number_of_Awards desc
LIMIT 3;
#Naomie Harris won 3 awards as is at the top position

# Which TV series has least number of episodes?

SELECT title,count(episode_id) as Num_of_Episodes FROM titles t
JOIN Episodes e on t.title_id = e.episode_title_id
GROUP BY title
ORDER BY Num_of_Episodes
LIMIT 1;

# Ranking Nationalities based on cumulative box office grosses for James Bond Movies
select 
  a.actor_nationality as Nationality, 
  SUM(t.gross_earnings_dollars) as Total_gross
from 
  Titles t
  join Casting c on c.title_id = t.title_id 
  join Actors a on a.actor_name = c.actor_name
  join Roles r on r.role_id = c.role_id
where 
  r.role_name = "James Bond"
  group by Nationality
  order by Total_gross desc
  limit 1;
  
# The most profitable nationality of Bond actor is British.

/* The box-office numbers for each film are not adjusted for inflation. They are the original numbers earned for the film when 
it was released. If we assume that inflation is, on average, 3% per year, then rank all films by their inflation-adjusted 
box-office revenues, from the most to the least. */

select Film, 
       Original_Revenue, 
       Num_years, 
       Release_Year,
	   ROUND( Original_Revenue * POW(1+( 3 / 100 ), Num_years) , 2) as Inflation_Adjusted_Current_Revenue
from (
	select t.title as Film,
		   t.gross_earnings_dollars as Original_Revenue, 
		   t.start_year as Release_Year,
		   (cast(year(CURDATE()) as float) - (t.start_year)) as Num_years
	from 
		   Titles t
    ) tbl1
  order by Inflation_Adjusted_Current_Revenue desc;

