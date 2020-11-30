package generator.objects;

import generator.Generator;
//fixme оно работает, просто посмотри
public class Publication {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_publication('%s','%s');";
    private static final String DESCRIPTION_TEMPLATE = "Article about %s";

    public int publication_id;
    public String name;
    public String description;

    private Publication(String name, String description) {
        this.publication_id = cnt++;
        this.name = name;
        this.description = description;
    }

    public static Publication generate() {
        String title = Generator.generatePublicationName();
        return insert(title,String.format(DESCRIPTION_TEMPLATE, title.toLowerCase()));
    }

    public static Publication insert(String name, String description) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, description));

        Publication newPublication = new Publication(name, description);
        Generator.publications.add(newPublication);

        return newPublication;
    }

}
