### end_championship

end_championship - завершить чемпионат.

#### Описание
Функция позволяет завершить чемпионат. При этом дата завершения заносится в таблицу `championship`, а в 
таблицу `score` заносятся данные о финальном счете, призовых местах и специальных наградах участников.
#### Синтаксис

```SQL 
end_championship(championship_id integer)
```

#### Параметры
`championship_id` - id завершаемого чемпионата.

#### Пример использования

```SQL
SELECT end_championship(1);
```