  (function( $ ) {
                $.widget( "ui.combobox", {
                        _create: function() {
                                var self = this,
                                        select = this.element.hide(),
                                        selected = select.children( ":selected" ),
                                        value = selected.val() ? selected.text() : "";
                                var input = this.input = $( "<input>" )
                                        .insertAfter( select )
                                        .val( value )
                                        .autocomplete({
                                                delay: 0,
                                                minLength: 0,
                                                source: function( request, response ) {
                                                        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
                                                        response( select.children( "option" ).map(function() {
                                                                var text = $( this ).text();
                                                                if ( this.value && ( !request.term || matcher.test(text) ) )
                                                                        return {
                                                                                label: text.replace(
                                                                                        new RegExp(
                                                                                                "(?![^&;]+;)(?!<[^<>]*)(" +
                                                                                                $.ui.autocomplete.escapeRegex(request.term) +
                                                                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
                                                                                        ), "<strong>$1</strong>" ),
                                                                                value: text,
                                                                                option: this
                                                                        };
                                                        }) );
                                                },
                                                select: function( event, ui ) {
                                                        ui.item.option.selected = true;
                                                        self._trigger( "selected", event, {
                                                                item: ui.item.option
                                                        });
                                                        
                                                        // Display overlay of questions for the procedure selected
                                                        PromptOpen(ui.item.option.value);
                                                },
                                                change: function( event, ui ) {
                                                        if ( !ui.item ) {
                                                                var matcher = new RegExp( "^" + $.ui.autocomplete.escapeRegex( $(this).val() ) + "$", "i" ),
                                                                        valid = false;
                                                                select.children( "option" ).each(function() {
                                                                        if ( $( this ).text().match( matcher ) ) {
                                                                                this.selected = valid = true;
                                                                                return false;
                                                                        }
                                                                });
                                                                if ( !valid ) {
                                                                        // remove invalid value, as it didn't match anything
                                                                        $( this ).val( "" );
                                                                        select.val( "" );
                                                                        input.data( "autocomplete" ).term = "";
                                                                        return false;
                                                                }
                                                        }
                                                        else
                                                        {
                                                        	/* Search and display a list of q/a's for the procedure selected */
                                                        }                                                        
                                                }
                                        })
                                        .addClass( "ui-widget ui-widget-content ui-corner-left" );

                                input.data( "autocomplete" )._renderItem = function( ul, item ) {
                                        return $( "<li></li>" )
                                                .data( "item.autocomplete", item )
                                                .append( "<a>" + item.label + "</a>" )
                                                .appendTo( ul );
                                };

                                this.button = $( "<button type='button'>&nbsp;</button>" )
                                        .attr( "tabIndex", -1 )
                                        .attr( "title", "Show All Items" )
                                        .insertAfter( input )
                                        .button({
                                                icons: {
                                                        primary: "ui-icon-triangle-1-s"
                                                },
                                                text: false
                                        })
                                        .removeClass( "ui-corner-all" )
                                        .addClass( "ui-corner-right ui-button-icon" )
                                        .click(function() {
                                                // close if already visible
                                                if ( input.autocomplete( "widget" ).is( ":visible" ) ) {
                                                        input.autocomplete( "close" );
                                                        return;
                                                }

                                                // work around a bug (likely same cause as #5265)
                                                $( this ).blur();

                                                // pass empty string as value to search for, displaying all results
                                                input.autocomplete( "search", "" );
                                                input.focus();
                                        });
                        },

                        destroy: function() {
                                this.input.remove();
                                this.button.remove();
                                this.element.show();
                                $.Widget.prototype.destroy.call( this );
                        }
                });
        })( jQuery );
 
  $(function() {
	  
    $( "#combobox" ).combobox();
    $( "#toggle" ).click(function() {
      $( "#combobox" ).toggle();
    });
  
    
    $("#AskADocIntroShowMore").click(function(){		
		$(".AskADocIntro").show();
		$("#AskADocIntroShowMore").hide();
	});
    
    
    
    /* Prepare overlay to display list of questions for procedure selected */
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
			width:800,
			height:600,
			show:'fade',
			hide:'fade',
			my:'center center',
			at:'center center',
			of:'body'
	});   
	
 
  });
  
  
function PromptOpen(specialtyOrProcedureId){
	
	
	// Request list of ask a doctor q/a's for this specialty or procedure, and display them in the #OverlaySearchResults overlay
	$.ajax({ 
        type: "POST", 
        url: "/ask-a-doctor/procedure-questions?debug=0&SPECIALTYORPROCEDUREID=" + specialtyOrProcedureId,
        dataType: "html", 
        success: function(response) { 
        	
        	if(response == "")
        	{
        	}
        	else
        	{
        		$('.prompt-box').dialog('open');        	
                $("#OverlaySearchResults").html(response);
        	}      	
        	
        }
    });
}

function ALListClose(){
	// Overlay close button called
	$('.prompt-box').dialog('close');						
}