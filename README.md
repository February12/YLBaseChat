<!DOCTYPE html>
<html>

<head>

<meta charset="utf-8">
<title>javascript调用手机原生操作文档</title>


<style type="text/css">
body {
  font-family: Helvetica, arial, sans-serif;
  font-size: 14px;
  line-height: 1.6;
  padding-top: 10px;
  padding-bottom: 10px;
  background-color: white;
  padding: 30px; }

body > *:first-child {
  margin-top: 0 !important; }
body > *:last-child {
  margin-bottom: 0 !important; }

a {
  color: #4183C4; }
a.absent {
  color: #cc0000; }
a.anchor {
  display: block;
  padding-left: 30px;
  margin-left: -30px;
  cursor: pointer;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0; }

h1, h2, h3, h4, h5, h6 {
  margin: 20px 0 10px;
  padding: 0;
  font-weight: bold;
  -webkit-font-smoothing: antialiased;
  cursor: text;
  position: relative; }

h1:hover a.anchor, h2:hover a.anchor, h3:hover a.anchor, h4:hover a.anchor, h5:hover a.anchor, h6:hover a.anchor {
  background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA09pVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoMTMuMCAyMDEyMDMwNS5tLjQxNSAyMDEyLzAzLzA1OjIxOjAwOjAwKSAgKE1hY2ludG9zaCkiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OUM2NjlDQjI4ODBGMTFFMTg1ODlEODNERDJBRjUwQTQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OUM2NjlDQjM4ODBGMTFFMTg1ODlEODNERDJBRjUwQTQiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo5QzY2OUNCMDg4MEYxMUUxODU4OUQ4M0REMkFGNTBBNCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo5QzY2OUNCMTg4MEYxMUUxODU4OUQ4M0REMkFGNTBBNCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PsQhXeAAAABfSURBVHjaYvz//z8DJYCRUgMYQAbAMBQIAvEqkBQWXI6sHqwHiwG70TTBxGaiWwjCTGgOUgJiF1J8wMRAIUA34B4Q76HUBelAfJYSA0CuMIEaRP8wGIkGMA54bgQIMACAmkXJi0hKJQAAAABJRU5ErkJggg==) no-repeat 10px center;
  text-decoration: none; }

h1 tt, h1 code {
  font-size: inherit; }

h2 tt, h2 code {
  font-size: inherit; }

h3 tt, h3 code {
  font-size: inherit; }

h4 tt, h4 code {
  font-size: inherit; }

h5 tt, h5 code {
  font-size: inherit; }

h6 tt, h6 code {
  font-size: inherit; }

h1 {
  font-size: 28px;
  color: black; }

h2 {
  font-size: 24px;
  border-bottom: 1px solid #cccccc;
  color: black; }

h3 {
  font-size: 18px; }

h4 {
  font-size: 16px; }

h5 {
  font-size: 14px; }

h6 {
  color: #777777;
  font-size: 14px; }

p, blockquote, ul, ol, dl, li, table, pre {
  margin: 15px 0; }

hr {
  background: transparent url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAYAAAAECAYAAACtBE5DAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMC1jMDYwIDYxLjEzNDc3NywgMjAxMC8wMi8xMi0xNzozMjowMCAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNSBNYWNpbnRvc2giIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OENDRjNBN0E2NTZBMTFFMEI3QjRBODM4NzJDMjlGNDgiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OENDRjNBN0I2NTZBMTFFMEI3QjRBODM4NzJDMjlGNDgiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo4Q0NGM0E3ODY1NkExMUUwQjdCNEE4Mzg3MkMyOUY0OCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo4Q0NGM0E3OTY1NkExMUUwQjdCNEE4Mzg3MkMyOUY0OCIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PqqezsUAAAAfSURBVHjaYmRABcYwBiM2QSA4y4hNEKYDQxAEAAIMAHNGAzhkPOlYAAAAAElFTkSuQmCC) repeat-x 0 0;
  border: 0 none;
  color: #cccccc;
  height: 4px;
  padding: 0;
}

body > h2:first-child {
  margin-top: 0;
  padding-top: 0; }
body > h1:first-child {
  margin-top: 0;
  padding-top: 0; }
  body > h1:first-child + h2 {
    margin-top: 0;
    padding-top: 0; }
body > h3:first-child, body > h4:first-child, body > h5:first-child, body > h6:first-child {
  margin-top: 0;
  padding-top: 0; }

a:first-child h1, a:first-child h2, a:first-child h3, a:first-child h4, a:first-child h5, a:first-child h6 {
  margin-top: 0;
  padding-top: 0; }

h1 p, h2 p, h3 p, h4 p, h5 p, h6 p {
  margin-top: 0; }

li p.first {
  display: inline-block; }
li {
  margin: 0; }
ul, ol {
  padding-left: 30px; }

ul :first-child, ol :first-child {
  margin-top: 0; }

dl {
  padding: 0; }
  dl dt {
    font-size: 14px;
    font-weight: bold;
    font-style: italic;
    padding: 0;
    margin: 15px 0 5px; }
    dl dt:first-child {
      padding: 0; }
    dl dt > :first-child {
      margin-top: 0; }
    dl dt > :last-child {
      margin-bottom: 0; }
  dl dd {
    margin: 0 0 15px;
    padding: 0 15px; }
    dl dd > :first-child {
      margin-top: 0; }
    dl dd > :last-child {
      margin-bottom: 0; }

blockquote {
  border-left: 4px solid #dddddd;
  padding: 0 15px;
  color: #777777; }
  blockquote > :first-child {
    margin-top: 0; }
  blockquote > :last-child {
    margin-bottom: 0; }

table {
  padding: 0;border-collapse: collapse; }
  table tr {
    border-top: 1px solid #cccccc;
    background-color: white;
    margin: 0;
    padding: 0; }
    table tr:nth-child(2n) {
      background-color: #f8f8f8; }
    table tr th {
      font-weight: bold;
      border: 1px solid #cccccc;
      margin: 0;
      padding: 6px 13px; }
    table tr td {
      border: 1px solid #cccccc;
      margin: 0;
      padding: 6px 13px; }
    table tr th :first-child, table tr td :first-child {
      margin-top: 0; }
    table tr th :last-child, table tr td :last-child {
      margin-bottom: 0; }

img {
  max-width: 100%; }

span.frame {
  display: block;
  overflow: hidden; }
  span.frame > span {
    border: 1px solid #dddddd;
    display: block;
    float: left;
    overflow: hidden;
    margin: 13px 0 0;
    padding: 7px;
    width: auto; }
  span.frame span img {
    display: block;
    float: left; }
  span.frame span span {
    clear: both;
    color: #333333;
    display: block;
    padding: 5px 0 0; }
span.align-center {
  display: block;
  overflow: hidden;
  clear: both; }
  span.align-center > span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: center; }
  span.align-center span img {
    margin: 0 auto;
    text-align: center; }
span.align-right {
  display: block;
  overflow: hidden;
  clear: both; }
  span.align-right > span {
    display: block;
    overflow: hidden;
    margin: 13px 0 0;
    text-align: right; }
  span.align-right span img {
    margin: 0;
    text-align: right; }
span.float-left {
  display: block;
  margin-right: 13px;
  overflow: hidden;
  float: left; }
  span.float-left span {
    margin: 13px 0 0; }
span.float-right {
  display: block;
  margin-left: 13px;
  overflow: hidden;
  float: right; }
  span.float-right > span {
    display: block;
    overflow: hidden;
    margin: 13px auto 0;
    text-align: right; }

code, tt {
  margin: 0 2px;
  padding: 0 5px;
  white-space: nowrap;
  border: 1px solid #eaeaea;
  background-color: #f8f8f8;
  border-radius: 3px; }

pre code {
  margin: 0;
  padding: 0;
  white-space: pre;
  border: none;
  background: transparent; }

.highlight pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px; }

pre {
  background-color: #f8f8f8;
  border: 1px solid #cccccc;
  font-size: 13px;
  line-height: 19px;
  overflow: auto;
  padding: 6px 10px;
  border-radius: 3px; }
  pre code, pre tt {
    background-color: transparent;
    border: none; }

sup {
    font-size: 0.83em;
    vertical-align: super;
    line-height: 0;
}
* {
	-webkit-print-color-adjust: exact;
}
@media screen and (min-width: 914px) {
    body {
        width: 854px;
        margin:0 auto;
    }
}
@media print {
	table, pre {
		page-break-inside: avoid;
	}
	pre {
		word-wrap: break-word;
	}
}
</style>

<style type="text/css">
/**
 * prism.js tomorrow night eighties for JavaScript, CoffeeScript, CSS and HTML
 * Based on https://github.com/chriskempson/tomorrow-theme
 * @author Rose Pritchard
 */

code[class*="language-"],
pre[class*="language-"] {
	color: #ccc;
	background: none;
	font-family: Consolas, Monaco, 'Andale Mono', 'Ubuntu Mono', monospace;
	text-align: left;
	white-space: pre;
	word-spacing: normal;
	word-break: normal;
	word-wrap: normal;
	line-height: 1.5;

	-moz-tab-size: 4;
	-o-tab-size: 4;
	tab-size: 4;

	-webkit-hyphens: none;
	-moz-hyphens: none;
	-ms-hyphens: none;
	hyphens: none;

}

/* Code blocks */
pre[class*="language-"] {
	padding: 1em;
	margin: .5em 0;
	overflow: auto;
}

:not(pre) > code[class*="language-"],
pre[class*="language-"] {
	background: #2d2d2d;
}

/* Inline code */
:not(pre) > code[class*="language-"] {
	padding: .1em;
	border-radius: .3em;
	white-space: normal;
}

.token.comment,
.token.block-comment,
.token.prolog,
.token.doctype,
.token.cdata {
	color: #999;
}

.token.punctuation {
	color: #ccc;
}

.token.tag,
.token.attr-name,
.token.namespace,
.token.deleted {
	color: #e2777a;
}

.token.function-name {
	color: #6196cc;
}

.token.boolean,
.token.number,
.token.function {
	color: #f08d49;
}

.token.property,
.token.class-name,
.token.constant,
.token.symbol {
	color: #f8c555;
}

.token.selector,
.token.important,
.token.atrule,
.token.keyword,
.token.builtin {
	color: #cc99cd;
}

.token.string,
.token.char,
.token.attr-value,
.token.regex,
.token.variable {
	color: #7ec699;
}

.token.operator,
.token.entity,
.token.url {
	color: #67cdcc;
}

.token.important,
.token.bold {
	font-weight: bold;
}
.token.italic {
	font-style: italic;
}

.token.entity {
	cursor: help;
}

.token.inserted {
	color: green;
}
</style>

<style type="text/css">
pre.line-numbers {
	position: relative;
	padding-left: 3.8em;
	counter-reset: linenumber;
}

pre.line-numbers > code {
	position: relative;
}

.line-numbers .line-numbers-rows {
	position: absolute;
	pointer-events: none;
	top: 0;
	font-size: 100%;
	left: -3.8em;
	width: 3em; /* works for line-numbers below 1000 lines */
	letter-spacing: -1px;
	border-right: 1px solid #999;

	-webkit-user-select: none;
	-moz-user-select: none;
	-ms-user-select: none;
	user-select: none;

}

	.line-numbers-rows > span {
		pointer-events: none;
		display: block;
		counter-increment: linenumber;
	}

		.line-numbers-rows > span:before {
			content: counter(linenumber);
			color: #999;
			display: block;
			padding-right: 0.8em;
			text-align: right;
		}
</style>

<style type="text/css">
div.prism-show-language {
	position: relative;
}

div.prism-show-language > div.prism-show-language-label {
	color: black;
	background-color: #CFCFCF;
	display: inline-block;
	position: absolute;
	bottom: auto;
	left: auto;
	top: 0;
	right: 0;
	width: auto;
	height: auto;
	font-size: 0.9em;
	border-radius: 0 0 0 5px;
	padding: 0 0.5em;
	text-shadow: none;
	z-index: 1;
	-webkit-box-shadow: none;
	-moz-box-shadow: none;
	box-shadow: none;
	-webkit-transform: none;
	-moz-transform: none;
	-ms-transform: none;
	-o-transform: none;
	transform: none;
}
</style>


</head>

<body>

<h1 id="toc_0">Javascript调用手机原生操作文档</h1>

<h2 id="toc_1">已废弃的接口</h2>

<h3 id="toc_2">获取当前网络状态(废弃)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getNetworkType({
    success: function(res) {
        //your-code
    }
});</code></pre></div>

<ul>
<li>success: 获取成功回调，参数res为网络状态，分为三种情况：3G，WIFI，NONE。</li>
</ul>

<h3 id="toc_3">获取当前经纬度(废弃)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getLocation({
    success: function(res) {
        //your-code 
    }
});</code></pre></div>

<ul>
<li>success: 获取成功回调，参数res为经纬度对象，可通过<code>res.latitude</code>和<code>res.longitude</code>获取。</li>
</ul>

<h3 id="toc_4">全屏地图显示位置(废弃)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.openLocation({
    type: &#39;&#39;,
    locate: {
        address: &#39;&#39;
    },
    route: {
        startAdd: &#39;&#39;,
        endAdd: &#39;&#39;
    },
    line: [{
        longitude: 0.0,
        latitud: 0.0
    }]
});</code></pre></div>

<ul>
<li>type：有三种字符串，‘locate’，‘route’，‘line’，分别对应定位地图，两点之间路径地图，多点路线地图。<code>type</code>对应的字符串，则需要传入对应的object。</li>
<li>locate：object含有详细地址<code>address</code>。</li>
<li>route：object含有详细起止地址<code>startAdd</code>和<code>endAdd</code>。</li>
<li>line：经纬度数组，数组含有object内包含经纬度<code>longitude</code>和<code>latitud</code>。</li>
</ul>

<h3 id="toc_5">设置搜索栏(废弃)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setSearchBar({
    title: &#39;&#39;,
    action: function(message) {

    },
    cancelAction: function() {
        
    }
});</code></pre></div>

<ul>
<li>title: 搜索默认显示。</li>
<li>action: 搜索回调，<code>message</code>回调搜索内容。</li>
<li>cancelAction: 取消搜索回调。</li>
</ul>

<h3 id="toc_6">设置切换卡(废弃)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setCutoverBar({
    titles: [&#39;xxx&#39;, &#39;yyy&#39;, &#39;zzz&#39;],
    callback: function(index) {

    }
});</code></pre></div>

<ul>
<li>titles: 切换卡标题名，一个数组。</li>
<li>callback: 标题点击回调，<code>index</code>是被点击标题所在数组位置。</li>
</ul>

<h2 id="toc_7">正在使用的接口</h2>

<h3 id="toc_8">调用相机或相册获取照片(修改)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.chooseImage({
    maxSelects: 1,
    isRateTailor: false,
    tailoringRate: 0,
    success: function(data) {
        //your-code 
    }
});</code></pre></div>

<ul>
<li>maxSelects: 最大获取相片数量。</li>
<li>isRateTailor: 照片是否需要固定比例剪裁。</li>
<li>tailoringRate: 照片固定剪裁比例，width/height。</li>
<li>success: 获取成功回调，参数data为图片路径组成的数组，Array。</li>
</ul>

<h3 id="toc_9">全屏展示多张图片</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.displayFullImages({
    currentIndex: 0,
    urls: [
        &#39;http://cibits.net/f/1865/1865-1.jpg&#39;,
        &#39;http://livedoor.blogimg.jp/surotenn/imgs/c/6/c6de370d.jpg&#39;,
        &#39;https://img.mengniang.org/common/thumb/6/67/6770373.jpg/250px-6770373.jpg&#39;
        ]
});</code></pre></div>

<ul>
<li>currentIndex: 展示第几张图片，int。</li>
<li>urls: 所有图片数组，数组对象为String。</li>
</ul>

<h3 id="toc_10">设置导航栏(修改)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setNavigationBar({
    titleIcon: &#39;&#39;,
    title: &#39;&#39;,
    isLeftItemShow: true,
    leftTitleIcon: &#39;&#39;,
    leftItemTitle: &#39;&#39;,
    leftItemAction: function() {
        //your-code
    },
    isRightItemShow: true,
    rightTitleIcon: &#39;&#39;,
    rightItemTitle: &#39;&#39;,
    rightItemAction: function() {
        //your-code
    }
});</code></pre></div>

<ul>
<li>titleIcon: 标题图片。</li>
<li>title: 导航栏标题。</li>
<li>isLeftItemShow: 导航栏左侧按钮是否显示标示，若为true，则显示，须填写leftTitleIcon，leftItemTitle，leftItemAction，若为false，则不显示，若不需要改变，则不加该属性，若左上角为返回，则设置为false。</li>
<li>leftTitleIcon: 按钮图标，图片名称，若无，则填写空字符串。</li>
<li>leftItemTitle: 按钮名称，若无，则填写空字符串。</li>
<li>leftItemAction: 按钮点击事件。</li>
<li>isRightItemShow: 导航栏右侧按钮是否显示标示，若为true，则显示，须填写rightTitleIcon，rightItemTitle，rightItemAction，若为false，则不显示，若不需要改变，则不加该属性。</li>
<li>rightTitleIcon: 按钮图标，图片名称，若无，则填写空字符串。</li>
<li>rightItemTitle: 按钮名称，若无，则填写空字符串。</li>
<li>rightItemAction: 按钮点击事件。</li>
</ul>

<h3 id="toc_11">原生Loading</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.startLoading(); //开始Loading
gwt.endLoading();   //结束Loading</code></pre></div>

<h3 id="toc_12">显示信息提示</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.showMessage({
    message: &#39;&#39;,
    type: &#39;&#39;    //error, warm, success
});</code></pre></div>

<ul>
<li>message: 信息内容。</li>
<li>type: 信息提示种类，分别为error，warm，success。</li>
</ul>

<h3 id="toc_13">显示弹出框</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.alertMessage({
    title: &#39;&#39;,
    message: &#39;&#39;,
    isJudgment: true,
    action: function(){
        //your-code
    },
    cancelAction: function(){
        //your-code
    }
});</code></pre></div>

<ul>
<li>title: 弹出框标题。</li>
<li>message: 弹出框信息。</li>
<li>isJudgment: 弹出框是否需要判断，true时弹出框为两个键，false时弹出框一个键。</li>
<li>action: 弹出框点击事件。</li>
<li>cancelAction: 当<code>isJudgment</code>为true时，取消按钮的点击事件，没有可以不写该参数。</li>
</ul>

<h3 id="toc_14">显示Sheet</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.alertSheet({
    title: &#39;&#39;,
    btns: [
        {
            title: &#39;按钮1&#39;,
            action: function(){
                //your-code
            }
        },
        {
            title: &#39;按钮2&#39;,
            action: function(){
                //your-code
            }
        },
        {
            title: &#39;按钮3&#39;,
            action: function(){
                //your-code
            }
        }
    ]
});</code></pre></div>

<ul>
<li>title: sheet标题，可以为空字符串。</li>
<li>btns: sheet按钮数组。</li>
<li>btns.title: 具体每个按钮标题。</li>
<li>btns.action: 具体每个按钮点击事件。</li>
</ul>

<h3 id="toc_15">Push到一个新界面</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.pushNewActivity({
    url: &#39;&#39;,
    data: {}
});</code></pre></div>

<ul>
<li>url: 下一个界面的路由，为App.jsx中路由别名加斜杠组成。</li>
<li>data: 传给下一个界面的参数，object参数。</li>
<li>data里面传不同参数可能进入不同界面：</li>
<li>isSearch: 是否跳转到Search界面；</li>
<li>searchHint: searchbar默认文字。</li>
<li>isCutover: 是否跳转到切换卡界面；
具体参数：</li>
</ul>

<div><pre class="line-numbers"><code class="language-javascript">{
  &quot;url&quot;: &quot;&quot;,
  &quot;data&quot;: {
    &quot;isCutover&quot;: true,
    &quot;navs&quot;: [
      {
        &quot;title&quot;: &quot;百度&quot;,
        &quot;url&quot;: &quot;https://www.baidu.com/&quot;,
        &quot;data&quot;: {}
      },
      {
        &quot;title&quot;: &quot;百度&quot;,
        &quot;url&quot;: &quot;https://www.baidu.com/&quot;,
        &quot;data&quot;: {}
      }
    ],
    &quot;cutovers&quot;: [
      [
        {
          &quot;title&quot;: &quot;百度&quot;,
          &quot;url&quot;: &quot;https://www.baidu.com/&quot;,
          &quot;data&quot;: {}
        },
        {
          &quot;title&quot;: &quot;简书&quot;,
          &quot;url&quot;: &quot;http://www.jianshu.com/&quot;,
          &quot;data&quot;: {}
        }
      ],
      [
        {
          &quot;title&quot;: &quot;百度&quot;,
          &quot;url&quot;: &quot;https://www.baidu.com/&quot;,
          &quot;data&quot;: {}
        },
        {
          &quot;title&quot;: &quot;简书&quot;,
          &quot;url&quot;: &quot;http://www.jianshu.com/&quot;,
          &quot;data&quot;: {}
        }
      ]
    ]
  }
}</code></pre></div>

<h3 id="toc_16">设置搜索回调(新增)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setSearchBarCallback({
    action: function(message) {
    
    },
   cancelAction: function() {
        
   }
});</code></pre></div>

<h3 id="toc_17">设置切换卡(新增)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setCutover({
    titles: [&quot;&quot;]
    currentIndex: 0
});</code></pre></div>

<h3 id="toc_18">获取上层界面传递参数</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getTransferInfo({
    success: function(obj){
        //your-code
    }
});
</code></pre></div>

<ul>
<li>success: 成功回调，参数obj为上层push时传过来的参数。</li>
</ul>

<h3 id="toc_19">Pop回到原来界面</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.popOldActivity({
    index: 1,
    data: {},
    isCallback: true
});</code></pre></div>

<ul>
<li>index: 回到界面层级数，从0开始。</li>
<li>data: 传给原界面参数。</li>
<li>isCallback: 是否回调返回界面的回调方法。</li>
</ul>

<h3 id="toc_20">设置当前界面popOldActivity回调</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setCallBackAction({
    action: function(obj){
        //your-code
    }
});</code></pre></div>

<ul>
<li>action: 当前界面在<code>popOldActivity</code>回调时<code>isCallback</code>为true时执行的方法，参数obj为<code>popOldActivity</code>中的<code>data</code>传入。</li>
</ul>

<h3 id="toc_21">获取App配置信息(暂定参数)</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getUserInfo({
    success: function(obj){
        //your-code
    }
});</code></pre></div>

<ul>
<li>success: 成功回调，参数obj为配置对象，目前包含:</li>
</ul>

<div><pre class="line-numbers"><code class="language-objectivec">/**
 *  令牌
 */
@property (nonatomic, strong) NSString *accessToken;

/**
 *  用户名称
 */
@property (nonatomic, strong) NSString *userName;

/**
 *  登录手机号码
 */
@property (nonatomic, strong) NSString *userCode;

/**
 *  承运商代码
 */
@property (nonatomic, strong) NSString *organizationCode;

/**
 *  承运商名称
 */
@property (nonatomic, strong) NSString *organizationName;

/**
 *  承运商类型
 */
@property (nonatomic, strong) NSNumber *userType;

/**
 *  角色
 */
@property (nonatomic, strong) NSNumber *role;

/**
 *  百度推送设备号
 */
@property (nonatomic, strong) NSString *channelId;

/**
 *  设备操作系统
 */
@property (nonatomic, strong) NSString *deviceType;

/**
 *  设备信息
 */
@property (nonatomic, strong) NSString *deviceInfo;

/**
 *  APP版本号
 */
@property (nonatomic, strong) NSString *appVersion;

/**
 *  APP包版本号
 */
@property (nonatomic, strong) NSString *packVersion;
</code></pre></div>

<div><pre class="line-numbers"><code class="language-java">/**
 *  令牌
 */
public String accessToken;

/**
 *  用户名称
 */
public String userName;

/**
 *  登录手机号码
 */
public String userCode;

/**
 *  承运商代码
 */
public String organizationCode;

/**
 *  承运商名称
 */
public String organizationName;

/**
 *  承运商类型
 */
public Integer userType;

/**
 *  角色
 */
public Integer role;

/**
 *  百度推送设备号
 */
public String channelId;

/**
 *  设备操作系统
 */
public String deviceType;

/**
 *  设备信息
 */
public String deviceInfo;

/**
 *  APP版本号
 */
public String appVersion;

/**
 *  APP包版本号
 */
public String packVersion;
</code></pre></div>

<h3 id="toc_22">设置App配置信息</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setUserInfo({
    //your-code
});</code></pre></div>

<ul>
<li>设置传入键值对，键值必须包含在<code>getUserInfo</code>所有参数，可以有<code>success</code>参数，是设置完成的回调。</li>
</ul>

<h3 id="toc_23">图片转base64码</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getImageBase64({
    images:[
        {
            key: &#39;&#39;,
            baseUrl: &#39;&#39;
        }
    ],
    success: function(res){
        
    }
});</code></pre></div>

<ul>
<li>images: 需要转码的图片数组。</li>
<li>images.key: 具体image的唯一标示。</li>
<li>images.baseUrl: 具体image的图片路径。</li>
<li>success: 成功回调，回调参数res是一个对象，包含KV值是<code>images.key: images.baseUrl.base64</code>。</li>
</ul>

<h3 id="toc_24">设置下拉刷新</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setRefresh({
    refresh: function(end){
        //your-code
        //example
        setTimeout(function () {
            end();
        }, 5000);
    },
    isFirstRefresh: true
});</code></pre></div>

<ul>
<li>refresh: 下拉刷新方法，参数<code>end</code>是回调函数，结束刷新时调用。</li>
<li>isFirstRefresh: 界面初始化时是否直接自动调用刷新，true时自动调用，false不调用。</li>
</ul>

<h3 id="toc_25">设置上拉加载</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setLoadmore({
    loadmore: function(end){
        //your-code
        //example
        setTimeout(function () {
            end();
        }, 5000);
    }
});</code></pre></div>

<ul>
<li>loadmore: 上拉加载方法，参数<code>end</code>是回调函数，结束加载时调用。</li>
</ul>

<h3 id="toc_26">立即启动下拉刷新</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.startRefreshing();</code></pre></div>

<h3 id="toc_27">设置界面出现时的回调函数</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setViewAppear({
    action: function(){
        //your-code
    }
});</code></pre></div>

<ul>
<li>action: 当前界面出现时执行的方法。</li>
</ul>

<h3 id="toc_28">拨打电话</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.callPhone({
    phone: xxxx
});</code></pre></div>

<ul>
<li>phone: 电话号码。</li>
</ul>

<h3 id="toc_29">push到单纯的WebView界面</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.pushOnlyWebview({
    title: &#39;&#39;,
    url: &#39;&#39;
});</code></pre></div>

<ul>
<li>title: nav标题。</li>
<li>url: html路径。</li>
</ul>

<h3 id="toc_30">设置TabBar所在index</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setTabbarIndex({
    index: 0,
    data: {}
});</code></pre></div>

<ul>
<li>index: Tabbar位置切换index。</li>
<li>data: 传给新界面数据。</li>
</ul>

<h3 id="toc_31">获取原生datetime</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.getDatetime({
    currentTime: 0,
    success: function(time){
        //your-code
    }
});</code></pre></div>

<ul>
<li>currentTime: datetime现实的时间戳。</li>
<li>success: 获取时间成功回调，<code>time</code>为时间戳。</li>
</ul>

<h3 id="toc_32">设置TabBar显示数字。</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.setTabbarNumber({
    numbers: []
});</code></pre></div>

<ul>
<li>numbers: tabbar显示的数字。</li>
</ul>

<h3 id="toc_33">发送全局广播</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.sendGlobalBroadcast({
    key: &#39;&#39;,
    data: {}
});</code></pre></div>

<h3 id="toc_34">接收全局广播</h3>

<div><pre class="line-numbers"><code class="language-javascript">gwt.receiveGlobalBroadcast({
    key: &#39;&#39;,
    success: function(data) {
    }
});</code></pre></div>



<script type="text/javascript">
var _self="undefined"!=typeof window?window:"undefined"!=typeof WorkerGlobalScope&&self instanceof WorkerGlobalScope?self:{},Prism=function(){var e=/\blang(?:uage)?-(\w+)\b/i,t=0,n=_self.Prism={util:{encode:function(e){return e instanceof a?new a(e.type,n.util.encode(e.content),e.alias):"Array"===n.util.type(e)?e.map(n.util.encode):e.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/\u00a0/g," ")},type:function(e){return Object.prototype.toString.call(e).match(/\[object (\w+)\]/)[1]},objId:function(e){return e.__id||Object.defineProperty(e,"__id",{value:++t}),e.__id},clone:function(e){var t=n.util.type(e);switch(t){case"Object":var a={};for(var r in e)e.hasOwnProperty(r)&&(a[r]=n.util.clone(e[r]));return a;case"Array":return e.map&&e.map(function(e){return n.util.clone(e)})}return e}},languages:{extend:function(e,t){var a=n.util.clone(n.languages[e]);for(var r in t)a[r]=t[r];return a},insertBefore:function(e,t,a,r){r=r||n.languages;var l=r[e];if(2==arguments.length){a=arguments[1];for(var i in a)a.hasOwnProperty(i)&&(l[i]=a[i]);return l}var o={};for(var s in l)if(l.hasOwnProperty(s)){if(s==t)for(var i in a)a.hasOwnProperty(i)&&(o[i]=a[i]);o[s]=l[s]}return n.languages.DFS(n.languages,function(t,n){n===r[e]&&t!=e&&(this[t]=o)}),r[e]=o},DFS:function(e,t,a,r){r=r||{};for(var l in e)e.hasOwnProperty(l)&&(t.call(e,l,e[l],a||l),"Object"!==n.util.type(e[l])||r[n.util.objId(e[l])]?"Array"!==n.util.type(e[l])||r[n.util.objId(e[l])]||(r[n.util.objId(e[l])]=!0,n.languages.DFS(e[l],t,l,r)):(r[n.util.objId(e[l])]=!0,n.languages.DFS(e[l],t,null,r)))}},plugins:{},highlightAll:function(e,t){var a={callback:t,selector:'code[class*="language-"], [class*="language-"] code, code[class*="lang-"], [class*="lang-"] code'};n.hooks.run("before-highlightall",a);for(var r,l=a.elements||document.querySelectorAll(a.selector),i=0;r=l[i++];)n.highlightElement(r,e===!0,a.callback)},highlightElement:function(t,a,r){for(var l,i,o=t;o&&!e.test(o.className);)o=o.parentNode;o&&(l=(o.className.match(e)||[,""])[1],i=n.languages[l]),t.className=t.className.replace(e,"").replace(/\s+/g," ")+" language-"+l,o=t.parentNode,/pre/i.test(o.nodeName)&&(o.className=o.className.replace(e,"").replace(/\s+/g," ")+" language-"+l);var s=t.textContent,u={element:t,language:l,grammar:i,code:s};if(!s||!i)return n.hooks.run("complete",u),void 0;if(n.hooks.run("before-highlight",u),a&&_self.Worker){var c=new Worker(n.filename);c.onmessage=function(e){u.highlightedCode=e.data,n.hooks.run("before-insert",u),u.element.innerHTML=u.highlightedCode,r&&r.call(u.element),n.hooks.run("after-highlight",u),n.hooks.run("complete",u)},c.postMessage(JSON.stringify({language:u.language,code:u.code,immediateClose:!0}))}else u.highlightedCode=n.highlight(u.code,u.grammar,u.language),n.hooks.run("before-insert",u),u.element.innerHTML=u.highlightedCode,r&&r.call(t),n.hooks.run("after-highlight",u),n.hooks.run("complete",u)},highlight:function(e,t,r){var l=n.tokenize(e,t);return a.stringify(n.util.encode(l),r)},tokenize:function(e,t){var a=n.Token,r=[e],l=t.rest;if(l){for(var i in l)t[i]=l[i];delete t.rest}e:for(var i in t)if(t.hasOwnProperty(i)&&t[i]){var o=t[i];o="Array"===n.util.type(o)?o:[o];for(var s=0;s<o.length;++s){var u=o[s],c=u.inside,g=!!u.lookbehind,h=!!u.greedy,f=0,d=u.alias;u=u.pattern||u;for(var p=0;p<r.length;p++){var m=r[p];if(r.length>e.length)break e;if(!(m instanceof a)){u.lastIndex=0;var y=u.exec(m),v=1;if(!y&&h&&p!=r.length-1){var b=r[p+1].matchedStr||r[p+1],k=m+b;if(p<r.length-2&&(k+=r[p+2].matchedStr||r[p+2]),u.lastIndex=0,y=u.exec(k),!y)continue;var w=y.index+(g?y[1].length:0);if(w>=m.length)continue;var _=y.index+y[0].length,P=m.length+b.length;if(v=3,P>=_){if(r[p+1].greedy)continue;v=2,k=k.slice(0,P)}m=k}if(y){g&&(f=y[1].length);var w=y.index+f,y=y[0].slice(f),_=w+y.length,S=m.slice(0,w),O=m.slice(_),j=[p,v];S&&j.push(S);var A=new a(i,c?n.tokenize(y,c):y,d,y,h);j.push(A),O&&j.push(O),Array.prototype.splice.apply(r,j)}}}}}return r},hooks:{all:{},add:function(e,t){var a=n.hooks.all;a[e]=a[e]||[],a[e].push(t)},run:function(e,t){var a=n.hooks.all[e];if(a&&a.length)for(var r,l=0;r=a[l++];)r(t)}}},a=n.Token=function(e,t,n,a,r){this.type=e,this.content=t,this.alias=n,this.matchedStr=a||null,this.greedy=!!r};if(a.stringify=function(e,t,r){if("string"==typeof e)return e;if("Array"===n.util.type(e))return e.map(function(n){return a.stringify(n,t,e)}).join("");var l={type:e.type,content:a.stringify(e.content,t,r),tag:"span",classes:["token",e.type],attributes:{},language:t,parent:r};if("comment"==l.type&&(l.attributes.spellcheck="true"),e.alias){var i="Array"===n.util.type(e.alias)?e.alias:[e.alias];Array.prototype.push.apply(l.classes,i)}n.hooks.run("wrap",l);var o="";for(var s in l.attributes)o+=(o?" ":"")+s+'="'+(l.attributes[s]||"")+'"';return"<"+l.tag+' class="'+l.classes.join(" ")+'" '+o+">"+l.content+"</"+l.tag+">"},!_self.document)return _self.addEventListener?(_self.addEventListener("message",function(e){var t=JSON.parse(e.data),a=t.language,r=t.code,l=t.immediateClose;_self.postMessage(n.highlight(r,n.languages[a],a)),l&&_self.close()},!1),_self.Prism):_self.Prism;var r=document.currentScript||[].slice.call(document.getElementsByTagName("script")).pop();return r&&(n.filename=r.src,document.addEventListener&&!r.hasAttribute("data-manual")&&document.addEventListener("DOMContentLoaded",n.highlightAll)),_self.Prism}();"undefined"!=typeof module&&module.exports&&(module.exports=Prism),"undefined"!=typeof global&&(global.Prism=Prism);
</script>

<script type="text/javascript">
Prism.languages.clike={comment:[{pattern:/(^|[^\\])\/\*[\w\W]*?\*\//,lookbehind:!0},{pattern:/(^|[^\\:])\/\/.*/,lookbehind:!0}],string:{pattern:/(["'])(\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1/,greedy:!0},"class-name":{pattern:/((?:\b(?:class|interface|extends|implements|trait|instanceof|new)\s+)|(?:catch\s+\())[a-z0-9_\.\\]+/i,lookbehind:!0,inside:{punctuation:/(\.|\\)/}},keyword:/\b(if|else|while|do|for|return|in|instanceof|function|new|try|throw|catch|finally|null|break|continue)\b/,"boolean":/\b(true|false)\b/,"function":/[a-z0-9_]+(?=\()/i,number:/\b-?(?:0x[\da-f]+|\d*\.?\d+(?:e[+-]?\d+)?)\b/i,operator:/--?|\+\+?|!=?=?|<=?|>=?|==?=?|&&?|\|\|?|\?|\*|\/|~|\^|%/,punctuation:/[{}[\];(),.:]/};
</script>

<script type="text/javascript">
Prism.languages.javascript=Prism.languages.extend("clike",{keyword:/\b(as|async|await|break|case|catch|class|const|continue|debugger|default|delete|do|else|enum|export|extends|finally|for|from|function|get|if|implements|import|in|instanceof|interface|let|new|null|of|package|private|protected|public|return|set|static|super|switch|this|throw|try|typeof|var|void|while|with|yield)\b/,number:/\b-?(0x[\dA-Fa-f]+|0b[01]+|0o[0-7]+|\d*\.?\d+([Ee][+-]?\d+)?|NaN|Infinity)\b/,"function":/[_$a-zA-Z\xA0-\uFFFF][_$a-zA-Z0-9\xA0-\uFFFF]*(?=\()/i}),Prism.languages.insertBefore("javascript","keyword",{regex:{pattern:/(^|[^\/])\/(?!\/)(\[.+?]|\\.|[^\/\\\r\n])+\/[gimyu]{0,5}(?=\s*($|[\r\n,.;})]))/,lookbehind:!0,greedy:!0}}),Prism.languages.insertBefore("javascript","class-name",{"template-string":{pattern:/`(?:\\\\|\\?[^\\])*?`/,greedy:!0,inside:{interpolation:{pattern:/\$\{[^}]+\}/,inside:{"interpolation-punctuation":{pattern:/^\$\{|\}$/,alias:"punctuation"},rest:Prism.languages.javascript}},string:/[\s\S]+/}}}),Prism.languages.markup&&Prism.languages.insertBefore("markup","tag",{script:{pattern:/(<script[\w\W]*?>)[\w\W]*?(?=<\/script>)/i,lookbehind:!0,inside:Prism.languages.javascript,alias:"language-javascript"}}),Prism.languages.js=Prism.languages.javascript;
</script>

<script type="text/javascript">
Prism.languages.java=Prism.languages.extend("clike",{keyword:/\b(abstract|continue|for|new|switch|assert|default|goto|package|synchronized|boolean|do|if|private|this|break|double|implements|protected|throw|byte|else|import|public|throws|case|enum|instanceof|return|transient|catch|extends|int|short|try|char|final|interface|static|void|class|finally|long|strictfp|volatile|const|float|native|super|while)\b/,number:/\b0b[01]+\b|\b0x[\da-f]*\.?[\da-fp\-]+\b|\b\d*\.?\d+(?:e[+-]?\d+)?[df]?\b/i,operator:{pattern:/(^|[^.])(?:\+[+=]?|-[-=]?|!=?|<<?=?|>>?>?=?|==?|&[&=]?|\|[|=]?|\*=?|\/=?|%=?|\^=?|[?:~])/m,lookbehind:!0}}),Prism.languages.insertBefore("java","function",{annotation:{alias:"punctuation",pattern:/(^|[^.])@\w+/,lookbehind:!0}});
</script>

<script type="text/javascript">
Prism.languages.c=Prism.languages.extend("clike",{keyword:/\b(asm|typeof|inline|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while)\b/,operator:/\-[>-]?|\+\+?|!=?|<<?=?|>>?=?|==?|&&?|\|?\||[~^%?*\/]/,number:/\b-?(?:0x[\da-f]+|\d*\.?\d+(?:e[+-]?\d+)?)[ful]*\b/i}),Prism.languages.insertBefore("c","string",{macro:{pattern:/(^\s*)#\s*[a-z]+([^\r\n\\]|\\.|\\(?:\r\n?|\n))*/im,lookbehind:!0,alias:"property",inside:{string:{pattern:/(#\s*include\s*)(<.+?>|("|')(\\?.)+?\3)/,lookbehind:!0},directive:{pattern:/(#\s*)\b(define|elif|else|endif|error|ifdef|ifndef|if|import|include|line|pragma|undef|using)\b/,lookbehind:!0,alias:"keyword"}}},constant:/\b(__FILE__|__LINE__|__DATE__|__TIME__|__TIMESTAMP__|__func__|EOF|NULL|stdin|stdout|stderr)\b/}),delete Prism.languages.c["class-name"],delete Prism.languages.c["boolean"];
</script>

<script type="text/javascript">
Prism.languages.objectivec=Prism.languages.extend("c",{keyword:/\b(asm|typeof|inline|auto|break|case|char|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|register|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|volatile|while|in|self|super)\b|(@interface|@end|@implementation|@protocol|@class|@public|@protected|@private|@property|@try|@catch|@finally|@throw|@synthesize|@dynamic|@selector)\b/,string:/("|')(\\(?:\r\n|[\s\S])|(?!\1)[^\\\r\n])*\1|@"(\\(?:\r\n|[\s\S])|[^"\\\r\n])*"/,operator:/-[->]?|\+\+?|!=?|<<?=?|>>?=?|==?|&&?|\|\|?|[~^%?*\/@]/});
</script>

<script type="text/javascript">
!function(){"undefined"!=typeof self&&self.Prism&&self.document&&Prism.hooks.add("complete",function(e){if(e.code){var t=e.element.parentNode,s=/\s*\bline-numbers\b\s*/;if(t&&/pre/i.test(t.nodeName)&&(s.test(t.className)||s.test(e.element.className))&&!e.element.querySelector(".line-numbers-rows")){s.test(e.element.className)&&(e.element.className=e.element.className.replace(s,"")),s.test(t.className)||(t.className+=" line-numbers");var n,a=e.code.match(/\n(?!$)/g),l=a?a.length+1:1,m=new Array(l+1);m=m.join("<span></span>"),n=document.createElement("span"),n.className="line-numbers-rows",n.innerHTML=m,t.hasAttribute("data-start")&&(t.style.counterReset="linenumber "+(parseInt(t.getAttribute("data-start"),10)-1)),e.element.appendChild(n)}}})}();
</script>

<script type="text/javascript">
!function(){if("undefined"!=typeof self&&self.Prism&&self.document){var e={html:"HTML",xml:"XML",svg:"SVG",mathml:"MathML",css:"CSS",clike:"C-like",javascript:"JavaScript",abap:"ABAP",actionscript:"ActionScript",apacheconf:"Apache Configuration",apl:"APL",applescript:"AppleScript",asciidoc:"AsciiDoc",aspnet:"ASP.NET (C#)",autoit:"AutoIt",autohotkey:"AutoHotkey",basic:"BASIC",csharp:"C#",cpp:"C++",coffeescript:"CoffeeScript","css-extras":"CSS Extras",fsharp:"F#",glsl:"GLSL",http:"HTTP",inform7:"Inform 7",json:"JSON",latex:"LaTeX",lolcode:"LOLCODE",matlab:"MATLAB",mel:"MEL",nasm:"NASM",nginx:"nginx",nsis:"NSIS",objectivec:"Objective-C",ocaml:"OCaml",parigp:"PARI/GP",php:"PHP","php-extras":"PHP Extras",powershell:"PowerShell",jsx:"React JSX",rest:"reST (reStructuredText)",sas:"SAS",sass:"Sass (Sass)",scss:"Sass (Scss)",sql:"SQL",typescript:"TypeScript",vhdl:"VHDL",vim:"vim",wiki:"Wiki markup",yaml:"YAML"};Prism.hooks.add("before-highlight",function(s){var a=s.element.parentNode;if(a&&/pre/i.test(a.nodeName)){var t,i,r=a.getAttribute("data-language")||e[s.language]||s.language.substring(0,1).toUpperCase()+s.language.substring(1),l=a.previousSibling;l&&/\s*\bprism-show-language\b\s*/.test(l.className)&&l.firstChild&&/\s*\bprism-show-language-label\b\s*/.test(l.firstChild.className)?i=l.firstChild:(t=document.createElement("div"),i=document.createElement("div"),i.className="prism-show-language-label",t.className="prism-show-language",t.appendChild(i),a.parentNode.insertBefore(t,a)),i.innerHTML=r}})}}();
</script>


</body>

</html>
