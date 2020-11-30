package generator.objects;

import generator.Generator;

//fixme я не знаю как передавать массив кейсов и соответственно его выводить

public class Project {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_project('%s', %d, '%s', '%s');";
    private static final String PROJECT_NAME_TEMPLATE = "Project %d";

    public int project_id;
    public String name;
    public int team_id;
    public String description;

    private Project(String name, int team_id, String description) {
        this.project_id = cnt++;
        this.name = name;
        this.team_id = team_id;
        this.description = description;
    }

    public static Project generate() {
        String title = generateProject();
        int _cases = 1;
        return insert(title, cnt, _cases, "The best project ever");
    }

    public static Project generate(int team_id, int _cases) {
        String title = generateProject();
        return insert(title, team_id, _cases, String.format(PROJECT_NAME_TEMPLATE, cnt));
    }

    public static Project insert(String name, int team_id, int _cases, String description) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, team_id,_cases,description));

        Project newProject = new Project(name,team_id, description);
        Generator.projects.add(newProject);

        return newProject;
    }

    public static String generateProject() {
        return generateProject("simple_project");
    }

    public static String generateProject(String name) {
        return String.format(PROJECT_NAME_TEMPLATE, cnt);
    }
}
