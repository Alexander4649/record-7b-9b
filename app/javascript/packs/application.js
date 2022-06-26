// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


import Rails from "@rails/ujs"
import Turbolinks from "turbolinks" //グラフ適用の為、一時的に
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// import "jquery"
import "popper.js"
import "bootstrap"

import '@fortawesome/fontawesome-free/js/all';
import "../stylesheets/application" 

Rails.start()
Turbolinks.start()  //グラフ適用の為、一時的に
ActiveStorage.start()


window.$ = window.jQuery = require('jquery');
require('packs/raty')

// import"chartkick" // 追記
// import"chart.js" // 追記

import Chart from 'chart.js/auto';
import jQuery from "jquery"
global.$ = jQuery;
window.$ = jQuery;
global.Chart = Chart;