<?

  $t0 = mtime_float();
  
  for($i=0;$i<4;$i++) 
    for($j=0;$j<3;$j++) {
      for($k=0;$k<3;$k++) {
      
        $t1 = mtime_float();
      
        $back = imagecreatefromjpeg('i/back_'.(!$j ? 'red' : ($j==1 ? 'gray' : 'yellow')).'.jpg');
        $front = imagecreatefrompng('i/front_'.(!$k ? 'red' : ($k==1 ? 'orange' : 'yellow')).'.png');

        imagecopy($back, $front, 0, 0, 0,0, 1920, 1050);
        imageinterlace($back, 1);
        imagejpeg($back, 'back_'.(!$j ? 'red' : ($j==1 ? 'gray' : 'yellow')).'.jpg', 75);
  
        imagedestroy($back);
        imagedestroy($front);
        
        echo (mtime_float() - $t1).' ';
        flush();
        
      }
      
      echo "<br>";
      
    }
  
  echo "<br>".(mtime_float() - $t0);
  
  function mtime_float() {
    list($usec, $sec) = explode(" ", microtime());
    return ((float)$usec + (float)$sec);
  }
  
?>