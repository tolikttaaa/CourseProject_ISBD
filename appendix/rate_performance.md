### insert_team_with_mentor

insert_team_with_mentor - оценить выступление.

#### Описание
Функция позволяет осуществлять добавление информации о результате выступления команды.
Добавление происходит в таблицу `performance`.
#### Синтаксис

```SQL 
rate_performance(performance_id integer, points real)
```

#### Параметры
`performance_id` - id выступления команды.
`points` - оценка за выступление.

#### Пример использования

```SQL
SELECT rate_performance(1, 7.40);
```