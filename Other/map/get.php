<?

  if(!isset($_GET['id'])) exit;
  
  $lnk = mysql_connect('localhost', 'igorarg_glasm', 'zxigora') or die();//'er_mc: '.mysql_error());
  mysql_select_db('igorarg_glasm') or die();//die('er_mdb');
  
  $q = mysql_query('SELECT `title` FROM gamemap WHERE `id`='.$_GET['id'].' LIMIT 1') or die();

  $r = mysql_fetch_row($q);
  echo $_GET['id'].','.$r[0];
  
  mysql_free_result($q);
  mysql_close($lnk);