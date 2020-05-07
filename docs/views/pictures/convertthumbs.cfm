<style>
.filename {
	cursor:pointer;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<cfoutput>
	<script>
		var missing = [];
		var idx = 0;
		var running = false;
		var misscounter = #arrayLen(missing)#;
		var tick = (new Date()).getTime();
		var newtick = tick;
		var timeremaining = 0;
		<cfloop from="1" to="#arrayLen(missing)#" index="i">
			missing.push('#JSStringFormat(missing[i])#');
		</cfloop>
		$(function(){
			$("button")
				.click(function(e){
					e.preventDefault();
					$("<input type='radio'>")
						.appendTo($("tr."+idx))
						.focus()
						.remove();
					running = true;
					$.post("/pictures/convertthumbs/",{filename:missing[idx]},function(response){
						$("tr."+idx).find("td:first").html("[x]");
						idx++;
						misscounter--;
						if(idx % 50 == 0){
	  					 	newtick = (new Date()).getTime();
	  					 	timeremaining = misscounter * (newtick - tick)/50000;
	  					 	tick = newtick;
	  					 	$("##timeleft").html(Math.floor(timeremaining / 60) + " minutes, " + Math.floor(timeremaining % 60) + " seconds");
						}
						if(misscounter == 0)$("##timeleft").html("Done");
						$("##misscount").html(misscounter);
						if(idx<missing.length)$("button").click();
					});
				});
			$(".filename")
				.click(function(e){
					e.preventDefault();
					if (!running) {
						idx = parseInt($(this).parent().attr("class"));
						alert("start with index "+idx);
					}
				});
		});
	</script>
	<div style="position:fixed; width:600px; left:600px; top:20px;">
	<strong>Profile images:</strong> #doctorImagePath# (#oldcount#)<br>
	<strong>Thumb images:</strong> #doctorImagePath#/thumb (#newcount#)<br>
	There are <strong id="misscount">#arrayLen(missing)#</strong> images that are missing thumbs. <button>convert them!</button><br>
	<div id="timeleft"></div>
	</div>
	<table>
		<cfloop from="1" to="#arrayLen(missing)#" index="i">
			<tr class="#(i-1)#">
				<td class="tick">[&nbsp;]</td>
				<td class="filename">#missing[i]#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>