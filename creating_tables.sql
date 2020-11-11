create table people
(
    person_id  serial PRIMARY KEY,
    first_name character[20] NOT NULL,
    last_name  character[20] NOT NULL,
    birth_date date          NOT NULL CHECK (birth_date <= NOW()),
    age        integer
);

create table publication
(
    publication_id serial PRIMARY KEY,
    name           text NOT NULL,
    description    text
);
create table email
(
    email     character[50] primary key,
    person_id integer REFERENCES people (person_id) ON DELETE CASCADE
);
create table phone
(
    phone_number character[15] PRIMARY KEY NOT NULL,
    person_id    integer REFERENCES people (person_id) ON DELETE CASCADE
);
create table team
(
    team_id   serial PRIMARY KEY,
    name      text,
    leader_id integer
);
create table championship
(
    championship_id serial PRIMARY KEY,
    name            text NOT NULL,
    description     text,
    begin_date      date NOT NULL,
    end_date        date
);
create table platform
(
    platform_id       serial PRIMARY KEY,
    name              text    NOT NULL,
    address           text    NOT NULL,
    contact_person_id integer NOT NULL
);
create table judge_team
(
    judge_team_id serial PRIMARY KEY
);
create table participant
(
    person_id       integer REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    team_id         integer NOT NULL,
    PRIMARY KEY (person_id, championship_id)
);
create table mentor
(
    person_id       integer UNIQUE REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, championship_id)
);

create table score
(
    team_id       integer REFERENCES team (team_id) ON DELETE CASCADE,
    final_score   real,
    place         integer,
    special_award text
);
create table project
(
    project_id  serial PRIMARY KEY,
    name        text NOT NULL,
    team_id     integer REFERENCES team (team_id) ON DELETE CASCADE,
    description text
);
create table performance
(
    performance_id   serial PRIMARY KEY,
    project_id       integer REFERENCES project (project_id) ON DELETE CASCADE,
    performance_time timestamp,
    judge_team_id    integer REFERENCES judge_team (judge_team_id) ON DELETE SET NULL,
    platform_id      integer REFERENCES platform (platform_id) ON DELETE CASCADE,
    points           real
);
create table "case"
(
    case_id     serial PRIMARY KEY,
    description text    NOT NULL,
    complexity  integer NOT NULL
);
create table judge
(
    person_id       integer REFERENCES people (person_id) ON DELETE CASCADE,
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    work            text,
    judge_team_id   integer REFERENCES judge_team (judge_team_id) ON DELETE CASCADE,
    PRIMARY KEY (person_id, championship_id)
);
create table championship_case
(
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    case_id         integer REFERENCES "case" (case_id) ON DELETE SET NULL
);
create table championship_platform
(
    championship_id integer REFERENCES championship (championship_id) ON DELETE CASCADE,
    platform_id     integer REFERENCES platform (platform_id) ON DELETE SET NULL
);
create table project_case
(
    project_id integer REFERENCES project (project_id) ON DELETE CASCADE,
    case_id    integer REFERENCES "case" (case_id) ON DELETE SET NULL
);
create table mentor_team
(
    mentor_id integer REFERENCES mentor (person_id) ON DELETE SET NULL,
    team_id   integer REFERENCES team (team_id) ON DELETE CASCADE
);
create table people_publication
(
    person_id      integer REFERENCES people (person_id) ON DELETE CASCADE,
    publication_id integer REFERENCES publication (publication_id) ON DELETE SET NULL
);