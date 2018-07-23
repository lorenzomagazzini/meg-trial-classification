<!DOCTYPE html>
<html class="" lang="en">
<head prefix="og: http://ogp.me/ns#">
<meta charset="utf-8">
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta content="object" property="og:type">
<meta content="GitLab" property="og:site_name">
<meta content="classification/RFE_CV.m · master · c1465333 / Trial-classification" property="og:title">
<meta content="Scripts for MVPA MEG trial classification" property="og:description">
<meta content="https://gitlab.cubric.cf.ac.uk/assets/gitlab_logo-7ae504fe4f68fdebb3c2034e36621930cd36ea87924c11ff65dbcb8ed50dca58.png" property="og:image">
<meta content="64" property="og:image:width">
<meta content="64" property="og:image:height">
<meta content="https://gitlab.cubric.cf.ac.uk/c1465333/Trial-classification/blob/master/classification/RFE_CV.m" property="og:url">
<meta content="summary" property="twitter:card">
<meta content="classification/RFE_CV.m · master · c1465333 / Trial-classification" property="twitter:title">
<meta content="Scripts for MVPA MEG trial classification" property="twitter:description">
<meta content="https://gitlab.cubric.cf.ac.uk/assets/gitlab_logo-7ae504fe4f68fdebb3c2034e36621930cd36ea87924c11ff65dbcb8ed50dca58.png" property="twitter:image">

<title>classification/RFE_CV.m · master · c1465333 / Trial-classification · GitLab</title>
<meta content="Scripts for MVPA MEG trial classification" name="description">
<link rel="shortcut icon" type="image/x-icon" href="/assets/favicon-075eba76312e8421991a0c1f89a89ee81678bcde72319dd3e8047e2a47cd3a42.ico" id="favicon" />
<link rel="stylesheet" media="all" href="/assets/application-325f5c25e3f95e19088164315f4b2806ee11fcb87da891e39d30ebdceca2d1fe.css" />
<link rel="stylesheet" media="print" href="/assets/print-87b4ace0db1f79d91e4fe6e74435b66b71d70fee57ffbb72d0fade17374fcc6b.css" />


<script>
//<![CDATA[
window.gon={};gon.api_version="v4";gon.default_avatar_url="https:\/\/gitlab.cubric.cf.ac.uk\/assets\/no_avatar-849f9c04a3a0d0cea2424ae97b27447dc64a7dbfae83c036c45b403392f0e8ba.png";gon.max_file_size=10;gon.asset_host=null;gon.webpack_public_path="\/assets\/webpack\/";gon.relative_url_root="";gon.shortcuts_path="\/help\/shortcuts";gon.user_color_scheme="white";gon.katex_css_url="\/assets\/katex-e46cafe9c3fa73920a7c2c063ee8bb0613e0cf85fd96a3aea25f8419c4bfcfba.css";gon.katex_js_url="\/assets\/katex-04bcf56379fcda0ee7c7a63f71d0fc15ffd2e014d017cd9d51fd6554dfccf40a.js";gon.gitlab_url="https:\/\/gitlab.cubric.cf.ac.uk";gon.revision="19893b0";gon.gitlab_logo="\/assets\/gitlab_logo-7ae504fe4f68fdebb3c2034e36621930cd36ea87924c11ff65dbcb8ed50dca58.png";gon.current_user_id=21;gon.current_username="c1465333";gon.current_user_fullname="c1465333";gon.current_user_avatar_url="https:\/\/secure.gravatar.com\/avatar\/bfa7d1b940d347ee81dd3d2a90c81cff?s=80\u0026d=identicon";
//]]>
</script>
<script src="/assets/webpack/webpack_runtime.fa793bf2940c89ac98c8.bundle.js" defer="defer"></script>
<script src="/assets/webpack/common.017ed42f19870cbb16cc.bundle.js" defer="defer"></script>
<script src="/assets/webpack/locale.df27085beb4ed115d6d1.bundle.js" defer="defer"></script>
<script src="/assets/webpack/main.0fbafd42bcc4fc962c93.bundle.js" defer="defer"></script>



<script src="/assets/webpack/blob.6043bed197eb079db95f.bundle.js" defer="defer"></script>
<script src="/assets/webpack/blob.6043bed197eb079db95f.bundle.js" defer="defer"></script>

<script>
  window.uploads_path = "/c1465333/Trial-classification/uploads";
</script>

<meta name="csrf-param" content="authenticity_token" />
<meta name="csrf-token" content="eWRJorD0jHxzDXyX2+WWTtSfs26iUnWlsfR0kGsy5dDrmp9tZPRfUyQRp+TfWhR+isD9rzQ+yXnidPRlq1ycrA==" />
<meta content="origin-when-cross-origin" name="referrer">
<meta content="width=device-width, initial-scale=1, maximum-scale=1" name="viewport">
<meta content="#474D57" name="theme-color">
<link rel="apple-touch-icon" type="image/x-icon" href="/assets/touch-icon-iphone-5a9cee0e8a51212e70b90c87c12f382c428870c0ff67d1eb034d884b78d2dae7.png" />
<link rel="apple-touch-icon" type="image/x-icon" href="/assets/touch-icon-ipad-a6eec6aeb9da138e507593b464fdac213047e49d3093fc30e90d9a995df83ba3.png" sizes="76x76" />
<link rel="apple-touch-icon" type="image/x-icon" href="/assets/touch-icon-iphone-retina-72e2aadf86513a56e050e7f0f2355deaa19cc17ed97bbe5147847f2748e5a3e3.png" sizes="120x120" />
<link rel="apple-touch-icon" type="image/x-icon" href="/assets/touch-icon-ipad-retina-8ebe416f5313483d9c1bc772b5bbe03ecad52a54eba443e5215a22caed2a16a2.png" sizes="152x152" />
<link color="rgb(226, 67, 41)" href="/assets/logo-d36b5212042cebc89b96df4bf6ac24e43db316143e89926c0db839ff694d2de4.svg" rel="mask-icon">
<meta content="/assets/msapplication-tile-1196ec67452f618d39cdd85e2e3a542f76574c071051ae7effbfde01710eb17d.png" name="msapplication-TileImage">
<meta content="#30353E" name="msapplication-TileColor">




</head>

<body class="" data-find-file="/c1465333/Trial-classification/find_file/master" data-group="" data-page="projects:blob:show" data-project="Trial-classification">


<header class="navbar navbar-gitlab with-horizontal-nav">
<div class="navbar-border"></div>
<a class="sr-only gl-accessibility" href="#content-body" tabindex="1">Skip to content</a>
<div class="container-fluid">
<div class="header-content">
<div class="dropdown global-dropdown">
<button class="global-dropdown-toggle" data-toggle="dropdown" type="button">
<span class="sr-only">Toggle navigation</span>
<i aria-hidden="true" data-hidden="true" class="fa fa-bars"></i>
</button>
<div class="dropdown-menu-nav global-dropdown-menu">
<ul>
<li class="active home"><a title="Projects" class="dashboard-shortcuts-projects" href="/dashboard/projects"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
P
</div>
</div>
<span>
Projects
</span>
</a></li><li class=""><a class="dashboard-shortcuts-activity" title="Activity" href="/dashboard/activity"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
A
</div>
</div>
<span>
Activity
</span>
</a></li><li class=""><a class="dashboard-shortcuts-groups" title="Groups" href="/dashboard/groups"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
G
</div>
</div>
<span>
Groups
</span>
</a></li><li class=""><a class="dashboard-shortcuts-milestones" title="Milestones" href="/dashboard/milestones"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
L
</div>
</div>
<span>
Milestones
</span>
</a></li><li class=""><a title="Issues" class="dashboard-shortcuts-issues" href="/dashboard/issues?assignee_id=21"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
I
</div>
</div>
<span class="badge pull-right">0</span>
<span>
Issues
</span>
</a></li><li class=""><a title="Merge Requests" class="dashboard-shortcuts-merge_requests" href="/dashboard/merge_requests?assignee_id=21"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
M
</div>
</div>
<span class="badge pull-right">0</span>
<span>
Merge Requests
</span>
</a></li><li class=""><a class="dashboard-shortcuts-snippets" title="Snippets" href="/dashboard/snippets"><div class="shortcut-mappings">
<div class="key">
<i aria-label="hidden" class="fa fa-arrow-up"></i>
S
</div>
</div>
<span>
Snippets
</span>
</a></li><li class="divider"></li>
<li>
<a title="About GitLab CE" class="about-gitlab" href="/help">Help</a>
</li>
</ul>

</div>
</div>
<div class="header-logo">
<a class="home" title="Dashboard" id="logo" href="/"><svg width="28" height="28" class="tanuki-logo" viewBox="0 0 36 36">
  <path class="tanuki-shape tanuki-left-ear" fill="#e24329" d="M2 14l9.38 9v-9l-4-12.28c-.205-.632-1.176-.632-1.38 0z"/>
  <path class="tanuki-shape tanuki-right-ear" fill="#e24329" d="M34 14l-9.38 9v-9l4-12.28c.205-.632 1.176-.632 1.38 0z"/>
  <path class="tanuki-shape tanuki-nose" fill="#e24329" d="M18,34.38 3,14 33,14 Z"/>
  <path class="tanuki-shape tanuki-left-eye" fill="#fc6d26" d="M18,34.38 11.38,14 2,14 6,25Z"/>
  <path class="tanuki-shape tanuki-right-eye" fill="#fc6d26" d="M18,34.38 24.62,14 34,14 30,25Z"/>
  <path class="tanuki-shape tanuki-left-cheek" fill="#fca326" d="M2 14L.1 20.16c-.18.565 0 1.2.5 1.56l17.42 12.66z"/>
  <path class="tanuki-shape tanuki-right-cheek" fill="#fca326" d="M34 14l1.9 6.16c.18.565 0 1.2-.5 1.56L18 34.38z"/>
</svg>

</a></div>
<div class="title-container js-title-container">
<h1 class="title"><a href="/c1465333">c1465333</a> / <a class="project-item-select-holder" href="/c1465333/Trial-classification">Trial-classification</a><button name="button" type="button" class="dropdown-toggle-caret js-projects-dropdown-toggle" aria-label="Toggle switch project dropdown" data-target=".js-dropdown-menu-projects" data-toggle="dropdown" data-order-by="last_activity_at"><i aria-hidden="true" data-hidden="true" class="fa fa-chevron-down"></i></button></h1>
</div>
<div class="navbar-collapse collapse">
<ul class="nav navbar-nav">
<li class="hidden-sm hidden-xs">
<div class="has-location-badge search search-form">
<form class="navbar-form" action="/search" accept-charset="UTF-8" method="get"><input name="utf8" type="hidden" value="&#x2713;" /><div class="search-input-container">
<div class="location-badge">This project</div>
<div class="search-input-wrap">
<div class="dropdown" data-url="/search/autocomplete">
<input type="search" name="search" id="search" placeholder="Search" class="search-input dropdown-menu-toggle no-outline js-search-dashboard-options" spellcheck="false" tabindex="1" autocomplete="off" data-toggle="dropdown" data-issues-path="https://gitlab.cubric.cf.ac.uk/dashboard/issues" data-mr-path="https://gitlab.cubric.cf.ac.uk/dashboard/merge_requests" aria-label="Search" />
<div class="dropdown-menu dropdown-select">
<div class="dropdown-content"><ul>
<li>
<a class="is-focused dropdown-menu-empty-link">
Loading...
</a>
</li>
</ul>
</div><div class="dropdown-loading"><i aria-hidden="true" data-hidden="true" class="fa fa-spinner fa-spin"></i></div>
</div>
<i class="search-icon"></i>
<i class="clear-icon js-clear-input"></i>
</div>
</div>
</div>
<input type="hidden" name="group_id" id="group_id" class="js-search-group-options" />
<input type="hidden" name="project_id" id="search_project_id" value="47" class="js-search-project-options" data-project-path="Trial-classification" data-name="Trial-classification" data-issues-path="/c1465333/Trial-classification/issues" data-mr-path="/c1465333/Trial-classification/merge_requests" />
<input type="hidden" name="search_code" id="search_code" value="true" />
<input type="hidden" name="repository_ref" id="repository_ref" value="master" />

<div class="search-autocomplete-opts hide" data-autocomplete-path="/search/autocomplete" data-autocomplete-project-id="47" data-autocomplete-project-ref="master"></div>
</form></div>

</li>
<li class="visible-sm-inline-block visible-xs-inline-block">
<a title="Search" aria-label="Search" data-toggle="tooltip" data-placement="bottom" data-container="body" href="/search"><i aria-hidden="true" data-hidden="true" class="fa fa-search"></i>
</a></li>
<li class="header-new dropdown">
<a class="header-new-dropdown-toggle has-tooltip" title="New..." ref="tooltip" aria-label="New..." data-toggle="dropdown" data-placement="bottom" data-container="body" href="/projects/new"><i aria-hidden="true" data-hidden="true" class="fa fa-plus fa-fw"></i>
<i aria-hidden="true" data-hidden="true" class="fa fa-caret-down"></i>
</a><div class="dropdown-menu-nav dropdown-menu-align-right">
<ul>
<li class="dropdown-bold-header">This project</li>
<li>
<a href="/c1465333/Trial-classification/issues/new">New issue</a>
</li>
<li>
<a href="/c1465333/Trial-classification/merge_requests/new">New merge request</a>
</li>
<li class="divider"></li>
<li class="dropdown-bold-header">GitLab</li>
<li>
<a href="/projects/new">New project</a>
</li>
<li>
<a href="/groups/new">New group</a>
</li>
<li>
<a href="/snippets/new">New snippet</a>
</li>
</ul>
</div>
</li>

<li>
<a title="Issues" aria-label="Issues" data-toggle="tooltip" data-placement="bottom" data-container="body" href="/dashboard/issues?assignee_id=21"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 16 16"><path d="M10.458 15.012l.311.055a3 3 0 0 0 3.476-2.433l1.389-7.879A3 3 0 0 0 13.2 1.28L11.23.933a3.002 3.002 0 0 0-.824-.031c.364.59.58 1.28.593 2.02l1.854.328a1 1 0 0 1 .811 1.158l-1.389 7.879a1 1 0 0 1-1.158.81l-.118-.02a3.98 3.98 0 0 1-.541 1.935zM3 0h4a3 3 0 0 1 3 3v10a3 3 0 0 1-3 3H3a3 3 0 0 1-3-3V3a3 3 0 0 1 3-3zm0 2a1 1 0 0 0-1 1v10a1 1 0 0 0 1 1h4a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1H3z"/></svg>

<span class="badge hidden issues-count">
0
</span>
</a></li>
<li>
<a title="Merge requests" aria-label="Merge requests" data-toggle="tooltip" data-placement="bottom" data-container="body" href="/dashboard/merge_requests?assignee_id=21"><svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 16 16"><path d="m5 5.563v4.875c1.024.4 1.75 1.397 1.75 2.563 0 1.519-1.231 2.75-2.75 2.75-1.519 0-2.75-1.231-2.75-2.75 0-1.166.726-2.162 1.75-2.563v-4.875c-1.024-.4-1.75-1.397-1.75-2.563 0-1.519 1.231-2.75 2.75-2.75 1.519 0 2.75 1.231 2.75 2.75 0 1.166-.726 2.162-1.75 2.563m-1 8.687c.69 0 1.25-.56 1.25-1.25 0-.69-.56-1.25-1.25-1.25-.69 0-1.25.56-1.25 1.25 0 .69.56 1.25 1.25 1.25m0-10c.69 0 1.25-.56 1.25-1.25 0-.69-.56-1.25-1.25-1.25-.69 0-1.25.56-1.25 1.25 0 .69.56 1.25 1.25 1.25"/><path d="m10.501 2c1.381.001 2.499 1.125 2.499 2.506v5.931c1.024.4 1.75 1.397 1.75 2.563 0 1.519-1.231 2.75-2.75 2.75-1.519 0-2.75-1.231-2.75-2.75 0-1.166.726-2.162 1.75-2.563v-5.931c0-.279-.225-.506-.499-.506v.926c0 .346-.244.474-.569.271l-2.952-1.844c-.314-.196-.325-.507 0-.71l2.952-1.844c.314-.196.569-.081.569.271v.93m1.499 12.25c.69 0 1.25-.56 1.25-1.25 0-.69-.56-1.25-1.25-1.25-.69 0-1.25.56-1.25 1.25 0 .69.56 1.25 1.25 1.25"/></svg>


<span class="badge hidden merge-requests-count">
0
</span>
</a></li>
<li>
<a title="Todos" aria-label="Todos" class="shortcuts-todos" data-toggle="tooltip" data-placement="bottom" data-container="body" href="/dashboard/todos"><i aria-hidden="true" data-hidden="true" class="fa fa-check-circle fa-fw"></i>
<span class="badge hidden todos-count">
0
</span>
</a></li>
<li class="header-user dropdown">
<a class="header-user-dropdown-toggle" data-toggle="dropdown" href="/c1465333"><img width="26" height="26" class="header-user-avatar lazy" data-src="https://secure.gravatar.com/avatar/bfa7d1b940d347ee81dd3d2a90c81cff?s=52&amp;d=identicon" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" />
<i aria-hidden="true" data-hidden="true" class="fa fa-caret-down"></i>
</a><div class="dropdown-menu-nav dropdown-menu-align-right">
<ul>
<li class="current-user">
<div class="user-name bold">
c1465333
</div>
@c1465333
</li>
<li class="divider"></li>
<li>
<a class="profile-link" data-user="c1465333" href="/c1465333">Profile</a>
</li>
<li>
<a href="/profile">Settings</a>
</li>
<li>
<a href="/profile/preferences#new-navigation">Turn on new navigation</a>
</li>
<li class="divider"></li>
<li>
<a class="sign-out-link" rel="nofollow" data-method="delete" href="/users/sign_out">Sign out</a>
</li>
</ul>
</div>
</li>
</ul>
</div>
<button class="navbar-toggle" type="button">
<span class="sr-only">Toggle navigation</span>
<i aria-hidden="true" data-hidden="true" class="fa fa-ellipsis-v"></i>
</button>
<div class="js-dropdown-menu-projects">
<div class="dropdown-menu dropdown-select dropdown-menu-projects">
<div class="dropdown-title"><span>Go to a project</span><button class="dropdown-title-button dropdown-menu-close" aria-label="Close" type="button"><i aria-hidden="true" data-hidden="true" class="fa fa-times dropdown-menu-close-icon"></i></button></div>
<div class="dropdown-input"><input type="search" id="" class="dropdown-input-field" placeholder="Search your projects" autocomplete="off" /><i aria-hidden="true" data-hidden="true" class="fa fa-search dropdown-input-search"></i><i role="button" aria-hidden="true" data-hidden="true" class="fa fa-times dropdown-input-clear js-dropdown-input-clear"></i></div>
<div class="dropdown-content"></div>
<div class="dropdown-loading"><i aria-hidden="true" data-hidden="true" class="fa fa-spinner fa-spin"></i></div>
</div>
</div>

</div>
</div>
</header>


<div class="page-with-sidebar">
<div class="layout-nav">
<div class="container-fluid">
<div class="nav-control scrolling-tabs-container">
<div class="fade-left">
<i aria-hidden="true" data-hidden="true" class="fa fa-angle-left"></i>
</div>
<div class="fade-right">
<i aria-hidden="true" data-hidden="true" class="fa fa-angle-right"></i>
</div>
<ul class="nav-links scrolling-tabs">
<li class="home"><a title="Project" class="shortcuts-project" href="/c1465333/Trial-classification"><span>
Project
</span>
</a></li><li class="active"><a title="Repository" class="shortcuts-tree" href="/c1465333/Trial-classification/tree/master"><span>
Repository
</span>
</a></li><li class=""><a title="Issues" class="shortcuts-issues" href="/c1465333/Trial-classification/issues"><span>
Issues
<span class="badge count issue_counter">0</span>
</span>
</a></li><li class=""><a title="Merge Requests" class="shortcuts-merge_requests" href="/c1465333/Trial-classification/merge_requests"><span>
Merge Requests
<span class="badge count merge_counter js-merge-counter">1</span>
</span>
</a></li><li class=""><a title="Pipelines" class="shortcuts-pipelines" href="/c1465333/Trial-classification/pipelines"><span>
Pipelines
</span>
</a></li><li class=""><a title="Wiki" class="shortcuts-wiki" href="/c1465333/Trial-classification/wikis/home"><span>
Wiki
</span>
</a></li><li class=""><a title="Members" class="shortcuts-members" href="/c1465333/Trial-classification/project_members"><span>
Members
</span>
</a></li><li class=""><a title="Settings" class="shortcuts-tree" href="/c1465333/Trial-classification/edit"><span>
Settings
</span>
</a></li><li class="hidden">
<a title="Activity" class="shortcuts-project-activity" href="/c1465333/Trial-classification/activity"><span>
Activity
</span>
</a></li>
<li class="hidden">
<a title="Network" class="shortcuts-network" href="/c1465333/Trial-classification/network/master">Graph
</a></li>
<li class="hidden">
<a title="Charts" class="shortcuts-repository-charts" href="/c1465333/Trial-classification/graphs/master/charts">Charts
</a></li>
<li class="hidden">
<a class="shortcuts-new-issue" href="/c1465333/Trial-classification/issues/new">Create a new issue
</a></li>
<li class="hidden">
<a title="Jobs" class="shortcuts-builds" href="/c1465333/Trial-classification/-/jobs">Jobs
</a></li>
<li class="hidden">
<a title="Commits" class="shortcuts-commits" href="/c1465333/Trial-classification/commits/master">Commits
</a></li>
<li class="hidden">
<a title="Issue Boards" class="shortcuts-issue-boards" href="/c1465333/Trial-classification/boards">Issue Boards</a>
</li>
</ul>
</div>

</div>
</div>
<div class="scrolling-tabs-container sub-nav-scroll">
<div class="fade-left">
<i aria-hidden="true" data-hidden="true" class="fa fa-angle-left"></i>
</div>
<div class="fade-right">
<i aria-hidden="true" data-hidden="true" class="fa fa-angle-right"></i>
</div>

<div class="nav-links sub-nav scrolling-tabs">
<ul class="container-fluid container-limited">
<li class="active"><a href="/c1465333/Trial-classification/tree/master">Files
</a></li><li class=""><a href="/c1465333/Trial-classification/commits/master">Commits
</a></li><li class=""><a href="/c1465333/Trial-classification/branches">Branches
</a></li><li class=""><a href="/c1465333/Trial-classification/tags">Tags
</a></li><li class=""><a href="/c1465333/Trial-classification/graphs/master">Contributors
</a></li><li class=""><a href="/c1465333/Trial-classification/network/master">Graph
</a></li><li class=""><a href="/c1465333/Trial-classification/compare?from=master&amp;to=master">Compare
</a></li><li class=""><a href="/c1465333/Trial-classification/graphs/master/charts">Charts
</a></li></ul>
</div>
</div>

<div class="content-wrapper page-with-layout-nav page-with-sub-nav">
<div class="alert-wrapper">

<div class="flash-container flash-container-page">
</div>


</div>
<div class=" ">
<div class="content" id="content-body">

<div class="row-content-block top-block hidden-xs white">
<div class="event-last-push">
<div class="event-last-push-text">
<span>You pushed to</span>
<strong>
<a class="ref-name" href="/c1465333/Trial-classification/commits/diana-gitlab-update">diana-gitlab-update</a>
</strong>
<time class="js-timeago" title="Jul 23, 2018 5:45pm" datetime="2018-07-23T17:45:57Z" data-toggle="tooltip" data-placement="top" data-container="body">Jul 23, 2018</time>
</div>
<div class="pull-right">
<a title="New merge request" class="btn btn-info btn-sm" href="/c1465333/Trial-classification/merge_requests/new?merge_request%5Bsource_branch%5D=diana-gitlab-update&amp;merge_request%5Bsource_project_id%5D=47&amp;merge_request%5Btarget_branch%5D=master&amp;merge_request%5Btarget_project_id%5D=47">Create merge request
</a></div>
</div>
</div>

<div class="container-fluid container-limited">
<div class="tree-holder" id="tree-holder">
<div class="nav-block">
<div class="tree-ref-container">
<div class="tree-ref-holder">
<form class="project-refs-form" action="/c1465333/Trial-classification/refs/switch" accept-charset="UTF-8" method="get"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="destination" id="destination" value="blob" />
<input type="hidden" name="path" id="path" value="classification/RFE_CV.m" />
<div class="dropdown">
<button class="dropdown-menu-toggle js-project-refs-dropdown" type="button" data-toggle="dropdown" data-selected="master" data-ref="master" data-refs-url="/c1465333/Trial-classification/refs" data-field-name="ref" data-submit-form-on-click="true" data-visit="true"><span class="dropdown-toggle-text ">master</span><i aria-hidden="true" data-hidden="true" class="fa fa-chevron-down"></i></button>
<div class="dropdown-menu dropdown-menu-selectable git-revision-dropdown">
<div class="dropdown-title"><span>Switch branch/tag</span><button class="dropdown-title-button dropdown-menu-close" aria-label="Close" type="button"><i aria-hidden="true" data-hidden="true" class="fa fa-times dropdown-menu-close-icon"></i></button></div>
<div class="dropdown-input"><input type="search" id="" class="dropdown-input-field" placeholder="Search branches and tags" autocomplete="off" /><i aria-hidden="true" data-hidden="true" class="fa fa-search dropdown-input-search"></i><i role="button" aria-hidden="true" data-hidden="true" class="fa fa-times dropdown-input-clear js-dropdown-input-clear"></i></div>
<div class="dropdown-content"></div>
<div class="dropdown-loading"><i aria-hidden="true" data-hidden="true" class="fa fa-spinner fa-spin"></i></div>
</div>
</div>
</form>
</div>
<ul class="breadcrumb repo-breadcrumb">
<li>
<a href="/c1465333/Trial-classification/tree/master">Trial-classification
</a></li>
<li>
<a href="/c1465333/Trial-classification/tree/master/classification">classification</a>
</li>
<li>
<a href="/c1465333/Trial-classification/blob/master/classification/RFE_CV.m"><strong>RFE_CV.m</strong>
</a></li>
</ul>
</div>
<div class="tree-controls">
<a class="btn shortcuts-find-file" rel="nofollow" href="/c1465333/Trial-classification/find_file/master"><i aria-hidden="true" data-hidden="true" class="fa fa-search"></i>
<span>Find file</span>
</a>
<div class="btn-group" role="group"><a class="btn js-blob-blame-link" href="/c1465333/Trial-classification/blame/master/classification/RFE_CV.m">Blame</a><a class="btn" href="/c1465333/Trial-classification/commits/master/classification/RFE_CV.m">History</a><a class="btn js-data-file-blob-permalink-url" href="/c1465333/Trial-classification/blob/3bfe7696603259d091b9be905cc64582c112da1e/classification/RFE_CV.m">Permalink</a></div>
</div>
</div>

<div class="info-well hidden-xs">
<div class="well-segment">
<ul class="blob-commit-info">
<li class="commit flex-row js-toggle-container" id="commit-0b832cd5">
<div class="avatar-cell hidden-xs">
<a href="/c1465333"><img class="avatar s36 hidden-xs has-tooltip  lazy" alt="c1465333&#39;s avatar" title="c1465333" data-container="body" data-src="https://secure.gravatar.com/avatar/bfa7d1b940d347ee81dd3d2a90c81cff?s=72&amp;d=identicon" src="data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==" /></a>
</div>
<div class="commit-detail">
<div class="commit-content">
<a class="commit-row-message item-title" href="/c1465333/Trial-classification/commit/0b832cd5ccae8d90fca12a50b4e99f98cd951603">add SVM classification functions</a>
<span class="commit-row-message visible-xs-inline">
&middot;
0b832cd5
</span>
<div class="commiter">
<a class="commit-author-link has-tooltip" title="dimadc@cardiff.ac.uk" href="/c1465333">c1465333</a> committed <time class="js-timeago" title="May 10, 2018 9:45am" datetime="2018-05-10T09:45:27Z" data-toggle="tooltip" data-placement="top" data-container="body">May 10, 2018</time>
</div>
</div>
<div class="commit-actions hidden-xs">

<a class="commit-sha btn btn-transparent" href="/c1465333/Trial-classification/commit/0b832cd5ccae8d90fca12a50b4e99f98cd951603">0b832cd5</a>
<button class="btn btn-clipboard btn-transparent" data-toggle="tooltip" data-placement="bottom" data-container="body" data-title="Copy commit SHA to clipboard" data-clipboard-text="0b832cd5ccae8d90fca12a50b4e99f98cd951603" type="button" title="Copy commit SHA to clipboard" aria-label="Copy commit SHA to clipboard"><i aria-hidden="true" aria-hidden="true" data-hidden="true" class="fa fa-clipboard"></i></button>

</div>
</div>
</li>

</ul>
</div>

</div>
<div class="blob-content-holder" id="blob-content-holder">
<article class="file-holder">
<div class="js-file-title file-title-flex-parent">
<div class="file-header-content">
<i aria-hidden="true" data-hidden="true" class="fa fa-file-text-o fa-fw"></i>
<strong class="file-title-name">
RFE_CV.m
</strong>
<button class="btn btn-clipboard btn-transparent prepend-left-5" data-toggle="tooltip" data-placement="bottom" data-container="body" data-class="btn-clipboard btn-transparent prepend-left-5" data-title="Copy file path to clipboard" data-clipboard-text="{&quot;text&quot;:&quot;classification/RFE_CV.m&quot;,&quot;gfm&quot;:&quot;`classification/RFE_CV.m`&quot;}" type="button" title="Copy file path to clipboard" aria-label="Copy file path to clipboard"><i aria-hidden="true" aria-hidden="true" data-hidden="true" class="fa fa-clipboard"></i></button>
<small>
2.79 KB
</small>
</div>

<div class="file-actions hidden-xs">

<div class="btn-group" role="group"><button class="btn btn btn-sm js-copy-blob-source-btn" data-toggle="tooltip" data-placement="bottom" data-container="body" data-class="btn btn-sm js-copy-blob-source-btn" data-title="Copy source to clipboard" data-clipboard-target=".blob-content[data-blob-id=&#39;5fe7fb56da4a41f32e80ddba165b498616ea6b52&#39;]" type="button" title="Copy source to clipboard" aria-label="Copy source to clipboard"><i aria-hidden="true" aria-hidden="true" data-hidden="true" class="fa fa-clipboard"></i></button><a class="btn btn-sm has-tooltip" target="_blank" rel="noopener noreferrer" title="Open raw" data-container="body" href="/c1465333/Trial-classification/raw/master/classification/RFE_CV.m"><i aria-hidden="true" data-hidden="true" class="fa fa-file-code-o"></i></a></div>
<div class="btn-group" role="group"><a class="btn js-edit-blob  btn-sm" href="/c1465333/Trial-classification/edit/master/classification/RFE_CV.m">Edit</a><button name="button" type="submit" class="btn btn-default" data-target="#modal-upload-blob" data-toggle="modal">Replace</button><button name="button" type="submit" class="btn btn-remove" data-target="#modal-remove-blob" data-toggle="modal">Delete</button></div>
</div>
</div>
<div class="js-file-fork-suggestion-section file-fork-suggestion hidden">
<span class="file-fork-suggestion-note">
You're not allowed to
<span class="js-file-fork-suggestion-section-action">
edit
</span>
files in this project directly. Please fork this project,
make your changes there, and submit a merge request.
</span>
<a class="js-fork-suggestion-button btn btn-grouped btn-inverted btn-new" rel="nofollow" data-method="post" href="/c1465333/Trial-classification/blob/master/classification/RFE_CV.m">Fork</a>
<button class="js-cancel-fork-suggestion-button btn btn-grouped" type="button">
Cancel
</button>
</div>


<div class="blob-viewer" data-type="simple" data-url="/c1465333/Trial-classification/blob/master/classification/RFE_CV.m?format=json&amp;viewer=simple">
<div class="text-center prepend-top-default append-bottom-default">
<i aria-hidden="true" aria-label="Loading content…" class="fa fa-spinner fa-spin fa-2x"></i>
</div>

</div>


</article>
</div>

</div>
<div class="modal" id="modal-remove-blob">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<a class="close" data-dismiss="modal" href="#">×</a>
<h3 class="page-title">Delete RFE_CV.m</h3>
</div>
<div class="modal-body">
<form class="form-horizontal js-delete-blob-form js-quick-submit js-requires-input" action="/c1465333/Trial-classification/blob/master/classification/RFE_CV.m" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="delete" /><input type="hidden" name="authenticity_token" value="wAWK9Wrwsn66nUIgkignTGSWfpcGQ0g1boEuNFl/5XtS+1w6vvBhUe2BmVOWl6V8OskwVpAv9Ok9Aa7BmRGcBw==" /><div class="form-group commit_message-group">
<label class="control-label" for="commit_message-7f8690a6f4423504b9f28928c90d951e">Commit message
</label><div class="col-sm-10">
<div class="commit-message-container">
<div class="max-width-marker"></div>
<textarea name="commit_message" id="commit_message-7f8690a6f4423504b9f28928c90d951e" class="form-control js-commit-message" placeholder="Delete RFE_CV.m" required="required" rows="3">
Delete RFE_CV.m</textarea>
</div>
</div>
</div>

<div class="form-group branch">
<label class="control-label" for="branch_name">Target Branch</label>
<div class="col-sm-10">
<input type="text" name="branch_name" id="branch_name" value="master" required="required" class="form-control js-branch-name ref-name" />
<div class="js-create-merge-request-container">
<div class="checkbox">
<label for="create_merge_request-a58f5a4edacc7132fab31a8506c7210b"><input type="checkbox" name="create_merge_request" id="create_merge_request-a58f5a4edacc7132fab31a8506c7210b" value="1" class="js-create-merge-request" checked="checked" />
Start a <strong>new merge request</strong> with these changes
</label></div>

</div>
</div>
</div>
<input type="hidden" name="original_branch" id="original_branch" value="master" class="js-original-branch" />

<div class="form-group">
<div class="col-sm-offset-2 col-sm-10">
<button name="button" type="submit" class="btn btn-remove btn-remove-file">Delete file</button>
<a class="btn btn-cancel" data-dismiss="modal" href="#">Cancel</a>
</div>
</div>
</form></div>
</div>
</div>
</div>

<div class="modal" id="modal-upload-blob">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<a class="close" data-dismiss="modal" href="#">×</a>
<h3 class="page-title">Replace RFE_CV.m</h3>
</div>
<div class="modal-body">
<form class="js-quick-submit js-upload-blob-form form-horizontal" data-method="put" action="/c1465333/Trial-classification/update/master/classification/RFE_CV.m" accept-charset="UTF-8" method="post"><input name="utf8" type="hidden" value="&#x2713;" /><input type="hidden" name="_method" value="put" /><input type="hidden" name="authenticity_token" value="vr9JtpFqufL6YcGDr/UcipMXQacnPPuQPJS8wOznAMgsQZ95RWpq3a19GvCrSp66zUgPZrFQR0xvFDw1LIl5tA==" /><div class="dropzone">
<div class="dropzone-previews blob-upload-dropzone-previews">
<p class="dz-message light">
Attach a file by drag &amp; drop or <a class="markdown-selector" href="#">click to upload</a>
</p>
</div>
</div>
<br>
<div class="dropzone-alerts alert alert-danger data" style="display:none"></div>
<div class="form-group commit_message-group">
<label class="control-label" for="commit_message-bbb7ca565475c73fb9ff921c991db796">Commit message
</label><div class="col-sm-10">
<div class="commit-message-container">
<div class="max-width-marker"></div>
<textarea name="commit_message" id="commit_message-bbb7ca565475c73fb9ff921c991db796" class="form-control js-commit-message" placeholder="Replace RFE_CV.m" required="required" rows="3">
Replace RFE_CV.m</textarea>
</div>
</div>
</div>

<div class="form-group branch">
<label class="control-label" for="branch_name">Target Branch</label>
<div class="col-sm-10">
<input type="text" name="branch_name" id="branch_name" value="master" required="required" class="form-control js-branch-name ref-name" />
<div class="js-create-merge-request-container">
<div class="checkbox">
<label for="create_merge_request-bf7befbc9df3a2ec47c18b6909202671"><input type="checkbox" name="create_merge_request" id="create_merge_request-bf7befbc9df3a2ec47c18b6909202671" value="1" class="js-create-merge-request" checked="checked" />
Start a <strong>new merge request</strong> with these changes
</label></div>

</div>
</div>
</div>
<input type="hidden" name="original_branch" id="original_branch" value="master" class="js-original-branch" />

<div class="form-actions">
<button name="button" type="button" class="btn btn-create btn-upload-file" id="submit-all"><i aria-hidden="true" data-hidden="true" class="fa fa-spin fa-spinner js-loading-icon hidden"></i>
Replace file
</button><a class="btn btn-cancel" data-dismiss="modal" href="#">Cancel</a>
</div>
</form></div>
</div>
</div>
</div>

</div>

</div>
</div>
</div>
</div>


</body>
</html>

