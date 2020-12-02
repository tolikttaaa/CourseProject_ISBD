### add_mentor_to_team

add_mentor_to_team - добавить кейс в чемпионат.

#### Описание
Функция позволяет осуществлять добавление информации о менторе, закреплённом за конкретной командой.
Добавление происходит в таблицу `mentor_team`.
#### Синтаксис

```SQL 
add_mentor_to_team(mentor_id integer, championship_id integer, team_id integer)
```

#### Параметры
`mentor_id` - id добавляемого ментора.
`championship_id` - id чемпионата в котором участвует команда.
`team_id` - id команды в которую происходит добавление ментора.

#### Пример использования

```SQL
SELECT add_mentor_to_team(5,1,1);
```