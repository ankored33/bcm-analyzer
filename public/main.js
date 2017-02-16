//入力したidでjson取得####################################################


$(function(){
  $('#input_area').on('click', '#submit', function(){
    var hatenaId = $('#input').val();
    var pieGraphSource;
    var lineGraphSource;
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
          pieGraphSource = source[source.length - 2];
          lineGraphSource = source[source.length - 3]
          var favorite = source[source.length - 1];
          console.log(pieGraphSource);
          pieGraph(pieGraphSource);
          console.log(lineGraphSource);
          lineGraph(lineGraphSource);
          favoriteList(favorite, hatenaId);
        });
      },
      error: function() {
        $('#result').text('error');
        
      }
      });
  });
});

//円グラフ####################################################


function pieGraph (pieGraphSource){
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
            data: [pieGraphSource[1],pieGraphSource[2],pieGraphSource[3],pieGraphSource[4]],
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
ctx = document.getElementById('pie_graph').getContext('2d');
myChart = new Chart(ctx, {
  type: 'pie',
  data: data,
});

}


//よく見るサイト####################################################

function favoriteList (favorite, hatenaId) {
  $('#favorite_site').append(''+
    '<div>id:' + hatenaId +'がよくブックマークをつけるサイト</div>'
  );
  favorite.forEach(function(line){
    $('#favorite_site').append(''+
      '<div><a href="'+ line[0] + '">' + line[0] + '</a>　　' + line[1] + '</div>'
    );
  });
  
}



//棒グラフ####################################################


function lineGraph (l){
var ctxB
var myChartB
var dataB

dataB = {
      //データ項目のラベル
      labels: ["0～2時", "2～4時", "4～6時", "6～12", "12～14時", "14～16時", "16～18時", "18～20時", "20～22時", "22～24時"],
      //データセット
      datasets: [{
          //凡例
          label: "ブックマーク数",
          //背景色
          backgroundColor: "rgba(75,192,192,0.4)",
          //枠線の色
          borderColor: "rgba(75,192,192,1)",
          //グラフのデータ
          data: [
            l[0]+l[1],
            l[2]+l[3],
            l[4]+l[5],
            l[6]+l[7],
            l[8]+l[9],
            l[10]+l[11],
            l[12]+l[13],
            l[14]+l[15],
            l[16]+l[17],
            l[18]+l[19],
            l[20]+l[21],
            l[22]+l[23]
            ]
      }]
  },
ctxB = document.getElementById('bar_graph').getContext('2d');
myChartB = new Chart(ctxB, {
  type: 'line',
  data: dataB,
});

}