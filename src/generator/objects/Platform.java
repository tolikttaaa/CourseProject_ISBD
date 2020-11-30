package generator.objects;

import generator.Generator;

public class Platform {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO platform (name, address, contact_person_id) VALUES ('%s', '%s', %d);";
    private static final String NAME_TEMPLATE = "Platform #%d";

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
        return insert(generateName(), "Some specific address", contact_person_id);
    }

    public static Platform insert(String name, String address, int contact_person_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, address, contact_person_id));

        Platform newPlatform = new Platform(name, address, contact_person_id);
        Generator.platforms.add(newPlatform);

        return newPlatform;
    }

    private static String generateName() {
        return String.format(NAME_TEMPLATE, cnt);
    }
}
