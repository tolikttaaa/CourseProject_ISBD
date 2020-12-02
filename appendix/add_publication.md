### add_publication

add_publication - добавить публикацию человеку.

#### Описание
Функция позволяет осуществлять добавление информации об авторстве публикации.
Добавление происходит в таблицу `people_publication`.
#### Синтаксис

```SQL 
SELECT add_publication(person_id integer, publication_id integer);
```

#### Параметры
`person_id` - id человека, которому добавляется публикация..
`publication_id` - id публикации.

#### Пример использования

```SQL
SELECT add_publication(5,1);
```