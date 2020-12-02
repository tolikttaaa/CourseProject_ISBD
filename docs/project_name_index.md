### Пользовательская задача

Представитель организационного комитета (далее пользователь) хочет получить данные о команде, работающей над определённым проектом.

### Пример возможного запроса

```SQL
SELECT team.name
FROM team
         JOIN project p ON team.team_id = p.team_id
WHERE p.name = 'Project 1';
```

#### План выполнения запроса без использования индекса

```
Nested Loop  (cost=0.27..20.75 rows=1 width=9) (actual time=0.073..0.256 rows=1 loops=1)
  ->  Seq Scan on project p  (cost=0.00..12.45 rows=1 width=4) (actual time=0.066..0.248 rows=1 loops=1)
        Filter: (name = 'Project 1'::text)
        Rows Removed by Filter: 515
  ->  Index Scan using team_pkey on team  (cost=0.27..8.29 rows=1 width=13) (actual time=0.004..0.005 rows=1 loops=1)
        Index Cond: (team_id = p.team_id)
Planning time: 0.786 ms
Execution time: 0.297 ms

```

#### Создание индекса
```SQL
CREATE INDEX "project_name_index" ON project USING hash ("name");
```

#### План выполнения запроса с использованием индекса

```
Nested Loop  (cost=0.27..16.32 rows=1 width=9) (actual time=0.039..0.041 rows=1 loops=1)
  ->  Index Scan using project_name_index on project p  (cost=0.00..8.02 rows=1 width=4) (actual time=0.033..0.034 rows=1 loops=1)
        Index Cond: (name = 'Project 1'::text)
  ->  Index Scan using team_pkey on team  (cost=0.27..8.29 rows=1 width=13) (actual time=0.003..0.003 rows=1 loops=1)
        Index Cond: (team_id = p.team_id)
Planning time: 0.247 ms
Execution time: 0.062 ms
```

#### Вывод

Время выполнения запроса сократилось в несколько раз, так как вместо перебора всех строк таблицы `project` (сложность `O(n)`) 
производится "переход" по нужному хешу (сложность `O(1)`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n` раз меньше, чем без использования индекса.