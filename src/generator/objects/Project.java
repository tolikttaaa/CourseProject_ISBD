package generator.objects;

import generator.Generator;

import java.util.List;

public class Project {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_project('%s', %d, '%s', '%s');";
    private static final String PROJECT_NAME_TEMPLATE = "Project %d";
    private static final String PROJECT_DESCRIPTION_TEMPLATE = "Description for \"%s\"";

    public int project_id;
    public String name;
    public int team_id;
    public List<Integer> cases;
    public String description;

    private Project(String name, int team_id, List<Integer> cases, String description) {
        this.project_id = cnt++;
        this.name = name;
        this.team_id = team_id;
        this.cases = cases;
        this.description = description;
    }

    public static Project generate(int team_id, List<Integer> cases) {
        String name = generateProjectName();
        return insert(name, team_id, cases, String.format(PROJECT_DESCRIPTION_TEMPLATE, name));
    }

    public static Project insert(String name, int team_id, List<Integer> cases, String description) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE, name, team_id, Generator.getIntArray(cases), description));

        Project newProject = new Project(name, team_id, cases, description);
        Generator.projects.add(newProject);

        return newProject;
    }

    public static String generateProjectName() {
        return String.format(PROJECT_NAME_TEMPLATE, cnt);
    }
}
