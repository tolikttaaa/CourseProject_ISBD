CREATE TABLE people
(
    person_id  serial PRIMARY KEY,
    first_name character[20] NOT NULL,
    last_name  character[20] NOT NULL,
    birth_date date          NOT NULL CHECK (birth_date <= NOW())
);

-- function that return age of the person by his ID
CREATE OR REPLACE FUNCTION age(person integer) RETURNS integer AS
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

CREATE VIEW people_view AS
SELECT *, age(person_id) AS age
FROM people;

CREATE TABLE publication
(
    publication_id serial PRIMARY KEY,
    name           text NOT NULL,
    description    text
);

CREATE TABLE email
(
    email     character[50] PRIMARY KEY,
    person_id integer REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE phone
(
    phone_number character[15] PRIMARY KEY NOT NULL,
    person_id    integer REFERENCES people (person_id) ON DELETE CASCADE
);

CREATE TABLE championship
(
    championship_id serial PRIMARY KEY,
    name            text NOT NULL,
    description     text,
    begin_date      date NOT NULL,
    end_date        date
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
    platform_id      integer REFERENCES platform (platform_id) ON DELETE CASCADE,
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
CREATE OR REPLACE FUNCTION insert_participant(first_name character[20],
                                              last_name character[20],
                                              birth_date date,
                                              championship_id integer) RETURNS integer AS
$$
DECLARE
    person integer;

BEGIN
    INSERT INTO people (first_name, last_name, birth_date)
    VALUES (insert_participant.first_name, insert_participant.last_name, insert_participant.birth_date);

    SELECT max(person_id)
    INTO person
    FROM people;

    INSERT INTO participant (person_id, championship_id)
    VALUES (person, insert_participant.championship_id);

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
    SELECT max(team_id) INTO team_number FROM team;

    FOREACH person IN ARRAY participants
        LOOP
            UPDATE participant
            SET team_id = team_number
            WHERE person_id = person
              AND championship_id = insert_team.championship_id;
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
CREATE OR REPLACE FUNCTION insert_team(name text,
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

    INSERT INTO team (name) VALUES (insert_team.name);
    SELECT max(team_id) INTO team_number FROM team;

    FOREACH cur_mentor IN ARRAY mentors
        LOOP
            PERFORM add_mentor_to_team(cur_mentor, championship_id, team_number);
        END LOOP;

    RETURN team_number;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION rate_performance(performance_id integer, points real) RETURNS VOID AS
$$
BEGIN
    UPDATE performance
    SET points = rate_performance.points
    WHERE performance_id = rate_performance.performance_id;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_teams(championship_id integer) RETURNS boolean AS
$$
DECLARE
    team_size integer;
    cur_team  team%rowtype;
BEGIN
    IF ((SELECT COUNT(*)
         FROM team
                  JOIN mentor_team ON (team.team_id = mentor_team.team_id)) > 2) THEN
        RAISE EXCEPTION 'Team can not have more than two mentors';
    END IF;

    FOR cur_team IN (SELECT * FROM team WHERE team.championship_id = check_teams.championship_id)
    LOOP
        SELECT COUNT(*) FROM participant WHERE team_id = cur_team.team_id INTO team_size;

        IF (team_size < 2) THEN
            RAISE EXCEPTION 'Team can not have less than 2 participants';
        END IF;

        IF (team_size > 5) THEN
            RAISE EXCEPTION 'Team can not have More than 5 participants';
        END IF;

        IF ((SELECT team_id FROM participant WHERE person_id = cur_team.leader_id
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
    cur_case "case"%rowtype;
BEGIN
    IF NOT EXISTS(SELECT project_id FROM project
                        INNER JOIN team ON team.team_id = project.team_id
               WHERE team.championship_id = check_projects.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one project';
    END IF;

    FOR cur_project IN
        (SELECT * FROM project WHERE (
                SELECT team.championship_id FROM team WHERE team.team_id = project.team_id
            ) = check_projects.championship_id)
    LOOP
        IF NOT EXISTS(SELECT * FROM "case" WHERE EXISTS(SELECT * FROM project_case
                WHERE "case".case_id = project_case.case_id AND cur_project.project_id = project_case.project_id)) THEN
            RAISE EXCEPTION 'Project should contains at least one case';
        END IF;

        FOR cur_case IN
            (SELECT * FROM "case" WHERE EXISTS(SELECT * FROM project_case
                WHERE "case".case_id = project_case.case_id AND cur_project.project_id = project_case.project_id))
        LOOP
            IF NOT EXISTS(SELECT * FROM championship_case WHERE case_id = cur_case.case_id
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
    IF NOT EXISTS(SELECT judge.judge_team_id FROM judge_team
                    JOIN judge ON judge_team.judge_team_id = judge.judge_team_id
                    WHERE judge.championship_id = check_judge_teams.championship_id) THEN
        RAISE EXCEPTION 'Championship should contains at least one platform';
    END IF;

    FOR cur_judge_team IN
        (SELECT * FROM judge_team
        WHERE EXISTS(SELECT COUNT(*) FROM judge WHERE judge.judge_team_id = judge_team.judge_team_id))
    LOOP
        IF ((SELECT COUNT(*) FROM judge WHERE judge.judge_team_id = cur_judge_team.judge_team_id) != 3) THEN
            RAISE EXCEPTION 'Judge teams should contains 3 judges.';
        END IF;
    END LOOP;

    RETURN true;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION check_performances(championship_id integer) RETURNS boolean AS
$$
BEGIN
--     TODO:
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
        WHERE championship_id = start_championship.championship_id;
    END IF;
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION end_championship(championship_id integer) RETURNS VOID AS
$$
BEGIN
    -- TODO: 1) check that max performance time less than now and all performances are rated
    --       2) calculate score table
END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION get_results(championship_id integer)
    RETURNS TABLE(
                     team_id       integer,
                     team_name     text,
                     final_score   integer,
                     place         integer,
                     special_award text
                 ) AS
$$
BEGIN
    -- TODO
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
END;
$checkPersonContactInfo$ LANGUAGE plpgSQL;

CREATE FUNCTION check_participant() RETURNS trigger
AS
$checkParticipant$
BEGIN
    IF age(NEW.person_id) > 27 THEN
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

    IF NEW.team_id IS NOT NULL AND NEW.championship_id != ALL
        (SELECT participant.championship_id FROM participant WHERE team_id = NEW.team_id) THEN
        RAISE EXCEPTION 'Participants in one team should be from one championship';
    END IF;
END;
$checkParticipant$ LANGUAGE plpgsql;

CREATE FUNCTION check_mentor() RETURNS trigger AS
$checkMentor$
BEGIN
    IF age(NEW.person_id) < 21 THEN
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
END;
$checkMentor$ LANGUAGE plpgsql;

CREATE FUNCTION check_judge() RETURNS trigger AS
$checkJudge$
BEGIN
    IF age(NEW.person_id) < 27 THEN
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

    IF NEW.judge_team_id IS NOT NULL AND NEW.championship_id != ALL
        (SELECT judge.championship_id FROM judge WHERE judge_team_id = NEW.judge_team_id) THEN
        RAISE EXCEPTION 'Judges in one judge team should be from one championship';
    END IF;
END;
$checkJudge$ LANGUAGE plpgsql;

-- Triggers
CREATE TRIGGER checkParticipant
    BEFORE INSERT OR UPDATE
    ON participant
    FOR EACH ROW
EXECUTE PROCEDURE check_participant();

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

CREATE TRIGGER checkPersonContactInfo
    BEFORE INSERT OR UPDATE
    ON people
    FOR EACH ROW
EXECUTE PROCEDURE check_person_contact_info();