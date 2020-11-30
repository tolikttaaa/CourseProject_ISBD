package generator.objects;

import generator.Generator;

public class Participant {
    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO participant (person_id, championship_id) VALUES (%d, %d);";

    public int person_id;
    public int championship_id;
    public int team_id;

    private Participant(int person_id, int championship_id) {
        this.person_id = person_id;
        this.championship_id = championship_id;
        this.team_id = -1;
    }

    public static Participant generate(int person_id, int championship_id) {
        return insert(person_id, championship_id);
    }

    public static Participant insert(int person_id, int championship_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, person_id, championship_id));

        Participant newParticipant = new Participant(person_id, championship_id);
        Generator.participants.add(newParticipant);

        return newParticipant;
    }
}
