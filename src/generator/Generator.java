package generator;

import generator.objects.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.*;

public class Generator {
    public static final Random random = new Random(100);
    private static final StringBuilder builder = new StringBuilder();

    private static final String SCRIPT_SEPARATOR = "\n---------------------\n";
    private static final String SMALL_SCRIPT_SEPARATOR = "---------------------\n";

    private static final int COUNT_OF_PEOPLE = 1000;
    private static final int COUNT_OF_PARTICIPANTS = 300;
    private static final int COUNT_OF_CHAMPIONSHIPS = 5;
    private static final int COUNT_OF_CASES = 20;
    private static final int COUNT_OF_PLATFORMS = 10;
    private static final int COUNT_OF_MENTORS = 30;
    private static final int COUNT_OF_JUDGES = 12;
    private static final int COUNT_OF_PUBLICATION = 20;

    public static ArrayList<Case> cases = new ArrayList<>();
    public static ArrayList<Champioship> championships = new ArrayList<>();
    public static ArrayList<Email> emails = new ArrayList<>();
    public static ArrayList<Judge> judges = new ArrayList<>();
    public static ArrayList<JudgeTeam> judgeTeams = new ArrayList<>();
    public static ArrayList<Mentor> mentors = new ArrayList<>();
    public static ArrayList<Participant> participants = new ArrayList<>();
    public static ArrayList<Performance> performances = new ArrayList<>();
    public static ArrayList<Person> people = new ArrayList<>();
    public static ArrayList<Phone> phones = new ArrayList<>();
    public static ArrayList<Platform> platforms = new ArrayList<>();
    public static ArrayList<Project> projects = new ArrayList<>();
    public static ArrayList<Publication> publications = new ArrayList<>();
    public static ArrayList<Team> teams = new ArrayList<>();

    private static final Set<Integer> peopleWithPublication = new HashSet<>();
    private static Set<Integer> judges_id = new HashSet<>();
    private static Set<Integer> mentors_id = new HashSet<>();
    private static Set<Integer> participants_id = new HashSet<>();

    public static void main(String[] args) throws FileNotFoundException {
        PrintWriter out = new PrintWriter(new File("test.sql"));

        //generate random people
        for (int iter = 0; iter < COUNT_OF_PEOPLE; iter++) {
            Person.generate();
        }

        addScript(SCRIPT_SEPARATOR);

        //generate platforms
        for (int iter = 0; iter < COUNT_OF_PLATFORMS; iter++) {
            Person randomPerson = selectRandomPerson();

            while (random.nextInt(10) > 3) {
                Phone.generate(randomPerson.person_id);
            }

            while (random.nextInt(10) > 3) {
                Email.generate(randomPerson.person_id);
            }

            Platform.generate(randomPerson.person_id);
        }

        addScript(SCRIPT_SEPARATOR);

        //generate cases
        for (int iter = 0; iter < COUNT_OF_CASES; iter++) {
            Case.generate();
        }

        addScript(SCRIPT_SEPARATOR);

        //generate random publication
        for (int iter = 0; iter < COUNT_OF_PUBLICATION; iter++) {
            int cntAuthors = random.nextInt(5) + 3;

            Set<Integer> authors = new HashSet<>();
            while (authors.size() < cntAuthors) {
                authors.add(selectRandomPerson().person_id);
            }

            Publication.generate(new ArrayList<>(authors));
            peopleWithPublication.addAll(authors);
        }

        addScript(SCRIPT_SEPARATOR);

        //generate championships
        for (int iter = 0; iter < COUNT_OF_CHAMPIONSHIPS; iter++) {
            int cntCases = random.nextInt(8) + 3;

            Set<Integer> cases = new HashSet<>();
            while (cases.size() < cntCases) {
                cases.add(selectRandomCase().case_id);
            }

            int cntPlatforms = random.nextInt(5) + 2;

            Set<Integer> platforms = new HashSet<>();
            while (platforms.size() < cntPlatforms) {
                platforms.add(selectRandomPlatform().platform_id);
            }

            Champioship champioship = Champioship.generate(
                    new ArrayList<>(cases),
                    new ArrayList<>(platforms)
            );

            addScript(SMALL_SCRIPT_SEPARATOR);

            judges = new ArrayList<>();
            judgeTeams = new ArrayList<>();
            mentors = new ArrayList<>();
            participants = new ArrayList<>();
            performances = new ArrayList<>();
            teams = new ArrayList<>();

            judges_id = new HashSet<>();
            mentors_id = new HashSet<>();
            participants_id = new HashSet<>();

            //generate judges
            int curCountOfJudges = COUNT_OF_JUDGES + 3 * (random.nextInt(3) - 1);
            while (judges.size() < curCountOfJudges) {
                int person_id = selectRandomPersonWithPublication();
                judges_id.add(person_id);
                Judge.generate(person_id, champioship.championship_id);
            }

            addScript(SMALL_SCRIPT_SEPARATOR);

            //generate mentors
            int curCountOfMentors = COUNT_OF_MENTORS + (random.nextInt(21) - 10);
            while (mentors.size() < curCountOfMentors) {
                int person_id = selectRandomPersonWithPublication();
                mentors_id.add(person_id);
                Mentor.generate(person_id, champioship.championship_id);
            }

            addScript(SMALL_SCRIPT_SEPARATOR);

            //generate participant
            int curCountOfParticipants = COUNT_OF_PARTICIPANTS + (random.nextInt(151) - 75);
            while (participants.size() < curCountOfParticipants) {
                int person_id = selectRandomPersonWithoutPublication();
                participants_id.add(person_id);
                Participant.generate(person_id, champioship.championship_id);
            }

            addScript(SMALL_SCRIPT_SEPARATOR);

            //team
            //project

            //judgeTeam

            //performance

            //startChampionship

            //rate

            //endChampionship

            //TODO

            addScript(SCRIPT_SEPARATOR);
        }

        out.println(builder);
        out.close();
    }

    public static void addScript(String script) {
        builder.append(script);
        builder.append("\n");
    }

    public static LocalDate generateDate() {
        return generateDate(LocalDate.of(1950, 1, 1));
    }

    public static LocalDate generateDate(LocalDate startDate) {
        return generateDate(startDate, LocalDate.now());
    }

    public static LocalDate generateDate(LocalDate startDate, LocalDate endDate) {
        long start = startDate.toEpochDay();
        long end = endDate.toEpochDay();

        long cur = start + random.nextInt((int) (end - start));

        return LocalDate.ofEpochDay(cur);
    }

    public static String getIntArray(ArrayList<Integer> array) {
        StringBuilder res = new StringBuilder();

        res.append('{');
        res.append(array.get(0));
        for (int i = 1; i < array.size(); i++) {
            res.append(',');
            res.append(array.get(i));
        }
        res.append('}');

        return res.toString();
    }

    private static Person selectRandomPerson() {
        return people.get(random.nextInt(people.size()));
    }

    private static Case selectRandomCase() {
        return cases.get(random.nextInt(cases.size()));
    }

    private static Platform selectRandomPlatform() {
        return platforms.get(random.nextInt(platforms.size()));
    }

    private static int selectRandomPersonWithPublication() {
        while (true) {
            int size = peopleWithPublication.size();
            int item = random.nextInt(size);
            int i = 0;

            for (int obj : peopleWithPublication) {
                if (i == item && !judges_id.contains(obj)
                        && !mentors_id.contains(obj)
                        && !participants_id.contains(obj)) {
                    return obj;
                }

                i++;
            }
        }
    }

    private static int selectRandomPersonWithoutPublication() {
        while (true) {
            Person person = people.get(random.nextInt(people.size()));

            if (!judges_id.contains(person.person_id)
                    && !mentors_id.contains(person.person_id)
                    && !participants_id.contains(person.person_id)) {
                return person.person_id;
            }
        }
    }
}
