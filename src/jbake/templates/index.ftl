<#include "header.ftl">
	
	<#include "menu.ftl">

	<div class="page-header">
		<h1>Наш маленький программист снова накодил в углу</h1>
	</div>
	<#list posts as post>
  		<#if (post.status == "published")>
  			<a href="${post.uri}"><h1><#escape x as x?xml>${post.title}</#escape></h1></a>
  			<p>${post.date?string("dd MMMM yyyy")}</p>
  			<p>${post.body}</p>
  		</#if>
  	</#list>
	
	<hr />
	
	<p>Посмотреть на старые посты в <a href="/blog/${config.archive_file}">архиве</a>.</p>

<#include "footer.ftl">