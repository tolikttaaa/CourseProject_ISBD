### Пользовательская задача

Представитель организационного комитета (пользователь) хочет получить данные о командах, ставших победителями и 
призерами/занявших какой-либо промежуток мест.

### Пример возможного запроса

```SQL
SELECT team.name
FROM team
         JOIN score ON team.team_id = score.team_id
         JOIN championship c ON c.championship_id = team.championship_id
WHERE place <= 3
  AND c.championship_id = 1;
```

#### План выполнения запроса без использования индекса

```
Nested Loop  (cost=10.45..26.95 rows=3 width=9) (actual time=0.479..0.739 rows=3 loops=1)
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (actual time=0.044..0.046 rows=1 loops=1)
        Index Cond: (championship_id = 1)
        Heap Fetches: 1
  ->  Hash Join  (cost=10.30..18.75 rows=3 width=13) (actual time=0.419..0.671 rows=3 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.030..0.270 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=10.11..10.11 rows=15 width=4) (actual time=0.308..0.308 rows=15 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Seq Scan on score  (cost=0.00..10.11 rows=15 width=4) (actual time=0.039..0.291 rows=15 loops=1)
                    Filter: (place <= 3)
                    Rows Removed by Filter: 394
Planning time: 1.284 ms
Execution time: 0.803 ms
```

#### Создание индекса
```SQL
CREATE INDEX "place_index" ON score USING btree ("place");
```

#### План выполнения запроса с использованием индекса

```
Nested Loop  (cost=9.91..26.41 rows=3 width=9) (actual time=0.084..0.161 rows=3 loops=1)
  ->  Index Only Scan using championship_pkey on championship c  (cost=0.15..8.17 rows=1 width=4) (actual time=0.007..0.008 rows=1 loops=1)
        Index Cond: (championship_id = 1)
        Heap Fetches: 1
  ->  Hash Join  (cost=9.76..18.21 rows=3 width=13) (actual time=0.076..0.151 rows=3 loops=1)
        Hash Cond: (team.team_id = score.team_id)
        ->  Seq Scan on team  (cost=0.00..8.11 rows=82 width=17) (actual time=0.016..0.084 rows=82 loops=1)
              Filter: (championship_id = 1)
              Rows Removed by Filter: 327
        ->  Hash  (cost=9.58..9.58 rows=15 width=4) (actual time=0.031..0.031 rows=15 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 9kB
              ->  Bitmap Heap Scan on score  (cost=4.39..9.58 rows=15 width=4) (actual time=0.014..0.022 rows=15 loops=1)
                    Recheck Cond: (place <= 3)
                    Heap Blocks: exact=4
                    ->  Bitmap Index Scan on place_index  (cost=0.00..4.38 rows=15 width=0) (actual time=0.010..0.010 rows=15 loops=1)
                          Index Cond: (place <= 3)
Planning time: 0.241 ms
Execution time: 0.206 ms
```


#### Вывод

Время выполнения запроса сократилось в несколько раз, так как вместо перебора всех строк таблицы `score` (сложность `O(n)`) 
производится поиск по листьям сбалансированного дерева (сложность `O(log(n))`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n/log(n)` раз меньше, чем без использования индекса.
