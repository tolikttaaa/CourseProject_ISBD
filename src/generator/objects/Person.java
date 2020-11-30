package generator.objects;

import generator.Generator;

import java.time.LocalDate;

public class Person {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_person('%s','%s','%s','%s','%s');";

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
        return generate(Generator.generateFirstName(), Generator.generateLastName(), Generator.generateDate());
    }

    public static Person generate(LocalDate birth_date) {
        return generate(Generator.generateFirstName(), Generator.generateLastName(), birth_date);
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
}
