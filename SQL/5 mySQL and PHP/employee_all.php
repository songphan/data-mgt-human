<?php
	//แสดงชื่อตาราง
	echo "<h2>แสดงข้อมูลจากตาราง employee(Native Connectivity) </h2>";
	//ตัวแปรรับค่า login ไปยังฐานข้อมูล MySQL ด้วยคำสั่ง mysqli_connect
	$link = mysqli_connect("localhost", "root", "", "employee");
	//คำสั่ง Query
	$sql = "select * from employee;";
	//ใช้คำสั่ง mysqli_query ในการ run query
	$result = mysqli_query($link, $sql);
	//สร้างตารางและแสดงชื่อคอลัมน์
	echo "<table border=1>";
    echo "<tr>";
    echo "<td>รหัสพนักงาน</td>";
    echo "<td>ชื่อพนักงาน</td>";
    echo "<td>ตำแหน่งงาน</td>";
	echo "<td>เงินเดือน</td>";
    echo "<td>รหัสแผนก</td>";
    echo "</tr>";
	//รับค่าที่ได้จากการ query ข้อมูลในตัวแปร $result มาอยู่ในตัวแปรที่ชื่อ $dbarr ที่อยู่ในรูปของ array
	while ($dbarr = mysqli_fetch_array($result))
	{
		//แสดงผลตัวแปรที่อยู่ในรูป array ให้อยู่ในรูปตาราง
		echo "<tr>";
        		echo "<td>$dbarr[employeeID]</td>";
        		echo "<td>$dbarr[name]</td>";
        		echo "<td>$dbarr[job]</td>";
				echo "<td>$dbarr[salary]</td>";
        		echo "<td>$dbarr[departmentID]</td>";
        		echo "</tr>";
	}
	echo "</table>";
	//ปิดการเชื่อมต่อกับฐานข้อมูล
	mysqli_close($link);
?>