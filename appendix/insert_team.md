### insert_team

insert_team - добавить команду.

#### Описание
Функция позволяет осуществлять добавление информации о команде.
Добавление происходит в таблицу `team`.
#### Синтаксис

```SQL 
insert_team(name text, participants integer[], leader_id integer, championship_id integer)
```

#### Параметры
`name` - название команды.
`participants` - массив id участников команды.
`leader_id` - id капитана команды.
`championship_id` - id чемпионата в котором участвует команда.

#### Пример использования

```SQL
SELECT insert_team('Lady Killers', '{496,420,88,606,926}', 496, 1);
```