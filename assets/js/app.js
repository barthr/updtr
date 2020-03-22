import "../css/app.scss";
import "phoenix_html";

const jQuery = require('jquery');
const $ = jQuery;
window.$ = window.jQuery = $;

require("../node_modules/semantic-ui-css/semantic.min");

$(document).ready(function(){
	$('.message .close')
		.on('click', function() {
			$(this)
				.closest('.message')
				.transition('fade')
			;
		})
	;
});

