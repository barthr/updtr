import "../css/app.scss";
import "phoenix_html";

import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect();


const jQuery = require('jquery');
const $ = jQuery;
window.$ = window.jQuery = $;

require("../node_modules/semantic-ui-css/semantic.min");

$(document).ready(function () {
	$('.message .close')
		.on('click', function () {
			$(this)
				.closest('.message')
				.transition('fade')
			;
		})
	;
});

