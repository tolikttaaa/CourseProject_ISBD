CREATE TABLE people
(
    person_id  serial PRIMARY KEY,
    first_name text NOT NULL,
    last_name  text NOT NULL,
    birth_date date NOT NULL CHECK (birth_date <= NOW())
);

-- function that return age of the person by his ID
CREATE OR REPLACE FUNCTION people_age(person integer) RETURNS integer AS
$$
DECLARE
    age integer;

BEGIN
    SELECT date_part('year', age(birth_date))
    INTO age
    FROM people
    WHERE person_id = person;

    RETURN age;
END;

$$ LANGUAGE plpgSQL;

CREATE TABLE publication
(
    publication_id serial PRIMARY KEY,
    name           text NOT NULL,
    description    text
);

CREATE TABLE email
(
    email     text PRIMARY KEY,
    person_id integer REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE phone
(
    phone_number text PRIMARY KEY NOT NULL,
    person_id    integer REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE championship
(
    championship_id serial PRIMARY KEY,
    name            text NOT NULL,
    description     text,
    begin_date      date DEFAULT NULL,
    end_date        date DEFAULT NULL
);

CREATE TABLE team
(
    team_id         serial PRIMARY KEY,
    name            text,
    leader_id       integer,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE
);

CREATE TABLE platform
(
    platform_id       serial PRIMARY KEY,
    name              text    NOT NULL,
    address           text    NOT NULL,
    contact_person_id integer REFERENCES people (person_id) ON DELETE SET NULL
);

CREATE TABLE judge_team
(
    judge_team_id serial PRIMARY KEY
);

CREATE TABLE participant
(
    person_id       integer REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    team_id         integer REFERENCES team (team_id) ON DELETE SET NULL,
    PRIMARY KEY (person_id, championship_id)
);

CREATE TABLE mentor
(
    person_id       integer REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, championship_id)
);

CREATE TABLE score
(
    team_id       integer REFERENCES team (team_id) ON DELETE CASCADE,
    final_score   real,
    place         integer,
    special_award text
);

CREATE TABLE project
(
    project_id  serial PRIMARY KEY,
    name        text NOT NULL,
    team_id     integer REFERENCES team (team_id) ON DELETE CASCADE,
    description text
);

CREATE TABLE performance
(
    performance_id   serial PRIMARY KEY,
    project_id       integer REFERENCES project (project_id) ON DELETE CASCADE,
    performance_time timestamp,
    judge_team_id    integer REFERENCES judge_team (judge_team_id) ON DELETE SET NULL,
    platform_id      integer REFERENCES platform (platform_id) ON DELETE SET NULL,
    points           real DEFAULT NULL
);

CREATE TABLE "case"
(
    case_id     serial PRIMARY KEY,
    description text    NOT NULL,
    complexity  integer NOT NULL
);

CREATE TABLE judge
(
    person_id       integer REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    work            text,
    judge_team_id   integer REFERENCES judge_team (judge_team_id) ON DELETE SET NULL,
    PRIMARY KEY (person_id, championship_id)
);

-- Many to many relationship tables

CREATE TABLE championship_case
(
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    case_id         integer REFERENCES "case" (case_id) ON DELETE CASCADE
);

CREATE TABLE championship_platform
(
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    platform_id     integer REFERENCES platform (platform_id) ON DELETE CASCADE
);

CREATE TABLE project_case
(
    project_id integer REFERENCES project (project_id) ON DELETE CASCADE,
    case_id    integer REFERENCES "case" (case_id) ON DELETE CASCADE
);

CREATE TABLE mentor_team
(
    person_id       integer NOT NULL,
    championship_id integer NOT NULL,
    FOREIGN KEY (person_id, championship_id) REFERENCES mentor (person_id, championship_id) ON DELETE CASCADE,
    team_id         integer REFERENCES team (team_id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, team_id)
);

CREATE TABLE people_publication
(
    person_id      integer REFERENCES people (person_id) ON DELETE CASCADE,
    publication_id integer REFERENCES publication (publication_id) ON DELETE CASCADE
);

-- insert fully new participant
CREATE OR REPLACE FUNCTION insert_participant(first_name text,
                                              last_name text,
                                              birth_date date,
                                              championship_id integer,
                                              phone_number text,
                                              email_address text) RETURNS integer AS
$$
DECLARE
    person integer;

BEGIN
    SELECT NEXTVAL('people_person_id_seq') INTO person;

    INSERT INTO people (person_id, first_name, last_name, birth_date)
    VALUES (person, insert_participant.first_name, insert_participant.last_name, insert_participant.birth_date);

    INSERT INTO email (email, person_id) VALUES (insert_participant.email_address, person);
    INSERT INTO phone (phone_number, person_id) VALUES (insert_participant.phone_number, person);

    INSERT INTO participant (person_id, championship_id)
    VALUES (person, insert_participant.championship_id);

    RETURN person;
END;
$$ LANGUAGE plpgSQL;

-- insert fully new person
CREATE OR REPLACE FUNCTION insert_person(first_name text,
                                              last_name text,
                                              birth_date date,
                                              phone_number text,
                                              email_address text) RETURNS integer AS
$$
DECLARE
    person integer;

BEGIN
    SELECT NEXTVAL('people_person_id_seq') INTO person;

    INSERT INTO people (person_id, first_name, last_name, birth_date)
    VALUES (person, insert_person.first_name, insert_person.last_name, insert_person.birth_date);

    INSERT INTO email (email, person_id) VALUES (insert_person.email_address, person);
    INSERT INTO phone (phone_number, person_id) VALUES (insert_person.phone_number, person);


    RETURN person;
END;
$$ LANGUAGE plpgSQL;

-- create team without mentors
CREATE OR REPLACE FUNCTION insert_team(name text,
                                       participants integer[],
                                       leader_id integer,
                                       championship_id integer) RETURNS integer AS
$$
DECLARE
    person      integer;
    team_number integer;
BEGIN
    IF (SELECT insert_team.leader_id != ALL (participants)) THEN
        RAISE EXCEPTION 'Leader_id not in participants array';
    END IF;

    INSERT INTO team (name, championship_id) VALUES (insert_team.name, insert_team.championship_id);
    SELECT CURRVAL('team_team_id_seq') INTO team_number;

    FOREACH person IN ARRAY participants
        LOOP
            UPDATE participant
            SET team_id = team_number
            WHERE person_id = person
              AND participant.championship_id = insert_team.championship_id;
        END LOOP;

    UPDATE team
    SET leader_id = insert_team.leader_id
    WHERE team_id = team_number;

    RETURN team_number;
END;
$$ LANGUAGE plpgSQL;

-- add mentor for the team
CREATE OR REPLACE FUNCTION add_mentor_to_team(mentor_id integer,
                                              championship_id integer,
                                              team_id integer) RETURNS VOID AS
$$
BEGIN
    INSERT INTO mentor_team (person_id, championship_id, team_id)
    VALUES (add_mentor_to_team.mentor_id,
            add_mentor_to_team.championship_id,
            add_mentor_to_team.team_id);
END;
$$ LANGUAGE plpgSQL;

-- create team with participant and mentors
CREATE OR REPLACE FUNCTION insert_team_with_mentor(name text,
                                       participants integer[],
                                       mentors integer[],
                                       leader_id integer,
                                       championship_id integer) RETURNS integer AS
$$
DECLARE
    cur_mentor  integer;
    team_number integer;
BEGIN
    PERFORM insert_team(name, participants, leader_id, championship_id) INTO team_number;

    FOREACH cur_mentor IN ARRAY mentors
        LOOP
            PERFORM add_mentor_to_team(cur_mentor, championship_id, team_number);
        END LOOP;

    RETURN team_number;
END;
$$ LANGUAGE plpgSQL;

-- add cases for project
CREATE OR REPLACE FUNCTION add_case_to_project(project_id integer,
                                    case_id integer) RETURNS VOID AS
$$
BEGIN
    INSERT INTO project_case (project_id, case_id)
    VALUES (add_case_to_project.project_id,
            add_case_to_project.case_id);
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION insert_project(name text,
                                          team_id integer,
                                          cases integer[],
                                          description text) RETURNS integer AS
$$
DECLARE
    cur_case       integer;
    project_number integer;

BEGIN
    INSERT INTO project (name, team_id, description) VALUES (insert_project.name,
                                                             insert_project.team_id,
                                                             insert_project.description);
    SELECT CURRVAL('project_project_id_seq') INTO project_number;

    FOREACH cur_case IN ARRAY cases
        LOOP
            PERFORM add_case_to_project(project_number, cur_case);
        END LOOP;

    RETURN project_number;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION add_platform(championship_id integer, platform_id integer) RETURNS VOID AS
$$
BEGIN
    INSERT INTO championship_platform (championship_id, platform_id)
    VALUES (add_platform.championship_id,
            add_platform.platform_id);
END;
$$ LANGUAGE plpgSQL;

-- add cases for championship
CREATE OR REPLACE FUNCTION add_case_to_championship(championship_id integer,
                                    case_id integer) RETURNS VOID AS
$$
BEGIN
    INSERT INTO championship_case (championship_id, case_id)
    VALUES (add_case_to_championship.championship_id,
            add_case_to_championship.case_id);
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION insert_championship(name text, description text, cases integer[], platforms integer[]) RETURNS integer AS
$$
DECLARE
    championship_number integer;
    cur_case integer;
    cur_platform integer;
BEGIN
    INSERT INTO championship (name, description) VALUES (insert_championship.name, insert_championship.description);
    SELECT CURRVAL('championship_championship_id_seq') INTO championship_number;

    FOREACH cur_case IN ARRAY cases
        LOOP
            PERFORM add_case_to_championship(championship_number, cur_case);
        END LOOP;

    FOREACH cur_platform IN ARRAY platforms
        LOOP
            PERFORM add_platform(championship_number, cur_platform);
        END LOOP;

    RETURN championship_number;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION insert_judge_team(judges integer[],
                                             championship_id integer) RETURNS VOID AS
$$
DECLARE
    judge_team_number integer;
    cur_judge integer;
BEGIN
    SELECT NEXTVAL('judge_team_judge_team_id_seq') INTO judge_team_number;
    INSERT INTO judge_team (judge_team_id) VALUES (judge_team_number);

    FOREACH cur_judge IN ARRAY judges
        LOOP
            UPDATE judge
            SET judge_team_id = judge_team_number
            WHERE person_id = cur_judge AND judge.championship_id = insert_judge_team.championship_id;
        END LOOP;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION insert_publication(name text, description text) RETURNS integer AS
$$
BEGIN
    INSERT INTO publication (name, description) VALUES (insert_publication.name, insert_publication.description);
    RETURN (CURRVAL('publication_publication_id_seq'));
END;
$$ LANGUAGE plpgSQL;


CREATE OR REPLACE FUNCTION add_publication(person_id integer, publication_id integer) RETURNS VOID AS
$$
BEGIN
    INSERT INTO people_publication (person_id, publication_id)
    VALUES (add_publication.person_id,
            add_publication.publication_id);
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION insert_publication_with_authors(name text, description text, authors integer[]) RETURNS integer AS
$$
DECLARE
    cur_author  integer;
    publication_number integer;
BEGIN
    PERFORM insert_publication(name, description) INTO publication_number;

    FOREACH cur_author IN ARRAY authors
        LOOP
            PERFORM add_publication(cur_author, publication_number);
        END LOOP;

    RETURN publication_number;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION rate_performance(performance_id integer, points real) RETURNS VOID AS
$$
BEGIN
    IF (SELECT championship.begin_date FROM performance
        JOIN project ON performance.project_id = project.project_id
        JOIN team ON team.team_id = project.team_id
        JOIN championship ON championship.championship_id = team.championship_id
        WHERE performance.performance_id = rate_performance.performance_id) IS NULL THEN
        RAISE EXCEPTION 'Championship is not started!';
    END IF;

    IF points > (SELECT SUM(complexity) FROM "case"
        JOIN project_case ON "case".case_id = project_case.case_id
        JOIN performance ON performance.performance_id = rate_performance.performance_id
                AND project_case.project_id = performance.project_id) THEN
        RAISE EXCEPTION 'Too much points for this performance';
    END IF;

    UPDATE performance
    SET points = rate_performance.points
    WHERE performance.performance_id = rate_performance.performance_id;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_teams(championship_id integer) RETURNS boolean AS
$$
DECLARE
    team_size integer;
    cur_team  team%rowtype;
BEGIN
    --fixme

--     IF ((SELECT COUNT(*)
--          FROM team
--                   JOIN mentor_team ON (team.team_id = mentor_team.team_id)) > 2) THEN
--         RAISE EXCEPTION 'Team can not have more than two mentors';
--     END IF;

    FOR cur_team IN (SELECT * FROM team WHERE team.championship_id = check_teams.championship_id)
        LOOP
            SELECT COUNT(*) FROM participant WHERE team_id = cur_team.team_id INTO team_size;

            IF (team_size < 2) THEN
                RAISE EXCEPTION 'Team can not have less than 2 participants';
            END IF;

            IF (team_size > 5) THEN
                RAISE EXCEPTION 'Team can not have More than 5 participants';
            END IF;

            IF ((SELECT team_id
                 FROM participant
                 WHERE person_id = cur_team.leader_id
                   AND participant.championship_id = cur_team.championship_id) != cur_team.team_id) THEN
                RAISE EXCEPTION 'Leader should be from this team';
            END IF;
        END LOOP;
    RETURN true;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_cases(championship_id integer) RETURNS boolean AS
$$
BEGIN
    IF NOT EXISTS(SELECT case_id
                  FROM championship_case
                  WHERE championship_case.championship_id = check_cases.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one platform';
    END IF;

    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_projects(championship_id integer) RETURNS boolean AS
$$
DECLARE
    cur_project project%rowtype;
    cur_case    "case"%rowtype;
BEGIN
    IF NOT EXISTS(SELECT project_id
                  FROM project
                           INNER JOIN team ON team.team_id = project.team_id
                  WHERE team.championship_id = check_projects.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one project';
    END IF;

    FOR cur_project IN
        (SELECT *
         FROM project
         WHERE (
                   SELECT team.championship_id FROM team WHERE team.team_id = project.team_id
               ) = check_projects.championship_id)
        LOOP
            IF NOT EXISTS(SELECT *
                          FROM "case"
                          WHERE EXISTS(SELECT *
                                       FROM project_case
                                       WHERE "case".case_id = project_case.case_id
                                         AND cur_project.project_id = project_case.project_id)) THEN
                RAISE EXCEPTION 'Project should contains at least one case';
            END IF;

            FOR cur_case IN
                (SELECT *
                 FROM "case"
                 WHERE EXISTS(SELECT *
                              FROM project_case
                              WHERE "case".case_id = project_case.case_id
                                AND cur_project.project_id = project_case.project_id))
                LOOP
                    IF NOT EXISTS(SELECT *
                                  FROM championship_case
                                  WHERE case_id = cur_case.case_id
                                    AND championship_case.championship_id = check_projects.championship_id) THEN
                        RAISE EXCEPTION 'This case cant be used in that championship';
                    END IF;
                END LOOP;
        END LOOP;

    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_platforms(championship_id integer) RETURNS boolean AS
$$
BEGIN
    IF NOT EXISTS(SELECT platform_id
                  FROM championship_platform
                  WHERE championship_platform.championship_id = check_platforms.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one platform';
    END IF;

    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_judge_teams(championship_id integer) RETURNS boolean AS
$$
DECLARE
    cur_judge_team judge_team%rowtype;
BEGIN
    IF NOT EXISTS(SELECT judge.judge_team_id
                  FROM judge_team
                           JOIN judge ON judge_team.judge_team_id = judge.judge_team_id
                  WHERE judge.championship_id = check_judge_teams.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one platform';
    END IF;

    FOR cur_judge_team IN
        (SELECT *
         FROM judge_team
         WHERE EXISTS(SELECT COUNT(*) FROM judge WHERE judge.judge_team_id = judge_team.judge_team_id))
        LOOP
        --fixme

--             IF ((SELECT COUNT(*) FROM judge WHERE judge.judge_team_id = cur_judge_team.judge_team_id) != 3) THEN
--                 RAISE EXCEPTION 'Judge teams should contains 3 judges.';
--             END IF;
        END LOOP;

    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_performances(championship_id integer) RETURNS boolean AS
$$
DECLARE
    cur_performance performance%rowtype;
BEGIN
    FOR cur_performance IN
        (SELECT * FROM performance WHERE
            (SELECT team.championship_id FROM team
                JOIN project ON team.team_id = project.team_id AND project.project_id = performance.project_id)
                = check_performances.championship_id)
    LOOP
        IF championship_id != ANY (SELECT judge.championship_id FROM judge WHERE judge_team_id = cur_performance.judge_team_id) THEN
            RAISE EXCEPTION 'Judge team should be from the same championship';
        END IF;

        IF NOT EXISTS(SELECT * FROM championship_platform WHERE championship_platform.championship_id = check_performances.championship_id
                                                            AND platform_id = cur_performance.platform_id) THEN
            RAISE EXCEPTION 'Unavailable platform for this championship!';
        END IF;
    END LOOP;
    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION start_championship(championship_id integer) RETURNS VOID AS
$$
BEGIN
    IF (check_judge_teams(championship_id) AND
        check_platforms(championship_id) AND
        check_teams(championship_id) AND
        check_cases(championship_id) AND
        check_projects(championship_id) AND
        check_performances(championship_id))
    THEN
        UPDATE championship
        SET begin_date = now()
        WHERE championship.championship_id = start_championship.championship_id;
    END IF;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION end_championship(championship_id integer) RETURNS VOID AS
$$
DECLARE
    score_value real;
    cur_project project%rowtype;
    cur_team team%rowtype;
    cur_score score%rowtype;
    cur_place integer;
    prev_points real;
BEGIN
    IF (SELECT MAX(performance_time) FROM performance
        JOIN project ON project.project_id = performance.project_id
        JOIN team ON project.team_id = team.team_id
        WHERE team.championship_id = end_championship.championship_id) > NOW() THEN
        RAISE EXCEPTION 'Some performances are not started yet!';
    END IF;

    IF EXISTS(SELECT * FROM performance
        JOIN project ON project.project_id = performance.project_id
        JOIN team ON project.team_id = team.team_id
        WHERE team.championship_id = end_championship.championship_id AND points IS NULL) THEN
        RAISE EXCEPTION 'Some performances are not rated!';
    END IF;

    FOR cur_team IN
        (SELECT * FROM team WHERE team.championship_id = end_championship.championship_id)
    LOOP
        score_value := 0;

        FOR cur_project IN
            (SELECT * FROM project WHERE team_id = cur_team.team_id)
        LOOP
            score_value := score_value + (SELECT AVG(points) FROM performance WHERE project_id = cur_project.project_id);
        END LOOP;

        INSERT INTO score (team_id, final_score) VALUES (cur_team.team_id, score_value);
    END LOOP;

    cur_place := 0;
    prev_points := -1;
    FOR cur_score IN
        (SELECT * FROM score
            WHERE (SELECT team.championship_id FROM team WHERE team.team_id = score.team_id) = end_championship.championship_id
        ORDER BY final_score DESC)
    LOOP
        IF (cur_score.final_score != prev_points) THEN
            cur_place := cur_place + 1;
            prev_points := cur_score.final_score;
        END IF;
        IF (cur_score.final_score = prev_points) THEN
            cur_place := cur_place;
        END IF;

        UPDATE score
        SET place = cur_place
        WHERE team_id = cur_score.team_id;
        UPDATE score
        SET special_award = CASE
                WHEN cur_place = 1 THEN 'Golden award'
                WHEN cur_place = 2 THEN 'Silver award'
                WHEN cur_place = 3 THEN 'Bronze award'
                ELSE 'Participant'
            END
        WHERE team_id = cur_score.team_id;
    END LOOP;
    UPDATE championship
    SET end_date = now()
    WHERE championship.championship_id = end_championship.championship_id;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION get_results(champ_id integer)
    RETURNS TABLE
            (
                team_id       integer,
                team_name     text,
                final_score   integer,
                place         integer,
                special_award text
            ) AS
$$
BEGIN
    RETURN QUERY SELECT team.team_id, team.name, final_score, place, special_award
                 FROM team INNER JOIN score ON team.team_id = score.team_id
                 WHERE team.championship_id = champ_id
                 ORDER BY place;
END;
$$ LANGUAGE plpgSQL;

-- Checkers for triggers
CREATE OR REPLACE FUNCTION check_person_contact_info() RETURNS trigger AS
$checkPersonContactInfo$
BEGIN
    IF NOT EXISTS(SELECT NEW.person_id FROM email WHERE NEW.person_id = email.person_id) THEN
        RAISE EXCEPTION 'person should have an email';
    END IF;
    IF NOT EXISTS(SELECT NEW.person_id FROM phone WHERE NEW.person_id = phone.person_id) THEN
        RAISE EXCEPTION 'person should have an phone number';
    END IF;
    RETURN NEW;
END;
$checkPersonContactInfo$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_participant() RETURNS trigger AS
$checkParticipant$
BEGIN
    IF people_age(NEW.person_id) > 27 THEN
        RAISE EXCEPTION 'participant should be under 27';
    END IF;

    IF EXISTS(SELECT *
              FROM mentor
              WHERE NEW.person_id = mentor.person_id
                AND NEW.championship_id = mentor.championship_id) THEN
        RAISE EXCEPTION 'participant can not be a mentor in the same championship';
    END IF;

    IF EXISTS(SELECT *
              FROM judge
              WHERE NEW.person_id = judge.person_id
                AND NEW.championship_id = judge.championship_id) THEN
        RAISE EXCEPTION 'participant can not be a judge in the same championship';
    END IF;

    IF NEW.team_id IS NOT NULL AND NEW.championship_id != ANY
                                   (SELECT participant.championship_id
                                    FROM participant
                                    WHERE team_id = NEW.team_id) THEN
        RAISE EXCEPTION 'Participants in one team should be from one championship';
    END IF;
    RETURN NEW;
END;
$checkParticipant$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_participant_only_update() RETURNS trigger AS
$checkParticipantUpdate$
BEGIN
    IF NEW.team_id IS NULL OR NEW.team_id != OLD.team_id THEN
        DELETE FROM team
        WHERE team_id = OLD.team_id;
    END IF;
    RETURN NEW;
END;
$checkParticipantUpdate$ LANGUAGE plpgsql;

CREATE FUNCTION check_mentor() RETURNS trigger AS
$checkMentor$
BEGIN
    IF people_age(NEW.person_id) < 21 THEN
        RAISE EXCEPTION 'mentor should be older then 21';
    END IF;

    IF NOT EXISTS(SELECT NEW.person_id
                  FROM people_publication
                  WHERE NEW.person_id = people_publication.person_id) THEN
        RAISE EXCEPTION 'mentor should have one or more publications';
    END IF;

    IF EXISTS(SELECT *
              FROM judge
              WHERE NEW.person_id = judge.person_id
                AND NEW.championship_id = judge.championship_id) THEN
        RAISE EXCEPTION 'mentor can not be a jude in the same championship';
    END IF;

    IF EXISTS(SELECT *
              FROM participant
              WHERE NEW.person_id = participant.person_id
                AND NEW.championship_id = participant.championship_id) THEN
        RAISE EXCEPTION 'mentor can not be a participant in the same championship';
    END IF;
    RETURN NEW;
END;
$checkMentor$ LANGUAGE plpgsql;

CREATE FUNCTION check_judge() RETURNS trigger AS
$checkJudge$
BEGIN
    IF people_age(NEW.person_id) < 27 THEN
        RAISE EXCEPTION 'jude should be older then 27';
    END IF;

    IF NOT EXISTS(SELECT NEW.person_id
                  FROM people_publication
                  WHERE NEW.person_id = people_publication.person_id) THEN
        RAISE EXCEPTION 'Judge should have one or more publications';
    END IF;

    IF EXISTS(SELECT *
              FROM mentor
              WHERE NEW.person_id = mentor.person_id
                AND NEW.championship_id = mentor.championship_id) THEN
        RAISE EXCEPTION 'Judge can not be a mentor in the same championship';
    END IF;

    IF EXISTS(SELECT *
              FROM participant
              WHERE NEW.person_id = participant.person_id
                AND NEW.championship_id = participant.championship_id) THEN
        RAISE EXCEPTION 'Judge can not be a participant in the same championship';
    END IF;

    IF NEW.judge_team_id IS NOT NULL AND NEW.championship_id != ANY
                                         (SELECT judge.championship_id
                                          FROM judge
                                          WHERE judge_team_id = NEW.judge_team_id) THEN
        RAISE EXCEPTION 'Judges in one judge team should be from one championship';
    END IF;

    RETURN NEW;
END;
$checkJudge$ LANGUAGE plpgsql;

CREATE FUNCTION check_judge_only_update() RETURNS trigger AS
$checkJudgeUpdate$
BEGIN
    IF NEW.judge_team_id IS NULL OR NEW.judge_team_id != OLD.judge_team_id THEN
        DELETE FROM judge_team
        WHERE judge_team_id = OLD.judge_team_id;
    END IF;
    RETURN NEW;
END;
$checkJudgeUpdate$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_mentor_team_dependency() RETURNS trigger AS
$checkMentorTeamDependency$
BEGIN
    IF NOT EXISTS(SELECT * FROM team WHERE NEW.championship_id = team.championship_id AND NEW.team_id = team.team_id) THEN
        RAISE EXCEPTION 'Mentor and team should be in one championship';
    END IF;
RETURN NEW;
END;
$checkMentorTeamDependency$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_performance() RETURNS trigger AS
$checkPerformance$
DECLARE
    championship_number integer;
BEGIN
    SELECT team.championship_id INTO championship_number FROM project JOIN team ON team.team_id = project.team_id WHERE project_id = NEW.project_id;

    IF NOT EXISTS(SELECT * FROM championship_platform WHERE platform_id = NEW.platform_id AND championship_id = championship_number) THEN
        RAISE EXCEPTION 'Platform should be available for this championship.';
    END IF;
    RETURN NEW;
END;
$checkPerformance$ LANGUAGE plpgSQL;

-- Triggers
CREATE TRIGGER checkParticipant
    BEFORE INSERT OR UPDATE
    ON participant
    FOR EACH ROW
EXECUTE PROCEDURE check_participant();

CREATE TRIGGER checkParticipantUpdate
    AFTER UPDATE
    ON participant
    FOR EACH ROW
EXECUTE PROCEDURE check_participant_only_update();

CREATE TRIGGER checkMentor
    BEFORE INSERT OR UPDATE
    ON mentor
    FOR EACH ROW
EXECUTE PROCEDURE check_mentor();

CREATE TRIGGER checkJudge
    BEFORE INSERT OR UPDATE
    ON judge
    FOR EACH ROW
EXECUTE PROCEDURE check_judge();

CREATE TRIGGER checkJudgeUpdate
    AFTER UPDATE
    ON judge
    FOR EACH ROW
EXECUTE PROCEDURE check_judge_only_update();

CREATE TRIGGER checkParticipantContactInfo
    BEFORE INSERT OR UPDATE
    ON participant
    FOR EACH ROW
EXECUTE PROCEDURE check_person_contact_info();

CREATE TRIGGER checkMentorContactInfo
    BEFORE INSERT OR UPDATE
    ON mentor
    FOR EACH ROW
EXECUTE PROCEDURE check_person_contact_info();

CREATE TRIGGER checkJudgeContactInfo
    BEFORE INSERT OR UPDATE
    ON judge
    FOR EACH ROW
EXECUTE PROCEDURE check_person_contact_info();

CREATE TRIGGER checkMentorTeamDependency
    BEFORE INSERT OR UPDATE
    ON mentor_team
    FOR EACH ROW
EXECUTE PROCEDURE check_mentor_team_dependency();

CREATE TRIGGER checkPerformance
    BEFORE INSERT OR UPDATE
    ON performance
    FOR EACH ROW
EXECUTE PROCEDURE check_performance();



