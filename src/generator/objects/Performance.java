package generator.objects;

import generator.Generator;

import java.time.LocalDateTime;

public class Performance {
    private static int cnt = 1;

    private static final String INSERT_SCRIPT_TEMPLATE = "INSERT INTO performance (project_id, performance_time, judge_team_id, platform_id) VALUES (%d, '%s', %d, %d);";
    private static final String SQL_TIMESTAMP_TEMPLATE = "%04d-%02d-%02d %02d:%02d:%02d";

    public int performance_id;
    public int project_id;
    public LocalDateTime performance_time;
    public int judge_team_id;
    public int platform_id;
    public float points;

    private Performance(int project_id, LocalDateTime performance_time, int judge_team_id, int platform_id) {
        this.performance_id = cnt++;
        this.project_id = project_id;
        this.performance_time = performance_time;
        this.judge_team_id = judge_team_id;
        this.platform_id = platform_id;
        this.points = 0.0f;
    }

    public static Performance generate(int project_id, int judge_team_id, int platform_id) {
        return insert(project_id, LocalDateTime.now(), judge_team_id, platform_id);
    }

    public static Performance insert(int project_id, LocalDateTime performance_time, int judge_team_id, int platform_id) {
        Generator.addScript(String.format(INSERT_SCRIPT_TEMPLATE,
                project_id, getSQLTimestamp(performance_time), judge_team_id, platform_id));

        Performance newPerformance = new Performance(project_id, performance_time, judge_team_id, platform_id);
        Generator.performances.add(newPerformance);

        return newPerformance;
    }

    private static String getSQLTimestamp(LocalDateTime time) {
        return String.format(SQL_TIMESTAMP_TEMPLATE,
                time.getYear(),
                time.getMonthValue(),
                time.getDayOfMonth(),
                time.getHour(),
                time.getMinute(),
                time.getSecond());
    }
}
