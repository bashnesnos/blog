title=Localizing your blog with JBake
date=2014-03-27
type=post
tags=jbake, localization
status=published
~~~~~~
(Please disregard dates in russian for now, blog is still in development mode)

Let's get it started.

I was inspired by this post [about authoring a blog with JBake and jbake-gradle-plugin](http://melix.github.io/blog/2014/02/hosting-jbake-github.html); so my first post would be on the same topic (my apologies for too many 'posts' and 'blogs' in one sentence). First of all because it has something to do with Gradle (which I love) and JBake (which is something to learn) in the second turn.

My first time blog was generated, looked nice. What can one wish more? Well, I wish there was kind of a localization capability. It's not common at all, but when you want something and it is not there - you are not completely satisfied. So I decided to try and <del>break everything</del>add such a capability.

The idea is: localized pages during the build are put to a separate folder. Since the pages are static it is the cheapest and straight-forward option. Switching between the localized/original is to be operated by URL manipulation in javascript. E.g. the following transformation will occur:

    src\jbake\content\blog\2014\jbake_locale.md -> \blog\2014\jbake_locale.html (original)
    src\jbake\content\blog\2014\en_jbake_locale.md -> \en\blog\2014\jbake_locale.html (localized)

I.e. to switch back to the original in the given example, we would to remove **en\\** from the URL. Which will happen if you click <a href="/blog/2014/jbake_locale.html">here</a>

By implementing that feature we are saving ourselves from copying and maintaining all the folder structure in our sources for all the kinds of locales. A nice and automatic tool will bake it for us.

Convention is the following:
* Localized post file name should differ from original only by _localeId\__ prefix (in my case **en_**)
* Add the localized templates into jbake.properties
* Localized template name should start from _localeId\__ (in my case **en_**)
* Keep the _localeId\__ in mind when populating links and includes inside of the templates

I will open you the secret: _localeId\__ is being derived from your template declarations in jbake.properties. If you have a template with name **en_**post, **en_** would become one of your _localeId\__

Here is jbake.properties of my blog:

    site.host=http://localhost:8080
    template.en_post.file=en_post.ftl
    template.en_page.file=en_page.ftl
    template.en_index.file=en_index.ftl
    template.en_archive.file=en_archive.ftl
    template.en_feed.file=en_feed.ftl
    render.tags=false

The localized templates list is bigger though (en_menu, en_footer are not an outstanding document types, they are just being included by other localized templates):

    en_archive.ftl
    en_feed.ftl
    en_footer.ftl
    en_header.ftl
    en_index.ftl
    en_menu.ftl
    en_page.ftl
    en_post.ftl

At the moment it works for Freemarker only, I would go on with others if my enhancement would be approved. And in that case it would be my first relatively significant contribution to the open-source!