Create Table Teams(
	team_name varchar,
	country varchar,
	home_stadium varchar
);
Select * From teams
Copy teams from 'D:\Cuvette\Data Science\SQL\Project\Teams.csv' CSV header;

Create Table Matches(
	match_id varchar primary key,
	season varchar,
	date date,
	home_team varchar,
	away_team varchar, 
	stadium varchar,
	home_team_score int,
	away_team_score int,
	penalty_shoot boolean,
	attendance int
);
Select * From Matches;
Copy matches from 'D:\Cuvette\Data Science\SQL\Project\Matches.csv' CSV header;


Create Table Players(
	player_id varchar primary key,
	first_name varchar,
	last_name varchar,
	nationality varchar,
	dob date,
	team varchar, 
	jersey_number int,
	position varchar,
	height decimal,
	weight decimal,
	foot char
);
Select * From Players;
Copy players from 'D:\Cuvette\Data Science\SQL\Project\Players.csv' CSV header;


Create Table Stadiums(
	name varchar,
	city varchar,
	country varchar,
	capacity int
);
Select * From stadiums;
Copy stadiums from 'D:\Cuvette\Data Science\SQL\Project\Stadiums.csv' CSV header;

Create Table Goals(
	goal_id varchar primary key,
	match_id varchar Not Null,
	pid varchar,
	duration int,
	assist varchar,
	goal_desc varchar
)
Select * From Goals;
Copy goals from 'D:\Cuvette\Data Science\SQL\Project\Goals.csv' CSV header;

