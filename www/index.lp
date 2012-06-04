<%
  require "sajax"
  cjson = require "cjson"

  package.path = package.path .. ";/home/ubuntu/luaweb/?.lua"
  nbmb = require "nbmb"

  function get_email_by_id_json(id)
    if type(id) ~= "string" or tonumber(id) > 30714 then return nil end
    local email = nbmb.get_email(tonumber(id))
    assert(email)
    return cjson.encode(email)
  end

  sajax.init()

  sajax.export("get_email", get_email_by_id_json)

  if sajax.handle_client_request () then return end
%>

 <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=utf-8" />
  <title>NB-Discuss</title>
  <script type="text/javascript" src="http://d1topzp4nao5hp.cloudfront.net/uranium-upload/0.1.85/uranium.js"></script>
  <script type="text/javascript" src="http://d3js.org/d3.v2.js"></script>
  <script type="text/javascript" src="json2.js"></script>
  <script type="text/javascript" src="d3.layout.cloud.js"></script>

  <script type="text/javascript">
    /* <![CDATA[ */
<%
  sajax.show_javascript()
%>

Array.prototype.each = function(callback){
    for (var i =  0; i < this.length; i++){
        callback(this[i]);
    }
}

// Array Remove - By John Resig (MIT Licensed)
Array.prototype.remove = function(from, to) {
  var rest = this.slice((to || from) + 1 || this.length);
  this.length = from < 0 ? this.length + from : from;
  return this.push.apply(this, rest);
};

    function do_get_email_cb(e) {
      console.log(e)
    }

    function do_get_email() { // get the folder name var x, y;
      id = document.getElementById("id").value;
      x_get_email(id, do_get_email_cb);
    }
    /* ]]> */
  </script>

  <script type="text/javascript">
    /* <![CDATA[ */
  //    .start();

    var common = ["the","be","to","of","and","a","in","that","have","I","it","for","not","on","with","he","as","you","do","at","this","but","his","by","from","they","we","say","her","she","or","an","will","my","one","all","would","there","their","what","so","up","out","if","about","who","get","which","go","me","when","make","can","like","time","no","just","him","know","take","people","into","year","your","good","some","could","them","see","other","than","then","now","look","only","come","its","over","think","also","back","after","use","two","how","our","work","first","well","way","even","new","want","because","any","these","give","day","most","us"];

    var interval = null;

    function stop_make_cloud() {
      if(interval) {
        clearInterval(interval);
        interval = null;
      }
    }

    var startid = 0;
    var delay = 1000;

    function mkcloud() {
      x_get_email(startid++, make_cloud_cb);
      document.getElementById("id").value = startid;
    }

    function start_make_cloud() {
      startid = document.getElementById("id").value;
      delay = document.getElementById("delay").value;

      interval = setInterval("mkcloud()", delay);
    }

    function make_cloud() {
      id = document.getElementById("id").value;
      x_get_email(id, make_cloud_cb);
    }


    function make_cloud_cb(data) {
      if(data == null) { stop_make_cloud(); return false; }

    var email = JSON.parse(data);
    var raw = email.body.split(" ");

    raw.map(function(d) {
      d.replace(/[^0-9a-zA-Z]+/g, '');
    }); 

    var freq = new Array(0);
    var unique = new Array(0);

    raw.each(function(w) {
      if(freq[w]) {
        freq[w] += 1;
      } else {
          if(common.indexOf(w) == -1) {
            freq[w] = 1;
            unique.push(w);
          }
      }
    });

    var cl = d3.layout.cloud().size([800, 600])
      .words(unique.map(function(d) {
        return {text: d, size: 10 + freq[d] * 10};
      }))
      .rotate(function() { return ~~(Math.random() * 2) * 30; })
      .fontSize(function(d) { return d.size; })
      .on("end", draw);


      cl.start();
    }

    var cloud = null;

    function draw(words) {
	if(cloud) {
            cloud.remove();
        }
      cloud = d3.select("body").append("svg")
        .attr("width", 800)
            .attr("height", 600);

      cloud.append("g")
        .attr("transform", "translate(150,150)")
      .selectAll("text")
        .data(words)
      .enter().append("text")
        .style("font-size", function(d) { return d.size + "px"; })
        .attr("text-anchor", "middle")
        .attr("transform", function(d) {
          return "translate(" + [d.x, d.y] + ")rotate(" + d.rotate + ")";
        })
        .text(function(d) { return d.text; });
    }
    /* ]]> */
  </script>

  <style type="text/css">
    /* <![CDATA[ */
    /* Required CSS Styling */

    *[data-ur-set='toggler'] *[data-ur-toggler-component='content'] {
      display:none;
    }

    *[data-ur-set='toggler'] *[data-ur-toggler-component='content'][data-ur-state='enabled'] {
      display: block;
    }
    /* ]]> */
  </style>

</head>
<body>
  <div id="email">
    <span>Start Index:</span>
    <input type="text" name="id" id="id" value="1" size="5" />
    <span>Delay:</span>
    <input type="text" name="delay" id="delay" value="5000" size="5" />
    <input type="button" name="check" value="Start" onclick="start_make_cloud(); return false;" />
    <input type="button" name="check" value="Stop" onclick="stop_make_cloud(); return false;" />
  </div>
<!--
   <div id="chart">
      <button id="topic" class="first active">
        by topic
       </button>
       <button id="users">
        by users
      </button>
      <button id="emails" class="last">
        by emails
      </button>
      <button id="resize" class="first last">
        resize
      </button>

      <input type="text" size="4" id="width" value="600" />
        width
      <input type="text" size="5" id="height" value="500" />
        height
      <div id="status">click buttons to resize - mouse over for data</div>
    </div>
-->


<!--
    <div data-ur-set='toggler'>
    <div data-ur-toggler-component='button'>Click Here!</div>
    <ul data-ur-toggler-component='content'>
      <li> Hat </li>
      <li> Socks </li>
      <li> Shoes </li>
      <li> Gloves </li>
      <li> Shirts </li>
    </ul>
  </div>
-->

<script type="text/javascript">
  /* <![CDATA[ */
//  make_tree();
//  make_cloud();
  /* ]]> */
</script>
</body>
</html>
