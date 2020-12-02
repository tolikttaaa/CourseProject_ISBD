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
Sort  (cost=69.65..72.26 rows=1042 width=17) (actual time=0.869..1.160 rows=1042 loops=1)
  Sort Key: birth_date
  Sort Method: quicksort  Memory: 121kB
  ->  Seq Scan on people  (cost=0.00..17.42 rows=1042 width=17) (actual time=0.010..0.375 rows=1042 loops=1)
Planning time: 0.087 ms
Execution time: 1.417 ms
```

#### Создание индекса
```SQL
CREATE INDEX "b_date_btree_index" ON people USING hash ("last_name");
```

#### План выполнения запроса с использованием индекса

```
Index Scan using b_date_btree_index on people  (cost=0.28..63.83 rows=1042 width=17) (actual time=0.017..0.672 rows=1042 loops=1)
Planning time: 0.070 ms
Execution time: 0.949 ms
```

#### Вывод

Время выполнения запроса сократилось в несколько раз, так как вместо перебора всех строк таблицы `perfofmance` (сложность `O(n)`) 
производится поиск по листьям сбалансированного дерева (сложность `O(log(n))`). Соответственно при увеличении обёма данных время выполнения 
запроса с использованием индекса будет в `n/log(n)` раз меньше, чем без использования индекса.