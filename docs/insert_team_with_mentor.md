### insert_team_with_mentor

insert_team_with_mentor - добавить команду вместе с данными о менторе.

#### Описание
Функция позволяет осуществлять добавление информации о команде.
Добавление происходит в таблицу `team` и `mentor_team`.
#### Синтаксис

```SQL 
insert_team(name text, participants integer[], mentors integer[], leader_id integer, championship_id integer)
```

#### Параметры
`name` - название команды.
`participants` - массив id участников команды.
`mentors` - массив id менторов команды.
`leader_id` - id капитана команды.
`championship_id` - id чемпионата в котором участвует команда.

#### Пример использования

```SQL
SELECT insert_team_with_mentor('Lady Killers', '{496,420,88,606,926}', '{457}', 496, 1);
```