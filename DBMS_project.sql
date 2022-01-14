USE dbms;
CREATE TABLE Person(
 ID int NOT NULL,
 Name VARCHAR(255) NOT NULL,
 Gender VARCHAR(5) NOT NULL,
 Height VARCHAR(10),
 Weight VARCHAR(10),
 PRIMARY KEY (ID)
);
CREATE TABLE Medals (
ID INTEGER ,
MedalName varchar(255) not null,
PRIMARY KEY (ID)
);

CREATE TABLE Games (
ID varchar(255),
Name varchar(255) NOT NULL,
Year integer NOT NULL,
Season varchar(255) NOT NULL,
constraint gameID_pk PRIMARY KEY (ID)
);

CREATE TABLE Sport (
ID varchar(255),
Name varchar(255) NOT NULL,
constraint sport_pk PRIMARY KEY (ID)
);

CREATE TABLE City(
ID varchar(255),
City varchar(255),
constraint c1D_pk PRIMARY KEY (ID)
);

CREATE TABLE Country (
ID INTEGER,
Country_Team varchar(255) not null,
NOC varchar(255) not null,
PRIMARY KEY (ID)
);

CREATE TABLE Olympics(
    ID Integer,
    Age INTEGER,
    Game_Id varchar(255),
    player_id INTEGER,
    CONSTRAINT fk_sup1 FOREIGN KEY (player_id) REFERENCES Person(ID),
    CONSTRAINT fk_sup2 FOREIGN KEY (Game_Id) REFERENCES Games(ID),
    PRIMARY KEY (ID)
);



CREATE TABLE Person_Country (
Country_ID Integer,
Person_ID Integer,
constraint Country_ID_fk foreign key (Country_ID) references Country (ID),
constraint Person_ID_fk foreign key (Person_ID) references Person (ID),
constraint pk_34 primary key (Country_ID,Person_ID)
);

CREATE TABLE Events(
ID INTEGER,
Events varchar(255) NOT NULL,
Sport varchar(255),
constraint EventsID_pk PRIMARY KEY (ID),
constraint Sport_fk FOREIGN KEY (Sport) REFERENCES Sport(ID)
);

CREATE TABLE Games_City (
Game_ID  varchar(255),
City_ID  varchar(255),
constraint c_1 FOREIGN KEY (Game_ID) REFERENCES Games(ID),
constraint c_2 FOREIGN KEY (City_ID) REFERENCES City(ID),
constraint pk_35 primary key (Game_ID,City_ID)
);

CREATE TABLE Olympic_Event (
Olympics_ID Integer,
Medal_ID Integer,
Event_ID Integer,
constraint fk_olym Foreign Key (Olympics_ID) References Olympics(ID),
constraint fk_med Foreign Key (Medal_ID) References Medals(ID),
constraint fk_eve Foreign Key (Event_ID) References Events(ID),
constraint pk_37 primary key (Olympics_ID, Medal_ID, Event_ID)
);

drop table olympic_event;
drop table events;
drop table GAMES_CITY;
drop table olympics;
drop table person_country;
drop table Country;
drop table city;
drop table sport;
drop table games;
drop table medals;
drop table Person;

select count(*) from olympics;
select @@sql_mode;
set sql_mode = '';

Create database DBMS;

Alter table person_country
add constraint pk_34 primary key (Country_ID,Person_ID);




Alter table olympic_event
add constraint fk_olym Foreign Key (Olympics_ID) References Olympics(ID),
add constraint fk_med Foreign Key (Medal_ID) References Medals(ID),
add constraint fk_eve Foreign Key (Event_ID) References Events(ID);

add CONSTRAINT fk_sup1 FOREIGN KEY (player_id) REFERENCES Person(ID),
add CONSTRAINT fk_sup2 FOREIGN KEY (Game_Id) REFERENCES Games(ID),
add CONSTRAINT fk_sup3 FOREIGN KEY (Country_ID) REFERENCES Country(ID),
add CONSTRAINT PRIMARY KEY (ID);
add constraint pk_47 primary key (Olympics_ID, Medal_ID, Event_ID);
Alter table medals
add CONSTRAINT PRIMARY KEY (ID);
add CONSTRAINT fk_sup4 FOREIGN KEY (player_id) REFERENCES person(ID);

delete from city where ID='ID';
ALter table olympics Modify column Age varchar(255);

Alter table olympics
add constraint unq_value UNIQUE (Age,Country_ID,Game_ID,player_id);


# Query 1
SELECT Year, count(player_ID) as total_count
From(
SELECT DISTINCT o.player_ID, g.Year
from olympics o,games g
where o.Game_Id = g.ID and o.Country_ID in (Select ID
											from country
											where NOC='USA')) t
GROUP BY Year
Order BY Year;
         
#Query 2
SELECT Year, count(country_ID) as total_medal
From(
SELECT DISTINCT g.Year, o.country_ID, Event_ID, medal_id
from olympics o, olympic_event oe, games g
Where o.Game_Id = g.ID and oe.Olympics_ID = o.ID and Medal_ID != 3 and o.Country_ID in (Select ID
																			from country
																			where NOC='USA'))t
Group By Year
Order By Year;

#Query 3

Select m.year, male, female
FROM
(Select year, count(gender) as male
from (
Select Distinct year, gender, player_id
from player_gender
where gender = 'M' and Country_ID in (Select ID
										from country
										where NOC='USA'))t
Group by year
order by year) m,
(Select year, count(gender) as female
from (
Select Distinct year, gender, player_id
from player_gender
where gender = 'F' and Country_ID in (Select ID
										from country
										where NOC='USA'))t
Group by year
order by year) f
Where m.year = f.year;


Select m.year, male, female
FROM
(Select year, count(gender) as male
from (
Select Distinct g.year, p.gender, p.ID
from olympics o, games g, person p
where  o.Game_Id = g.ID and o.player_id = p.ID and p.gender = 'M' and o.Country_ID in (Select ID
																			from country
																			where NOC='USA'))t
Group by year
order by year) m,
(Select year, count(gender) as female
from (
Select Distinct g.year, p.gender, p.ID
from olympics o, games g, person p
where  o.Game_Id = g.ID and o.player_id = p.ID and p.gender = 'F' and o.Country_ID in (Select ID
																			from country
																			where NOC='USA'))t
Group by year
order by year) f
Where m.year = f.year;

Select * from player_gender

SELECT t.year, male, female FROM( Select year, count(distinct player_id) as m from player_gender where gender = 'M' and year = '2016' and Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Swimming'))t JOIN  (Select year, count(distinct player_id) as f from player_gender where gender = 'F' and year = '2016' and Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Swimming')) k ON t.year = k.year


#View 1

Create view player_gender as
Select g.year, o.player_id, oe.Event_ID, o.Country_ID, p.gender
from olympics o, olympic_event oe, person p, games g
where o.Game_Id = g.ID and o.ID = oe.Olympics_ID and o.player_id = p.ID

#Query 4

(Select m.year, m.male,f.female
From
(SELECT year, count(player_id) as male
From(
Select DISTINCT year, player_id, Event_ID
from player_gender
where gender = 'M' and Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')) t
Group by Year
Order by Year ) m
LEFT Join 
(SELECT year, count(player_id) as female
From(
Select DISTINCT year, player_id, Event_ID
from player_gender
where gender = 'F' and Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')) t
Group by Year
Order by Year) f
ON m.year = f.year)


(Select m.year, m.male,f.female
From
(SELECT year, count(player_id) as male
From(
Select DISTINCT g.year, o.player_id, oe.Event_ID
from olympics o, olympic_event oe, person p, games g
where o.Game_Id = g.ID and o.ID = oe.Olympics_ID and o.player_id = p.ID and gender = 'M' and oe.Event_ID in
 (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling'))t
Group by Year
Order by Year ) m
LEFT Join 
(SELECT year, count(player_id) as female
From(
Select DISTINCT g.year, o.player_id, oe.Event_ID
from olympics o, olympic_event oe, person p, games g
where o.Game_Id = g.ID and o.ID = oe.Olympics_ID and o.player_id = p.ID and gender = 'F' and oe.Event_ID in 
(Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling'))t
Group by Year
Order by Year) f
ON m.year = f.year)

#Query 5
SELECT year, count(Medal_ID) as country_medal
From(
SELECT DISTINCT g.year, oe.event_ID, o.player_ID, oe.Medal_ID
from olympics o, olympic_event oe, games g
where  o.Game_Id = g.ID and o.ID = oe.olympics_ID and oe.Medal_ID != 3 and o.Country_ID in
 (Select ID from country where NOC='USA')and oe.Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')
) t
GROUP BY year
Order BY year

#Query 6

select age, count(player_id) as total
from (
Select distinct age, player_id, Event_ID
from player_event 
where Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')
) t
group by age
Having age <> '' 
order by age

select age, count(player_id) as total
from(
Select distinct age, player_id, Event_ID
from olympics o, olympic_event oe, person p
where o.ID = oe.olympics_ID and o.player_id = p.ID and oe.Event_ID in
 (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')

)t
group by age
Having age <> '' 
order by age

#Query 7

select age, count(player_id) as total
from (
Select distinct age, player_id, Event_ID
from player_event 
where Country_ID in (Select ID from country where NOC='USA') 
) t
group by age
Having age <> '' 
order by age

select age, count(player_id) as total
from(
Select distinct age, player_id, Event_ID
from olympics o, olympic_event oe, person p
where o.ID = oe.olympics_ID and o.player_id = p.ID and o.Country_ID in (Select ID from country where NOC='USA')

)t
group by age
Having age <> '' 
order by age

#QUery 8


select age, count(player_id) as total
from (
Select distinct age, player_id, Event_ID
from player_event 
where Country_ID in (Select ID from country where NOC='USA') 
and Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')
) t
group by age
Having age <> '' 
order by age

select age, count(player_id) as total
from(
Select distinct age, player_id, Event_ID
from olympics o, olympic_event oe, person p
where o.ID = oe.olympics_ID and o.player_id = p.ID and o.Country_ID in 
(Select ID from country where NOC='USA') and oe.Event_ID in (Select e.ID from events e, sport s where e.sport = s.ID and s.Name = 'Wrestling')

)t
group by age
Having age <> '' 
order by age

Error Code: 1064. You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version for the right syntax to use near 'FULL Join (SELECT year, count(player_id) as female From( Select DISTINCT g.year,' at line 10

                                                                            

select final_table.sportName, final_table.year, count(if(final_table.gender = 'M', 1, null)) as male, count(if(final_table.gender = 'F', 1, null)) as female, count(if(final_table.gender != 'F' and final_table.gender !='M', 1, null)) as error from 
(
        select oly_per_olyeve_eve_game.gender, (select year from games g where oly_per_olyeve_eve_game.game_id = g.ID) as year,  (select s.Name from sport s where s.ID = oly_per_olyeve_eve_game.sport) as sportName from         
                (
                        select oly_per_olyeve.Olympics_ID, oly_per_olyeve.event_id, oly_per_olyeve.player_id, oly_per_olyeve.game_id, oly_per_olyeve.gender, e.sport from events e join
                        (
                                select oe.Olympics_ID, oe.event_id, op.player_id, op.game_id, op.gender from olympic_event oe join 
                                (
                                select o.id as oid, p.id as player_id, o.game_id as game_id, p.gender as gender from Olympics o join person p on o.player_id = p.id 
                                ) as op on oe.olympics_id = op.oid
                        ) as oly_per_olyeve on oly_per_olyeve.event_id = e.id
                ) as oly_per_olyeve_eve_game
) as final_table group by final_table.sportName, final_table.year having final_table.sportName = 'Wrestling';



SELECT c.NOC, g.Name,  count(mix.Medal_ID) as Medals_Won
from(
	Select DISTINCT Medal_ID, Country_ID, Game_ID, Event_ID from olympic_event oe, olympics o
	where oe.olympics_ID = o.ID 
) mix, country c, games g
where mix.country_ID = c.ID and mix.Game_ID = g.ID
GROUP BY c.NOC, g.Name
HAVING NOC = 'USA'
ORDER BY Name;


select * from person where id = 3858;

Create View participant As
select c.NOC, g.Year, sum(mix.count) as total_count
from(
select country_ID, Game_Id, count(*) as count
from  olympics o
Group BY country_ID,Game_Id) mix, country c, games g
where mix.country_ID = c.ID and g.ID = mix.Game_Id
GROUP BY c.NOC, g.Year
ORDER BY Year;

Select * from participant;
Call total_participant();

select final_table.year, final_table.noc, final_table.sportName, count(medal_id)  from
(
        select games_oly_noc_olyeve.medal_id,
        CASE 
                WHEN games_oly_noc_olyeve.medal_id = 0 THEN "Gold"
                WHEN games_oly_noc_olyeve.medal_id = 1 THEN "Silver"
                WHEN games_oly_noc_olyeve.medal_id = 2 THEN "Bronze"
        END medal
        , games_oly_noc_olyeve.year, games_oly_noc_olyeve.noc, e.sport as sportID, (select s.name from sport s where s.id = e.sport) as sportName
        from events e join 
        (
                select games_olympics_country.olympic_id as olympic_id, oe.medal_id as medal_id, oe.event_id as event_id, games_olympics_country.year as year, 
                games_olympics_country.noc as noc 
                from olympic_event oe join 
                (
                        select g.ID as game_id, g.year, o.id as olympic_id, o.country_id, (select noc from country c where c.ID = o.Country_ID) as NOC from 
                        games g join olympics o on o.game_id = g.id
                ) as games_olympics_country on oe.olympics_ID = games_olympics_country.olympic_id 
                -- where oe.medal_id = 0
        ) as games_oly_noc_olyeve on games_oly_noc_olyeve.event_id = e.id
) as final_table group by final_table.year, final_table.noc, final_table.sportName having noc = 'USA' and sportName = 'Wrestling'
;

#View 2

CREATE VIEW player_event as
Select age, player_id, Event_ID,  oe.olympics_ID, o.Country_ID
from olympics o, olympic_event oe, person p
where o.ID = oe.olympics_ID and o.player_id = p.ID

use dbms;
SELECT * FROM DBMS.Games;

DELIMITER $$
create trigger year_check
before insert on Games
for each row
Begin
	DECLARE rowcount int;
    SELECT count(*) into rowcount
    FROM Games
    WHERE year = new.year;
    IF rowcount > 0 THEN
        signal sqlstate '45000' set message_text = 'MyTriggerError: Trying to insert a year that already exists ';
	END IF;
End $$

DELIMITER ;

INSERT INTO GAMES
VALUES('G70','2020 Summer', 2016, 'Summer')

Drop Trigger age_check

DELIMITER $$
create trigger age_check
before insert on olympics
for each row
Begin
	
    IF new.age <0 THEN
        signal sqlstate '45000' set message_text = 'MyTriggerError: Trying to insert age less than zero ';
	END IF;
End $$

DELIMITER ;

INSERT INTO olympics
VALUES(36709823,'-1',3,'G12',6)

drop view player_event;
select distinct(final_table.medal), final_table.year, final_table.noc, final_table.sportName, count(medal_id) over (partition by medal_id, year, noc, sportName) as cnt_medal from (select games_oly_noc_olyeve.medal_id, CASE WHEN games_oly_noc_olyeve.medal_id = 0 THEN 'Gold' WHEN games_oly_noc_olyeve.medal_id = 1 THEN 'Silver' WHEN games_oly_noc_olyeve.medal_id = 2 THEN 'Bronze' END medal, games_oly_noc_olyeve.year, games_oly_noc_olyeve.noc, e.sport as sportID, (select s.name from sport s where s.id = e.sport) as sportName from events e join (select games_olympics_country.olympic_id as olympic_id, oe.medal_id as medal_id, oe.event_id as event_id, games_olympics_country.year as year,games_olympics_country.noc as noc from olympic_event oe join (select g.ID as game_id, g.year, o.id as olympic_id, o.country_id, (select noc from country c where c.ID = o.Country_ID) as NOC from games g join olympics o on o.game_id = g.id) as games_olympics_country on oe.olympics_ID = games_olympics_country.olympic_id) as games_oly_noc_olyeve on games_oly_noc_olyeve.event_id = e.id) as final_table having noc = 'USA' and year = '2016' and sportName = 'Wrestling'


