<cfif thisTag.executionMode is "start">
<cfimport prefix="mangoAdmin" taglib="tags">
<cfimport prefix="mangoAdminPartials" taglib="partials">
<cfparam name="attributes.page" default=""/>
<cfparam name="attributes.title" default=""/>
	<cfparam name="attributes.hierarchy" default="#arraynew()#"/>
<cfset blog = request.blogManager.getBlog() />
<cfset currentSkin = request.administrator.getSkin(blog.getSkin()) />
	<cfset currentAuthor = request.blogManager.getCurrentUser() />

<cfcontent reset="true">

	<!DOCTYPE html>
	<html lang="en">

	<head><cfoutput>
		<meta http-equiv="Content-Type" content="text/html;charset=#blog.getCharset()#" />
		<!-- Primary Meta Tags -->
		<title>#attributes.title#</title>
</cfoutput>
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

		<!-- Favicon -->
		<link rel="apple-touch-icon" sizes="120x120" href="assets/img/favicon/apple-touch-icon.png">
		<link rel="icon" type="image/png" sizes="32x32" href="assets/img/favicon/favicon-32x32.png">
		<link rel="icon" type="image/png" sizes="16x16" href="assets/img/favicon/favicon-16x16.png">
		<link rel="manifest" href="assets/img/favicon/site.webmanifest">
		<link rel="mask-icon" href="assets/img/favicon/safari-pinned-tab.svg" color="#ffffff">
		<meta name="msapplication-TileColor" content="#ffffff">
		<meta name="theme-color" content="#ffffff">

		<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

		<!-- Sweet Alert -->
		<link type="text/css" href="assets/js/vendor/sweetalert2/dist/sweetalert2.min.css" rel="stylesheet">

		<!-- Notyf -->
		<link type="text/css" href="assets/js/vendor/notyf/notyf.min.css" rel="stylesheet">


		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" ></script>
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.20.0/jquery.validate.min.js" ></script>
		<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.13.2/jquery-ui.min.js"></script>

		<script type="text/javascript" src="assets/scripts/utils.js" ></script>
		<script type="text/javascript" src="assets/scripts/admin.js" ></script>


		<script type="text/javascript" src="assets/scripts/spry/xpath.js"></script>
		<script type="text/javascript" src="assets/scripts/spry/SpryData.js"></script>
		<script type="text/javascript" src="assets/scripts/spry/SpryJSONDataSet.js"></script>

		<link rel="stylesheet" href="assets/styles/fileexplorer.css">

		<!-- Charts -->
		<script src="assets/js/vendor/chartist/dist/chartist.min.js"></script>
		<script src="assets/js/vendor/chartist-plugin-tooltips/dist/chartist-plugin-tooltip.min.js"></script>


		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/4.5.6/css/ionicons.min.css" integrity="sha512-0/rEDduZGrqo4riUlwqyuHDQzp2D1ZCgH/gFIfjMIL5az8so6ZiXyhf1Rg8i6xsjv+z/Ubc4tt1thLigEcu6Ug==" crossorigin="anonymous" referrerpolicy="no-referrer" />
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.13.1/css/all.min.css" integrity="sha256-2XFplPlrFClt0bIdPgpz8H7ojnk10H69xRqd9+uTShA=" crossorigin="anonymous" />


		<link href="https://cdn.jsdelivr.net/npm/bootstrap-table@1.22.2/dist/bootstrap-table.min.css" rel="stylesheet">

		<script src="https://cdn.jsdelivr.net/npm/bootstrap-table@1.22.2/dist/bootstrap-table.min.js"></script>

		<!-- Volt CSS -->
		<link type="text/css" href="assets/styles/volt.css" rel="stylesheet">
		<link href="assets/styles/custom.css" rel="stylesheet" type="text/css" />

		<style>
	.ui-front {
		z-index:1000000 !important; /* The default is 100. !important overrides the default. */
	}
</style>

		<mangoAdmin:Event name="beforeAdminHeaderEnd" />
</head>
<body>

	<cf_navigation page="#attributes.page#">
	<!--- old --->
<!---
<div id="container">
<div id="header">
	<h1><cfoutput>#blog.getTitle()# &gt; #attributes.title#</h1>
		<div id="viewsitelink"><a href="#blog.getUrl()#">Go to site</a></div></cfoutput>
	<div id="logout"><a href="files.cfm?logout=1">Logout</a></div>
</div>



	--->	<!---<main class="content">

	<nav class="navbar navbar-top navbar-expand navbar-dashboard navbar-dark ps-0 pe-2 pb-0">
			<div class="container-fluid px-0">
				<div class="d-flex justify-content-between w-100" id="navbarSupportedContent">
					<h2 class="h4"><cfoutput>#attributes.title#</cfoutput></h2>

					<mangoAdminPartials:user_menu>

				</div>
			</div>
		</nav>
--->

	<main class="content">

	<nav class="navbar navbar-top navbar-expand navbar-dashboard navbar-dark ps-0 pe-2 pb-0">
	<div class="container-fluid px-0">
	<div class="d-flex justify-content-between w-100" id="navbarSupportedContent">
<!---  <h2 class="h4">Overview</h2>--->
		<nav aria-label="breadcrumb" class="d-none d-md-inline-block">
			<ol class="breadcrumb breadcrumb-dark breadcrumb-transparent mb-0">
				<li class="breadcrumb-item">
					<a href="index.cfm">
						<i class="bi bi-house-door-fill icon icon-xxs"></i>
					</a>
				</li>
	<cfoutput>
				<cfif arraylen( attributes.hierarchy)>
				<cfloop array="#attributes.hierarchy#" item="i">
					<li class="breadcrumb-item"><a href="#i.link#">#i.title#</a></li>
				</cfloop>
				</cfif>
				<li class="breadcrumb-item active" aria-current="page">#attributes.title#</li>

				</cfoutput>
			</ol>
		</nav>

		<!-- Navbar links -->
		<ul class="navbar-nav align-items-center">
			<li class="nav-item dropdown ms-lg-3">
				<a class="nav-link dropdown-toggle pt-1 px-0" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false">
					<div class="media d-flex align-items-center">
						<cfif len( currentAuthor.picture )><img class="avatar rounded-circle" alt="Image placeholder" src="../../assets/img/team/profile-picture-3.jpg">
						<cfelse><span class="sidebar-icon"><i class="bi bi-gear-fill icon icon-xs"></i></span>
</cfif>
						<div class="media-body ms-2 text-dark align-items-center d-none d-lg-block">
							<span class="mb-0 font-small fw-bold text-gray-900"><cfoutput>#currentAuthor.name#</cfoutput></span>
						</div>
					</div>
				</a>
				<div class="dropdown-menu dashboard-dropdown dropdown-menu-end mt-2 py-1">
					<a class="dropdown-item d-flex align-items-center" href="author.cfm?profile=1">
						<svg class="dropdown-icon text-gray-400 me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.986 5.986 0 0010 16a5.986 5.986 0 004.546-2.084A5 5 0 0010 11z" clip-rule="evenodd"></path></svg>
						My Profile
					</a>
					<div role="separator" class="dropdown-divider my-1"></div>
					<a class="dropdown-item d-flex align-items-center" href="index.cfm?logout=1">
						<svg class="dropdown-icon text-danger me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
						Logout
					</a>
				</div>
			</li>
		</ul>
	</div>
	</div>
	</nav>


		<!-- INNER NAV IF NEEDED -->
		<!---<nav class="navbar navbar-expand-lg navbar-transparent navbar-dark navbar-theme-primary mb-4">
			<div class="">
				<div class="navbar-collapse collapse w-100" id="navbar-default-primary">
					<ul class="navbar-nav navbar-nav-hover align-items-start">
						<li class="nav-item">
							<a href="#" class="nav-link">Home</a>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link">About</a>
						</li>
						<li class="nav-item">
							<a href="#" class="nav-link">Contact</a>
						</li>
					</ul>
				</div>
				<div class="d-flex align-items-start">
					<button class="navbar-toggler ms-2" type="button" data-toggle="collapse"
							data-target="#navbar-default-primary" aria-controls="navbar-default-primary"
							aria-expanded="false" aria-label="Toggle navigation">
						<span class="navbar-toggler-icon"></span>
					</button>
				</div>
			</div>
		</nav>--->
		<!-- END INNER NAV IF NEEDED -->



		<!---<h2 class="h4">All Posts</h2>
		<div class="table-settings mb-4">
			<div class="row align-items-center justify-content-between">
				<div class="col-4 col-md-2 ">
					<button class="btn btn-secondary" type="button"><i class="bi bi-plus"></i>New Post</button>
				</div>

				<div class="col col-md-6 col-lg-3 col-xl-4">
					<div class="input-group me-2 me-lg-3 fmxw-400">

						<span class="input-group-text"> <i class="bi bi-search icon icon-xs"></i> </span>
						<input type="text" class="form-control" placeholder="Search posts">
					</div>
				</div>
				<!-- <div class="col-4 col-md-2 col-xl-1 ps-md-0 text-end">
                     <div class="dropdown">
                         <button class="btn btn-link text-dark dropdown-toggle dropdown-toggle-split m-0 p-1" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                             <svg class="icon icon-sm" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M11.49 3.17c-.38-1.56-2.6-1.56-2.98 0a1.532 1.532 0 01-2.286.948c-1.372-.836-2.942.734-2.106 2.106.54.886.061 2.042-.947 2.287-1.561.379-1.561 2.6 0 2.978a1.532 1.532 0 01.947 2.287c-.836 1.372.734 2.942 2.106 2.106a1.532 1.532 0 012.287.947c.379 1.561 2.6 1.561 2.978 0a1.533 1.533 0 012.287-.947c1.372.836 2.942-.734 2.106-2.106a1.533 1.533 0 01.947-2.287c1.561-.379 1.561-2.6 0-2.978a1.532 1.532 0 01-.947-2.287c.836-1.372-.734-2.942-2.106-2.106a1.532 1.532 0 01-2.287-.947zM10 13a3 3 0 100-6 3 3 0 000 6z" clip-rule="evenodd"></path></svg>
                             <span class="visually-hidden">Toggle Dropdown</span>
                         </button>
                         <div class="dropdown-menu dropdown-menu-xs dropdown-menu-end pb-0">
                             <span class="small ps-3 fw-bold text-dark">Show</span>
                             <a class="dropdown-item d-flex align-items-center fw-bold" href="#">10 <svg class="icon icon-xxs ms-auto" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"></path></svg></a>
                             <a class="dropdown-item fw-bold" href="#">20</a>
                             <a class="dropdown-item fw-bold rounded-bottom" href="#">30</a>
                         </div>
                     </div>
                 </div>-->
			</div>
		</div>--->

		<!--
            <div class="py-4">
                 <div class="dropdown">
                     <button class="btn btn-gray-800 d-inline-flex align-items-center me-2 dropdown-toggle" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                         <svg class="icon icon-xs me-2" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
                         New Task
                     </button>
                  <div class="dropdown-menu dashboard-dropdown dropdown-menu-start mt-2 py-1">
                         <a class="dropdown-item d-flex align-items-center" href="#">
                             <svg class="dropdown-icon text-gray-400 me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M8 9a3 3 0 100-6 3 3 0 000 6zM8 11a6 6 0 016 6H2a6 6 0 016-6zM16 7a1 1 0 10-2 0v1h-1a1 1 0 100 2h1v1a1 1 0 102 0v-1h1a1 1 0 100-2h-1V7z"></path></svg>
                             Add User
                         </a>
                         <a class="dropdown-item d-flex align-items-center" href="#">
                             <svg class="dropdown-icon text-gray-400 me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M7 3a1 1 0 000 2h6a1 1 0 100-2H7zM4 7a1 1 0 011-1h10a1 1 0 110 2H5a1 1 0 01-1-1zM2 11a2 2 0 012-2h12a2 2 0 012 2v4a2 2 0 01-2 2H4a2 2 0 01-2-2v-4z"></path></svg>
                             Add Widget
                         </a>
                         <a class="dropdown-item d-flex align-items-center" href="#">
                             <svg class="dropdown-icon text-gray-400 me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path d="M5.5 13a3.5 3.5 0 01-.369-6.98 4 4 0 117.753-1.977A4.5 4.5 0 1113.5 13H11V9.413l1.293 1.293a1 1 0 001.414-1.414l-3-3a1 1 0 00-1.414 0l-3 3a1 1 0 001.414 1.414L9 9.414V13H5.5z"></path><path d="M9 13h2v5a1 1 0 11-2 0v-5z"></path></svg>
                             Upload Files
                         </a>
                         <a class="dropdown-item d-flex align-items-center" href="#">
                             <svg class="dropdown-icon text-gray-400 me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M2.166 4.999A11.954 11.954 0 0010 1.944 11.954 11.954 0 0017.834 5c.11.65.166 1.32.166 2.001 0 5.225-3.34 9.67-8 11.317C5.34 16.67 2 12.225 2 7c0-.682.057-1.35.166-2.001zm11.541 3.708a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg>
                             Preview Security
                         </a>
                         <div role="separator" class="dropdown-divider my-1"></div>
                         <a class="dropdown-item d-flex align-items-center" href="#">
                             <svg class="dropdown-icon text-danger me-2" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M12.395 2.553a1 1 0 00-1.45-.385c-.345.23-.614.558-.822.88-.214.33-.403.713-.57 1.116-.334.804-.614 1.768-.84 2.734a31.365 31.365 0 00-.613 3.58 2.64 2.64 0 01-.945-1.067c-.328-.68-.398-1.534-.398-2.654A1 1 0 005.05 6.05 6.981 6.981 0 003 11a7 7 0 1011.95-4.95c-.592-.591-.98-.985-1.348-1.467-.363-.476-.724-1.063-1.207-2.03zM12.12 15.12A3 3 0 017 13s.879.5 2.5.5c0-1 .5-4 1.25-4.5.5 1 .786 1.293 1.371 1.879A2.99 2.99 0 0113 13a2.99 2.99 0 01-.879 2.121z" clip-rule="evenodd"></path></svg>
                             Upgrade to Pro
                         </a>
                     </div>
                </div>
        </div>-->




</cfif>

<cfif thisTag.executionMode is "end">
	<!---<div id="footer"><a href="http://www.mangoblog.org" id="mangolink"><span>Powered by Mango Blog></span></a> <span class="footer_version">&nbsp;&nbsp;<cfoutput>#request.blogManager.getVersion()#</cfoutput></span></div>
--->
	<div class="modal fade" id="filesModal" tabindex="-1" role="dialog" aria-hidden="true">

		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<p class="modal-title" id="modalTitleNotify">Files</p>
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<p>Loading...</p>
				</div>
			</div>
		</div>

	</div>
	</main>

<!-- Core -->
<script src="assets/js/vendor/@popperjs/core/dist/umd/popper.min.js"></script>
<script src="assets/js/vendor/bootstrap/dist/js/bootstrap.min.js"></script>

<!-- Vendor JS -->
<script src="assets/js/vendor/onscreen/dist/on-screen.umd.min.js"></script>

<!-- Slider -->
<script src="assets/js/vendor/nouislider/dist/nouislider.min.js"></script>
<!-- Smooth scroll -->
<script src="assets/js/vendor/smooth-scroll/dist/smooth-scroll.polyfills.min.js"></script>

<!-- Datepicker -->
<script src="assets/js/vendor/vanillajs-datepicker/dist/js/datepicker.min.js"></script>

<!-- Sweet Alerts 2 -->
<script src="assets/js/vendor/sweetalert2/dist/sweetalert2.all.min.js"></script>

<!-- Moment JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.27.0/moment.min.js"></script>

<!-- Notyf -->
<script src="assets/js/vendor/notyf/notyf.min.js"></script>

<!-- Simplebar -->
	<script src="assets/js/vendor/alpinejs/3-13-7.min.js" defer></script>

<!-- Volt JS -->
<script src="assets/js/volt.js"></script>
	<script src="https://cdn.datatables.net/v/bs5/dt-1.13.8/datatables.min.js"></script>
	<script defer src="assets/js/vendor/fontawesome/all.js"></script>


	<!-- Entire bundle -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/draggable/1.0.1/draggable.bundle.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/draggable/1.0.1/sortable.min.js"></script>

	<!-- legacy bundle for older browsers (IE11) -->

	<script src="assets/js/vendor/formrepeater/formrepeater.bundle.js"></script>

	<mangoAdmin:Event name="beforeAdminHtmlBodyEnd" page="#attributes.page#" />

</body>

</html>
</cfif>