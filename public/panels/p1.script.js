$(document).ready(function() {
	$("#p-size").slider({
		range: "min",
		value: 20,
		min: 1,
		max: 30,
		slide: function(event, ui) {
			$( "#p-size-display" ).val( "$" + ui.value );
		}
	});
	$( "#p-size-display" ).val($( "#p-size" ).slider( "value" ) );
});