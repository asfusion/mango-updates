<cfimport prefix="mango" taglib="../../tags/mango">
<cfimport prefix="mangox" taglib="../../tags/mangoextras">
<cfimport prefix="template" taglib=".">
<cfif thisTag.executionMode EQ "start">
<li>
<form name="searchForm" id="searchform" method="get" action="<mango:Blog searchUrl />">
		<div><input type="text" value="" name="term" id="s" /><input type="submit" id="searchsubmit" value="Search" /></div>
</form>
</li>
<li>
	<h2 class="sidebartitle">Categories</h2>
	<ul class="list-cat"><mango:Categories parent=""><mango:Category>
		<li><a href="<mango:CategoryProperty link />" title="<mango:CategoryProperty title />"><mango:CategoryProperty title /></a> (<mango:CategoryProperty postCount />)</li>
	</mango:Category>
		</mango:Categories>
	</ul>
</li>

<li>
   <h2 class="sidebartitle">Archives</h2>
	<ul class="list-archives"><mango:Archives type="month"><mango:Archive>
        	<li><a href='<mango:ArchiveProperty link />' title='<mango:ArchiveProperty title dateformat="mmmm yyyy" />'><mango:ArchiveProperty title dateformat="mmmm yyyy" /></a></li>
</mango:Archive></mango:Archives>
      </ul>
</li>
<!--- Links --->
<mangox:LinkCategories>
<mangox:LinkCategory>
<li>
	<h2 class="sidebartitle"><mangox:LinkCategoryProperty name /></h2>
	<ul class="list-blogroll"><mangox:Links><mangox:Link>
	<li><a href="<mangox:LinkProperty address />"><mangox:LinkProperty title /></a></li></mangox:Link></mangox:Links>
	</ul>
</li>
</mangox:LinkCategory>
</mangox:LinkCategories>
</cfif>