<?php
echo "<h2>รายงานจำนวนพนักงานที่มีเงินเดือนระหว่าง 10,000-15,000 บาท และ 15,001-20,000 บาท</h2>";	
	$link = mysqli_connect("localhost", "root", "", "employee");	
	$sql = "SELECT if(salary <= 15000, '10000-15000', '15001-20000'), count(*)
			FROM Employee 
			GROUP BY if(salary <= 15000, '10000-15000', '15001-20000');";	   //5
	$result = mysqli_query($link, $sql);						  //6
    	echo "<table border=1>";						  //7
    	echo "<tr>";								  //8
    		echo "<td>เงินเดือน </td>";	  				  //9
		echo "<td>จำนวน </td>";					  //10
    	echo "</tr>";								  //11
	while ($dbarr = mysqli_fetch_row($result))				  //12
	{									  //13
		echo "<tr>";							  //14
      			echo "<td>$dbarr[0] </td>";			  	  //15
			echo "<td>$dbarr[1] คน</td>";			  	  //16
       	echo "</tr>";							  //17
	}									  //18
	echo "</table> ";							  //19
	mysqli_close($link);							  //21
?>	
