<?php
   echo "<h2>รายงานข้อมูลพนักงานที่มีเงินเดือนระหว่าง 10,000-15,000 บาท</h2>";	  
	$link = mysqli_connect("localhost", "root", "", "employee");			  
	$sql = "select * from employee Where salary between 10000 and 15000;";	  
	$result = mysqli_query($link, $sql);						  
    	echo "<table border=1>";						  
    	echo "<tr>";								  
    		echo "<td>รหัสพนักงาน</td>";					  
    		echo "<td>ชื่อพนักงาน</td>";					  
    		echo "<td>ตำแหน่งงาน</td>";					  
		echo "<td>เงินเดือน</td>";					  
    		echo "<td>รหัสแผนก</td>";					  
    	echo "</tr>";								  
	while ($dbarr = mysqli_fetch_array($result))				  
	{									  
		echo "<tr>";							  
      			echo "<td>$dbarr[employeeID]</td>";			  
      			echo "<td>$dbarr[name]</td>";				  
      			echo "<td>$dbarr[job]</td>";				  
			echo "<td>$dbarr[salary]</td>";			
      			echo "<td>$dbarr[departmentID]</td>";		
      		echo "</tr>";			
	}		
	echo "</table>";	
	mysqli_close($link);		
?>
