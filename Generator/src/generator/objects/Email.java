package generator.objects;

import generator.Generator;

public class Email {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO email (email, person_id) VALUES ('%s', %d);";
    private static final String EMAIL_TEMPLATE = "%s_%d@gmail.com";

    public String email;
    public int person_id;

    private Email(String email, int person_id) {
        this.email = email;
        this.person_id = person_id;
    }

    public static Email generate(int person_id) {
        return insert(generateEmail(), person_id);
    }

    public static Email insert(String email, int person_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, email, person_id));

        Email newEmail = new Email(email, person_id);
        Generator.emails.add(newEmail);

        return newEmail;
    }

    public static String generateEmail() {
        return generateEmail("simple_email");
    }

    public static String generateEmail(String name) {
        return String.format(EMAIL_TEMPLATE, name.toLowerCase(), cnt++);
    }
}
