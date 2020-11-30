package generator;

import generator.objects.*;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Random;

public class Generator {
    public static final Random random = new Random(23956630);
    private static final StringBuilder builder = new StringBuilder();

    private static final String SCRIPT_SEPARATOR = "\n---------------------\n";

    private static final int COUNT_OF_PEOPLE = 1000;
    private static final int COUNT_OF_PARTICIPANTS = 300;
    private static final int COUNT_OF_CHAMPIONSHIPS = 5;
    private static final int COUNT_OF_CASES = 20;
    private static final int COUNT_OF_PLATFORMS = 10;
    private static final int COUNT_OF_MENTORS = 30;
    private static final int COUNT_OF_JUDGES = 12;
    private static final int COUNT_OF_PUBLICATION = 20;

    private static final String[] FIRST_NAMES = { "Olivia", "Emma", "Ava",
            "Sophia", "Isabella", "Charlotte", "Amelia", "Mia", "Harper",
            "Evelyn", "Abigail", "Emily", "Ella", "Elizabeth", "Camila",
            "Luna", "Sofia", "Avery", "Mila", "Aria", "Scarlett", "Penelope",
            "Layla", "Chloe", "Victoria", "Madison", "Eleanor", "Grace",
            "Nora", "Riley", "Zoey", "Hannah", "Hazel", "Lily", "Ellie",
            "Violet", "Lillian", "Zoe", "Stella", "Aurora", "Natalie",
            "Emilia", "Everly", "Leah", "Aubrey", "Willow", "Addison",
            "Lucy", "Audrey", "Bella", "Liam", "Noah", "William", "James",
            "Logan", "Benjamin", "Mason", "Elijah", "Oliver", "Jacob",
            "Lucas", "Michael", "Alexander", "Ethan", "Daniel", "Matthew",
            "Aiden", "Henry", "Joseph", "Jackson", "Samuel", "Sebastian",
            "David", "Carter", "Wyatt", "Jayden", "John", "Owen", "Dylan",
            "Luke", "Gabriel", "Anthony", "Isaac", "Grayson", "Jack",
            "Julian", "Levi", "Christopher", "Joshua", "Andrew", "Lincoln",
            "Mateo", "Ryan", "Jaxon", "Nathan", "Aaron", "Isaiah", "Thomas",
            "Charles", "Caleb" };

    private static final String[] LAST_NAMES = { "Smith", "Johnson", "Williams",
            "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor",
            "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin",
            "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez",
            "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez",
            "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams",
            "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez",
            "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans",
            "Edwards", "Collins" };

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

    public static void main(String[] args) throws FileNotFoundException {
        PrintWriter out = new PrintWriter(new File("test.sql"));

        //generate random people
        for (int _ = 0; _ < COUNT_OF_PEOPLE; _++) {
            Person.generate();
        }

        addScript(SCRIPT_SEPARATOR);

        //generate platforms
        for (int _ = 0; _ < COUNT_OF_PLATFORMS; _++) {
            Person randomPerson = selectRandomPerson();

            Phone.generate(randomPerson.person_id);
            if (random.nextBoolean())
                Phone.generate(randomPerson.person_id);

            Email.generate(randomPerson.person_id);
            if (random.nextBoolean())
                Email.generate(randomPerson.person_id);

            Platform.generate(randomPerson.person_id);
        }

        addScript(SCRIPT_SEPARATOR);

        //generate cases
        for (int _ = 0; _ < COUNT_OF_CASES; _++) {
            //TODO
        }

        //generate championships
        for (int _ = 0; _ < COUNT_OF_CHAMPIONSHIPS; _++) {
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

    public static String generateLastName() {
        return LAST_NAMES[random.nextInt(LAST_NAMES.length)];
    }

    public static String generateFirstName() {
        return FIRST_NAMES[random.nextInt(FIRST_NAMES.length)];
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

    private static Person selectRandomPerson() {
        return people.get(random.nextInt(people.size()));
    }
}