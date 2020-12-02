### Пользовательская задача

Представитель организационного комитета (пользователь) хочет получить данные о команде, набравшей какое-либо конкретное число баллов.

### Пример возможного запроса

```SQL
SELECT team.name
FROM team
         JOIN score ON team.team_id = score.team_id
         JOIN championship c ON c.championship_id = team.championship_id
WHERE final_score = 1
  AND c.championship_id = 1;
```

#### План выполнения запроса без использования индекса

```
Nested Loop  (cost=10.33..26.78 rows=1 width=9) (actual time=0.292..0.504 rows=2 loops=1)
  ->  Hash Join  (cost=10.18..18.61 rows=1 width=13) (actual time=0.270..0.468 rows=2 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.024..0.216 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=10.11..10.11 rows=5 width=4) (actual time=0.160..0.160 rows=5 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Seq Scan on score  (cost=0.00..10.11 rows=5 width=4) (actual time=0.032..0.148 rows=5 loops=1)
                    Filter: (final_score = '1'::double precision)
                    Rows Removed by Filter: 404
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (actual time=0.010..0.013 rows=1 loops=2)
        Index Cond: (championship_id = 1)
        Heap Fetches: 2
Planning time: 0.490 ms
Execution time: 0.557 ms
```

#### Создание индекса
```SQL
CREATE INDEX "f_score_hash_index" ON score USING btree ("final_score");
```

#### План выполнения запроса с использованием индекса

```
Nested Loop  (cost=9.58..26.04 rows=1 width=9) (actual time=0.072..0.147 rows=2 loops=1)
  ->  Hash Join  (cost=9.43..17.86 rows=1 width=13) (actual time=0.065..0.136 rows=2 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.009..0.081 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=9.37..9.37 rows=5 width=4) (actual time=0.026..0.026 rows=5 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Bitmap Heap Scan on score  (cost=4.04..9.37 rows=5 width=4) (actual time=0.017..0.021 rows=5 loops=1)
                    Recheck Cond: (final_score = '1'::double precision)
                    Heap Blocks: exact=3
                    ->  Bitmap Index Scan on f_score_hash_index  (cost=0.00..4.04 rows=5 width=0) (actual time=0.012..0.012 rows=5 loops=1)
                          Index Cond: (final_score = '1'::double precision)
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (actual time=0.003..0.004 rows=1 loops=2)
        Index Cond: (championship_id = 1)
        Heap Fetches: 2
Planning time: 0.279 ms
Execution time: 0.179 ms

```
### Пользовательская задача

Представитель организационного комитета (пользователь) хочет получить данные о команде, набравшей максимальное/минимальное количество баллов 

### Пример возможного запроса

```SQL
SELECT team.name
FROM team
         JOIN score ON team.team_id = score.team_id
         JOIN championship c ON c.championship_id = team.championship_id
WHERE final_score = (SELECT MAX(final_score) FROM score)
  AND c.championship_id = 1;
```

#### План выполнения запроса без использования индекса

```
Nested Loop  (cost=20.41..36.87 rows=1 width=9) (actual time=1.155..1.155 rows=0 loops=1)
  InitPlan 1 (returns $0)
    ->  Aggregate  (cost=10.11..10.12 rows=1 width=4) (actual time=0.701..0.702 rows=1 loops=1)
          ->  Seq Scan on score score_1  (cost=0.00..9.09 rows=409 width=4) (actual time=0.007..0.332 rows=409 loops=1)
  ->  Hash Join  (cost=10.14..18.57 rows=1 width=13) (actual time=1.153..1.153 rows=0 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.025..0.216 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=10.11..10.11 rows=2 width=4) (actual time=0.849..0.849 rows=1 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Seq Scan on score  (cost=0.00..10.11 rows=2 width=4) (actual time=0.764..0.844 rows=1 loops=1)
                    Filter: (final_score = $0)
                    Rows Removed by Filter: 408
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (never executed)
        Index Cond: (championship_id = 1)
        Heap Fetches: 0
Planning time: 0.623 ms
Execution time: 1.248 ms
```

#### Создание индекса
```SQL
CREATE INDEX "f_score_btree_index" ON score USING btree ("final_score");
```

#### План выполнения запроса с использованием индекса

```
Nested Loop  (cost=9.03..25.49 rows=1 width=9) (actual time=0.181..0.181 rows=0 loops=1)
  InitPlan 2 (returns $1)
    ->  Result  (cost=0.33..0.34 rows=1 width=4) (actual time=0.058..0.059 rows=1 loops=1)
          InitPlan 1 (returns $0)
            ->  Limit  (cost=0.27..0.33 rows=1 width=4) (actual time=0.056..0.056 rows=1 loops=1)
                  ->  Index Only Scan Backward using f_score_btree_index on score score_1  (cost=0.27..23.43 rows=409 width=4) (actual time=0.054..0.054 rows=1 loops=1)
                        Index Cond: (final_score IS NOT NULL)
                        Heap Fetches: 0
  ->  Hash Join  (cost=8.54..16.97 rows=1 width=13) (actual time=0.181..0.181 rows=0 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.011..0.082 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=8.52..8.52 rows=2 width=4) (actual time=0.070..0.070 rows=1 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Bitmap Heap Scan on score  (cost=4.29..8.52 rows=2 width=4) (actual time=0.067..0.067 rows=1 loops=1)
                    Recheck Cond: (final_score = $1)
                    Heap Blocks: exact=1
                    ->  Bitmap Index Scan on f_score_btree_index  (cost=0.00..4.29 rows=2 width=0) (actual time=0.063..0.063 rows=1 loops=1)
                          Index Cond: (final_score = $1)
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (never executed)
        Index Cond: (championship_id = 1)
        Heap Fetches: 0
Planning time: 0.471 ms
Execution time: 0.222 ms
```

#### Вывод
В первом сценарии использования время выполнения запроса сократилось в несколько раз, так как вместо перебора всех строк таблицы `score` (сложность `O(n)`) 
производится "переход" по нужному хешу (сложность `O(1)`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n` раз меньше, чем без использования индекса.

Во втором сценарии использования время выполнения запроса сократилось в несколько раз,так как вместо перебора всех строк таблицы `score` (сложность `O(n)`) 
производится поиск по листьям сбалансированного дерева (сложность `O(log(n))`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n/log(n)` раз меньше, чем без использования индекса.

Для данных задач необходимо создать два различных индекса, так как `hash` будет использоваться только при прямом сравнении (первый сценарий),
 а `btree` подходит для сравнения при помощи знаков `<, > и т.д.`, что необходимо для поиска максимального/минимального значения.