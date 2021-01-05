package generator.objects;

import generator.Generator;

import java.time.LocalDate;

public class Person {
    private static int cnt = 1;

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

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_person('%s', '%s', '%s', '%s', '%s');";

    public int person_id;
    public String first_name;
    public String last_name;
    public LocalDate birth_date;

    private Person(String first_name, String last_name, LocalDate birth_date) {
        this.person_id = cnt++;
        this.first_name = first_name;
        this.last_name = last_name;
        this.birth_date = birth_date;
    }

    public static Person generate() {
        return generate(generateFirstName(), generateLastName(), Generator.generateDate());
    }

    public static Person generate(LocalDate birth_date) {
        return generate(generateFirstName(), generateLastName(), birth_date);
    }

    public static Person generate(String first_name, String last_name, LocalDate birth_date) {
        return insert(first_name, last_name, birth_date, Phone.generatePhone(), Email.generateEmail(String.format("%s.%s", first_name, last_name)));
    }

    public static Person insert(String first_name, String last_name, LocalDate birth_date, String phone, String email) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, first_name, last_name, birth_date, phone, email));

        Person newPerson = new Person(first_name, last_name, birth_date);
        Generator.people.add(newPerson);

        return newPerson;
    }

    public static String generateLastName() {
        return LAST_NAMES[Generator.random.nextInt(LAST_NAMES.length)];
    }

    public static String generateFirstName() {
        return FIRST_NAMES[Generator.random.nextInt(FIRST_NAMES.length)];
    }

}
