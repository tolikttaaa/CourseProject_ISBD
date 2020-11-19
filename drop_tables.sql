DROP TABLE IF EXISTS people,
                     publication,
                     email,
                     phone,
                     team,
                     participant,
                     judge,
                     "case",
                     mentor,
                     judge_team,
                     score,
                     project,
                     performance,
                     platform,
                     championship,
                     championship_case,
                     championship_platform,
                     mentor_team,
                     project_case,
                     people_publication CASCADE;

DROP FUNCTION IF EXISTS people_age(integer) CASCADE;
DROP FUNCTION IF EXISTS insert_participant(text, text, date, integer, text, text) CASCADE;
DROP FUNCTION IF EXISTS insert_person(text, text, date, text, text) CASCADE;
DROP FUNCTION IF EXISTS insert_team(text, integer[], integer, integer) CASCADE;
DROP FUNCTION IF EXISTS insert_team_with_mentor(text, integer[], integer[], integer, integer) CASCADE;
DROP FUNCTION IF EXISTS insert_judge_team(integer[], integer) CASCADE;
DROP FUNCTION IF EXISTS insert_publication(text, text) CASCADE;
DROP FUNCTION IF EXISTS insert_publication_with_authors(text, text, integer[]) CASCADE;
DROP FUNCTION IF EXISTS insert_project(text, integer, integer[], text) CASCADE;
DROP FUNCTION IF EXISTS insert_championship(text, text, integer[], integer[]) CASCADE;

DROP FUNCTION IF EXISTS add_mentor_to_team(integer, integer, integer) CASCADE;
DROP FUNCTION IF EXISTS add_platform(integer, integer) CASCADE;
DROP FUNCTION IF EXISTS add_publication(integer, integer) CASCADE;
DROP FUNCTION IF EXISTS add_case_to_project(integer, integer) CASCADE;
DROP FUNCTION IF EXISTS add_case_to_championship(integer, integer) CASCADE;

DROP FUNCTION IF EXISTS check_person_contact_info() CASCADE;
DROP FUNCTION IF EXISTS check_participant() CASCADE;
DROP FUNCTION IF EXISTS check_participant_only_update() CASCADE;
DROP FUNCTION IF EXISTS check_mentor() CASCADE;
DROP FUNCTION IF EXISTS check_judge() CASCADE;
DROP FUNCTION IF EXISTS check_judge_only_update() CASCADE;
DROP FUNCTION IF EXISTS check_mentor_team_dependency() CASCADE;

DROP FUNCTION IF EXISTS check_teams(integer) CASCADE;
DROP FUNCTION IF EXISTS check_projects(integer) CASCADE;
DROP FUNCTION IF EXISTS check_cases(integer) CASCADE;
DROP FUNCTION IF EXISTS check_judge_teams(integer) CASCADE;
DROP FUNCTION IF EXISTS check_performances(integer) CASCADE;
DROP FUNCTION IF EXISTS check_platforms(integer) CASCADE;

DROP FUNCTION IF EXISTS start_championship(integer) CASCADE;
DROP FUNCTION IF EXISTS end_championship(integer) CASCADE;
DROP FUNCTION IF EXISTS get_results(integer) CASCADE;
DROP FUNCTION IF EXISTS rate_performance(integer, real) CASCADE;
