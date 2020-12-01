package generator.objects;

import generator.Generator;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class Publication {
    private static int cnt = 1;

    private static final Set<String> PUBLICATION_NAMES = new HashSet<>(Arrays.asList("Web developing in modern world",
            "Cybernetic", "Technology As A Service", "Internet of Things (IoT)", "OEM and ODM Development",
            "DevOps for software and hardware", "Application Containers", "Artificial Intelligence",
            "Operation Systems", "Software-defined networking", "Big Data", "IPv6", "Cloud computing",
            "Quantum physics", "Mechanic", "Optics", "Finances", "Investments", "Maths", "Git", "Kotlin vs Java",
            "Front-end development", "Back-end development", "UI/UX design", "The activation stack", "The C Language",
            "Functions in C", "Command Line Args", "NASA at 50", "The Space Race",
            "USB - How Connecting Electronic Devices Works", "Smart TV - Television and the Internet",
            "The International Space Station", "Silicon Valley - Americas High-Tech Center",
            "Air Force One - A Special Airplane for the American President",
            "Burj Dubai - The Tallest Building in the World", "Virtual Worlds are Useful for Children",
            "The Delta Works - The Netherlands Fight Against the Sea",
            "Cloud Computing - Using Software and Storing Data on the Internet", "The New Google Earth",
            "Project Apollo - NASAs Mission to the Moon", "The Hubble Space Telescope", "Cars of the Future",
            "Developing Countries Use More Mobile Phones", "Aircraft Carriers - Airports in the Sea",
            "Journeys End for Microsofts Flight Simulator", "China Blocks YouTube", "Submarines",
            "Web 3.0 - Development of the World Wide Web", "The Manhattan Project"));

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_publication_with_authors('%s', '%s', '%s');";
    private static final String DESCRIPTION_TEMPLATE = "Article about %s";

    public int publication_id;
    public String name;
    public String description;
    public ArrayList<Integer> authors;

    private Publication(String name, String description, ArrayList<Integer> authors) {
        this.publication_id = cnt++;
        this.name = name;
        this.description = description;
        this.authors = authors;
    }

    public static Publication generate(ArrayList<Integer> authors) {
        String title = generatePublicationName();
        return insert(title, String.format(DESCRIPTION_TEMPLATE, title.toLowerCase()), authors);
    }

    public static Publication insert(String name, String description, ArrayList<Integer> authors) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, description, Generator.getIntArray(authors)));

        Publication newPublication = new Publication(name, description, authors);
        Generator.publications.add(newPublication);

        return newPublication;
    }

    private static String generatePublicationName() {
        int resInd = Generator.random.nextInt(PUBLICATION_NAMES.size());
        int cur = 0;

        for (String s : PUBLICATION_NAMES) {
            if (cur == resInd) {
                PUBLICATION_NAMES.remove(s);
                return s;
            }

            cur++;
        }

        return "ERROR_BD_ERROR";
    }
}
