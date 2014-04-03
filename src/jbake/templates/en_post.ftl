<#include "en_header.ftl">

	<#include "en_menu.ftl">
	
	<div class="page-header">
		<h1><#escape x as x?xml>${content.title}</#escape></h1>
	</div>

	<p><em>${content.date?string("dd MMMM yyyy")}</em></p>

	<div class="container">
	<a href="https://twitter.com/share" class="twitter-share-button" data-text="${content.title}" data-url="${config.site_host}${content.uri}" data-via="AlexanderSemelit" data-lang="en">Twitter</a>
	<div class="g-plusone" data-size="medium" data-href="${config.site_host}${content.uri}"></div>
	<script type="IN/Share" data-url="${config.site_host}${content.uri}" data-counter="right"></script>
	<div class="fb-like" data-href="${config.site_host}${content.uri}" data-layout="button_count" data-action="like" data-show-faces="false" data-share="true"></div>
	</div>


	<p>${content.body}</p>

	<div class="container">
	<a href="https://twitter.com/share" class="twitter-share-button" data-text="${content.title}" data-url="${config.site_host}${content.uri}" data-via="AlexanderSemelit" data-lang="en">Twitter</a>
	<div class="g-plusone" data-size="medium" data-href="${config.site_host}${content.uri}"></div>
	<script type="IN/Share" data-url="${config.site_host}${content.uri}" data-counter="right"></script>
	<div class="fb-like" data-href="${config.site_host}${content.uri}" data-layout="button_count" data-action="like" data-show-faces="false" data-share="true"></div>
	</div>

	<hr>
    
    <div id="disqus_thread"></div>
    <script type="text/javascript">
        /* * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * */
        var disqus_shortname = 'bashneblog'; // required: replace example with your forum shortname
		var disqus_identifier = '${content.uri}';
        /* * * DON'T EDIT BELOW THIS LINE * * */
        (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
        })();
    </script>
    <noscript>Please enable JavaScript to view the <a href="http://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
    <a href="http://disqus.com" class="dsq-brlink">comments powered by <span class="logo-disqus">Disqus</span></a>
    
<#include "en_footer.ftl">