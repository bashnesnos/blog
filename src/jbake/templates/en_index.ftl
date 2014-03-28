<#include "en_header.ftl">
	
	<#include "en_menu.ftl">

	<div class="page-header">
		<h1>Blog</h1>
	</div>
	<#list en_posts as post>
  		<#if (post.status == "published")>
  			<a href="${post.uri}"><h1><#escape x as x?xml>${post.title}</#escape></h1></a>
  			<p>${post.date?string("dd MMMM yyyy")}</p>
  			<p>${post.body}</p>
  		</#if>
  	</#list>
	
	<hr />
	
	<p>Older posts are available in the <a href="/en/${config.archive_file}">archive</a>.</p>

<#include "en_footer.ftl">