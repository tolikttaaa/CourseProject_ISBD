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

DROP FUNCTION IF EXISTS age(integer) CASCADE;
DROP FUNCTION IF EXISTS insert_participant(character[], character[], date, integer) CASCADE;
DROP FUNCTION IF EXISTS insert_judge(character[], character[], date, integer, text) CASCADE;
DROP FUNCTION IF EXISTS insert_team(text, integer[], integer, integer) CASCADE;
DROP FUNCTION IF EXISTS insert_team(text, integer[], integer[], integer, integer) CASCADE;
DROP FUNCTION IF EXISTS add_mentor_to_team(integer, integer, integer) CASCADE;
DROP FUNCTION IF EXISTS person_contact_info_check() CASCADE;
DROP FUNCTION IF EXISTS participant_check() CASCADE;
DROP FUNCTION IF EXISTS mentor_check() CASCADE;
DROP FUNCTION IF EXISTS judge_check() CASCADE;
DROP FUNCTION IF EXISTS team_check() CASCADE;
DROP FUNCTION IF EXISTS check_project(integer) CASCADE;
