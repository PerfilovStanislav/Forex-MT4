<pre>
<?php

$file4save = 'file_for_import.csv';
if (file_exists($file4save)) unlink($file4save);

$arr = array();

$filelist = glob("*.CSV");

foreach($filelist as $file) {
	$f = $file === '1.CSV';
    $lines = file("./$file");
    foreach($lines as $index => $line) {
        $line = explode(',', $line);

		$dates = explode('.', $line[0]);
		$dt = $dates[0].'-'.$dates[1].'-'.$dates[2];
		$day_of_week = date("w", strtotime($dt));
		
		if (!($day_of_week >= 1 && $day_of_week <= 5)) continue;		
        $v = &$arr[$line[0]][$line[1]];	
		
		if ($f) { // основной файл
			$v['f'] = true;
			$v['kol']=1;
			for($i=0;$i<4;$i++) {
				$v[$i]=$line[2+$i];
			}
		}
		else { // дополнительный файл			
			if (!isset($v['f'])) { // если нет записи из основного файла	
				if (isset($v)) {
					$v['kol']++;
					for($i=0;$i<4;$i++) {
						$v[$i]+=$line[2+$i];
					}
				}
				else {
					$v['kol']=1;				
					for($i=0;$i<4;$i++) {
						$v[$i]=$line[2+$i];
					}
				}
			}
		}
    }
}

$arr_for_saving = array();
print_r($arr);
foreach($arr as $day_name => &$day) {
    foreach($day as $time_name => &$time) {
        $kol = $time['kol'];
		if ($time['kol'] === NULL || $time['kol'] == 0) continue;
        for($i=0;$i<4;$i++) {
            $time[$i]=$time[$i] / $kol;
        }
        $arr_for_saving[] = implode(',', array($day_name,$time_name,$time[0],$time[1],$time[2],$time[3],1));
    }
}


$str = implode ("\n", $arr_for_saving);
file_put_contents ($file4save, $str);



?>
</pre>