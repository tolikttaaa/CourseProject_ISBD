### add_case_to_championship

add_case_to_championship - добавить кейс в чемпионат.

#### Описание
Функция позволяет осуществлять добавление информации о кейсах, представленных в чемпионате.
Добавление происходит в таблицу `championship_case`.
#### Синтаксис

```SQL 
add_case_to_championship(championship_id integer, case_id integer)
```

#### Параметры
`championship_id` - id добавляемого чемпионата.
`case_id` - id добавляемого кейса.

#### Пример использования

```SQL
SELECT add_case_to_championship(1,1);
```