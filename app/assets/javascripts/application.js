// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require jquery3
//= require jquery_ujs
//= require foundation
//= require activestorage
//= require_tree .
$(function(){ $(document).foundation(); });

$(document).ready(function() {

  $('[data-js-change-status-form]').on("ajax:success", function(event, data, status, xhr){
    var currentId = $(event.target.parentNode).attr('id').slice(22)
    $("#change-status-div"+currentId).html(xhr.responseText).foundation();
    Foundation.reInit($("[data-dropdown-pane]"));
  });

  $('[data-js-change-rating-form]').on("ajax:success", function(event, data, status, xhr){
    var currentId = $(event.target.parentNode).attr('id').slice(22)
    $("#change-rating-div"+currentId).html(xhr.responseText).foundation();
    Foundation.reInit($("[data-dropdown-pane]"));
  });

});
