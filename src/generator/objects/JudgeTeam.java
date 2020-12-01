package generator.objects;

import generator.Generator;

import java.util.ArrayList;

public class JudgeTeam {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "SELECT insert_judge_team('%s', %d);";

    public int judge_team_id;
    public ArrayList<Integer> judges;
    public int championship_id;

    private JudgeTeam(ArrayList<Integer> judges, int championship_id) {
        this.judge_team_id = cnt++;
        this.judges = judges;
        this.championship_id = championship_id;
    }

    public static JudgeTeam generate(ArrayList<Integer> judges, int championship_id) {
        return insert(judges, championship_id);
    }

    public static JudgeTeam insert(ArrayList<Integer> judges, int championship_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE,
                Generator.getIntArray(judges),
                championship_id));

        JudgeTeam newJudgeTeam = new JudgeTeam(judges, championship_id);
        Generator.judgeTeams.add(newJudgeTeam);

        return newJudgeTeam;
    }
}
