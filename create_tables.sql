CREATE TABLE people
(
    person_id  serial        PRIMARY KEY,
    first_name character[20] NOT NULL,
    last_name  character[20] NOT NULL,
    birth_date date          NOT NULL CHECK (birth_date <= NOW())
);

-- function that return age of the person by his ID
CREATE OR REPLACE FUNCTION age(person integer) RETURNS integer
    AS $$
        DECLARE
            age integer;

        BEGIN
            SELECT date_part('year', age(birth_date)) INTO age
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
    name           text   NOT NULL,
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
    name            text   NOT NULL,
    description     text,
    begin_date      date   NOT NULL,
    end_date        date
);

CREATE TABLE team
(
    team_id         serial   PRIMARY KEY,
    name            text,
    leader_id       integer,
    championship_id integer  REFERENCES championship (championship_id) ON DELETE CASCADE
);

CREATE TABLE platform
(
    platform_id       serial  PRIMARY KEY,
    name              text    NOT NULL,
    address           text    NOT NULL,
    contact_person_id integer NOT NULL
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
    performance_id   serial  PRIMARY KEY,
    project_id       integer REFERENCES project (project_id) ON DELETE CASCADE,
    performance_time timestamp,
    judge_team_id    integer REFERENCES judge_team (judge_team_id) ON DELETE SET NULL,
    platform_id      integer REFERENCES platform (platform_id) ON DELETE CASCADE,
    points           real    DEFAULT NULL
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
    judge_team_id   integer REFERENCES judge_team (judge_team_id) ON DELETE SET NULL ,
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
    mentor_id integer,
    championship_id integer,
    FOREIGN KEY (mentor_id, championship_id) REFERENCES mentor (person_id, championship_id) ON DELETE CASCADE,
    team_id   integer REFERENCES team (team_id) ON DELETE CASCADE,
    PRIMARY KEY (mentor_id, team_id)
);

CREATE TABLE people_publication
(
    person_id      integer REFERENCES people (person_id) ON DELETE CASCADE,
    publication_id integer REFERENCES publication (publication_id) ON DELETE CASCADE
);

-- insert fully new participant
CREATE OR REPLACE FUNCTION insert_participant(
    first_name character[20],
    last_name character[20],
    birth_date date,
    championship_id integer
) RETURNS integer
AS $$
    DECLARE
        person integer;

    BEGIN
        INSERT INTO people (first_name, last_name, birth_date) VALUES
            (insert_participant.first_name, insert_participant.last_name, insert_participant.birth_date);

        SELECT max(person_id) INTO person
        FROM people;

        INSERT INTO participant (person_id, championship_id) VALUES
            (person, insert_participant.championship_id);

        RETURN person;
    END;
$$ LANGUAGE plpgSQL;

-- insert fully new judge
CREATE OR REPLACE FUNCTION insert_judge(
    first_name character[20],
    last_name character[20],
    birth_date date,
    championship_id integer,
    work text
) RETURNS integer
AS $$
    DECLARE
        person integer;

    BEGIN
        INSERT INTO people (first_name, last_name, birth_date) VALUES
            (insert_judge.first_name, insert_judge.last_name, insert_judge.birth_date);

        SELECT max(person_id) INTO person
        FROM people;

        INSERT INTO judge (person_id, championship_id, work) VALUES
            (person, insert_judge.championship_id, insert_judge.work);

        RETURN person;
    END;
$$ LANGUAGE plpgSQL;

-- create team without mentors
CREATE OR REPLACE FUNCTION insert_team(
    name text,
    participants integer[],
    leader_id integer,
    championship_id integer
) RETURNS integer
AS $$
    DECLARE
        person integer;
        team_number integer;
    BEGIN
        IF (SELECT insert_team.leader_id != ALL(participants)) THEN
            RAISE EXCEPTION 'Leader_id not in participants array';
        END IF;

        INSERT INTO team (name, championship_id) VALUES (insert_team.name, insert_team.championship_id);
        SELECT max(team_id) INTO team_number FROM team;

        FOREACH person IN ARRAY participants
        LOOP
            UPDATE participant
            SET team_id = team_number
            WHERE person_id = person AND championship_id = insert_team.championship_id;
        END LOOP;

        UPDATE team
        SET leader_id = insert_team.leader_id
        WHERE team_id = team_number;

        RETURN team_number;
    END;
$$ LANGUAGE plpgSQL;

-- add mentor for the team
CREATE OR REPLACE FUNCTION add_mentor_to_team(
    mentor_id integer,
    championship_id integer,
    team_id integer
) RETURNS VOID
AS $$
    BEGIN
        INSERT INTO mentor_team (mentor_id, championship_id, team_id) VALUES
            (add_mentor_to_team.mentor_id,
             add_mentor_to_team.championship_id,
             add_mentor_to_team.team_id);
    END;
$$ LANGUAGE plpgSQL;

-- create team with participant and mentors
CREATE OR REPLACE FUNCTION insert_team(
    name text,
    participants integer[],
    mentors integer[],
    leader_id integer,
    championship_id integer
) RETURNS integer
AS $$
    DECLARE
        cur_mentor integer;
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

CREATE OR REPLACE FUNCTION rate_performance(performance_id integer, points real) RETURNS VOID
AS $$
    BEGIN
        UPDATE performance
        SET points = rate_performance.points
        WHERE performance_id = rate_performance.performance_id;
    END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION start_championship(championship_id integer) RETURNS VOID
AS $$
    BEGIN
        -- TODO: check all entities 
    END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION end_championship(championship_id integer) RETURNS VOID
AS $$
    BEGIN
        -- TODO: 1) check is all performance rated
        --       2) calculate score table
    END;
$$ LANGUAGE plpgSQL;

CREATE OR REPLACE FUNCTION get_results(championship_id integer)
RETURNS TABLE
    (
        team_id integer,
        team_name text,
        final_score integer,
        place integer,
        special_award text
    )
AS $$
    BEGIN
        -- TODO: I still need to understand do we need this function
    END;
$$ LANGUAGE plpgSQL;

-- Triggers

