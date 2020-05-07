$(function(){
	
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(obj, start) {
		     for (var i = (start || 0), j = this.length; i < j; i++) {
		         if (this[i] === obj) { return i; }
		     }
		     return -1;
		}
	}
	
	
	$('.prompt-box').dialog({
			autoOpen:false,
			draggable:false,
			resizable:false,
			modal:true,
			closeText:'',
			dialogClass:'compare-dialog',
			width:640,
			height:480,
			show:'fade',
			hide:'fade',
			my:'center center',
			at:'center center',
			of:'body'
	});	
	
	
	SmartTruncate('.procedure-list-labels',20,175,true);
});



function PromptOpen(){
	$('.prompt-box').dialog('open');
}
function ALListClose(){
	$('.prompt-box').dialog('close');						
}