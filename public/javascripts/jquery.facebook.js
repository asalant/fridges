(function($) {

  $.fn.facebook = function(application_id) {
    return $(this).each(function() {
      var $root = $(this);
      $('<div id="fb-root"/>').appendTo($root).append($('<script/>').
        attr('src', document.location.protocol + '//connect.facebook.net/en_US/all.js').
        attr('async', true));

      window.fbAsyncInit = function() {
        FB.init({
          appId  : application_id,
          status : false, // check login status
          cookie : true, // enable cookies to allow the server to access the session
          xfbml  : true  // parse XFBML
        });

        FB.getLoginStatus(function(response) {
          if (response.session) {
            $root.trigger('facebook.loggedIn', { response: response, access_token: response.session.access_token });
          }
          else {
            $root.trigger('facebook.loggedOut', { response: response });
          }
        });
      };
    });
  };
})(jQuery);