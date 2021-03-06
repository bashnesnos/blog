title=Пишем блог на двух языках с помощью JBake
date=2014-03-27
type=post
tags=jbake, локализация
status=published
~~~~~~
Что ж, с почином.

Поскольку блог начался с прочтения этого поста [про создание блога с помощью JBake и jbake-gradle-plugin](http://melix.github.io/blog/2014/02/hosting-jbake-github.html), то мой первый пост будет тоже на эту тему (и прощу прощения за обилие "постов" и "блогов" в этом предложении). Мне определённо нравится Gradle (все текущие проекты собираю с ним), да и выпечка привлекает, так что решил попробовать.

Всё заработало отлично. Но вот незадача, локализации в JBake нет. Т.е. блог можно вести на одном языке. Так-то больше одного редко кому понадобится, но почему бы и не вести на двух языках, была бы возможность. На том и порешил попытаться <del>всё сломать</del>добавить такую возможность.

Идея такая: локализованные страницы во время сборки отправлять в отдельную папку. Так как блог предполагается статический, то это самый простой и убийственый вариант. Переключение между локализациями будет заключатся в вырезании из/добавления в URL нужного нам куска. Например, будет происходить следующая трансформация:

	src\jbake\content\2014\jbake_locale.md -> \2014\jbake_locale.html (оригинальная страница)
	src\jbake\content\2014\en_jbake_locale.md -> \en\2014\jbake_locale.html (локализованная)

Т.е. чтобы переключиться на английскую версию в данном примере, надо будет на оригинальной страниjaце в URL добавить **en\\**. Что и прозойдёт, если клинкуть <a href="/blog/en/2014/jbake_locale.html">сюда</a>

Экономия заключатся в том, что в исходниках не надо копировать дерево папок туда-сюда, и локализованный с нелокализованным лежат рядышком. JBake сам сгенерит всё, что надо.

Жёстких ограничений нет, чтобы работало надо придерживаться следующих правил:
* Имя файла с локализацией должно отличаться от имени оригинала только приставкой _localeId\__ (в данном примере **en_**)
* Нужно добавить в jbake.properties типы шаблонов, которые будут использоваться для генерации локализованных версий страниц
* Имена шаблонов должны начинаться с _localeId\__ (в данном примере **en_**)
* В шаблонах надо не забывать приставлять _localeId\__ при ссылках на другие шаблоны и при проставлении гиперссылок

В общем-то, _localeId\__ определяется из jbake.properties. Если указан темплэйт вида **en_**post, **en_** будет определяться как один из _localeId\__.

Итого, вот как выглядит jbake.properties для моего блога:

    site.host=http://localhost:8080
    template.en_post.file=en_post.ftl
    template.en_page.file=en_page.ftl
    template.en_index.file=en_index.ftl
    template.en_archive.file=en_archive.ftl
    template.en_feed.file=en_feed.ftl
    render.tags=false

Но самих локализованных шаблонов несколько больше (en_menu, en_footer учавствуют не напрямую, а включаются в перечисленные в jbake.properties):

    en_archive.ftl
    en_feed.ftl
    en_footer.ftl
    en_header.ftl
    en_index.ftl
    en_menu.ftl
    en_page.ftl
    en_post.ftl

Пока это работает только для шаблонов Freemarker, буду добавлять в остальные, если фича пройдёт модерацию. Если получится, то это будет мой первый более-менее весомый вклад в ПО с открытым кодом!