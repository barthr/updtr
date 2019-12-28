// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";

import "admin-lte/plugins/bootstrap/js/bootstrap"


import "admin-lte";
import "admin-lte/build/js/PushMenu";
import "admin-lte/build/js/CardWidget";

window.setTimeout(function () {
  $(".alert").fadeTo(200, 0).slideUp(200, function () {
    $(this).remove();
  });
}, 1000);