### insert_publication_with_authors

insert_publication_with_authors - добавить публикацию месте со сведениями об авторе.

#### Описание
Функция позволяет осуществлять добавление информации о публикации.
Добавление происходит в таблицу `publication` и `people_publication`.
#### Синтаксис

```SQL 
insert_publication(name text, description text, authors integer[])
```

#### Параметры
`name` - название публикации.
`description` - описание публикации.
`authors` - массив id авторов.

#### Пример использования

```SQL
SELECT insert_publication_with_authors('The Manhattan Project', 'Article about the manhattan project', '{320,227,853,363,287}');
```