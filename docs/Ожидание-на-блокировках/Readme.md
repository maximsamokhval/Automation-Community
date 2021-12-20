- [Статьи](#статьи)
- [Заметки](#заметки)

## Статьи

- [Проблема ожидания на блокировках при параллельной работе пользователей в 1С. rarus.ru](https://rarus.ru/publications/20200115-ot-ekspertov-1c-rarus-stranichnye-blokirovki-v-ms-sql-server-pri-provedenii-dokumenta-v-dokumente-v-1c-411421/)
- [Ошибки блокировок 1С. Как исправить конфликт блокировок в 1С 8.3. Как определить уровень изоляции блокировок 1С-запросов?](https://www.koderline.ru/expert/sovety-ekspertov-raznoe/article-oshibki-blokirovok-1s-kak-ispravit-konflikt-blokirovok-v-1s-8-3-kak-opredelit-uroven-izolyatsii-blok/)
- [Возможности оптимизации блокировок 1С](http://cascade-group.com.ua/vozmozhnosti-optimizacii-blokirovok-v-1s/)
- [Расследование ошибки в конфигураторе](https://kostyanetsky.ru/notes/designer-error-investigation/)
- [Оптимизация 1С на реальном примере. История №2 - deadlock](https://infostart.ru/1c/articles/844438/)



## Заметки

- При автоматическом режиме блокировки очистка пустой таблицы блокирует всю таблицу исключительной блокировкой (SERIALIZABLE). Когда у меня возникла такая ситуация, я поставил исключения: не записывать конкретные регистры. [источник](http://forum.infostart.ru/forum34/topic193811/message1996179/#message1996179)