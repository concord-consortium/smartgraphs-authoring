// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Event.addBehavior({
//     "select.animation-pane-animation:change": function (ev) {
//          Hobo.ajaxRequest(window.location.href, ['animation-part'], {
//              params: Form.serialize(this.up('form')),
//              method: 'get',
//              message: 'Please wait...'
//          });
//      }
// });
//

var activity_error_url = "/activity_errors";
var dom_id = "activity_errors";
var update_activity_status = function() {
  var current_url = window.location.pathname;
  new Ajax.Updater(dom_id, activity_error_url, {
    parameters: {thing: 'one', foo: 2, current_url: current_url }
  });
};

Ajax.Responders.register({
  onComplete: function(request,response) {
    if (request.url === activity_error_url) {
      return;
    }
    else {
      update_activity_status();
    }
  }
});
