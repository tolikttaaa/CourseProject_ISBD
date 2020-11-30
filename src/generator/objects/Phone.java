package generator.objects;

import generator.Generator;

public class Phone {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO phone (phone, person_id) VALUES ('%s', %d);";
    private static final String PHONE_TEMPLATE = "7%010d";

    public String phone;
    public int person_id;

    private Phone(String phone, int person_id) {
        this.phone = phone;
        this.person_id = person_id;
    }

    public static Phone generate(int person_id) {
        return insert(generatePhone(), person_id);
    }

    public static Phone insert(String phone, int person_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, phone, person_id));

        Phone newPhone = new Phone(phone, person_id);
        Generator.phones.add(newPhone);

        return newPhone;
    }

    public static String generatePhone() {
        return String.format(PHONE_TEMPLATE, cnt++);
    }
}
