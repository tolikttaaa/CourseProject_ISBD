package generator.objects;

import generator.Generator;

public class Mentor {
    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO mentor (person_id, championship_id) VALUES ('%d', %d);";

    public int person_id;
    public int championship_id;

    private Mentor(int person_id, int championship_id) {
        this.person_id = person_id;
        this.championship_id = championship_id;
    }

    public static Mentor generate(int person_id, int championship_id) {
        return insert(person_id, championship_id);
    }

    public static Mentor insert(int person_id, int championship_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, person_id, championship_id));

        Mentor newMentor = new Mentor(person_id, championship_id);
        Generator.mentors.add(newMentor);

        return newMentor;
    }
}
