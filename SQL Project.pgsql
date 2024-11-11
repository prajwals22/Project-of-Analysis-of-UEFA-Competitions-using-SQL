-- Q.1 Count the total number of Teams
Select COUNT(*) as total_count From Teams;

-- Q.2 Find the Number of Teams per Country
Select country, COUNT(*) as team_count 
From Teams GROUP BY country;

-- Q.3 Calculate the Average Team Name Length
Select Avg(Length(team_name)) as average_team_name_length
From Teams;

-- Q.4 Calculate the Average Stadium Capacity in Each Country round it off and sort by the total stadiums in the country.
Select country,
round(avg(capacity)) as avg_capacity,
count(*) as total_stadium
From stadiums Group by country 
order by total_stadium ASC;

-- Q.5 Calculate the Total Goals Scored.
Select Count(*) as total_count From goals;

-- Q.6 Find the total teams that have city in their names
Select Count(*) as teams_with_city_name From teams
where team_name ILIKE '%city';

-- Q.7 Use Text Functions to Concatenate the Team's Name and Country
Select team_name || ' ' || country as team_info From teams; 

-- Q.8 What is the highest attendance recorded in the dataset, and which match (including home and away teams, and date) does it correspond to?
Select match_id, home_team, away_team, date, attendance From matches
Where attendance = (SELECT max(attendance) From Matches);

-- Q.9 What is the lowest attendance recorded in the dataset, and which match (including home and away teams, and date) does it correspond to set the criteria as greater than 1 as some matches had 0 attendance because of covid.
Select match_id, home_team, away_team, date, attendance From matches
Where attendance > 1 and attendance = (SELECT min(attendance) From matches);

-- Q.10 Identify the match with the highest total score (sum of home and away team scores) in the dataset. Include the match ID, home and away teams, and the total score.
Select match_id, home_team, away_team, home_team_score + away_team_score 
as total_score From matches
order by total_score desc limit 1;

-- Q.11 Find the total goals scored by each team, distinguishing between home and away goals. Use a CASE WHEN statement to differentiate home and away goals within the subquery.
Select team_name, 
sum(case when home_team = team_name then home_team_score else 0 end) as home_goals,
sum(case when away_team = team_name then away_team_score else 0 end) as away_goals
From matches join teams on home_team = team_name or away_team = team_name
group by team_name;

-- Q.12 windows function - Rank teams based on their total scored goals (home and away combined) using a window function.In the stadium Old Trafford.
Select team_name,
RANK() OVER (order by total_goals DESC) as Rank, total_goals
From (Select team_name,
        sum(home_team_score + away_team_score) as total_goals
    From matches
    JOIN Teams ON (home_team = team_name OR away_team = team_name)
    WHERE stadium = 'Old Trafford'
    GROUP BY team_name)
    ranked_teams;

-- Q.13 TOP 5 l players who scored the most goals in Old Trafford, ensuring null values are not included in the result (especially pertinent for cases where a player might not have scored any goals).
Select p.player_id, p.first_name, p.last_name, COUNT(g.goal_id) as total_goals
From Players p
JOIN Goals g on p.player_id = g.pid
JOIN Matches m on g.match_id = m.match_id
WHERE m.stadium = 'Old Trafford'
GROUP BY p.player_id
ORDER BY total_goals DESC
LIMIT 5;

-- Q.14 Write a query to list all players along with the total number of goals they have scored. Order the results by the number of goals scored in descending order to easily identify the top 6 scorers.
Select p.player_id, p.first_name, p.last_name, COUNT(g.goal_id) as total_goals
FROM Players p
LEFT JOIN Goals g on p.player_id = g.pid
GROUP BY p.player_id
ORDER BY total_goals DESC
LIMIT 6;

-- Q.15 Identify the Top Scorer for Each Team - Find the player from each team who has scored the most goals in all matches combined. This question requires joining the Players, Goals, and possibly the Matches tables, and then using a subquery to aggregate goals by players and teams.
Select team, player_id, first_name, last_name, MAX(goal_count) as top_goals
FROM (
    Select p.player_id, p.first_name, p.last_name, p.team, COUNT(g.goal_id) as goal_count
    FROM Players p
    JOIN Goals g on p.player_id = g.pid
    GROUP BY p.player_id, p.first_name, p.last_name, p.team
) as player_goals
GROUP BY team, player_id, first_name, last_name
ORDER BY top_goals DESC;

-- 16)Find the Total Number of Goals Scored in the Latest Season - Calculate the total number of goals scored in the latest season available in the dataset. This question involves using a subquery to first identify the latest season from the Matches table, then summing the goals from the Goals table that occurred in matches from that season.

SELECT SUM(home_team_score + away_team_score) AS total_goals
FROM Matches
WHERE season = (SELECT MAX(season) FROM Matches);


--17)Find Matches with Above Average Attendance - Retrieve a list of matches that had an attendance higher than the average attendance across all matches. This question requires a subquery to calculate the average attendance first, then use it to filter matches.

WITH avg_attendance AS (
    SELECT AVG(attendance) AS average_attendance
    FROM Matches
)
SELECT match_id, home_team, away_team, attendance
FROM Matches
WHERE attendance > (SELECT average_attendance FROM avg_attendance);


