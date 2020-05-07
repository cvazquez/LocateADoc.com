<style>
.filename {
	cursor:pointer;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.1/jquery.min.js"></script>
<cfoutput>
	<script>
		var missing = []
		var idx = 0
		var running = false
		<cfloop from="1" to="#arrayLen(missing)#" index="i">
			missing.push('#JSStringFormat(missing[i])#')
		</cfloop>
		$(function(){
			$("button")
				.click(function(e){
					e.preventDefault()
					$("<input type='radio'>")
						.appendTo($("tr."+idx))
						.focus()
						.remove()
					running = true
					$.post("/pictures/doctorphoto/",{filename:missing[idx]},function(response){
						$("tr."+idx).find("td:first").html("[x]")
						idx++
						$("button").click()
					})
				})
			$(".filename")
				.click(function(e){
					e.preventDefault()
					if (!running) {
						idx = parseInt($(this).parent().attr("class"))
						alert("start with index "+idx)
					}
				})
		})
	</script>
	<strong>2.0 Location:</strong> #doctorImagePathOld# (#oldcount#)<br>
	<strong>3.0 Location:</strong> #doctorImagePath# (#newcount#)<br>
	There are <strong>#arrayLen(missing)#</strong> images that are in 2.0 but not in 3.0 <button>convert them!</button>
	<table>
		<cfloop from="1" to="#arrayLen(missing)#" index="i">
			<tr class="#(i-1)#">
				<td class="tick">[&nbsp;]</td>
				<td class="filename">#missing[i]#</td>
			</tr>
		</cfloop>
	</table>
</cfoutput>