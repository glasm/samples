<?
  $mob = preg_match("/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i", $_SERVER["HTTP_USER_AGENT"]);
?>

<!DOCTYPE html>
<html lang="ru">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	<title></title>
  <style>#menu{background:url(i/nb80.png);width:48px;height:360px;color:white;font-size:80%;padding:12px;text-align:center}a{color:white}img{border:0}</style>
</head>
<body>
  <div id="menu">
    Кирпич<br/>
    <a href="javascript:reload('','red');"><img src="i/th_front_red.jpg" alt=""/></a>
    <a href="javascript:reload('','orange');"><img src="i/th_front_orange.jpg" alt=""/></a>
    <a href="javascript:reload('','yellow');"><img src="i/th_front_yellow.jpg" alt=""/></a>
    <br/><br/>Плитка</br>
    <a href="javascript:reload('red','');"><img src="i/th_back_red.jpg" alt=""/></a>
    <a href="javascript:reload('gray','');"><img src="i/th_back_gray.jpg" alt=""/></a>
    <a href="javascript:reload('yellow','');"><img src="i/th_back_yellow.jpg" alt=""/></a>
  </div>
  <script src="js/jquery.js"></script>
	<script src="js/jquery.backstretch.js"></script>
	<script>var canvas=document.createElement("canvas");var isCanvasSupported=<?= $mob?'false':'!!(canvas.getContext&&canvas.getContext("2d"))'?>;var cur_front="";var cur_back="";function reload(e,d){$.backstretch(["i/def.jpg"]);if(e!=""){cur_back=e}if(d!=""){cur_front=d}if(isCanvasSupported){canvas.width=1920;canvas.height=1050;var b=canvas.getContext("2d");var c=new Image();var f=new Image();var a=new Image();c.src="i/back_"+cur_back+".jpg";c.onload=function(){f.src="i/front_"+cur_front+".jpg"};f.onload=function(){a.src="i/mask.png"};a.onload=function(){b.drawImage(a,0,0);b.globalCompositeOperation="source-in";b.drawImage(f,0,0);b.globalCompositeOperation="destination-atop";b.drawImage(c,0,0);$.backstretch([canvas.toDataURL()])}}else{$.backstretch(["img.php?b="+cur_back+"&f="+cur_front])}}reload("red","red");</script>
</body>	