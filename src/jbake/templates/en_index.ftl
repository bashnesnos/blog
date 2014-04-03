<#include "en_header.ftl">
	
	<#include "en_menu.ftl">

	<div class="page-header">
		<h1>Blog</h1>
	</div>
	<#list en_posts as post>

  		<#if (post.status == "published")>
  			<a href="/blog${post.uri}"><h1><#escape x as x?xml>${post.title}</#escape></h1></a>
  			<p>${post.date?string("dd MMMM yyyy")}</p>
  			
  			<div class="container">
  			<a href="https://twitter.com/share" class="twitter-share-button" data-text="${post.title}" data-url="${config.site_host}${post.uri}" data-via="AlexanderSemelit" data-lang="en">Twitter</a>
			<div class="g-plusone" data-size="medium" data-href="${config.site_host}${post.uri}"></div>
			<script type="IN/Share" data-url="${config.site_host}${post.uri}" data-counter="right"></script>
			<div class="fb-like" data-href="${config.site_host}${post.uri}" data-layout="button_count" data-action="like" data-show-faces="false" data-share="true"></div>
			</div>

  			<p>${post.body}</p>
  			<p><a href="/blog${post.uri}#disqus_thread">Comments</a></p>
  		</#if>
  	</#list>
	
	<hr />
	
	<p>Older posts are available in the <a href="/blog/en/${config.archive_file}">archive</a>.</p>

<#include "en_footer.ftl">