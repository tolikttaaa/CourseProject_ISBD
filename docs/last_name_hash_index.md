### Пользовательская задача

Представитель организационного комитета (далее пользователь) хочет получить данные о человеке/людях зная только его/их фамилию.

### Пример возможного запроса

```SQL
SELECT first_name, last_name, birth_date
FROM people
where last_name = 'Williams';
```

#### План выполнения запроса без использования индекса

```
Seq Scan on people  (cost=0.00..20.02 rows=25 width=17) (actual time=0.031..0.317 rows=25 loops=1)
  Filter: (last_name = 'Williams'::text)
  Rows Removed by Filter: 1017
Planning time: 1.049 ms
Execution time: 0.375 ms
```

#### Создание индекса
```SQL
CREATE INDEX "last_name_hash_index" ON people USING hash ("last_name");
```

#### План выполнения запроса с использованием индекса

```
Bitmap Heap Scan on people  (cost=4.19..11.51 rows=25 width=17) (actual time=0.075..0.097 rows=25 loops=1)
  Recheck Cond: (last_name = 'Williams'::text)
  Heap Blocks: exact=7
  ->  Bitmap Index Scan on last_name_hash_index  (cost=0.00..4.19 rows=25 width=0) (actual time=0.041..0.041 rows=25 loops=1)
        Index Cond: (last_name = 'Williams'::text)
Planning time: 0.169 ms
Execution time: 0.123 ms
```

#### Вывод

Время выполнения запроса сократилось в два раза, так как вместо перебора всех строк таблицы `people` (сложность `O(n)`) 
производится "переход" по нужному хешу (сложность `O(1)`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n` раз меньше, чем без использования индекса.