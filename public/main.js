//入力したidでjson取得####################################################


$(function(){
  $('#input_area').on('click', '#submit', function(){
    var hatenaId = $('#input').val();
    var graphSource = [0,0,0,0,0];
    var source
    console.log(hatenaId);
    $('#result').text('解析中');
    $.ajax({
      type: "POST",
      url: "/post",
      dataType: "text",
      data: {
        hatena_id: hatenaId,
      },
      success: function(json) {
      dataType: "json",
        $(function(){
          window.scrollTo( 0, 0 ) ;
          source = JSON.parse(json);
          graphSource = source[source.length - 2];
          var favorite = source[source.length - 1];
          console.log(favorite);
          $('#result').text(source.length-2 + '件のブクマ');
          graphA(graphSource);
          favoriteList(favorite);
        });
      },
      error: function() {
        $('#result').text('error');
        
      }
      });
  });
});

//円グラフ####################################################


function graphA (graphSource){
var ctx
var myChart
var data

data = {
    labels: [
        "無言",
        "ポジコメ",
        "ネガコメ",
        "普通のコメント"
    ],
    datasets: [
        {
            data: [graphSource[1],graphSource[2],graphSource[3],graphSource[4]],
            backgroundColor: [
                "#708090",
                "#FFB6C1",
                "#6495ED",
                "#FFFF00"
            ],
            hoverBackgroundColor: [
                "#708090",
                "#FFB6C1",
                "#6495ED",
                "#FFFF00"
            ]
        }]
};
ctx = document.getElementById('sample').getContext('2d');
myChart = new Chart(ctx, {
  type: 'pie',
  data: data,
});

}


//よく見るサイト####################################################

function favoriteList (favorite) {
  $('#favorite_site').text(favorite);
}