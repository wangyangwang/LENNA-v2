$(function worker() {
   
    setTimeout(function(){
        window.scrollTo(0,1000000);
    }, 100);

    // don't cache ajax or content won't be fresh
    $.ajaxSetup({
        cache: false,
        complete: function () {
            // Schedule the next request when the current one's complete
            setTimeout(worker, 5000);
        }
    });
    var ajax_load = "loading...";

    // load() functions
    var loadUrl = "content.txt";

    $("body").html(ajax_load).load(loadUrl);
    
    // end  
});