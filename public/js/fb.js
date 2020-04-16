// https://developers.facebook.com/apps/472876716648358/fb-login/quickstart/

window.fbAsyncInit = function() {
  FB.init({
    appId      : '472876716648358',
    cookie     : true,
    xfbml      : true,
    version    : 'v4.0'
  });
    
  FB.AppEvents.logPageView();   
    
};

function checkLoginState() {
  FB.getLoginStatus(function(res1) {
    if (res1.status === 'connected') {
      FB.api('/me', { fields: 'name, email' }, function(res2) {
        //res2 will have name, email, id 
        if (res2.email) {
          // log in with name, email, fb_id
          document.location = `/fb_login?email=${email}&fb_id=${fb_id}`
        } else {
          alert('Sorry, you must have a Facebook email to log in.')
        }
      })  
    } else {
      alert('Sorry, something went wrong.');
      console.log(res1);
    }
    
  });
}

(function(d, s, id){
   var js, fjs = d.getElementsByTagName(s)[0];
   if (d.getElementById(id)) {return;}
   js = d.createElement(s); js.id = id;
   js.src = "https://connect.facebook.net/en_US/sdk.js";
   fjs.parentNode.insertBefore(js, fjs);
 }(document, 'script', 'facebook-jssdk'));


// FB.getLoginStatus(function(response) {
//   statusChangeCallback(response);
// });