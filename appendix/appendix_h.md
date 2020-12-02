### Пользовательская задача

Представитель организационного комитета (пользователь) хочет получить данные о командах, которые на данный момент времени уже защитили свои проекты.

### Пример возможного запроса

```SQL
SELECT team.name
FROM team
         JOIN project ON team.team_id = project.team_id
WHERE project_id = (SELECT project.project_id
                    FROM performance
                             JOIN project ON project.project_id = performance.project_id
                             JOIN team ON project.team_id = team.team_id
                             JOIN championship c ON c.championship_id = team.championship_id
                    WHERE team.championship_id = 1
                      AND performance_time < NOW());
```

#### План выполнения запроса без использования индекса

```
Nested Loop  (cost=31.10..47.14 rows=1 width=9) (actual time=0.195..0.195 rows=0 loops=1)
  InitPlan 1 (returns $2)
    ->  Nested Loop  (cost=0.70..30.55 rows=1 width=4) (actual time=0.191..0.191 rows=0 loops=1)
          ->  Nested Loop  (cost=0.55..22.37 rows=1 width=8) (actual time=0.191..0.191 rows=0 loops=1)
                ->  Nested Loop  (cost=0.28..22.02 rows=1 width=8) (actual time=0.191..0.191 rows=0 loops=1)
                      ->  Seq Scan on performance  (cost=0.00..13.71 rows=1 width=4) (actual time=0.189..0.189 rows=0 loops=1)
                            Filter: (performance_time < now())
                            Rows Removed by Filter: 581
                      ->  Index Scan using project_pkey on project project_1  (cost=0.28..8.29 rows=1 width=8) (never executed)
                            Index Cond: (project_id = performance.project_id)
                ->  Index Scan using team_pkey on team team_1  (cost=0.27..0.35 rows=1 width=8) (never executed)
                      Index Cond: (team_id = project_1.team_id)
                      Filter: (championship_id = 1)
          ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (never executed)
                Index Cond: (championship_id = 1)
                Heap Fetches: 0
  ->  Index Scan using project_pkey on project  (cost=0.28..8.29 rows=1 width=4) (actual time=0.194..0.194 rows=0 loops=1)
        Index Cond: (project_id = $2)
  ->  Index Scan using team_pkey on team  (cost=0.27..8.29 rows=1 width=13) (never executed)
        Index Cond: (team_id = project.team_id)
Planning time: 0.530 ms
Execution time: 0.241 ms
```

#### Создание индекса
```SQL
CREATE INDEX "performance_time_index" ON performance USING btree ("performance_time");
```

#### План выполнения запроса с использованием индекса

```
Nested Loop  (cost=21.68..37.72 rows=1 width=9) (actual time=0.011..0.011 rows=0 loops=1)
  InitPlan 1 (returns $2)
    ->  Nested Loop  (cost=0.97..21.13 rows=1 width=4) (actual time=0.007..0.007 rows=0 loops=1)
          ->  Nested Loop  (cost=0.82..12.95 rows=1 width=8) (actual time=0.007..0.007 rows=0 loops=1)
                ->  Nested Loop  (cost=0.55..12.60 rows=1 width=8) (actual time=0.007..0.007 rows=0 loops=1)
                      ->  Index Scan using performance_time_index on performance  (cost=0.28..4.30 rows=1 width=4) (actual time=0.007..0.007 rows=0 loops=1)
                            Index Cond: (performance_time < now())
                      ->  Index Scan using project_pkey on project project_1  (cost=0.28..8.29 rows=1 width=8) (never executed)
                            Index Cond: (project_id = performance.project_id)
                ->  Index Scan using team_pkey on team team_1  (cost=0.27..0.35 rows=1 width=8) (never executed)
                      Index Cond: (team_id = project_1.team_id)
                      Filter: (championship_id = 1)
          ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (never executed)
                Index Cond: (championship_id = 1)
                Heap Fetches: 0
  ->  Index Scan using project_pkey on project  (cost=0.28..8.29 rows=1 width=4) (actual time=0.010..0.010 rows=0 loops=1)
        Index Cond: (project_id = $2)
  ->  Index Scan using team_pkey on team  (cost=0.27..8.29 rows=1 width=13) (never executed)
        Index Cond: (team_id = project.team_id)
Planning time: 0.512 ms
Execution time: 0.056 ms
```

#### Вывод

Время выполнения запроса сократилось в несколько раз, так как вместо перебора всех строк таблицы `perfofmance` (сложность `O(n)`) 
производится поиск по листьям сбалансированного дерева (сложность `O(log(n))`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n/log(n)` раз меньше, чем без использования индекса.