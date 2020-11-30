package generator.objects;

import generator.Generator;

public class Case {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO \"case\" (description, complexity) VALUES ('%s', '%s');";
    private static final String DESCRIPTION_TEMPLATE = "Description of the case #%d";

    public int case_id;
    public String description;
    public float complexity;

    private Case(String description, float complexity) {
        this.case_id = cnt++;
        this.description = description;
        this.complexity = complexity;
    }

    public static Case generate() {
        return insert(generateDescription(), Generator.random.nextInt(10) + 1);
    }

    public static Case insert(String description, float complexity) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, description, complexity));

        Case newCase = new Case(description, complexity);
        Generator.cases.add(newCase);

        return newCase;
    }

    private static String generateDescription() {
        return String.format(DESCRIPTION_TEMPLATE, cnt);
    }
}
