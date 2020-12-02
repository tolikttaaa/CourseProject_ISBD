### insert_person

insert_person - добавить человека.

#### Описание
Функция позволяет добавить информацию о человеке. 
Добавление происходит в таблицы `people`, `phone`,`email`.
#### Синтаксис

```SQL 
insert_person(first_name text, last_name text, birth_date date, phone_number text, email_address text)
```

#### Параметры
`first_name` - имя человека.
`last_name` - фамилия человека.
`birth_date` - дата рождения.
`phone_number` - номер телефона.
`email_address` - адрес электронной почты.

#### Пример использования

```SQL
SELECT insert_person('James', 'Anderson', '1997-10-01', '70000000431', 'james.anderson_431@gmail.com');
```