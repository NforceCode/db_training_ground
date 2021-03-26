/* все пользовтели у которых есть таски */
SELECT "user"
FROM tasks
GROUP BY "user";
/* Пользователь и все его таски */
SELECT "user", task, is_done
FROM tasks
WHERE "user" = 2;
/* Пользователь и все его невыполненные таски */
SELECT "user", task as "incomplete task"
FROM tasks
WHERE "user" = 1 AND is_done = false;
/* Кол-во выполненных тасок пользователя */
SELECT "user", count(task) as "completed tasks"
FROM tasks
WHERE "user" = 2 AND is_done = true
GROUP BY "user";