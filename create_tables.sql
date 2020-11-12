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

CREATE TABLE team
(
    team_id   serial PRIMARY KEY,
    name      text,
    leader_id integer
);

CREATE TABLE championship
(
    championship_id serial PRIMARY KEY,
    name            text   NOT NULL,
    description     text,
    begin_date      date   NOT NULL,
    end_date        date
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
    team_id         integer,  -- can be null before team was created
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
    points           real
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
    judge_team_id   integer REFERENCES judge_team (judge_team_id) ON DELETE CASCADE,
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
    champion_ship_id integer,
    FOREIGN KEY (mentor_id, champion_ship_id) REFERENCES mentor (person_id, championship_id) ON DELETE CASCADE,
    team_id   integer REFERENCES team (team_id) ON DELETE CASCADE,
    PRIMARY KEY (mentor_id, team_id)
);

CREATE TABLE people_publication
(
    person_id      integer REFERENCES people (person_id) ON DELETE CASCADE,
    publication_id integer REFERENCES publication (publication_id) ON DELETE CASCADE
);


CREATE FUNCTION addParticipant(
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
                (addParticipant.first_name, addParticipant.last_name, addParticipant.birth_date);

            SELECT max(person_id) INTO person
            FROM people;

            INSERT INTO participant (person_id, championship_id) VALUES
                (person, addParticipant.championship_id);

            RETURN person;
        END;
    $$ LANGUAGE plpgSQL;

-- Triggers

