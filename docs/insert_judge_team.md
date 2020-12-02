### insert_judge_team

insert_judge_team - добавить судейскую бригаду.

#### Описание
Функция позволяет добавить информацию о судейской бригаде. 
Добавление происходит в таблицу `judgeTeam`.
#### Синтаксис

```SQL 
insert_judge_team(judges integer[], championship_id integer)
```

#### Параметры
`judges` - массив id судей, входящих в новую судейскую бригаду.
`championship_id` - id чемпионата, который судит, данная бригада.

#### Пример использования

```SQL
SELECT insert_judge_team('{7,8,9}',1);
```