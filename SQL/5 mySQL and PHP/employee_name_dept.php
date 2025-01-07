<?php
	echo "<h2>รายงานข้อมูลพนักงานโดยให้แสดงรหัสพนักงาน ชื่อพนักงาน และชื่อแผนก</h2>";	   						 
	$link = mysqli_connect("localhost", "root", "", "employee");			
	$sql = "SELECT e.employeeID, e.name , d.name 
			FROM employee e , department d 
			WHERE e.departmentID = d.departmentID;";	  	  	 
	$result = mysqli_query($link, $sql);						
    	echo "<table border=1>";						
    	echo "<tr>";								
    		echo "<td>รหัสพนักงาน</td>";					
    		echo "<td>ชื่อพนักงาน</td>";					
    		echo "<td>ชื่อแผนก</td>";					
    	echo "</tr>";								
	while ($dbarr = mysqli_fetch_row($result))			
	{								
		echo "<tr>";						
      			echo "<td>$dbarr[0]</td>";			
      			echo "<td>$dbarr[1]</td>";			
      			echo "<td>$dbarr[2]</td>";		
      		echo "</tr>";					
	}								
	echo "</table> ";
	//สร้างตัวแปรชื่อ $total เพื่อรับค่าจำนวนแถว
	$total = mysqli_num_rows($result);			
	echo "<b>จำนวนพนักงาน รวม $total คน </b>";		
	mysqli_close($link);					
?>		
