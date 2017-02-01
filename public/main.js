$(function(){
  var userName = "barbieri"
  $('#input_area').on('click', '#submit', function(){
    $.ajax({
      type: "POST",
      url: "/post",
      dataType: "text",
      data: {
        user_name: userName,
      },
      success: function(json) {
      dataType: "json",
        $(function(){
          window.scrollTo( 0, 0 ) ;
          var bkmSource = JSON.parse(json);
          $('#result').text(bkmSource);
        });
      },
      error: function() {
      }
      });
  });
});
