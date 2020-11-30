package generator.objects;

import generator.Generator;

import java.time.LocalDate;
import java.util.ArrayList;

public class Champioship {
    private static int cnt = 1;

    private static String[] CHAMPIONSHIP_NAMES = { "Achernar", "Acrux", "Aldebaran", "Alpha Centauri",
            "Altair", "Antares", "Arcturus", "Betelgeuse", "Canopus", "Capella", "Castor", "Deneb",
            "Fomalhaut", "Pollux", "Procyon", "Regulus", "Rigel", "Sirius", "Spica", "Vega" };

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_championship('%s', '%s', '%s', '%s');";
    private static final String DESCRIPTION_TEMPLATE = "Championship \"%s\"";

    public int championship_id;
    public String name;
    public String description;
    public LocalDate begin_date;
    public LocalDate end_date;
    public ArrayList<Integer> platforms;
    public ArrayList<Integer> cases;

    private Champioship(String name, String description, ArrayList<Integer> cases, ArrayList<Integer> platforms) {
        this.championship_id = cnt++;
        this.name = name;
        this.description = description;
        this.platforms = platforms;
        this.cases = cases;
    }

    public static Champioship generate(ArrayList<Integer> cases, ArrayList<Integer> platforms) {
        String title = generateChampionshipName();
        return insert(title, String.format(DESCRIPTION_TEMPLATE, title), cases, platforms);
    }

    public static Champioship insert(String name, String description, ArrayList<Integer> cases, ArrayList<Integer> platforms) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE,
                name,
                description,
                Generator.getIntArray(cases),
                Generator.getIntArray(platforms)));

        Champioship newChampionship = new Champioship(name, description, cases, platforms);
        Generator.championships.add(newChampionship);

        return newChampionship;
    }

    private static String generateChampionshipName() {
        return CHAMPIONSHIP_NAMES[Generator.random.nextInt(CHAMPIONSHIP_NAMES.length)];
    }
}
