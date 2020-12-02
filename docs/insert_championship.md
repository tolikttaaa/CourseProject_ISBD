### insert_championship

insert_championship - завершить чемпионат.

#### Описание
Функция позволяет добавить информацию о чемпионате. 
Добавление происходит в таблицу `championship`.
#### Синтаксис

```SQL 
insert_championship(name text, description text, cases integer[], platforms integer[])
```

#### Параметры
`name` - название чемпионата.
`description` - текстовое описание чемпионата.
`cases` - массив id кейсов, представленных в чемпионате.
`platforms` - массив id платформ, на которых проходит чемпионат.

#### Пример использования

```SQL
SELECT end_championship(1);
```