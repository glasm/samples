<?

  $back = imagecreatefromjpeg('i/back_'.(strlen($_GET['b']) > 6 ? 'gray' : $_GET['b']).'.jpg');
  $front = imagecreatefrompng('i/front_'.(strlen($_GET['f']) > 6 ? 'red' : $_GET['f']).'.png');

  imagecopy($back, $front, 0, 0, 0,0, 1920, 1050);

  header('Content-Type: image/jpeg'); 

  imagejpeg($back, NULL, 75);
  
  imagedestroy($back);
  imagedestroy($front);

?>