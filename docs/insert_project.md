### insert_project

insert_project - добавить проект в чемпионат.

#### Описание
Функция позволяет осуществлять добавление информации о проектае, представленном в чемпионате.
Добавление происходит в таблицу `project`.
#### Синтаксис

```SQL 
insert_project(name text, team_id integer, cases integer[], description text)
```

#### Параметры
`name` - название проекта.
`team_id` - id команды, выполняющей проект.
`cases` - массив id выполняемых кейсов.
`description` - описание проекта.

#### Пример использования

```SQL
SELECT insert_project('Project 1', 1, '{17,19}', 'Description for "Project 1"');
```