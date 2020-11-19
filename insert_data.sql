--insert in publication (работает)
SELECT insert_publication('web developers in real world','Topic about Evgeny A. Tsopa');
SELECT insert_publication('front-end developers in real world','Topic about front-end');
SELECT insert_publication('back-end developers in real world','Topic about back-end');
SELECT insert_publication('UI/UX designers in real world','Topic about UI/UX');
SELECT insert_publication('The activation stack.','Topic about activation in stack');
SELECT insert_publication('The C Language','Topic about C Language');
SELECT insert_publication('Functions in C','Topic about functions');
SELECT insert_publication('Command Line Args','Topic about Line Args');

--inserting cases
INSERT INTO "case" (description, complexity) VALUES ('step 1', 1);
INSERT INTO "case" (description, complexity) VALUES ('step 2', 2);
INSERT INTO "case" (description, complexity) VALUES ('step 3', 3);
INSERT INTO "case" (description, complexity) VALUES ('step 4', 4);
INSERT INTO "case" (description, complexity) VALUES ('step 5', 5);
INSERT INTO "case" (description, complexity) VALUES ('step 6', 6);
INSERT INTO "case" (description, complexity) VALUES ('step 7', 7);
INSERT INTO "case" (description, complexity) VALUES ('step 8', 8);
INSERT INTO "case" (description, complexity) VALUES ('step 9', 9);
INSERT INTO "case" (description, complexity) VALUES ('step 10', 10);
INSERT INTO "case" (description, complexity) VALUES ('final step', 1);

--inserting people
SELECT insert_person('Angela','Henri','1975-01-02','89111111','Henri@mail.ru');
SELECT insert_person('Tony','Stark','1974-11-21','89111112','Stark@mail.ru');
SELECT insert_person('Eugen','Forest','1990-03-01','89111113','Forest@mail.ru');
SELECT insert_person('Freddie','Mercury','1946-09-04','89111114','Mercury@mail.ru');
SELECT insert_person('Adam','Lambert','1976-04-03','89111115','Lambert@mail.ru');
SELECT insert_person('Megan','Cornelius','1977-03-04','89111116','Corny@mail.ru');
SELECT insert_person('Rob','Stuart','1978-04-05','89111117','Styart@mail.ru');
SELECT insert_person('Jim','Moriarty','1979-05-06','89111118','Jim@mail.ru');
SELECT insert_person('Molly','Hooper','1980-06-07','89111119','Molly@mail.ru');
SELECT insert_person('Iren','Adler','1981-07-08','89111110','Iren@mail.ru');
SELECT insert_person('John','Watson','1982-08-09','89111121','John@mail.ru');
SELECT insert_person('Greg','Lestrade','1988-09-10','89111131','Greg@mail.ru');

--insert in people_publication (работает)
SELECT add_publication(5,1);
SELECT add_publication(6,2);
SELECT add_publication(7,3);
SELECT add_publication(8,4);
SELECT add_publication(9,5);
SELECT add_publication(10,6);
SELECT add_publication(11,7);
SELECT add_publication(12,8);

--inserting platforms
INSERT INTO platform (name, address, contact_person_id) VALUES ('main building', 'Kronverkskiy 49', 1);
INSERT INTO platform (name, address, contact_person_id) VALUES ('lomo', 'Lomonosova 9', 2);
INSERT INTO platform (name, address, contact_person_id) VALUES ('birzha', 'Birzhevaya line 14', 3);
INSERT INTO platform (name, address, contact_person_id) VALUES ('chaika', 'Chiakovskogo 25', 4);

--inserting championship
SELECT insert_championship('first champ','Just first championship','{1,2,3,4}','{2,1}');
SELECT insert_championship('second champ','Just second championship','{4,5,6,7}','{2,3}');
SELECT insert_championship('third champ','Just third championship','{7,8,9,10,11}','{4}');

--insert participants
SELECT insert_participant('James','Adams','2000-07-8',1,'89765432','Adams@mail.ru');
SELECT insert_participant('Mary','Allen','1999-07-9',1, '87654321', 'Allen@mail.ru');
SELECT insert_participant('John','Anderson','2000-11-9',1, '87654323', 'test@test.com');
SELECT insert_participant('Patricia','Armstrong','2000-09-29',1,'87654322', 'test1@test.com');
SELECT insert_participant('Robert','Atkinson','1998-03-13',1, '87654324', 'test2@test.com');
SELECT insert_participant('Janifer','Bailey','2000-02-07',1, '87654325', 'test3@test.com');
SELECT insert_participant('Michael','Baker','1995-10-23',1, '87654326', 'test4@test.com');
SELECT insert_participant('Linda','Ball','2000-06-10',1, '87654327', 'test5@test.com');
SELECT insert_participant('William','Barker','1999-06-11',1, '87654328', 'test6@test.com');
SELECT insert_participant('Elizabeth','Barnes','1999-06-11',1, '87654329', 'test7@test.com');
SELECT insert_participant('David','Bell','1999-05-12',1, '87654320', 'test8@test.com');
SELECT insert_participant('Barbara','Bennet','1999-05-12',1, '87654311', 'test9@test.com');
SELECT insert_participant('Richard','Booth','1999-04-13',1, '87654331', 'test10@test.com');
SELECT insert_participant('Susan','Bradley','1999-04-13',1, '87654341', 'test11@test.com');
SELECT insert_participant('Joseph','Brooks','1999-04-14',1, '87654351', 'test12@test.com');
SELECT insert_participant('Jessica','Brown','1998-04-14',1, '87654361', 'test13@test.com');
SELECT insert_participant('Thomas','Burton','1998-04-15',1, '87654371', 'test14@test.com');
SELECT insert_participant('Sarah','Butler','1998-03-15',1, '87654381', 'test15@test.com');
SELECT insert_participant('Carles','Campbell','1997-03-16',1, '87654391', 'test16@test.com');
SELECT insert_participant('Karen','Carter','1997-03-16',1, '87654301', 'test17@test.com');
SELECT insert_participant('Christoper','Chapman','1997-03-17',1, '87654121', 'test18@test.com');
SELECT insert_participant('Nancy','Clarke','1997-03-17',1, '87654221', 'test19@test.com');
SELECT insert_participant('Daniel','Cole','1996-03-18',1, '87654421', 'test20@test.com');
SELECT insert_participant('Lisa','Collins','1996-02-18',1, '87654521', 'test21@test.com');
SELECT insert_participant('Matthew','Cook','1996-02-19',1, '87654621', 'test22@test.com');
SELECT insert_participant('Margaret','Cooper','1996-02-19',1, '87654721', 'test23@test.com');
SELECT insert_participant('Anthony','Corbyn','1995-02-20',1, '87654821', 'test24@test.com');
SELECT insert_participant('Betty','Cox','1995-01-22',1, '87654921', 'test25@test.com');
SELECT insert_participant('Donald','Davidson','1995-01-23',1, '87654021', 'test26@test.com');
SELECT insert_participant('Sandra','Davies','1995-01-24',1, '87651321', 'test27@test.com');
SELECT insert_participant('Mark','Dawson','2001-01-25',1, '87652321', 'test28@test.com');
SELECT insert_participant('Ashley','Dixon','2001-01-28',1, '87653321', 'test29@test.com');
SELECT insert_participant('Paul','Edwards','2001-10-1',1, '87655321', 'test30@test.com');
SELECT insert_participant('Dorothy','Elliott','2001-10-1',2, '87656321', 'test31@test.com');
SELECT insert_participant('Steven','Evans','2002-10-1',2, '87657321', 'test32@test.com');
SELECT insert_participant('Kimberly','Fisher','2002-10-1',2, '87658321', 'test33@test.com');
SELECT insert_participant('Andrew','Ford','2002-10-2',2, '87659321', 'test34@test.com');
SELECT insert_participant('Emily','Foster','2002-10-2',2, '87650321', 'test35@test.com');
SELECT insert_participant('Kenneth','Fox','2000-12-3',2, '87614321', 'test36@test.com');
SELECT insert_participant('Donna','Gibson','2000-12-3',2, '87624321', 'test37@test.com');
SELECT insert_participant('Joshua','Graham','2000-12-4',2, '87634321', 'test38@test.com');
SELECT insert_participant('Michelle','Grant','2000-11-4',2, '87644321', 'test39@test.com');
SELECT insert_participant('Kevin','Gray','2000-11-5',3, '87664321', 'test40@test.com');
SELECT insert_participant('Carol','Green','2000-11-5',3, '87674321', 'test41@test.com');
SELECT insert_participant('Brian','Griffiths','2000-09-6',3, '87684321', 'test42@test.com');
SELECT insert_participant('Amanda','Hall','2000-09-6',2, '87694321', 'test43@test.com');
SELECT insert_participant('George','Hamilton','2000-09-7',2, '87604321', 'test44@test.com');
SELECT insert_participant('Melissa','Harris','2000-08-7',2, '87154321', 'test45@test.com');
SELECT insert_participant('Edward','Harrison','2000-08-8',2, '87254321', 'test46@test.com');

--insert teams (массив)
SELECT insert_team('fifth','{14,15,16,17}',14,1);
SELECT insert_team('six','{18,19,20,21}',19,1);
SELECT insert_team('seventh','{22,23,24,25}',23,1);
SELECT insert_team('eighth','{26,27,28,29}',26,1);
SELECT insert_team('nine','{30,31,32}',30,1);
SELECT insert_team('ten','{34,33}',34,1);
SELECT insert_team('help','{35,36,37,38}',35,2);
SELECT insert_team('to','{39,40,13}',39,2);
SELECT insert_team('my','{41,42,43}',41,2);
SELECT insert_team('imagination','{50,49,48,47}',49,3);

--inserting mentor
INSERT INTO mentor (person_id, championship_id) VALUES (5,1);
INSERT INTO mentor (person_id, championship_id) VALUES (6,1);
INSERT INTO mentor (person_id, championship_id) VALUES (7,2);
INSERT INTO mentor (person_id, championship_id) VALUES (8,2);
INSERT INTO mentor (person_id, championship_id) VALUES (9,2);

--adding mentor to the team
SELECT add_mentor_to_team(5,1,1);
SELECT add_mentor_to_team(6,1,2);
SELECT add_mentor_to_team(8,2,8);
SELECT add_mentor_to_team(9,2,9);

--creating projects
SELECT insert_project('project1',1,'{1,2}','the best project ever');
SELECT insert_project('project2',2,'{1,2,3}','the best project ever');
SELECT insert_project('project3',3,'{1,4,7,10}','the best project ever');
SELECT insert_project('project4',4,'{1,2,9}','the best project ever');
SELECT insert_project('project5',5,'{1,2,5}','the best project ever');
SELECT insert_project('project6',6,'{1,6,4}','the best project ever');
SELECT insert_project('project7',7,'{3,6,9}','the best project ever');
SELECT insert_project('project8',8,'{3,5,8,9,10}','the best project ever');
SELECT insert_project('project9',9,'{1,3,5}','the best project ever');
SELECT insert_project('project10',10,'{1,2,7}','the best project ever');

--fixme нет, он не может припихнуть ментору id созданной команды
-- ERROR: query "SELECT insert_team(name, participants, leader_id, championship_id) INTO team_number" is not a SELECT

--SELECT insert_team_with_mentor('dreamTeam','{13,35,36,37}','{5}',13,1);

--inserting judges
INSERT INTO judge (person_id, championship_id, work) VALUES (7,1,'LicuidCo');
INSERT INTO judge (person_id, championship_id, work) VALUES (8,1,'JobCo');
INSERT INTO judge (person_id, championship_id, work) VALUES (9,1,'CodeCo');;
INSERT INTO judge (person_id, championship_id, work) VALUES (7,3,'LicuidCo');
INSERT INTO judge (person_id, championship_id, work) VALUES (8,3,'JobCo');
INSERT INTO judge (person_id, championship_id, work) VALUES (9,3,'CodeCo');

--adding cases
SELECT add_case_to_championship(1,1);
SELECT add_case_to_championship(1,2);
SELECT add_case_to_championship(1,3);
SELECT add_case_to_championship(1,4);
SELECT add_case_to_championship(1,5);
SELECT add_case_to_championship(1,6);
SELECT add_case_to_championship(1,7);
SELECT add_case_to_championship(1,8);
SELECT add_case_to_championship(1,9);
SELECT add_case_to_championship(1,10);
SELECT add_case_to_championship(1,11);
SELECT add_case_to_championship(3,1);
SELECT add_case_to_championship(3,2);
SELECT add_case_to_championship(3,3);
SELECT add_case_to_championship(3,4);
SELECT add_case_to_championship(3,5);
SELECT add_case_to_championship(3,6);
SELECT add_case_to_championship(3,7);
SELECT add_case_to_championship(3,8);
SELECT add_case_to_championship(3,9);
SELECT add_case_to_championship(3,10);
SELECT add_case_to_championship(3,11);

--inserting judges
SELECT insert_judge_team('{7,8,9}',1);
SELECT insert_judge_team('{7,8,9}',3);


--inserting performances (работает)
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (1,'2020-03-16 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (2,'2020-03-13 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (3,'2020-03-13 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (4,'2020-03-13 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (5,'2020-03-14 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (6,'2020-03-15 10:30:00',1,1);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (7,'2020-03-16 10:30:00',1,2);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (8,'2020-03-17 10:30:00',1,2);
INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (9,'2020-03-18 10:30:00',1,2);

--starting championship
SELECT start_championship(1);
--rating performances
SELECT rate_performance(1,2);
SELECT rate_performance(2,2);
SELECT rate_performance(3,0.01);
SELECT rate_performance(4,4);
SELECT rate_performance(5,5);
SELECT rate_performance(6,1);

--ending championships
SELECT end_championship(1);
