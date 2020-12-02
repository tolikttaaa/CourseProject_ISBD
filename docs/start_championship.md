### start_championship

start_championship - запустить чемпионат.

#### Описание
Функция позволяет запустить чемпионат. При этом дата начала заносится в таблицу `championship`.
#### Синтаксис

```SQL 
start_championship(championship_id integer)
```

#### Параметры
`championship_id` - id завершаемого чемпионата.

#### Пример использования

```SQL
SELECT start_championship(1);
```