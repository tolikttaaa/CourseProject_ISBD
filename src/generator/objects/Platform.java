package generator.objects;

import generator.Generator;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class Platform {
    private static int cnt = 1;

    private static Set<String> PLATFORM_NAMES = new HashSet<>(Arrays.asList("Tuvalu", "CKiribati", "Marshall Islands",
            "Montserrat", "Niue", "American Samoa", "Solomon Islands", "Comoros", "Federated States of Micronesia",
            "Djibouti", "Sierra Leone", "Guinea", "Tonga", "Anguilla", "Timor Leste",
            "St. Vincent and the Grenadines", "San Marino", "Dominica", "Liechtenstein", "Vanuatu",
            "St. Kitts and Nevis", "New Caledonia", "Eritrea", "Moldova", "Haiku Stairs", "Enchanting River",
            "Crooked Forest", "Hitachi Seaside Park", "Pangong Tso Lake", "Apostle Islands", "Salar de Uyuni",
            "Aquarium", "Rotorua Hot springs", "Svalbard", "The Door to Hell", "Huacachina", "Monastery of Santa Maria",
            "Psychedelic Salt Mines", "Lake Natron", "Montreal Botanical Garden", "Java"));

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO platform (name, address, contact_person_id) VALUES ('%s', '%s', %d);";

    public int platform_id;
    public String name;
    public String address;
    public int contact_person_id;

    private Platform(String name, String address, int contact_person_id) {
        this.platform_id = cnt++;
        this.name = name;
        this.address = address;
        this.contact_person_id = contact_person_id;
    }

    public static Platform generate(int contact_person_id) {
        return insert(generatePlatformName(), "Some specific address", contact_person_id);
    }

    public static Platform insert(String name, String address, int contact_person_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, address, contact_person_id));

        Platform newPlatform = new Platform(name, address, contact_person_id);
        Generator.platforms.add(newPlatform);

        return newPlatform;
    }

    private static String generatePlatformName() {
        int resInd = Generator.random.nextInt(PLATFORM_NAMES.size());
        int cur = 0;

        for (String s : PLATFORM_NAMES) {
            if (cur == resInd) {
                PLATFORM_NAMES.remove(s);
                return s;
            }

            cur++;
        }

        return "ERROR_BD_ERROR";
    }
}
