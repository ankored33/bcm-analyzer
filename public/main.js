//入力したidでjson取得####################################################


$(function(){
  $('#input_area').on('click', '#submit', function(){
    var hatenaId = $('#input').val();
    var graphSource = [0,0,0,0,0];
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
          var source = JSON.parse(json);
          graphSource = source[source.length - 1]
          $('#result').text(source.length-1 + '件のブクマ');
          graphA(graphSource);
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
  
var data = {
    labels: [
        "無言ブクマ",
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
var ctx = document.getElementById('sample').getContext('2d');
var myChart = new Chart(ctx, {
  type: 'pie',
  data: data,
});

}