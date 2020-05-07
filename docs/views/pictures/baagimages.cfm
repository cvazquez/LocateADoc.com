<cftry>
<cfoutput>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
	<script>
	$(function(){
		$("th:first")
			.css({"background-color":"##6EC8FF",width:"50%"})
			.next()
				.css("background-color","##FB833E")
			.next()
				.css({"background-color":"##6EC8FF",width:"50%"})
		$("img")
			.css({"max-width":"100%","max-height":273})
		$("input[name=lad2]:first")
			.attr("checked","checked")
		$("input[name=lad3]:first")
			.attr("checked","checked")
		$("button")
			.click(function(){
				if ($("input").length == 0) return
				var theform = $("##baagfix").serialize()
				var caseid	= theform.split("lad3=")[1]
				$.post("/pictures/baagimages"+($("input[type=checkbox]:first").is(":checked")?"?baagauto=1":""),theform,function(response){
					var d = new Date()
					$("img."+caseid).each(function(){
						$(this).attr("src",$(this).attr("src")+"?"+d.getTime())
					})
				})
			})
		$("a[row]")
			.click(function(e){
				e.preventDefault()
				var row = $(this).attr("row")
				var disp = $(this).parent()
				disp.html("converting")
				$("tr[row="+row+"] input")
					.attr("checked","checked")
				var baagauto	= $("input##baagauto").is(":checked")?1:0
				var baagforce	= $("input##baagforce").is(":checked")?1:0
				var caseid		= #params.key#
				var lad2		= $(this).attr("lad2")
				var lad3		= $(this).attr("lad3")
				baagrequests++
				$.post("/pictures/baagimages"+($("input[type=checkbox]:first").is(":checked")?"?baagauto=1":""),{baagauto:baagauto,baagforce:baagforce,caseid:caseid,lad2:lad2,lad3:lad3},function(response){
					var d = new Date()
					$("img."+lad3).each(function(){
						$(this).attr("src",$(this).attr("src")+"?"+d.getTime())
					})
					disp.html("done!")
					baagrequests--
					if (baagrequests < 1) {
						if (nextaction == "reload") {
							$("##middle").html("reloading")
							setTimeout("reloadCase()",1000)
						} else {
							$("##middle").html("next case")
							setTimeout("nextCase()",1000)
						}
					} else {
						$("##middle").html("waiting "+baagrequests)
					}
				})
			})
		$("a[stopjs]")
			.click(function(e){
				e.preventDefault()
				for (var i in clicks) {
					clearTimeout(clicks[i])
				}
			})
		$("a[split]")
			.click(function(e){
				e.preventDefault()
				var split = $(this).attr("split")
				$(this).parent().text("..splitting..")
				$.post("/pictures/baagimages"+($("input[type=checkbox]:first").is(":checked")?"?baagauto=1":""),{split:split},function(response){
					//finished
				})
			})
		$("input[type=checkbox]:first")
			.click(function(e){
				if ($(this).is(":checked") && confirm("start auto process now?")) autoProcess()
			})
			.next().next()
				.click(function(e){
					if ($(this).is(":checked")) return confirm("force sync of all files? even ones that already have images?\n\nCheck 'Auto' to start.")
				})
		<cfif params.baagauto>
			autoProcess()
		</cfif>
		setTimeout("showDebug()",6000)
		if (nextaction == "nextcase") setTimeout("nextCase()",60000) //this will hopefully force it to continue to the next case even if the current case craps out
	})
	function autoProcess() {
		nextaction = "nextcase"
		$("a[row]").each(function(){
			var row = $(this).attr("row")
			var complete = $(this).attr("complete") == "YES"
			if (complete && $("input##baagforce").is(":checked") || !complete)
				clicks[row] = setTimeout("$('a[row="+row+"]').click()",500*row)
		})
		if (Object.keys(clicks).length==0 && baagrequests==0) {
			if (nextaction == "reload") {
				$("##middle").html("reloading")
				setTimeout("reloadCase()",1000)
			} else {
				$("##middle").html("next case")
				setTimeout("nextCase()",1000)
			}
		}
	}
	function reloadCase() {
		if (reloadcase) {
			location.reload()
			reloadcase = false
		}
	}
	function nextCase() {
		if (nextcase) {
			location.href	= "#(params.key+1)#"+($("input[type=checkbox]:first").is(":checked")?"?baagauto=1"+($("input##baagforce").is(":checked")?"&baagforce=1":""):"")
			nextcase		= false
		}
	}
	function showDebug() {
		if (debug.length > 0) alert(debug)
	}
	var clicks		= {}
	var baagrequests= 0
	var nextcase	= true
	var reloadcase	= true
	var nextaction	= "reload"
	var debug		= ""
	<cfif params.key gte max.id>
		alert("NO MORE CASES")
	<cfelseif (not val(before.recordcount) and not val(after.recordcount)) or not arrayLen(case.galleryCaseAngles)>
		$.post("/pictures/baagimages/",{disable:#params.key#},function(){
			nextCase()
		})
	</cfif>
	</script>
	<style>
	table {width:100%; border:1px solid ##00;}
	th {background-color:##ddd;}
	td {text-align:center;vertical-align:top;}
	th##middle {width:15%;}
	</style>
	<h3>#params.key# of #max.id#</h3>
	<a href="#val(params.key+1)#" style="float:right">next</a>
	<a href="#val(params.key-1)#" style="float:left">prev</a>
	<br>
	<form id="baagfix">
	<input type="hidden" name="caseid" value="#params.key#">
	<input type="checkbox" name="baagauto" id="baagauto" value="1"<cfif params.baagauto> checked="checked"</cfif> title="run autonymously"> <label for="baagauto">Auto</label>
	(<input type="checkbox" name="baagforce" id="baagforce" value="1"<cfif params.baagforce> checked="checked"</cfif> title="force sync all images"> <label for="baagforce">Force</label>) | <a href="##" stopjs="1">stop js</a>
	<table>
		<tr>
			<th colspan="3">LAD-2</th>
			<th id="middle">>---></th>
			<th colspan="3">LAD-3</th>
		</tr>
		<tr>
			<th>No</th>
			<th width="20%">Before</th>
			<th width="20%">After</th>
			<th><button type="button">sync</button></th>
			<th>Id</th>
			<th width="20%">Before</th>
			<th width="20%">After</th>
		</tr>
		<cfloop from="1" to="#max(max(before.recordcount,after.recordcount),arrayLen(case.galleryCaseAngles))#" index="i">
			<tr row="#i#">
				<td>#i#</td>
				<td>
					<cfif val(len(before.name[i]))>
						<img src="#LAD2galleryImageBase#/#before.name[i]#">
						<cfif not val(len(after.name[i]))>
							<br>split <a href="##" split="#params.key#,#before.name[i]#,0,#i#" verticle="#i#">verticle</a> | split <a href="##" split="#params.key#,#before.name[i]#,1,#i#">horizontal</a> --
						</cfif>
					<cfelse>None</cfif>
				</td>
				<td>
					<cfif val(len(after.name[i]))>
						<img src="#LAD2galleryImageBase#/#after.name[i]#">
					<cfelse>None</cfif>
				</td>
				<cfif val(len(before.name[i])) and val(len(after.name[i])) and arrayLen(case.galleryCaseAngles) gte i>
					<td>
						<input type="radio" name="lad2" value="#i#">
						<a lad2="#i#" lad3="#case.galleryCaseAngles[i].id#" href="##" row="#i#" complete="#(fileExists("#galleryImagePath#/regular/#params.key#-#case.galleryCaseAngles[i].id#-before.jpg") and fileExists("#galleryImagePath#/regular/#params.key#-#case.galleryCaseAngles[i].id#-after.jpg"))#">>---></a>
						<input type="radio" name="lad3" value="#case.galleryCaseAngles[i].id#">
					</td>
				<cfelse>
					<td></td>
				</cfif>
				<cfif arrayLen(case.galleryCaseAngles) gte i>
					<td>#case.galleryCaseAngles[i].id#</td>
					<td><img class="#case.galleryCaseAngles[i].id#" src="/pictures/gallery/jay-is-cool-before-regular-#case.id#-#case.galleryCaseAngles[i].id#.jpg"></td>
					<td><img class="#case.galleryCaseAngles[i].id#" src="/pictures/gallery/jay-is-cool-after-regular-#case.id#-#case.galleryCaseAngles[i].id#.jpg"></td>
				<cfelse>
					<td colspan="3">No angle</td>
				</cfif>
			</tr>
		</cfloop>
		</form>
	</table>
	<a href="#val(params.key+1)#" style="float:right">next</a>
	<a href="#val(params.key-1)#" style="float:left">prev</a>
</cfoutput>
<cfcatch>
	<cfdump var="#cfcatch#"><cfabort>
</cfcatch>
</cftry>