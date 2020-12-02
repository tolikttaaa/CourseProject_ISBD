### insert_publication

insert_publication - добавить публикацию.

#### Описание
Функция позволяет осуществлять добавление информации о публикации.
Добавление происходит в таблицу `publication`.
#### Синтаксис

```SQL 
insert_publication(name text, description text)
```

#### Параметры
`name` - название публикации.
`description` - описание публикации.

#### Пример использования

```SQL
SELECT insert_publication('Future of WEB-developing','Topic about Evgeny A. Tsopa');
```